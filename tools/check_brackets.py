from pathlib import Path
p=Path(r'c:/GitHub/MegaManAdvancedPET/lib/modules/singleplayer/home_screen.dart')
s=p.read_text()
stack=[]
pairs={'(':')','{':'}','[':']'}
opens='({['
closes=')}]'
for i,ch in enumerate(s,1):
    if ch in opens:
        stack.append((ch,i))
    elif ch in closes:
        if not stack:
            print('Unmatched closing',ch,'at',i)
            break
        last, pos = stack.pop()
        if pairs[last]!=ch:
            print('Mismatched', last, 'opened at', pos, 'but closed by', ch, 'at', i)
            break
else:
    if stack:
        for ch,pos in stack:
            print('Unclosed',ch,'at',pos)
    else:
        print('All balanced')

# If earlier mismatch, print line/col for positions
def pos_to_linecol(text, pos):
    line = text.count('\n', 0, pos) + 1
    col = pos - (text.rfind('\n', 0, pos))
    return line, col

try:
    with open(r'c:/GitHub/MegaManAdvancedPET/lib/modules/singleplayer/home_screen.dart','r',encoding='utf-8') as f:
        s=f.read()
    # re-run to find mismatch with line/col
    stack=[]
    for i,ch in enumerate(s,1):
        if ch in opens:
            stack.append((ch,i))
        elif ch in closes:
            if not stack:
                print('Unmatched closing',ch,'at',pos_to_linecol(s,i))
                break
            last, pos = stack.pop()
            if pairs[last]!=ch:
                print('MISMATCH: opened', last,'at',pos_to_linecol(s,pos),'but closed by',ch,'at',pos_to_linecol(s,i))
                break
    else:
        if stack:
            for ch,pos in stack:
                print('Unclosed',ch,'at',pos_to_linecol(s,pos))
        else:
            print('All balanced')
except Exception as e:
    print('Error in diagnostics',e)
