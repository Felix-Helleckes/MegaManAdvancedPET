import subprocess
import sys
import json
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]

def _resolve_exe(cmd):
    # If command is a list and the first element is 'flutter', try to find full path on PATH
    if isinstance(cmd, (list, tuple)) and len(cmd) > 0 and cmd[0] == 'flutter':
        path = shutil.which('flutter')
        if path:
            cmd = list(cmd)
            cmd[0] = path
    return cmd

def run(cmd, **kwargs):
    cmd = _resolve_exe(cmd)
    try:
        printable = ' '.join(cmd) if isinstance(cmd, (list, tuple)) else str(cmd)
    except Exception:
        printable = str(cmd)
    print(f"Running: {printable}")
    res = subprocess.run(cmd, cwd=ROOT, **kwargs)
    print(f"Exit: {res.returncode}\n")
    return res.returncode

def check_files():
    ok = True
    meta = ROOT / 'assets' / 'netnavi' / 'megaman' / 'megaman_meta.json'
    if not meta.exists():
        print('Missing meta:', meta)
        ok = False
    else:
        data = json.loads(meta.read_text(encoding='utf-8'))
        frames = data.get('frames_128') or data.get('frames')
        for f in frames:
            p = ROOT.joinpath(f['path'])
            if not p.exists():
                print('Missing frame file:', p)
                ok = False
    return ok

def main():
    # 1) analyze
    if run(['flutter', 'analyze']) != 0:
        print('flutter analyze failed')
    # 2) run asset generator
    py = sys.executable
    gen = ROOT / 'assets' / 'netnavi' / 'megaman' / 'generate_netnavi_assets.py'
    if run([py, str(gen)]) != 0:
        print('generator failed')
    # 3) run flutter test
    if run(['flutter', 'test']) != 0:
        print('flutter test failed')
    # 4) check files
    if not check_files():
        print('File checks failed')
        return 2
    print('CI run completed successfully')
    return 0

if __name__ == '__main__':
    sys.exit(main())
