; Zendo preamble pre.gcode
G28 ; home all axes
; M109 S208 ;  stay cool..
G21 ; set units to millimeters
G90 ; use absolute coordinates
G0 Z30 F9000 ; lift nozzle
G1 F6000 Z30  Y70 
G1 Z10 X70
; end preamble