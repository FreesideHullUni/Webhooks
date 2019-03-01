#!/bin/bash -e
echo  "[${SECONDS}] Waking Hosts"

wakeup_host_timeout() {
	target_mac_address="$1";
	target_hostname="$2";
	
	timeout_seconds="360";
	interface="eno1";
	interval="2";
	
	echo "[${SECONDS}] Attempting to wake ${target_mac_address}.";
	
	start_time="${SECONDS}";
	while [[ "$(((${SECONDS} - ${start_time})))" -lt "${timeout_seconds}" ]]; do
		
		ether-wake -i "${interace}" "${target_mac_address}";
		
		# Try to connect on port 22
		nc -vzw 2 "${target_hostname}" 22
		
		if [[ "$?" -eq 0 ]]; then
			break
		fi
		
		sleep "${interval}";
	done
}

wakeup_host_timeout "7c:05:07:0c:c5:e5" "fs-desktop-01.freeside.co.uk" &
wakeup_host_timeout "7c:05:07:10:6b:37" "fs-desktop-02.freeside.co.uk" &
wakeup_host_timeout "7c:05:07:0d:5b:fb" "fs-desktop-03.freeside.co.uk" &

echo  "[${SECONDS}] Waiting for desktops to start";

wait

# Old system:
#until nc -vzw 2 fs-desktop-01.freeside.co.uk 22; do sleep 2; done

echo  "[${SECONDS}] Desktops started"
