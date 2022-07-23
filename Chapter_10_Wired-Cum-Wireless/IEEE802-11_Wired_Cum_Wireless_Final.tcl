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
  set val(routP)           AODV                      ;# Routing Protocol
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
  set val(wired)              4                      ;# Define nodes in LAN Domain 0
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
AddrParams set domain_num_ 2                 ;# Domain Number (wired/wireless)
lappend cluster_num 1 1                      ;# Cluster Number by Domain
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel 4 52                     ;# Node Number by Cluster
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

# Creating Wired Nodes (Domain 0)
set Ethernet { 0.0.0 0.0.1 0.0.2 0.0.3 }
for {set i 0} {$i < $val(wired)} {incr i} {
set WN($i) [$ns_ node [lindex $Ethernet $i]]
    $WN($i) color red
    $ns_ at 0.0 "$WN($i) color red"
    $ns_ at 0.0 "$WN($i) label Ether$i"
}

# Creating Wireless Nodes 
set wireless { 1.0.0 1.0.1 1.0.2 1.0.3 1.0.4 1.0.5 1.0.6 1.0.7 1.0.8 1.0.9 
	 1.0.10 1.0.11 1.0.12 1.0.13 1.0.14 1.0.15 1.0.16 1.0.17 1.0.18 1.0.19 
	 1.0.20 1.0.21 1.0.22 1.0.23 1.0.24 1.0.25 1.0.26 1.0.27 1.0.28 1.0.29 
	 1.0.30 1.0.31 1.0.32 1.0.33 1.0.34 1.0.35 1.0.36 1.0.37 1.0.38 1.0.39 
	 1.0.40 1.0.41 1.0.42 1.0.43 1.0.44 1.0.45 1.0.46 1.0.47 1.0.48 1.0.49 
	 1.0.50 1.0.51 }
	 
# Setting AP(0) as first node and AP position
set AP(0) [ $ns_ node [lindex $wireless 0] ]
$AP(0) color black
$ns_ at 0.0 "$AP(0) color black"
$ns_ at 0.0 "$AP(0) label Access_Point"
$AP(0) set X_ 361.0
$AP(0) set Y_ 312.0
$AP(0) set Z_ 0.0
$AP(0) random-motion 0 ;# disable

# Setting AP(1) as last node and AP position
set AP(1) [ $ns_ node [lindex $wireless 1] ]
$AP(1) color black
$ns_ at 0.0 "$AP(1) color black"
$ns_ at 0.0 "$AP(1) label Access_Point"
$AP(1) set X_ 926.0
$AP(1) set Y_ 415.3
$AP(1) set Z_ 0.0
#$AP(1) random-motion 0 ;# disable

# Disable wired routing for Wi-Fi Nodes
$ns_ node-config -wiredRouting OFF
for {set i 0} {$i < $val(node_) } {incr i} {
	set node_($i) [$ns_ node [lindex $wireless [expr $i+2]]]
	$node_($i) color blue
    $ns_ at 0.0 "$node_($i) color blue"
    $ns_ at 0.0 "$node_($i) label Wlan$i"
    # Provide each wireless node with the Access Point identification address
    $node_($i) base-station [AddrParams addr2id [$AP(0) node-addr]]
    $node_($i) base-station [AddrParams addr2id [$AP(1) node-addr]]
    $node_($i) random-motion 0 ;# disable
}

#Creating a FullDuplex connection between the AP(0) and the wired Nodes
$ns_ duplex-link $WN(0) $AP(0) 100Mb 2ms DropTail
$ns_ duplex-link $WN(1) $AP(0) 100Mb 2ms DropTail
#Direction of the flows between the AP and the Wired nodes
$ns_ duplex-link-op $WN(0) $AP(0) orient left-up
$ns_ duplex-link-op $WN(1) $AP(0) orient left-up
$ns_ duplex-link-op $WN(0) $AP(0) orient left-down
$ns_ duplex-link-op $WN(1) $AP(0) orient left-down

#Creating a FullDuplex connection between the AP(1) and the wired Nodes
$ns_ duplex-link $WN(2) $AP(1) 100Mb 2ms DropTail
$ns_ duplex-link $WN(3) $AP(1) 100Mb 2ms DropTail
#Direction of the flows between the AP and the Wired nodes
$ns_ duplex-link-op $WN(2) $AP(1) orient left-up
$ns_ duplex-link-op $WN(3) $AP(1) orient left-up
$ns_ duplex-link-op $WN(2) $AP(1) orient left-down
$ns_ duplex-link-op $WN(3) $AP(1) orient left-down

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

for {set n 0} {$n < $val(wired) } {incr n} {
 $ns_ at $val(termina).0001 "$WN($n) reset";
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
