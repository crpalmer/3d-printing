set global.probe_n_deploys = 1
M402   ; so rrf knows it is retracted and it will retract if rrf thinks it needs to
M98 P"/sys/retractprobe.g" ; but now it will also retract if rrf was wrong
