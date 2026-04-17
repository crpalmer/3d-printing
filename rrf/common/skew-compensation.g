; Save to 0:/macros/Skew calculator.g
; Inputs
var AC = global.skew_AC
var BD = global.skew_BD
var AD = global.skew_AD
var axis = "X" ; X = XY, Y = YZ, Z = ZX

; Compute skew
var AB = sqrt((var.AC * var.AC + var.BD * var.BD - 2 * var.AD * var.AD)/2)
var BAD = acos((var.AC * var.AC - var.AB * var.AB - var.AD * var.AD)/(2 * var.AB * var.AD))
var skew = -tan(pi/2 - var.BAD)
var AE = sin(var.BAD) * var.AB
var EB = var.skew * var.AE
var skewAtbaseHeight = var.skew * var.AD

echo "Inputs: AC = " ^ var.AC ^ "mm, BD = " ^ var.BD ^ "mm, AD = " ^ var.AD ^ "mm, axis = " ^ var.axis
echo "Calculated: Skew = " ^ var.skew ^ " or " ^ degrees(var.BAD)-90 ^ "° AB = " ^ var.AB ^ "mm, AE = " ^ var.AE ^ "mm, EB = " ^ var.EB ^ "mm, Skew @ " ^ var.AD ^ "mm = " ^ var.skewAtbaseHeight ^ "mm"
echo "Send either: M556 S1 " ^ var.axis ^ var.skew ^ " or: M556 S" ^ var.AD , var.axis ^ var.skewAtbaseHeight
M556 S1 X{var.skew}
M556