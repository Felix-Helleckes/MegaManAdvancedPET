import sys
fn=r'c:/GitHub/MegaManAdvancedPET/lib/modules/singleplayer/home_screen.dart'
start= int(sys.argv[1])
end = int(sys.argv[2])
with open(fn,'r',encoding='utf-8') as f:
    for i,line in enumerate(f,1):
        if i<start: continue
        if i> end: break
        print(f"{i:4}: {line.rstrip()}")
