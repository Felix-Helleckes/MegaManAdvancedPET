#!/usr/bin/env python3
"""
Advanced PET overlay generator:
- Uses OpenCV to detect the front-screen rectangle automatically.
- Produces multiple overlay PNG sizes (1024, 512, 256) in assets/ux/
- Writes a simple SVG fallback to assets/ux/overlay.svg

Usage:
  python tools/generate_pet_overlay_advanced.py [--image PATH] [--out-dir assets/ux]

If detection fails, falls back to centered box heuristics.
"""
import os
import sys
import glob
import argparse
from PIL import Image, ImageDraw

try:
    import cv2
except Exception:
    cv2 = None

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
UX_DIR = os.path.join(ROOT, 'UXBook')
OUT_DIR = os.path.join(ROOT, 'assets', 'ux')

parser = argparse.ArgumentParser()
parser.add_argument('--image', help='Path to source image (optional)')
parser.add_argument('--out-dir', default=OUT_DIR)
parser.add_argument('--width', type=int, default=1024)
args = parser.parse_args()

if not os.path.exists(args.out_dir):
    os.makedirs(args.out_dir, exist_ok=True)

# select image
src = args.image
if not src:
    patterns = [os.path.join(UX_DIR, '*.' + ext) for ext in ['jpg','jpeg','png','webp','avif']]
    matches = []
    for p in patterns:
        matches.extend(glob.glob(p))
    matches.sort()
    if not matches:
        print('No images found in UXBook/. Place photos there or pass --image PATH')
        sys.exit(1)
    src = matches[0]

print('Using source image:', src)

img_cv = None
if cv2:
    try:
        img_cv = cv2.imread(src)
    except Exception as e:
        print('OpenCV failed to read image:', e)
        img_cv = None

# fallback to PIL reading
img_pil = Image.open(src).convert('RGBA')
# resize for processing
w = args.width
ratio = w / img_pil.width
h = int(img_pil.height * ratio)
img_resized = img_pil.resize((w,h), Image.LANCZOS)

# detection
poly = None
if img_cv is not None and cv2 is not None:
    try:
        img_small = cv2.resize(img_cv, (w, h), interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(img_small, cv2.COLOR_BGR2GRAY)
        blur = cv2.GaussianBlur(gray, (5,5), 0)
        edged = cv2.Canny(blur, 50, 150)
        # dilate/erode to close gaps
        kern = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))
        closed = cv2.morphologyEx(edged, cv2.MORPH_CLOSE, kern)
        contours, _ = cv2.findContours(closed, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        contours = sorted(contours, key=cv2.contourArea, reverse=True)
        for cnt in contours[:10]:
            peri = cv2.arcLength(cnt, True)
            approx = cv2.approxPolyDP(cnt, 0.02 * peri, True)
            if len(approx) == 4:
                poly = approx.reshape(4,2).tolist()
                break
        if poly:
            print('Detected quadrilateral:', poly)
    except Exception as e:
        print('OpenCV detection error:', e)
        poly = None

# If detection failed, use centered box heuristic
if not poly:
    bw = int(w * 0.60)
    bh = int(h * 0.45)
    x = (w - bw) // 2
    y = int(h * 0.20)
    poly = [[x,y],[x+bw,y],[x+bw,y+bh],[x,y+bh]]
    print('Using fallback box:', poly)

# Create alpha mask with transparent polygon inside
alpha = Image.new('L', (w,h), 255)
mask_draw = ImageDraw.Draw(alpha)
# polygon coordinates as tuple list
poly_t = [tuple(map(int,p)) for p in poly]
mask_draw.polygon(poly_t, fill=0)

# Apply alpha to resized image copy to create overlay frame
r,g,b,a = img_resized.split()
over = Image.merge('RGBA', (r,g,b,alpha))
# add subtle border
bd = Image.new('RGBA', (w,h), (0,0,0,0))
bd_draw = ImageDraw.Draw(bd)
bd_draw.line(poly_t + [poly_t[0]], fill=(255,255,255,120), width=3)
over = Image.alpha_composite(over, bd)

# save multiple sizes
sizes = [args.width, 512, 256]
base_out = os.path.join(args.out_dir, 'overlay')
for s in sizes:
    img_s = over.resize((s, int(h * s / w)), Image.LANCZOS)
    out_path = f'{base_out}_{s}.png' if s != args.width else f'{base_out}.png'
    img_s.save(out_path)
    print('Saved', out_path)

# Save SVG fallback (simple rounded rectangle with transparent center)
svg_path = os.path.join(args.out_dir, 'overlay.svg')
# compute box in original scale (relative)
# use normalized coords (0..1)
poly_n = [(p[0]/w, p[1]/h) for p in poly_t]
# bbox
minx = min(p[0] for p in poly_t)
miny = min(p[1] for p in poly_t)
maxx = max(p[0] for p in poly_t)
maxy = max(p[1] for p in poly_t)
# generate SVG with viewBox
svg_w = w
svg_h = h
rect_x = minx
rect_y = miny
rect_w = maxx - minx
rect_h = maxy - miny
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {svg_w} {svg_h}" width="{svg_w}" height="{svg_h}">
  <rect x="0" y="0" width="{svg_w}" height="{svg_h}" fill="black" />
  <rect x="{rect_x}" y="{rect_y}" width="{rect_w}" height="{rect_h}" fill="none" stroke="white" stroke-opacity="0.6" stroke-width="3"/>
</svg>
'''
with open(svg_path,'w',encoding='utf-8') as fh:
    fh.write(svg)
print('Saved SVG fallback to', svg_path)

print('Complete.')
