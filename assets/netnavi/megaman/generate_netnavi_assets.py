from PIL import Image, ImageChops
import os
import json

SRC = os.path.join('assets', 'images', 'NetNavi', 'MegaMan.jpg')
OUT_DIR = os.path.join('assets', 'netnavi', 'megaman')

os.makedirs(OUT_DIR, exist_ok=True)

im = Image.open(SRC).convert('RGBA')
# Trim whitespace (assume white background)
bg = Image.new('RGBA', im.size, (255,255,255,255))
diff = ImageChops.difference(im, bg)
bbox = diff.getbbox()
if bbox is None:
    bbox = (0,0,im.width, im.height)

sprite = im.crop(bbox)
# Ensure pixel art is kept crisp when resizing
sprite = sprite.convert('RGBA')

# Standardize sprite size by padding to square
w, h = sprite.size
size = max(w, h)
canvas = Image.new('RGBA', (size, size), (0,0,0,0))
canvas.paste(sprite, ((size-w)//2, (size-h)//2))
sprite = canvas

# Generate simple frames: idle bob (3 frames), shoot (2 frames with projectile), walk (2 frames shifted)
frames = []
# idle frames: slight vertical offsets
for dy in (0, -1, 0):
    f = Image.new('RGBA', (size, size), (0,0,0,0))
    f.paste(sprite, (0, dy))
    frames.append(('idle', f))

# walk frames: horizontal leg shift (simulate by shifting parts)
f1 = sprite.copy()
f2 = Image.new('RGBA', (size, size), (0,0,0,0))
f2.paste(sprite, (-1,0))
frames.append(('walk', f1))
frames.append(('walk', f2))

# shoot frames: add projectile to the right
proj = Image.new('RGBA', (8,8), (255,255,200,255))
# draw a circle-like pixel ball
for x in range(8):
    for y in range(8):
        dx = x-3.5; dy = y-3.5
        if dx*dx+dy*dy < 12:
            proj.putpixel((x,y),(255,230,180,255))

sframe = sprite.copy()
sf = sframe.copy()
sx = size - 16
sy = size//2 - 8
sf.paste(proj, (sx, sy), proj)
frames.append(('shoot', sf))
# projectile further
sf2 = sframe.copy()
sf2.paste(proj, (sx+8, sy), proj)
frames.append(('shoot', sf2))

# knockback frame (shift left)
kb = Image.new('RGBA', (size, size), (0,0,0,0))
kb.paste(sprite, (-2,0))
frames.append(('knockback', kb))

# Save individual frames and build spritesheet
frame_files = []
for i, (tag, img) in enumerate(frames):
    name = f'{tag}_{i}.png'
    path = os.path.join(OUT_DIR, name)
    img.save(path, optimize=True)
    frame_files.append({'name': name, 'tag': tag, 'path': path, 'w': img.width, 'h': img.height})

# Also generate 128x128 resized frames for use in the app
SMALL_DIR = os.path.join(OUT_DIR, '128')
os.makedirs(SMALL_DIR, exist_ok=True)
small_frame_files = []
SMALL = 128
for f in frame_files:
    img = Image.open(f['path'])
    small = img.resize((SMALL, SMALL), resample=Image.NEAREST)
    small_name = f"sm_{f['name']}"
    small_path = os.path.join(SMALL_DIR, small_name)
    small.save(small_path, optimize=True)
    small_frame_files.append({'name': small_name, 'tag': f['tag'], 'path': small_path.replace('\\','/'), 'w': SMALL, 'h': SMALL})

# Create a horizontal spritesheet
cols = len(frame_files)
ss_w = size * cols
ss_h = size
spritesheet = Image.new('RGBA', (ss_w, ss_h), (0,0,0,0))
for i, f in enumerate(frames):
    spritesheet.paste(f[1], (i*size, 0))
ss_path = os.path.join(OUT_DIR, 'megaman_spritesheet.png')
spritesheet.save(ss_path, optimize=True)

# create small spritesheet
ss_small = Image.new('RGBA', (SMALL * len(small_frame_files), SMALL), (0,0,0,0))
for i, sf in enumerate(small_frame_files):
    img = Image.open(sf['path'])
    ss_small.paste(img, (i*SMALL, 0))
ss_small_path = os.path.join(SMALL_DIR, 'megaman_spritesheet_128.png')
ss_small.save(ss_small_path, optimize=True)

# Export metadata
animations = {
    'idle': {'frames': [f for f in frame_files if f['tag']=='idle'], 'frame_time': 250},
    'walk': {'frames': [f for f in frame_files if f['tag']=='walk'], 'frame_time': 150},
    'shoot': {'frames': [f for f in frame_files if f['tag']=='shoot'], 'frame_time': 120},
    'knockback': {'frames': [f for f in frame_files if f['tag']=='knockback'], 'frame_time': 200},
}
meta = {
    'source': SRC,
    'spritesheet': os.path.relpath(ss_path).replace('\\','/'),
    'spritesheet_128': os.path.relpath(ss_small_path).replace('\\','/'),
    'frame_size': [size, size],
    'frame_size_128': [SMALL, SMALL],
    'frames': frame_files,
    'frames_128': small_frame_files,
    'animations': animations,
}
with open(os.path.join(OUT_DIR, 'megaman_meta.json'), 'w', encoding='utf-8') as fh:
    json.dump(meta, fh, indent=2)

print('Generated', len(frame_files), 'frames and spritesheet at', OUT_DIR)
