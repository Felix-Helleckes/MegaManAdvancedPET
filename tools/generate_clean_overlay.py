from PIL import Image, ImageDraw
import os

OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'ux', 'overlay.png')
W, H = 800, 1100

# Base transparent image
img = Image.new('RGBA', (W, H), (0, 0, 0, 0))
draw = ImageDraw.Draw(img, 'RGBA')

# Draw outer blue housing
pad = 40
draw.rounded_rectangle([pad, pad, W - pad, H - pad], radius=80, fill=(15, 82, 186, 255))

# Gold accents
accent_w = 18
draw.rectangle([pad + 8, pad + 20, pad + 8 + accent_w, H - pad - 20], fill=(212, 175, 55, 255))
draw.rectangle([W - pad - 8 - accent_w, pad + 20, W - pad - 8, H - pad - 20], fill=(212, 175, 55, 255))

# Inner silver panel
inner_pad = 70
draw.rounded_rectangle([inner_pad, inner_pad + 40, W - inner_pad, H - inner_pad - 140], radius=36, fill=(192, 192, 192, 255))

# Dark bezel for screen
screen_w = 300
screen_h = 220
sx = (W - screen_w) // 2
sy = inner_pad + 60
draw.rectangle([sx - 10, sy - 10, sx + screen_w + 10, sy + screen_h + 10], fill=(0, 0, 0, 200))

# Circular button + ring
cx = W // 2
by = H - 180
draw.ellipse([cx - 80, by - 80, cx + 80, by + 80], fill=(180, 40, 60, 255))
draw.ellipse([cx - 110, by - 110, cx + 110, by + 110], outline=(212, 175, 55, 255), width=12)

# Create alpha mask and clear the screen area to transparent
alpha = Image.new('L', (W, H), 255)
ad = ImageDraw.Draw(alpha)
ad.rectangle([sx, sy, sx + screen_w, sy + screen_h], fill=0)
img.putalpha(alpha)

# Save
os.makedirs(os.path.dirname(OUT), exist_ok=True)
img.save(OUT)
print('Wrote', OUT)
