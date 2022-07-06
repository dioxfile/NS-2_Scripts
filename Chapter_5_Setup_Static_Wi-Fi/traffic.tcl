#
# nodes: 10, max conn: 4, send rate: 0.0078125, seed: 0.75
#
#
# 0 connecting to 1 at time 8.0388103989133661
#
set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(1) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 1000
$cbr_(0) set rate_ 128.0kb
$cbr_(0) set random_ 1
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)
$ns_ at 8.0388103989133661 "$cbr_(0) start"
#
# 1 connecting to 2 at time 8.0328616288643619
#
set udp_(1) [new Agent/UDP]
$ns_ attach-agent $node_(1) $udp_(1)
set null_(1) [new Agent/Null]
$ns_ attach-agent $node_(2) $null_(1)
set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 1000
$cbr_(1) set rate_ 128.0kb
$cbr_(1) set random_ 1
$cbr_(1) attach-agent $udp_(1)
$ns_ connect $udp_(1) $null_(1)
$ns_ at 8.0328616288643619 "$cbr_(1) start"
#
# 5 connecting to 6 at time 8.0476940825337984
#
set udp_(2) [new Agent/UDP]
$ns_ attach-agent $node_(5) $udp_(2)
set null_(2) [new Agent/Null]
$ns_ attach-agent $node_(6) $null_(2)
set cbr_(2) [new Application/Traffic/CBR]
$cbr_(2) set packetSize_ 1000
$cbr_(2) set rate_ 128.0kb
$cbr_(2) set random_ 1
$cbr_(2) attach-agent $udp_(2)
$ns_ connect $udp_(2) $null_(2)
$ns_ at 8.0476940825337984 "$cbr_(2) start"
#
# 7 connecting to 8 at time 8.0364089657722086
#
set udp_(3) [new Agent/UDP]
$ns_ attach-agent $node_(7) $udp_(3)
set null_(3) [new Agent/Null]
$ns_ attach-agent $node_(8) $null_(3)
set cbr_(3) [new Application/Traffic/CBR]
$cbr_(3) set packetSize_ 1000
$cbr_(3) set rate_ 128.0kb
$cbr_(3) set random_ 1
$cbr_(3) attach-agent $udp_(3)
$ns_ connect $udp_(3) $null_(3)
$ns_ at 8.0364089657722086 "$cbr_(3) start"
#
#Total sources/connections: 4/4
#
