# Get UnixTime
:system script run unixtime
##### global vars #####
:global current
:global waittime 10
:global timestamp [$timestamp] 
:global currenttime $timestamp
:global ISP1state
:global ISP2state
:global ISP1downtime
:global ISP2downtime
:global ISP1sec
:global ISP2sec
##### if var is null - set it to 0 #####
:if ($current > 0 and $current < 4) do={
	:log info "Current ISP is $current"
} else={
	:log warning "Current ISP isn't set. Set it to 0"
	:set current 0
}
:if ($ISP1downtime >= 0) do={
	:set ISP1sec ($currenttime-$ISP1downtime)
	:log info "ISP1 was down $ISP1sec seeconds ago"
} else={
	:log warning "ISP2downtime isn't set. Set it to 0"
	:set ISP1downtime 0
}
:if ($ISP2downtime >= 0) do={
	:set ISP2sec ($currenttime-$ISP2downtime)
	:log info "ISP2 was down $ISP2sec seeconds ago"
} else={
	:log warning "ISP2downtime isn't set. Set it to 0"
	:set ISP2downtime 0
}
##### Time for pinging #####
:local ISP1 [/ping 8.8.8.8 interval=50ms count=10]
:local ISP2 [/ping 8.8.4.4 interval=50ms count=10]
# Is ISP1 down?
:if ($ISP1 < 5) do={
	:set ISP1state 0
	:set ISP1downtime ($currenttime)
	:log warning "ISP1 is down, $ISP1 pings of 10, timestamp: $currenttime"
} else={
	:set ISP1state 1
}
# Is ISP2 down?
:if ($ISP2 < 9) do={
	:set ISP2state 0
	:set ISP2downtime ($currenttime)
	:log warning "ISP2 is down, $ISP2 pings of 10, timestamp: $currenttime"
} else={
	:set ISP2state 1
}
##### If ISP1 is UP, With time#####
:if ($ISP1state = 1 and ($currenttime-$ISP1downtime)>$waittime) do={
	/ip route enable [:ip route find comment=ISP1]
	/ip route disable [:ip route find comment=ISP2]
	:if ($current != 1) do={
		:ip firewall connection remove [:ip firewall connection find]
		:ip firewall connection remove [:ip firewall connection find where connection-type=sip and assured=no]
	}
	:set current 1
} else={
	# If ISP1 is DOWN and ISP2 is UP
	:if ($ISP2state = 1 and ($currenttime-$ISP2downtime)>$waittime) do={
		/ip route disable [:ip route find comment=ISP1]
		/ip route enable [:ip route find comment=ISP2]
		:if ($current != 2) do={
			:ip firewall connection remove [:ip firewall connection find]
			:ip firewall connection remove [:ip firewall connection find where connection-type=sip and assured=no]
		}
		:set current 2
	}
}