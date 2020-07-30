# Replacing IP
In the `/etc/hosts` file, it's possible to define a custom hostname mapping to specific IP addresses. This script helps to change an IP based on the hostname provided. 
**IMPORTAT**: To modify the `hosts` file you need `sudo` access.

## Example
```
sudo replace-hosts-ip.sh google.com 1.1.1.1
```
