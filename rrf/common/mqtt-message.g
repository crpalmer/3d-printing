if ! exists(param.S)
  abort "Missing required argument: S"

M586.4 C{network.hostname} O2
M586 P4 H"mqtt.crpalmer.org" S1 ; Enable MQTT protocol/client
M118 P6 S{param.S} T{"alerts/"^network.hostname}
M586 P4 S0                      ; Disable MQTT protocol/client; disconnects from broker 