a = ["fluktuacje kwantowe", "fale grawitacji i grawitacja", "stworzenia morskie", "mój bez powodu zły na mnie ziom"]
b = []
for x in a: 
    for y in a:
        b.append(f'"{x}","{y}"')

pytania = '"Jak one moga byc ze soba powiazane powiazac? ' +\
    'Co jeżeli są funkcjami i powinny być powiązane?"'

c = [f'chatGPT_mysli({pytania}, {pair})' for pair in b]
# save to file
# fix polish signs with utf-8
text = ",\n".join(c)
text = f'[{text}]'
text = text.encode("utf-8").decode("utf-8")

print(text)
with open("tmp.txt", "w") as f:
    f.write(text)