T0
echo "bed.g - after T0"
M122

G1 Z5

M401
echo "bed.g - after M401"
M122
G30 P0 X{global.frontX} Y{global.frontY} Z-99999
G30 P1 X{global.brX} Y{global.blrY} Z-99999
G30 P2 X{global.blX} Y{global.blrY} Z-99999 S3
M402
echo "bed.g - after M402"
M122
