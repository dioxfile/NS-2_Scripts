set domain ""
set cluster ""
set nodes ""
set dm %d
set cl %d
set nd %d
set d 0
set c 0
set n 0
set grava [concat [pwd]/Wired-cum-wireless-nodes.tcl]
set id [open $grava w+]
global domain cluster nodes dm cl nd grava id d c n
puts $id "#Automatic Node Generator for the Wired-Cum-Wireless Model for NS-2#"
puts $id "#"
puts $id "#"

   puts "Enter the number of domains:"
     gets stdin domain
     scan $dm $domain
     puts $id "#Generated Domains:$domain"
     if { $domain<=1} {
        puts "Invalid Option Minimum domains are 2"
     } else {
            for {set d 0} {$d < $domain } { incr d} {
                puts "Enter the amount of clusters in the domain($d):"
                gets stdin cluster
                scan $cl $cluster
                puts $id "Domain: $d"
                if {$cluster < 1 } {
                    puts "Invalid Option the minimum of clusters must be equal to 1"
                } else {
                       for {set c 0} {$c < $cluster } { incr c} {
                           puts "Enter the number of nodes in the cluster($c):"
                           gets stdin nodes
                           scan $nd $nodes
                           puts $id "Clusters: $c"
                           puts $id "Nodes: $nodes"
                           if {$nodes < 1 } {
                               puts "Invalid Option the minimum number of nodes must be equal to 1"
                           } else {
                                  set x " set list \{"
                                  for {set n 0} {$n < $nodes} { incr n} {
                                   append x "$d.$c.$n "
                                  }
                              puts $id "$x\}"
                          }
                   }
            }
      }
}

