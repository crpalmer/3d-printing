if state.currentTool >= 0
  M98 P{"/sys/wipe" ^ state.currentTool ^ ".g"}
