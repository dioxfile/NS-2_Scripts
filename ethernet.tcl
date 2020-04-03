set ns [new Simulator]
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$n0 color red
$n1 color red
set f [open saida.tr w]
$ns trace-all $f
set ArquivoNam [open NAM_file.nam w]
$ns namtrace-all $ArquivoNam
$ns duplex-link $n0 $n2 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $tcp $sink
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 1.0 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 300.0 "finish"
proc finish {} {
global ns f ArquivoNam
$ns flush-trace
close $f
close $ArquivoNam
exec nam NAM_file.nam &
exit 0
}
$ns run
