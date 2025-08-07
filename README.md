# Ansible Raspberry Pi Security

This Ansible project provides a comprehensive security setup for Raspberry Pi devices running Ubuntu/Debian.

## Roles

- **unattended-upgrades**: Enables automatic security updates
- **firewall**: Configures UFW firewall to allow only SSH
- **ssh_hardening**: Disables password authentication in SSH
- **fail2ban**: Installs fail2ban to protect against brute force attacks
- **p2p_disable**: Disables Wi-Fi P2P mode
- **disable_bluetooth_audio**: Blacklists bluetooth and audio modules
- **monitoring**: Installs Netdata for system monitoring

## Usage

1. Ensure you have Ansible installed
2. Run the playbook:
   ```bash
   ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml
   ```

## Requirements

- Ansible 2.9+
- Python 3
- Ubuntu/Debian-based system
