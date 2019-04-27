; This wiping script is based on the one used by the taz6 printer...

M208 X360 S0            ; Allow us to move over to the wiping pad

; Touch the pad
G1 Z5
G1 X353 Y4 F12000
G1 Z0

; Do the wipe using relative moves so we only need to change the entry point, above
G91

; Slow wipe
G1 X2 Y5 F1000
G1 X-2 Y5
G1 X2 Y5
G1 X-2 Y-5
G1 X2 Y10
G1 X-2 Y-15

;Fast wipe
G1 X2 Y20 F2000
G1 X-2 Y10
G1 X2 Y-5
G1 X-2 Y10
G1 X2 Y5
G1 X-2 Y5
G1 X2 Y10
G1 X-2 Y-5
G1 X2 Y10
G1 X-2 Y-5
G1 X2 Y-30
G1 X-2 Y40 Z1
G1 X2 Y-5
G1 X-2 Y10
G1 X2 Y-5

; Slow wipe
G1 X-2 Y5 Z0.5 F1000
G1 X2 Y2

; Exit the wiping pad
G1 Z5
G90

; Back to the normal print bed
G1 X300 F12000
M98 P/sys/axis-limits.g