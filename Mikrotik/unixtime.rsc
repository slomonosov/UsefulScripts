:global fncJD do={
:local months [:toarray "jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec"];
:local jd
:local M [:pick $1 0 3];
:local D [:pick $1 4 6];
:local Y [:pick $1 7 11];
:for x from=0 to=([:len $months] - 1) do={
   :if ([:tostr [:pick $months $x]] = $M) do={:set M ($x + 1) } 
   }
:if ( $M = 1 || $M = 2) do={
    :set Y ($Y-1);
    :set M ($M+12);
}
:local A ($Y/100)
:local B ($A/4)
:local C (2-$A+$B)
:local E ((($Y+4716) * 36525)/100)
:local F ((306001*($M+1))/10000)
:local jd ($C+$D+$E+$F-1525)
:return $jd
};

:global timestamp do={
:global fncJD $fncJD
:local currtime [/system clock get time];
:local jdnow [$fncJD [/system clock get date]]
:local days ($jdnow - 2440587)
:local ore [:pick $currtime 0 2]
:local minute [:pick $currtime 3 5]
:local secunde [:pick $currtime 6 8]
:return (($days * 86400) + ($ore * 3600) + ($minute * 60) + $secunde - [/system clock get gmt-offset]);
}
:global timestamp $timestamp
:log warning [$timestamp]