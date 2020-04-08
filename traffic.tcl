# nodes: 10, max conn: 4, send rate: 0.015625, seed: 0.75
# 0 connecting to 1 at time 7.0322529910748139
set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(1) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 512
$cbr_(0) set rate_ 64.0kb
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)
$ns_ at 7.0322529910748139 "$cbr_(0) start"
# 1 connecting to 2 at time 7.0561181971133307
set udp_(1) [new Agent/UDP]
$ns_ attach-agent $node_(1) $udp_(1)
set null_(1) [new Agent/Null]
$ns_ attach-agent $node_(2) $null_(1)
set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 512
$cbr_(1) set rate_ 64.0kb
$cbr_(1) attach-agent $udp_(1)
$ns_ connect $udp_(1) $null_(1)
$ns_ at 7.0561181971133307 "$cbr_(1) start"
# 3 connecting to 4 at time 7.094137685044732
set udp_(2) [new Agent/UDP]
$ns_ attach-agent $node_(3) $udp_(2)
set null_(2) [new Agent/Null]
$ns_ attach-agent $node_(4) $null_(2)
set cbr_(2) [new Application/Traffic/CBR]
$cbr_(2) set packetSize_ 512
$cbr_(2) set rate_ 64.0kb
$cbr_(2) attach-agent $udp_(2)
$ns_ connect $udp_(2) $null_(2)
$ns_ at 7.094137685044732 "$cbr_(2) start"
# 4 connecting to 5 at time 7.0170415855092187
set udp_(3) [new Agent/UDP]
$ns_ attach-agent $node_(4) $udp_(3)
set null_(3) [new Agent/Null]
$ns_ attach-agent $node_(5) $null_(3)
set cbr_(3) [new Application/Traffic/CBR]
$cbr_(3) set packetSize_ 512
$cbr_(3) set rate_ 64.0kb
$cbr_(3) attach-agent $udp_(3)
$ns_ connect $udp_(3) $null_(3)
$ns_ at 7.0170415855092187 "$cbr_(3) start"
#Total sources/connections: 4/4
