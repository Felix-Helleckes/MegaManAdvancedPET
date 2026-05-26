fn=r'c:/GitHub/MegaManAdvancedPET/lib/modules/singleplayer/home_screen.dart'
line_no=244
with open(fn,'r',encoding='utf-8') as f:
    lines=f.readlines()
ln=lines[line_no-1]
print(line_no,repr(ln))
for i,ch in enumerate(ln,1):
    print(i, ch)
