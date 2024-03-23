iterate:
LO x
ADD y
STO z
LO y
STO x
LO z
STR y
LO i
SUB J
STO i
JNZA iterate
halt:
LO I
ADD I
JNZA halt
x: 1
y: 1
z: 0
i: 8
J: 1