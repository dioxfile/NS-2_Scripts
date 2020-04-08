Agent/OLSR set mpr_algorithm_               1    ;# 1 = RFC 3626, 2 = MPRR1, 3 = MPRR2, 4 = QOLSR, 5 = OLSRD
Agent/OLSR set routing_algorithm_           1    ;# OLSR Routing = 1 e Dijkstra = 2;
Agent/OLSR set link_quality_                1    ;# OLSR -> Hop-count = 1, ETX = 2, ML = 3 e MD = true 
Agent/OLSR set link_delay_                 false ;# If true LD will be used
Agent/OLSR set c_alpha_             	      0.4  ;# Smoothing Factor OLSR-MD only.
Agent/OLSR set willingness_         	      3    ;# Default (as published in RFC 3626)
Agent/OLSR set tc_ival_                     5    ;# Default (as published in RFC 3626)
Agent/OLSR set hello_ival_            	    2    ;# Default (as published in RFC 3626)
