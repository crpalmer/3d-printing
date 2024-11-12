T0
G1 Z5

M401

while true
  if iterations >= 5
    abort "G32 probing failed to converge"

  G30 P0 X100 Y100 Z-99999
  if result != 0
    continue

  G30 P1 X100 Y500 Z-99999
  if result != 0
    continue
      
  G30 P2 X500 Y500 Z-99999
  if result != 0
    continue
      
  G30 P3 X500 Y100 Z-99999 S4
  if result != 0
    continue    

  echo "Pre-calibration mean error was "^ move.calibration.initial.mean ^ "mm"
  if abs(move.calibration.initial.mean) <= 0.01
    break

  echo "Repeating calibration because the mean error is too high (" ^ move.calibration.initial.mean ^ "mm)"
  
M402