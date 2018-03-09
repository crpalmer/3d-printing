G28

; preheat the extruders & bed to probing temps
T1 M104 S170
T0 M104 S170
M190 S70
T1 M109 S170
T0 M109 S170

G32			; delta arm calibration
G31			; delta bed calibration

M190 S0			; turn off the bed
G1 X0 Y0 Z50 F25000	; move back to the center of the bed
G28			; home

M374			; save bed calibration
M500			; save configuration
