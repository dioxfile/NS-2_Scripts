#802.11a default parameters
$val(wlan0)  set CSThresh_                6.31e-12    ;#-82 dBm Wireless interface sensitivity (sensitivity defined in the standard)
$val(wlan0)  set Pt_                      3.3962527e-2         
$val(wlan0)  set freq_                    5.18e+9
$val(wlan0)  set noise_floor_             2.512e-13   ;#-96 dBm for 10MHz bandwidth
$val(wlan0)  set L_                       1.0         ;#default radio circuit gain/loss
$val(wlan0)  set PowerMonitorThresh_      1.259e-13   ;#-99dBm power monitor  sensitivity
$val(wlan0)  set HeaderDuration_          0.000020    ;#20 us
$val(wlan0)  set BasicModulationScheme_   0
$val(wlan0)  set PreambleCaptureSwitch_   1
$val(wlan0)  set DataCaptureSwitch_       0
$val(wlan0)  set SINR_PreambleCapture_    2.5118;     ;# 4 dB
$val(wlan0)  set SINR_DataCapture_      100.0;        ;# 10 dB
$val(wlan0)  set trace_dist_              1e6         ;# PHY trace until distance of 1 Mio. km ("infinty")
$val(wlan0)  set PHY_DBG_                 0
$val(mac)   set CWMin_                   15
$val(mac)   set CWMax_                 1023
$val(mac)   set SlotTime_                 0.000009
$val(mac)   set SIFS_                     0.000016
$val(mac)   set DIFS_                     0.000034
$val(mac)   set ShortRetryLimit_          7
$val(mac)   set LongRetryLimit_           4
$val(mac)   set HeaderDuration_           0.000020
$val(mac)   set SymbolDuration_           0.000004
$val(mac)   set BasicModulationScheme_    1
$val(mac)   set use_802_11a_flag_      true
$val(mac)   set RTSThreshold_          3000
$val(mac)   set MAC_DBG                   0
$val(mac)   set RTS_                     20.0
$val(mac)   set CTS_                     14.0
