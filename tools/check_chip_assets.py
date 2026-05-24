import re
from pathlib import Path

repo_root = Path(__file__).resolve().parents[1]
model = repo_root / 'lib' / 'core' / 'models' / 'battle_chip.dart'
assets_dir = repo_root / 'assets' / 'images' / 'chips'
report = repo_root / 'reports' / 'missing_chip_images.txt'
unref_report = repo_root / 'reports' / 'unreferenced_chip_images.txt'

ids = set()
if model.exists():
    txt = model.read_text(encoding='utf-8')
    # extract ids from fullCatalog entries like BattleChip(id: 'chip_001',
    for m in re.finditer(r"BattleChip\(id:\s*'([^']+)'", txt):
        ids.add(m.group(1))

# also include any placeholder ids in code (chip_### pattern)
for m in re.finditer(r"chip_(\d{1,3})", txt):
    ids.add('chip_' + m.group(1))

# Detect generated ranges like: for (var i = 1; i <= 320; i++) and add those ids
range_match = re.search(r"for\s*\(var\s+\w+\s*=\s*1;\s*\w+\s*<=\s*(\d+);", txt)
if range_match:
    max_n = int(range_match.group(1))
    for i in range(1, max_n + 1):
        ids.add(f'chip_{i}')

assets = {p.name for p in assets_dir.glob('BattleChip*.png')} if assets_dir.exists() else set()

missing = []
for cid in sorted(ids):
    m = re.search(r'chip_(\d+)', cid)
    if m:
        padded = m.group(1).zfill(3)
        fname = f'BattleChip{padded}.png'
        if fname not in assets:
            missing.append(f'{cid} -> {fname}')

report.parent.mkdir(exist_ok=True)
report.write_text('\n'.join(missing), encoding='utf-8')
unreferenced = sorted([a for a in assets if not any(a == f'BattleChip{m.group(1).zfill(3)}.png' for m in [re.search(r'chip_(\d+)', x) for x in ids] if m)])
unref_report.write_text('\n'.join(unreferenced), encoding='utf-8')
print(f'Wrote report with {len(missing)} missing entries to {report}')
print(f'Wrote report with {len(unreferenced)} unreferenced assets to {unref_report}')
