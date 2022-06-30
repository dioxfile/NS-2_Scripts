#
# nodes: 50, max conn: 8, send rate: 0.00390625, seed: 0.25
#
#
# 0 connecting to 1 at time 8.0978678042524805
#
set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $WN(1) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 500
$cbr_(0) set rate_ 256.0kb
$cbr_(0) set random_ 1
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)
$ns_ at 8.0978678042524805 "$cbr_(0) start"
#Total sources/connections: 1/1
#
