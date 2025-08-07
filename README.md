# Ansible Raspberry Pi Security

This Ansible project provides a comprehensive security setup for Raspberry Pi devices and cloud servers running Ubuntu/Debian.

## 🎯 Overview

This project implements security best practices through modular Ansible roles, making it easy to secure both local Raspberry Pi devices and remote cloud servers.

## 🔧 Roles

### Core Security Roles (All Environments)
- **`unattended-upgrades`**: Enables automatic security updates and package management
  - Installs and configures unattended-upgrades package
  - Automatically downloads and installs security updates
  - Configures cleanup intervals and verbosity settings

- **`firewall`**: Configures UFW firewall with secure defaults
  - Installs and enables UFW (Uncomplicated Firewall)
  - Allows only SSH connections by default
  - Blocks all other incoming traffic

- **`ssh_hardening`**: Hardens SSH configuration for enhanced security
  - Disables password authentication (key-based only)
  - Disables root login
  - Creates backup of original sshd_config

- **`fail2ban`**: Protects against brute force attacks
  - Installs and configures fail2ban
  - Monitors SSH login attempts
  - Bans IPs after 3 failed attempts for 1 hour

- **`monitoring`**: Installs Netdata for real-time system monitoring
  - Installs Netdata monitoring agent
  - Provides web-based dashboard for system metrics
  - Enables automatic startup

### Raspberry Pi Specific Roles
- **`p2p_disable`**: Disables Wi-Fi P2P mode
  - Configures brcmfmac module to disable P2P functionality
  - Reduces attack surface and power consumption

- **`disable_bluetooth_audio`**: Disables Bluetooth and audio modules
  - Blacklists bluetooth, audio, and related kernel modules
  - Stops and disables bluetooth service
  - Reduces power consumption and attack surface

## 🚀 Usage

### Prerequisites

- **Ansible 2.9+** installed on your control machine
- **Python 3** on target systems
- **SSH key-based authentication** configured for remote servers
- **Sudo privileges** on target systems
- **Ubuntu/Debian-based** target systems

### Local Deployment (Raspberry Pi)

For securing a local Raspberry Pi or similar device:

```bash
# Run the complete security setup
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml

# Run with verbose output for debugging
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml -v
```

### Cloud Deployment (Remote Servers)

For securing remote cloud servers:

1. **Update inventory** with your server details:
   ```bash
   # Edit inventories/cloud/hosts.ini
   # Replace the example IP and user with your actual server details
   ```

2. **Test connectivity**:
   ```bash
   ansible -i inventories/cloud/hosts.ini cloud_servers -m ping
   ```

3. **Run security setup**:
   ```bash
   # Apply core security roles (excludes Pi-specific roles)
   ansible-playbook -i inventories/cloud/hosts.ini playbooks/secure-cloud.yml

   # Run with verbose output
   ansible-playbook -i inventories/cloud/hosts.ini playbooks/secure-cloud.yml -v
   ```

### Selective Role Execution

Run specific roles only:

```bash
# Example: Only apply firewall and SSH hardening
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml --tags firewall,ssh_hardening

# Example: Skip monitoring installation
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml --skip-tags monitoring
```

## 🔒 Security Recommendations

### Before Running
1. **Backup your system** - Some roles modify critical system files
2. **Test in a safe environment** - Use a VM or test device first
3. **Ensure SSH key access** - Password authentication will be disabled
4. **Document current SSH configuration** - Backup sshd_config before changes

### After Running
1. **Verify SSH access** - Test SSH connection before closing current session
2. **Check firewall rules** - Verify UFW is active and SSH is allowed
3. **Monitor fail2ban logs** - Check `/var/log/fail2ban.log` for blocked attempts
4. **Test monitoring** - Access Netdata dashboard (usually on port 19999)

### Important Notes
- **SSH password authentication will be disabled** - Ensure you have SSH key access
- **Root login will be disabled** - Use sudo for administrative tasks
- **Firewall will block all non-SSH traffic** - Configure additional rules if needed
- **Automatic updates will be enabled** - Monitor system for update-related issues

## 📁 Project Structure

```
ansible-raspberry/
├── ansible.cfg                 # Ansible configuration
├── inventories/
│   ├── hosts                   # Localhost inventory
│   └── cloud/
│       └── hosts.ini          # Cloud servers inventory
├── playbooks/
│   ├── secure-rpi.yml         # Raspberry Pi security playbook
│   └── secure-cloud.yml       # Cloud server security playbook
├── roles/
│   ├── unattended-upgrades/   # Automatic security updates
│   ├── firewall/              # UFW firewall configuration
│   ├── ssh_hardening/         # SSH security hardening
│   ├── fail2ban/              # Brute force protection
│   ├── p2p_disable/           # Wi-Fi P2P disable (Pi only)
│   ├── disable_bluetooth_audio/ # Bluetooth/audio disable (Pi only)
│   └── monitoring/            # Netdata monitoring
└── README.md                  # This file
```

## 🐛 Troubleshooting

### Common Issues

**SSH connection lost after running:**
- Ensure you have SSH key authentication configured
- Check if your SSH key is in the authorized_keys file
- Verify the SSH service is running: `sudo systemctl status ssh`

**Firewall blocking access:**
- Check UFW status: `sudo ufw status`
- Temporarily allow your IP: `sudo ufw allow from YOUR_IP`

**Fail2ban blocking your IP:**
- Check fail2ban status: `sudo fail2ban-client status sshd`
- Unban your IP: `sudo fail2ban-client set sshd unbanip YOUR_IP`

### Logs to Monitor
- SSH: `/var/log/auth.log`
- Fail2ban: `/var/log/fail2ban.log`
- UFW: `/var/log/ufw.log`
- Unattended-upgrades: `/var/log/unattended-upgrades/`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
