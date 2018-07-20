; This does repeated probes:
; M558 P4 H5 I1 A50 S0.015 R1
;M558 P4 H5 I1 A1 R2
M558 P4 H2 I1
; aluminum bed: G31 P250 X0 Y0 Z-0.45                   ; Set Z probe trigger value, offset and trigger height (was 0.425 end of june 2018)
; G31 P250 X0 Y0 Z-0.230                   ; Set Z probe trigger value, offset and trigger height (was 0.425 end of june 2018)
;G31 P250 X0 Y0 Z-0.25                   ; Set Z probe trigger value, offset and trigger height (was 0.425 end of june 2018)
G31 P250 X0 Y0 Z-0.2                   ; Set Z probe trigger value, offset and trigger height (was 0.425 end of june 2018)
