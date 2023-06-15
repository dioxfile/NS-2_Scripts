set ns_ [new Simulator]
#Nodes Definitions_
set node_(0) [$ns_ node]
set node_(1) [$ns_ node]
set node_(2) [$ns_ node]
set node_(3) [$ns_ node]
set node_(4) [$ns_ node]
set node_(5) [$ns_ node]
$node_(0) color red
$node_(1) color red
$node_(2) color blue
$node_(3) color blue

#Logging Trace and NAM
set f [open saida.tr w]
$ns_ trace-all $f
set ArquivoNam [open NAM_file.nam w]
$ns_ namtrace-all $ArquivoNam

#Links Definitions_
$ns_ duplex-link $node_(0) $node_(2) 5Mb 10ms DropTail
$ns_ duplex-link $node_(1) $node_(2) 2Mb 10ms DropTail
$ns_ simplex-link $node_(2) $node_(3) 10Mb 100ms DropTail
$ns_ simplex-link $node_(3) $node_(2) 10Mb 100ms DropTail
set lan [$ns_ newLan "$node_(3) $node_(4) $node_(5)" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

#Traffics and Applications Definitions
# --- UDP N0--N4
set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(5) $null_(0)
# --- CBR
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 500
$cbr_(0) set rate_ 128.0kb
$cbr_(0) set random_ 1
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)
$ns_ at 1.0 "$cbr_(0) start"
# --- TCP N1--N5
set tcp_(0) [$ns_ create-connection  TCP $node_(1) TCPSink $node_(4) 0]
$tcp_(0) set window_ 32
$tcp_(0) set packetSize_ 500
$tcp_(0) set rate_ 128.0kb
# --- FTP
set ftp_(0) [$tcp_(0) attach-source FTP]
$ns_ at 1.0 "$ftp_(0) start"

#Finish Simulation
$ns_ at 300.0 "finish"
proc finish {} {
global ns_ f ArquivoNam
$ns_ flush-trace
close $f
close $ArquivoNam
exec nam NAM_file.nam &
exit 0
}
$ns_ run
