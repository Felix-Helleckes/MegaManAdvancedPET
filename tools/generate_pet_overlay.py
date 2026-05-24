#!/usr/bin/env python3
"""
Generate a PET front overlay PNG with a transparent central screen area.

Usage:
  python tools/generate_pet_overlay.py [--image PATH] [--out assets/ux/overlay.png] [--box x,y,w,h]

If no box is provided, the script will use a centered box with 60% width and 45% height of the image.
"""
from PIL import Image, ImageDraw
import sys
import os
import glob
import argparse

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
UX_DIR = os.path.join(ROOT, 'UXBook')
OUT_DIR = os.path.join(ROOT, 'assets', 'ux')

parser = argparse.ArgumentParser()
parser.add_argument('--image', help='Path to source image (optional)')
parser.add_argument('--out', default=os.path.join(OUT_DIR, 'overlay.png'))
parser.add_argument('--box', help='Manual box as x,y,w,h (pixels on resized image)')
parser.add_argument('--width', type=int, default=1024, help='Resize width for processing')
args = parser.parse_args()

# find image
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

try:
    img = Image.open(src).convert('RGBA')
except Exception as e:
    print('Failed to open image:', e)
    sys.exit(1)

# resize to target width
w = args.width
ratio = w / img.width
h = int(img.height * ratio)
img = img.resize((w,h), Image.LANCZOS)

# determine box
if args.box:
    x,y,bw,bh = map(int, args.box.split(','))
else:
    bw = int(w * 0.60)  # 60% width
    bh = int(h * 0.45)  # 45% height
    x = (w - bw) // 2
    y = int(h * 0.20)

# prepare overlay: keep original frame, but clear center box (make transparent)
overlay = img.copy()
mask = Image.new('RGBA', overlay.size, (0,0,0,0))
draw = ImageDraw.Draw(mask)

# Draw outer frame from original but set central rectangle alpha to 0
# We'll composite by taking the original image and making the center transparent
pixels = overlay.load()

# create alpha mask: start fully opaque
alpha = Image.new('L', overlay.size, 255)
ad = alpha.load()
for yy in range(y, y+bh):
    if yy < 0 or yy >= h: continue
    for xx in range(x, x+bw):
        if xx < 0 or xx >= w: continue
        ad[xx,yy] = 0

# apply alpha channel
r,g,b,a = overlay.split()
overlay = Image.merge('RGBA', (r,g,b,alpha))

# Optional: draw a subtle inner border to indicate screen
border = Image.new('RGBA', overlay.size, (0,0,0,0))
bd = ImageDraw.Draw(border)
bd.rectangle([x, y, x+bw, y+bh], outline=(255,255,255,120), width=2)
overlay = Image.alpha_composite(overlay, border)

# ensure output dir exists
os.makedirs(os.path.dirname(args.out), exist_ok=True)
overlay.save(args.out)
print('Saved overlay to', args.out)

# produce a small frame preview (cut to the frame region) for quick checking
frame_preview = img.copy()
frame_preview.save(os.path.join(os.path.dirname(args.out), 'frame_preview.png'))
print('Saved frame preview to', os.path.join(os.path.dirname(args.out), 'frame_preview.png'))
