if ! move.axes[0].homed || ! move.axes[1].homed || (exists(move.axes[3]) && ! move.axes[3].homed)
  M98 P"/sys/homexy.g"