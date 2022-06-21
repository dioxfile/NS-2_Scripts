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
  set val(node_)             50                      ;# Node Number
  set val(x)               1000                      ;# Axis X 
  set val(y)               1000                      ;# Axis Y
  set val(TX)                 1.2W                   ;# Default NS2 - 0.400 -> 0,000509W/PKT
  set val(RX)                 0.6W                   ;# Default NS2 - 0.300 -> 0.000156W/PKT 
  set val(IniEner)          100.00                   ;# Initial Energy
  set val(ModEner)         EnergyModel               ;# Energy Model
  set val(termina)            60                     ;# Simulation Time
#======================================================================#

# ---------------------BEGIN OLSR EXTENSIONS----------------------------
source "olsr-default.tcl"

# NIC Specification Ex. 802.11a, 802.11b, etc.
source "802-11b_functional.tcl"

#begin Simulation
set ns_ [new Simulator]
$defaultRNG seed NEW_SEED

# Trace File Writing
set ArquivoTrace [open TRACE_FILE_AODV.tr w]
$ns_ trace-all $ArquivoTrace

# NAM File  Writing
set ArquivoNam [open NAM_Arquivo.nam w]
$ns_ namtrace-all $ArquivoNam
$ns_ namtrace-all-wireless $ArquivoNam $val(x) $val(y)

# Topology
set topologia [new Topography]
$topologia  load_flatgrid $val(x) $val(y)

# "GOD (General Operations Director)"
set god_ [create-god $val(node_)]

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
			
# Create Wireless Nodes
for {set i 0} {$i < $val(node_)} {incr i} {
	set node_($i) [$ns_ node]
	$node_($i) color blue
    $ns_ at 0.0 "$node_($i) color blue"
    $ns_ at 0.0 "$node_($i) label WN_$i"
    $node_($i) random-motion 0 ;# disable
}

################Starting Mobility Model and Traffic Model###############
puts "Starting Random WayPoint (eg., file mobility.tcl)."
source "mobility.tcl" 
puts "Starting Traffic"
source "traffic_c8.tcl"
#puts "Start Selfish Nodes..."
#source "Selfish_On_Off.tcl"

# NAM Position 
for {set n 0} {$n < $val(node_) } {incr n} {
 $ns_ initial_node_pos $node_($n) 20
}

# Stop nodes simulation
for {set n 0} {$n < $val(node_) } {incr n} {
 $ns_ at $val(termina).000 "$node_($n) reset";
}

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
