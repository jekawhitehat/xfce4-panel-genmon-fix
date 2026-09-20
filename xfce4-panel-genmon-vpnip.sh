#!/bin/sh

interface=$(ip link show | grep -E 'tun|tap' | awk -F': ' '{print $2}' | head -n 1)

ip=$(ip -o -4 addr show dev "${interface}" 2>/dev/null | awk '{print $4}' | cut -d/ -f1)

if [ -n "${ip}" ]; then
    printf "<icon>network-vpn-symbolic</icon>"
    printf "<txt> %s</txt>" "${ip}"

    if command -v xclip >/dev/null 2>&1; then
        printf "<iconclick>sh -c 'printf %%s %s | xclip -selection clipboard'</iconclick>" "${ip}"
        printf "<txtclick>sh -c 'printf %%s %s | xclip -selection clipboard'</txtclick>" "${ip}"
        printf "<tool>VPN IP: %s (click to copy)</tool>" "${ip}"
    else
        printf "<tool>VPN IP: %s (install xclip to copy to clipboard)</tool>" "${ip}"
    fi
else
    printf "<txt></txt>"
fi
