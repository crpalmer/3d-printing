all: \
	configs/chimera-fsr configs/chimera-ir \
	configs/stock-fsr configs/stock-ir

configs/chimera-fsr: config config.chimera config.fsr
	cat config config.chimera config.fsr | egrep -v STOCK_ONLY> configs/chimera-fsr

configs/chimera-ir: config config.chimera config.ir
	cat config config.chimera config.ir | egrep -v STOCK_ONLY> configs/chimera-ir

configs/stock-fsr: config config.stock config.fsr
	cat config config.stock config.fsr | egrep -v CHIMERA_ONLY> configs/stock-fsr

configs/stock-ir: config config.stock config.ir
	cat config config.stock config.ir | egrep -v CHIMERA_ONLY> configs/stock-ir
