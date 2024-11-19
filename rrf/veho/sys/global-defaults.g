set global.print_ended_x = move.axes[0].max - 1
set global.print_ended_y = move.axes[1].max - 1

set global.bed_middle_x = 300
set global.bed_probe_points = { {100, 100}, {100, 500}, {500, 500}, {500, 100} }

set global.klicky_is_manual = true
set global.klicky_pre_x = move.axes[0].max - 1
set global.klicky_pre_y = 200
