G28
M190 S60		; preheat the bed to the temp we are likely to be using

G31			; delta bed calibration

M190 S0			; turn off the bed
G1 X0 Y0 Z50 F25000	; move back to the center of the bed
G28			; home

M374			; save bed calibration
