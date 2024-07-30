iterate:
LO x
ADD y
STO z
LO y
STO x
LO z
STO y
LO i
SUB J
STO i
JNZA iterate
halt:
LO i
ADD i
JNZA halt
x: 1
y: 1
z: 0
i: 8
J: 1