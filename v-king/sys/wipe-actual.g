; This wiping script is based on the one used by the taz6 printer...
; I mirrored all the x moves

; Touch the pad
G1 Z5
G1 X362 Y53 F12000
G1 Z-0.5

; Do the wipe using relative moves so we only need to change the entry point, above
G91

; Slow wipe
G1 X-2 Y5 F1000
G1 X2 Y5
G1 X-2 Y5
G1 X2 Y-5
G1 X-2 Y10
G1 X2 Y-15

;Fast wipe
G1 X-2 Y20 F2000
G1 X2 Y10
G1 X-2 Y-5
G1 X2 Y10
G1 X-2 Y5
G1 X2 Y5
G1 X-2 Y10
G1 X2 Y-5
G1 X-2 Y10
G1 X2 Y-5
G1 X-2 Y-30
G1 X2 Y40 Z1
G1 X-2 Y-5
G1 X2 Y10
G1 X-2 Y-5

; Slow wipe
G1 X2 Y5 Z0.5 F1000
G1 X-2 Y2

; Exit the wiping pad
G1 Z5
G90

; Back to the normal print bed (front right probe point in case we are about to a G32)
G1 X305 Y0 F12000