; called when tool 0 is freed

if move.axes[0].homed
  G1 X{global.xMax-1} F24000