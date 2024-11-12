if ! move.axes[0].homed || ! move.axes[1].homed
  M98 P"/sys/homexy.g"