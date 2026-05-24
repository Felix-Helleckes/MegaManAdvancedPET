from PIL import Image
import os

project_root = os.path.dirname(os.path.dirname(__file__))
mac_appicon_dir = os.path.join(project_root, 'macos', 'Runner', 'Assets.xcassets', 'AppIcon.appiconset')
source = os.path.join(mac_appicon_dir, 'app_icon_512.png')
if not os.path.exists(source):
    raise FileNotFoundError(source)
img = Image.open(source).convert('RGBA')
# ICO with multiple sizes
sizes = [(16,16),(32,32),(48,48),(64,64),(128,128),(256,256),(512,512)]
icons = [img.resize(s, Image.LANCZOS) for s in sizes]
out_path = os.path.join(project_root, 'windows','runner','resources','app_icon.ico')
icons[0].save(out_path, format='ICO', sizes=sizes)
print('Wrote', out_path)
