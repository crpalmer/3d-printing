; called when tool 1 is freed

if move.axes[3].homed
  G1 U{global.uMin+1} F24000