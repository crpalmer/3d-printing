set global.last_homez_failed = true
while iterations < 5 && global.last_homez_failed
  if iterations > 0
    echo "Z homing failed, retrying"
  G28 Z

if global.last_homez_failed
  abort "Failed to home Z even after retrying!!!"