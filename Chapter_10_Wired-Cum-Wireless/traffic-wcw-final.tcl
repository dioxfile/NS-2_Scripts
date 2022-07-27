# nodes: 6, max conn: 3, send rate: 64.0Kb and 128.0Kb, seed: 0.75

# node_(0) connecting to WN0(0) at time 8.0395525506881782
set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $WN0(0) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 250
$cbr_(0) set rate_ 64.0kb
$cbr_(0) set random_ 1
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)
$ns_ at 8.0395525506881782 "$cbr_(0) start"
# node_(29) connecting to WN1(1) at time 8.0849432202917253
set udp_(1) [new Agent/UDP]
$ns_ attach-agent $node_(29) $udp_(1)
set null_(1) [new Agent/Null]
$ns_ attach-agent $WN1(1) $null_(1)
set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 250
$cbr_(1) set rate_ 64.0kb
$cbr_(1) set random_ 1
$cbr_(1) attach-agent $udp_(1)
$ns_ connect $udp_(1) $null_(1)
$ns_ at 8.0849432202917253 "$cbr_(1) start"
# 40 connecting to 18 at time 10.025911885325758
set tcp_(0) [$ns_ create-connection  TCP $node_(40) TCPSink $node_(18) 0]
$tcp_(0) set window_ 32
$tcp_(0) set packetSize_ 500
set ftp_(0) [$tcp_(0) attach-source FTP]
$ns_ at 10.025911885325758 "$ftp_(0) start"
#Total sources/connections: 3/3
