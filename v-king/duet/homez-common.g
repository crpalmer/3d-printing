M98 P"/macros/probe/front-middle"
G91			; relative positioning
G1 X+2 F3000            ; move away from where we actually probe in G32
G90			; absolute positioning
G4 P500
G30    