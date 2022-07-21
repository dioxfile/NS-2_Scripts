#Script TCL Wireless Mesh/Ad-Hoc Networks
#=================GLOBAL+DEFINITIONS===================================#
  global val
  global defaultRNG                                  ;# RNG Global Var
  set val(canal)           Channel/WirelessChannel   ;# Channel(1-11)
  set val(propacacao)      Propagation/TwoRayGround  ;# Radio Propagation
  set val(antena)          Antenna/OmniAntenna       ;# Aerial (omni/straight)
  set val(layer2)          LL                        ;# Link Layer
  set val(drop)            Queue/DropTail/PriQueue   ;# Queue type
  set val(fileSize)          50                      ;# Queue size
  set val(wlan0)           Phy/WirelessPhy           ;# DSSS
  set val(mac)             Mac/802_11                ;# MAC Type
  set val(routP)           OLSR                      ;# Routing Protocol
 if { $val(routP) == "DSR" } {                       ;# Only DSR
  set val(drop)            CMUPriQueue		 
  } else {
  set val(drop)            Queue/DropTail/PriQueue   ;# FIFO Drop Queue
  }                                                  
  set val(node_)             50                      ;# Node Number Wi-Fi Domain 2
  set val(x)               1000                      ;# Axis X 
  set val(y)                540                      ;# Axis Y
  set val(TX)                 1.2W                   ;# Default NS2 - 0.400 -> 0,000509W/PKT
  set val(RX)                 0.6W                   ;# Default NS2 - 0.300 -> 0.000156W/PKT 
  set val(IniEner)          100.00                   ;# Initial Energy
  set val(ModEner)         EnergyModel               ;# Energy Model
  set val(termina)          100                      ;# Simulation Time
  set val(wired_0)            2                      ;# Define nodes in LAN Domain 0
  set val(wired_1)            2                      ;# Define nodes in LAN Domain 1
  set val(B_station)          2                      ;# Define Access Points Domain 2
#======================================================================#

# ---------------------BEGIN OLSR EXTENSIONS----------------------------
source "olsr-default.tcl"

# NIC Specification Ex. 802.11a, 802.11b, etc.
source "802-11b_functional.tcl"

#begin Simulation
set ns_ [new Simulator]
$defaultRNG seed NEW_SEED

#Setup Wired-Cum-Wireless (WCW)
$ns_ node-config -addressType hierarchical   ;# Hierarquical Address
AddrParams set domain_num_ 3                 ;# Domain Number (wired/wireless)
lappend cluster_num 1 1 1                    ;# Cluster Number by Domain
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel 2 52 2                   ;# Node Number by Cluster
AddrParams set nodes_num_ $eilastlevel

# Trace File Writing
set ArquivoTrace [open TRACE_FILE_WCW.tr w]
$ns_ trace-all $ArquivoTrace

# NAM File  Writing
set ArquivoNam [open NAM_Arquivo.nam w]
$ns_ namtrace-all $ArquivoNam
$ns_ namtrace-all-wireless $ArquivoNam $val(x) $val(y)

# Topology
set topologia [new Topography]
$topologia  load_flatgrid $val(x) $val(y)

# "GOD (General Operations Director)"
set god_ [create-god [expr $val(node_) + $val(B_station)] ]

#Starting Channel 1
set chan_11_ [new $val(canal)]

# Node Setup
$ns_ node-config -adhocRouting $val(routP) \
    -llType $val(layer2) \
		-macType $val(mac) \
		-ifqType $val(drop) \
		-ifqLen $val(fileSize) \
		-antType $val(antena) \
		-propType $val(propacacao) \
		-phyType $val(wlan0) \
		-topoInstance $topologia \
		-channel $chan_11_ \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace OFF \
		-energyModel $val(ModEner) \
		-initialEnergy $val(IniEner) \
		-wiredRouting ON \
		-rxPower $val(RX) \
		-txPower $val(TX) 

# Creating Wired Nodes (Domain 0)
set Ethernet1 {0.0.0 0.0.1}
for {set i 0} {$i < $val(wired)} {incr i} {
set WN0($i) [$ns_ node [lindex $Ethernet $i]]
    $WN0($i) color red
    $ns_ at 0.0 "$WN0($i) color red"
    $ns_ at 0.0 "$WN0($i) label Ether$i"
}

# Creating Wired Nodes (Domain 1)
set Ethernet2 {1.0.0 1.0.1}
for {set i 0} {$i < $val(wired)} {incr i} {
set WN1($i) [$ns_ node [lindex $Ethernet $i]]
    $WN1($i) color red
    $ns_ at 0.0 "$WN1($i) color red"
    $ns_ at 0.0 "$WN1($i) label Ether$i"
}
	
# Creating Wireless Nodes 
set wireless { 2.0.0 2.0.1 2.0.2 2.0.3 2.0.4 2.0.5 2.0.6 2.0.7 2.0.8 2.0.9 
	 2.0.10 2.0.11 2.0.12 2.0.13 2.0.14 2.0.15 2.0.16 2.0.17 2.0.18 2.0.19 
	 2.0.20 2.0.21 2.0.22 2.0.23 2.0.24 2.0.25 2.0.26 2.0.27 2.0.28 2.0.29 
	 2.0.30 2.0.31 2.0.32 2.0.33 2.0.34 2.0.35 2.0.36 2.0.37 2.0.38 2.0.39 
	 2.0.40 2.0.41 2.0.42 2.0.43 2.0.44 2.0.45 2.0.46 2.0.47 2.0.48 2.0.49 
	 2.0.50 2.0.51 }
# Setting AP(0) as first node and AP position
set AP(0) [ $ns_ node [lindex $wireless 0] ]
$AP(0) color blue
$ns_ at 0.0 "$AP(0) color blue"
$ns_ at 0.0 "$AP(0) label Access_Point"
$AP(0) random-motion 0 ;# disable
$AP(0) set X_ 361.0
$AP(0) set Y_ 312.0
$AP(0) set Z_ 0.0

# Setting AP(1) as last node and AP position
set AP(0) [ $ns_ node [lindex $wireless 49] ]
$AP(1) color blue
$ns_ at 0.0 "$AP(1) color blue"
$ns_ at 0.0 "$AP(1) label Access_Point"
$AP(1) random-motion 0 ;# disable
$AP(1) set X_ 926.0
$AP(1) set Y_ 415.3
$AP(1) set Z_ 0.0

# Disable wired routing for Wi-Fi Nodes
$ns_ node-config -wiredRouting OFF
for {set i 0} {$i < expr $val(node_)} {incr i} {
	set node_($i) [$ns_ node [lindex $wireless [expr $i+1]]]
	$node_($i) color blue
    $ns_ at 0.0 "$node_($i) color blue"
    $ns_ at 0.0 "$node_($i) label Wlan$i"
    # Provide each wireless node with the Access Point identification address
    $node_($i) base-station [AddrParams addr2id [$AP(0) node-addr]]
    $node_($i) base-station [AddrParams addr2id [$AP(1) node-addr]]
    $node_($i) random-motion 0 ;# disable
}

#Creating a FullDuplex connection between the AP(0) and the wired Nodes
$ns_ duplex-link $WN0(0) $AP(0) 100Mb 2ms DropTail
$ns_ duplex-link $WN0(1) $AP(0) 100Mb 2ms DropTail
#Direction of the flows between the AP and the Wired nodes
$ns_ duplex-link-op $WN0(0)   $AP(0) orient left-up
$ns_ duplex-link-op $WN0(1)   $AP(0) orient left-up
$ns_ duplex-link-op $WN0(0)   $AP(0) orient left-down
$ns_ duplex-link-op $WN0(1)   $AP(0) orient left-down

#Creating a FullDuplex connection between the AP(1) and the wired Nodes
$ns_ duplex-link $WN1(0) $AP(1) 100Mb 2ms DropTail
$ns_ duplex-link $WN1(1) $AP(1) 100Mb 2ms DropTail
#Direction of the flows between the AP and the Wired nodes
$ns_ duplex-link-op $WN1(0)   $AP(1) orient left-up
$ns_ duplex-link-op $WN1(1)   $AP(1) orient left-up
$ns_ duplex-link-op $WN1(0)   $AP(1) orient left-down
$ns_ duplex-link-op $WN1(1)   $AP(1) orient left-down

################Starting Mobility Model and Traffic Model###############
puts "Starting Random WayPoint (eg., file mobility.tcl)."
source "mobility-wcw.tcl" 
puts "Starting Traffic"
source "traffic_wcw.tcl"

# NAM Position 
for {set n 0} {$n < $val(node_) } {incr n} {
 $ns_ initial_node_pos $node_($n) 20
}

# Stop nodes simulation
for {set n 0} {$n < $val(node_) } {incr n} {
 $ns_ at $val(termina).000 "$node_($n) reset";
}

for {set n 0} {$n < $val(wired_0) } {incr n} {
 $ns_ at $val(termina).0001 "$WN0($n) reset";
}

for {set n 0} {$n < $val(wired_1) } {incr n} {
 $ns_ at $val(termina).0001 "$WN1($n) reset";
}

$ns_ at $val(termina).0001 "$AP(0) reset";
$ns_ at $val(termina).0001 "$AP(1) reset";

proc final {} {
global ns_ ArquivoTrace ArquivoNam val geral
$ns_ flush-trace
close $ArquivoTrace
close $ArquivoNam
exec nam NAM_Arquivo.nam &
exit 0
}

puts "Starting Simulation"
$ns_ at $val(termina).001 "$ns_ nam-end-wireless $val(termina)"
$ns_ at $val(termina).002 "puts \"END SIMULATION...\"; final"
$ns_ at $val(termina).003 "$ns_ halt"
$ns_ run
