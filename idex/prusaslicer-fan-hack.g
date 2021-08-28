; PrusaSlicer doesn't understand that each tool can have its own fan.  Instead,
; the slicer simply sends M106 commands to control "the fan".  To work around
; this stupid behaviour, after a tool change invoke this macro to mirror the fan
; from the other tool

if state.currentTool == 0
  M106 P0 S{fans[2].requestedValue}
elif state.currentTool == 1
  M106 P2 S{fans[0].requestedValue}
endif