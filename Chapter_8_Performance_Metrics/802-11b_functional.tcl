$val(mac)       set SlotTime_            0.000020        ;# 20us
$val(mac)       set SIFS_                0.000010        ;# 10us
$val(mac)       set DIFS_                0.000050        ;# 50us
$val(mac)       set CWMin_              31               ;# Min Backoff [0, CW]
$val(mac)       set CWMax_            1023               ;# Max Backoff [CW+1]
$val(mac)       set PreambleLength_    144               ;# 144 bit
$val(mac)       set PLCPHeaderLength_   48               ;# 48 bits MAC_Address
$val(mac)       set PLCPDataRate_        1.0e6           ;# 1Mbps
$val(mac)       set dataRate_           11.0e6           ;# 11Mbps
$val(wlan0)     set bandwidth_          11.0e6           ;# Bandwidth
$val(mac)       set basicRate_           1.0e6           ;# 1Mbps
$val(wlan0)     set freq_                2.4e9           ;# 2.4 GHz 802.11b.
$val(wlan0)     set Pt_                  3.3962527e-2    ;# Power TX.
$val(wlan0)     set RXThresh_            6.309573e-12    ;# RX Threshold. 
$val(wlan0)     set CSThresh_            6.309573e-12    ;# Carrie Sense Threshold. 
$val(wlan0)     set RTSThreshold_     3000               ;# Use RTS/CTS for packets larger 3000 bytes
