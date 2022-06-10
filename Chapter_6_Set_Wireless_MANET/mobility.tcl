#nodes: 3, speed type: 1, min speed: 5.00, max speed: 20.00 
#avg speed: 10.19, pause type: 1, pause: 3.00, max x: 1000.00, 
#max y: 1000.00
$node_(0) set X_ 300.000000000000
$node_(0) set Y_ 50.000000000000
$node_(0) set Z_ 0.000000000000
$node_(1) set X_ 900.000000000000
$node_(1) set Y_ 900.000000000000
$node_(1) set Z_ 0.000000000000
$node_(2) set X_ 500.000000000000
$node_(2) set Y_ 500.000000000000
$node_(2) set Z_ 0.000000000000
$ns_ at 0.000000000000 "$node_(0) setdest 132.493959869897 232.432901474192 7.877060257231"
$ns_ at 0.000000000000 "$node_(1) setdest 37.490348051766 960.543227100976 10.314614129122"
$ns_ at 0.000000000000 "$node_(2) setdest 633.549928613563 603.605263994517 9.293105009237"
$god_ set-dist 0 1 16777215
$god_ set-dist 0 2 1
$god_ set-dist 1 2 16777215
$ns_ at 14.644108582841 "$node_(0) setdest 132.493959869897 232.432901474192 0.000000000000"
$ns_ at 17.644108582841 "$node_(0) setdest 940.793540255413 438.049090121456 10.701127853439"
$ns_ at 40.228578482824 "$god_ set-dist 0 1 2"
$ns_ at 40.228578482824 "$god_ set-dist 1 2 1"
# Destination Unreachables: 2
# Route Changes: 2
# Link Changes: 1
# Node | Route Changes | Link Changes
#    0 |             1 |            0
#    1 |             2 |            1
#    2 |             1 |            1
