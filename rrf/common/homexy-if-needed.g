if ! move.axes[0].homed or ! move.axes[1].homed or (exists(move.axes[3]) && ! move.axes[3].homed)
  M98 P"/sys/homexy.g"