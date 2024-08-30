M420 S0            ; Turn off any mesh leveling
M290 P0 Z0         ; Clear babystepping

G28 Z

G1 Z7 F12000
{% for xy in [
  [155, 520], [445, 520],
  [ 85, 270], [515, 270],
  [155,  20], [445, 20]
 ] %}
  G1 X{{xy[0]}} Y{{xy[1]}}
  G30
  G1 Z7 F12000
{% endfor %}
G1 X300 Y300 F12000
