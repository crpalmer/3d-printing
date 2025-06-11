; PrusaSlicer doesn't understand that each tool can have its own fan.  Instead,
; the slicer simply sends M106 commands to control "the fan".  To work around
; this stupid behaviour, during a tool change invoke this macro to mirror the fan
; from the other tool

var new_tool = exists(param.E) ? param.E : state.currentTool

if state.currentTool >= 0 && state.currentTool != var.new_tool
  ; Lift Z
  var z = move.axes[2].userPosition
  G1 Z{var.z+0.5}
 
  ; Set the fan speed
  var old_fan = state.currentTool == 0 ? 0 : 2
  var new_fan = state.currentTool == 0 ? 2 : 0
  M106 P{var.new_fan} S{fans[var.old_fan].requestedValue}
  M106 P{var.old_fan} S0

  ; Switch the tool and ensure Z is reset for any tool position differences
  T{var.new_tool}
  G1 Z{var.z+0.5}

  ; NOTE: We depend on PrusaSlicer setting Z to the print height after a tool change.