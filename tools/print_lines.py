fn=r'c:/GitHub/MegaManAdvancedPET/lib/modules/singleplayer/home_screen.dart'
with open(fn,'r',encoding='utf-8') as f:
    lines=f.readlines()
for i in range(620,636):
    print(i+1, repr(lines[i]))
