from PIL import Image
import os

# Paths
project_root = os.path.dirname(os.path.dirname(__file__))
mac_appicon_dir = os.path.join(project_root, 'macos', 'Runner', 'Assets.xcassets', 'AppIcon.appiconset')
android_res_dir = os.path.join(project_root, 'android', 'app', 'src', 'main', 'res')
source_icon = os.path.join(mac_appicon_dir, 'app_icon_512.png')

if not os.path.exists(source_icon):
    raise FileNotFoundError(f"Source icon not found: {source_icon}")

# Loads and make near-white pixels transparent
img = Image.open(source_icon).convert('RGBA')
px = img.load()
width, height = img.size
for y in range(height):
    for x in range(width):
        r,g,b,a = px[x,y]
        # if pixel is nearly white (tolerance), make transparent
        if r > 240 and g > 240 and b > 240:
            px[x,y] = (255,255,255,0)

# Save macOS/iOS appicon sizes
sizes = {
    'app_icon_16.png': (16,16),
    'app_icon_32.png': (32,32),
    'app_icon_64.png': (64,64),
    'app_icon_128.png': (128,128),
    'app_icon_256.png': (256,256),
    'app_icon_512.png': (512,512),
    'app_icon_1024.png': (1024,1024),
}

for name, s in sizes.items():
    out = img.resize(s, Image.LANCZOS)
    out.save(os.path.join(mac_appicon_dir, name))
    print('Wrote', name)

# Generate Android launcher icons in mipmap folders
mipmap_sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

for folder, size in mipmap_sizes.items():
    dirpath = os.path.join(android_res_dir, folder)
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)
    out_img = img.resize((size, size), Image.LANCZOS)
    out_path = os.path.join(dirpath, 'ic_launcher.png')
    out_img.save(out_path)
    # also write round icon
    out_img.save(os.path.join(dirpath, 'ic_launcher_round.png'))
    print('Wrote', out_path)

print('Icon generation complete.')
