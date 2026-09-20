# XFCE4 Panel Genmon - OpenVPN `tun0` IP Fix

This is a fixed version of `xfce4-panel-genmon-vpnip.sh` for **Kali Linux** and XFCE4 Panel Genmon.

The original script may fail to correctly detect and display the VPN IP address when an **OpenVPN** connection creates a `tun0` interface. This version improves VPN interface detection and reliably extracts the IPv4 address assigned to the VPN interface.

## What this fixes

The script:

* Automatically detects `tun` or `tap` network interfaces.
* Retrieves the IPv4 address assigned to the VPN interface.
* Removes the CIDR subnet mask (`/24`, `/16`, etc.).
* Displays the VPN IP directly in the XFCE4 panel.
* Uses the `network-vpn-symbolic` icon.
* Allows clicking the IP address to copy it to the clipboard using `xclip`.
* Shows a helpful tooltip with the current VPN IP.
* Gracefully hides the output when no VPN interface is available.
* Works with OpenVPN interfaces such as `tun0`.

## Example

When OpenVPN is connected and `tun0` has the address `10.8.0.6/24`, the XFCE4 panel will display:

```text
🔒 10.8.0.6
```

Clicking the IP address copies it directly to the clipboard.

## Script

```sh
#!/bin/sh

interface=$(ip link show | grep -E 'tun|tap' | awk -F': ' '{print $2}' | head -n 1)

ip=(ip-o-4addrshowdev"{interface}" 2>/dev/null | awk '{print $4}' | cut -d/ -f1)

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
```

## Installation (for default only)

Replace the existing `xfce4-panel-genmon-vpnip.sh` script with the fixed version and make sure it is executable:

```bash
sudo nano /usr/share/kali-themes/xfce4-panel-genmon-vpnip.sh
```

```bash
chmod +x xfce4-panel-genmon-vpnip.sh
```

If you want the click-to-copy functionality, install `xclip`:

```bash
sudo apt install xclip
```

Then configure the script as a **Generic Monitor (Genmon)** plugin in the XFCE4 Panel.

## Why this version works

The important part is the IPv4 address lookup:

```sh
ip -o -4 addr show dev "${interface}" | awk '{print $4}' | cut -d/ -f1
```

Instead of relying on a specific interface name such as `tun0`, the script first detects an available `tun` or `tap` interface and then queries its IPv4 address.

This makes the script more suitable for different OpenVPN configurations where the VPN interface name may not always be exactly the same.

## Notes

This script is primarily intended for **Kali Linux + XFCE4 + Genmon + OpenVPN**, but it should also work on other Debian-based distributions using the same networking tools.

If no `tun` or `tap` interface is present, the plugin produces no visible IP address instead of displaying an incorrect or stale value.




Скрипт:

