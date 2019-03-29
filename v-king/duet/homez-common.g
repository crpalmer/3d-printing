M98 P"/macros/probe/front-middle"
G4 P500
G91			; relative positioning
G1 X+1 F3000		; move over so we don't leave any filament where we will ultimately probe
G30		        ; probe a little to squash any filament on the nozzle
G1 X-1 F3000
G90			; absolute positioning
G30    