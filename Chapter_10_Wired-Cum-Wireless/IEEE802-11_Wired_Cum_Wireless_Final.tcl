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
  set val(x)               1000.0                    ;# Axis X 
  set val(y)                540.0                    ;# Axis Y
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
source "802-11b_functional_final.tcl"

#begin Simulation
set ns_ [new Simulator]
$defaultRNG seed NEW_SEED

#Setup Wired-Cum-Wireless (WCW)
$ns_ node-config -addressType hierarchical   ;# Hierarquical Address
AddrParams set domain_num_ 3                 ;# Domain Number (wired/wireless)
lappend cluster_num 2 1 1                    ;# Cluster Number by Domain
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel 2 50 2 2                 ;# Node Number by Cluster
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
$topologia load_flatgrid $val(x) $val(y)

# "GOD (General Operations Director)"
set god_ [ create-god [ expr $val(node_) + $val(B_station) ] ]

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

# Creating Wired Nodes (Domain 1)
set Ethernet0 { 1.0.0 1.0.1 }
for {set i 0} {$i < $val(wired_0)} {incr i} {
set WN0($i) [$ns_ node [lindex $Ethernet0 $i]]
    $WN0($i) color red
    $ns_ at 0.0 "$WN0($i) color red"
    $ns_ at 0.0 "$WN0($i) label Ether$i"
}
#Wired Node Position (Domain 1)
$WN0(0) set X_ 324.290
$WN0(0) set Y_ 328.499
$WN0(0) set Z_ 0.0
$WN0(1) set X_ 344.931
$WN0(1) set Y_ 278.145
$WN0(1) set Z_ 0.0

# Creating Wired Nodes (Domain 2)
set Ethernet1 { 2.0.0 2.0.1 }
for {set i 0} {$i < $val(wired_1)} {incr i} {
set WN1($i) [$ns_ node [lindex $Ethernet1 $i]]
    $WN1($i) color red
    $ns_ at 0.0 "$WN1($i) color red"
    $ns_ at 0.0 "$WN1($i) label Ether$i"
}
#Wired Node Position (Domain 2)
$WN1(0) set X_ 938.142
$WN1(0) set Y_ 414.229
$WN1(0) set Z_ 0.0
$WN1(1) set X_ 972.138
$WN1(1) set Y_ 374.162
$WN1(1) set Z_ 0.0

# Creating Wireless Nodes (Domain 0)
set wireless { 0.0.0 0.0.1 0.1.0 0.1.1 0.1.2 0.1.3 0.1.4 0.1.5 0.1.6 0.1.7 0.1.8 0.1.9 
	 0.1.10 0.1.11 0.1.12 0.1.13 0.1.14 0.1.15 0.1.16 0.1.17 0.1.18 0.1.19 
	 0.1.20 0.1.21 0.1.22 0.1.23 0.1.24 0.1.25 0.1.26 0.1.27 0.1.28 0.1.29 
	 0.1.30 0.1.31 0.1.32 0.1.33 0.1.34 0.1.35 0.1.36 0.1.37 0.1.38 0.1.39 
	 0.1.40 0.1.41 0.1.42 0.1.43 0.1.44 0.1.45 0.1.46 0.1.47 0.1.48 0.1.49 }
	 
# Setting AP(0) as first node and AP position
set AP(0) [ $ns_ node [ lindex $wireless 0 ] ]
$AP(0) color black
$ns_ at 0.0 "$AP(0) color black"
$ns_ at 0.0 "$AP(0) label Access_Point"
$AP(0) set X_ 361.0
$AP(0) set Y_ 312.0
$AP(0) set Z_ 0.0
$AP(0) random-motion 0 ;# disable

# Setting AP(1) as last node and AP position
set AP(1) [ $ns_ node [ lindex $wireless 1 ] ]
$AP(1) color black
$ns_ at 0.0 "$AP(1) color black"
$ns_ at 0.0 "$AP(1) label Access_Point"
$AP(1) set X_ 926.0
$AP(1) set Y_ 415.3
$AP(1) set Z_ 0.0
$AP(1) random-motion 0 ;# disable

# Disable wired routing for Wi-Fi Nodes
$ns_ node-config -wiredRouting OFF
for {set i 0} {$i < $val(node_) } {incr i} {
	set node_($i) [ $ns_ node [ lindex $wireless [ expr $i+2 ] ] ]
	$node_($i) color blue
    $ns_ at 0.0 "$node_($i) color blue"
    $ns_ at 0.0 "$node_($i) label Wlan$i"
    # Provide each wireless node with the Access Point identification address
    $node_($i) base-station [AddrParams addr2id [$AP(0) node-addr]]
    $node_($i) base-station [AddrParams addr2id [$AP(1) node-addr]]
    $node_($i) random-motion 0 ;# disable
}

#Creating a FullDuplex connection between the AP(0) and the wired Nodes
$ns_ duplex-link $WN0(0) $WN0(1) 5Mb 2ms DropTail
$ns_ duplex-link $WN0(1) $WN0(0) 5Mb 2ms DropTail
$ns_ duplex-link $WN0(0) $AP(0) 5Mb 2ms DropTail
#$ns_ duplex-link $WN0(1) $AP(0) 5Mb 2ms DropTail
#Direction of the flows between the AP and the Wired nodes
$ns_ duplex-link-op $WN0(0) $WN0(1) orient right-down
$ns_ duplex-link-op $WN0(0) $WN0(1) orient left-up
$ns_ duplex-link-op $WN0(1) $WN0(0) orient right-down
$ns_ duplex-link-op $WN0(1) $WN0(0) orient left-up
$ns_ duplex-link-op $WN0(0) $AP(0) orient right-down
$ns_ duplex-link-op $WN0(0) $AP(0) orient left-up

#Creating a FullDuplex connection between the AP(1) and the wired Nodes
$ns_ duplex-link $WN1(0) $WN1(1) 5Mb 2ms DropTail
$ns_ duplex-link $WN1(1) $WN1(0) 5Mb 2ms DropTail
$ns_ duplex-link $WN1(0) $AP(1) 5Mb 2ms DropTail
#$ns_ duplex-link $WN1(1) $AP(1) 5Mb 2ms DropTail
#Direction of the flows between the AP and the Wired nodes
$ns_ duplex-link-op $WN1(0) $WN1(1) orient left-down
$ns_ duplex-link-op $WN1(0) $WN1(1) orient right-up
$ns_ duplex-link-op $WN1(1) $WN1(0) orient left-down
$ns_ duplex-link-op $WN1(1) $WN1(0) orient right-up
$ns_ duplex-link-op $WN1(0) $AP(1) orient left-down
$ns_ duplex-link-op $WN1(0) $AP(1) orient right-up


################Starting Mobility Model and Traffic Model###############
puts "Starting Random WayPoint (eg., file mobility.tcl)."
source "mobility-wcw-final.tcl" 
puts "Starting Traffic"
source "traffic-wcw-final.tcl"

# NAM Position 
for {set n 0} {$n < $val(node_) } {incr n} {
 $ns_ initial_node_pos $node_($n) 20
}

# Stop nodes simulation
for {set n 0} {$n < $val(node_) } {incr n} {
 $ns_ at $val(termina).0001 "$node_($n) reset";
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
