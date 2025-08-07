# 🔒 Ansible Security Hardening Suite

[![Ansible](https://img.shields.io/badge/Ansible-2.9+-red.svg)](https://www.ansible.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-blue.svg)](https://ubuntu.com/)

> **Enterprise-grade security hardening for Raspberry Pi, VPS, and cloud servers**

This Ansible project implements comprehensive security hardening following CIS benchmarks, DevSecOps practices, and industry best practices. It provides modular, idempotent roles for securing Ubuntu/Debian systems in various environments.

## 🎯 Features

### 🔐 Core Security Roles
- **`unattended-upgrades`** - Automated security updates
- **`firewall`** - UFW firewall configuration
- **`ssh_hardening`** - SSH security hardening
- **`fail2ban`** - Brute force protection
- **`monitoring`** - Netdata system monitoring

### 🛡️ Advanced Security Roles
- **`system_hardening`** - CIS-level system hardening
- **`network_security`** - Advanced network protection
- **`logging_monitoring`** - Centralized logging
- **`backup_security`** - Automated security backups

### 🍓 Raspberry Pi Specific
- **`p2p_disable`** - Wi-Fi P2P disable
- **`disable_bluetooth_audio`** - Bluetooth/audio modules disable

## 📋 Prerequisites

### Control Machine
- **Ansible 2.9+** installed
- **Python 3.7+**
- **SSH client** configured
- **Git** for version control

### Target Systems
- **Ubuntu 18.04+** or **Debian 10+**
- **Python 3** available
- **Sudo privileges** for Ansible user
- **SSH key-based authentication** configured

### Security Requirements
- **SSH key pair** generated and deployed
- **Backup strategy** in place
- **Network access** to target systems
- **Documentation** of current configuration

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/BonnardValentin/ansible-raspberry.git
cd ansible-raspberry
```

### 2. Configure Inventory
```bash
# Edit inventories/hosts for localhost
# Edit inventories/cloud/hosts.ini for remote servers
```

### 3. Test Connectivity
```bash
# Test local connection
ansible -i inventories/hosts raspberry_pi -m ping

# Test remote connection
ansible -i inventories/cloud/hosts.ini cloud_servers -m ping
```

### 4. Run Security Hardening
```bash
# Raspberry Pi (local)
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml

# Cloud servers
ansible-playbook -i inventories/cloud/hosts.ini playbooks/secure-cloud.yml

# Enterprise hardening
ansible-playbook -i inventories/hosts playbooks/secure-enterprise.yml
```

## 📁 Project Structure

```
ansible-raspberry/
├── ansible.cfg                 # Ansible configuration
├── group_vars/
│   └── all.yml                # Global variables
├── inventories/
│   ├── hosts                   # Localhost inventory
│   └── cloud/
│       └── hosts.ini          # Cloud servers inventory
├── playbooks/
│   ├── secure-rpi.yml         # Raspberry Pi security
│   ├── secure-cloud.yml       # Cloud server security
│   └── secure-enterprise.yml  # Enterprise hardening
├── roles/
│   ├── backup_security/       # Automated backups
│   ├── disable_bluetooth_audio/ # Bluetooth disable
│   ├── fail2ban/              # Brute force protection
│   ├── firewall/              # UFW firewall
│   ├── logging_monitoring/    # Centralized logging
│   ├── monitoring/            # Netdata monitoring
│   ├── network_security/      # Advanced networking
│   ├── p2p_disable/           # Wi-Fi P2P disable
│   ├── ssh_hardening/         # SSH security
│   └── system_hardening/      # CIS-level hardening
├── .gitignore                 # Git ignore rules
├── LICENSE                    # MIT License
└── README.md                  # This file
```

## 🔧 Role Details

### Core Security Roles

#### `unattended-upgrades`
- **Purpose**: Automated security updates
- **Features**:
  - Installs unattended-upgrades package
  - Configures automatic security updates
  - Sets cleanup intervals and verbosity
- **Configuration**: `/etc/apt/apt.conf.d/20auto-upgrades`

#### `firewall`
- **Purpose**: UFW firewall configuration
- **Features**:
  - Installs and configures UFW
  - Allows SSH (port 22) only
  - Blocks all other incoming traffic
- **Configuration**: UFW rules and policies

#### `ssh_hardening`
- **Purpose**: SSH security hardening
- **Features**:
  - Disables password authentication
  - Disables root login
  - Creates backup of sshd_config
- **Configuration**: `/etc/ssh/sshd_config`

#### `fail2ban`
- **Purpose**: Brute force protection
- **Features**:
  - Monitors SSH login attempts
  - Bans IPs after failed attempts
  - Configurable ban time and retry limits
- **Configuration**: `/etc/fail2ban/jail.local`

#### `monitoring`
- **Purpose**: System monitoring with Netdata
- **Features**:
  - Installs Netdata monitoring agent
  - Provides web-based dashboard
  - Real-time system metrics
- **Access**: `http://host:19999`

### Advanced Security Roles

#### `system_hardening`
- **Purpose**: CIS-level system hardening
- **Features**:
  - Password quality policies
  - Session timeout configuration
  - Kernel parameter hardening
  - Auditd configuration
  - AppArmor profiles
  - Service disablement

#### `network_security`
- **Purpose**: Advanced network protection
- **Features**:
  - iptables rules configuration
  - TCP wrappers setup
  - Network monitoring tools
  - ICMP rate limiting

#### `logging_monitoring`
- **Purpose**: Centralized logging
- **Features**:
  - rsyslog configuration
  - Security log rotation
  - Audit log management
  - Structured logging

#### `backup_security`
- **Purpose**: Automated security backups
- **Features**:
  - Critical config backups
  - Log file backups
  - Automated cleanup
  - Cron job scheduling

## 🎛️ Usage Examples

### Basic Security (Raspberry Pi)
```bash
# Apply basic security hardening
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml

# With verbose output
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml -v

# Dry run (check mode)
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml --check
```

### Cloud Server Security
```bash
# Apply cloud security (excludes Pi-specific roles)
ansible-playbook -i inventories/cloud/hosts.ini playbooks/secure-cloud.yml

# Target specific hosts
ansible-playbook -i inventories/cloud/hosts.ini playbooks/secure-cloud.yml --limit server1
```

### Enterprise Hardening
```bash
# Apply enterprise-grade security
ansible-playbook -i inventories/hosts playbooks/secure-enterprise.yml

# With custom variables
ansible-playbook -i inventories/hosts playbooks/secure-enterprise.yml \
  -e "security_level=high"
```

### Selective Role Execution
```bash
# Run specific roles only
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml \
  --tags firewall,ssh_hardening

# Skip specific roles
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml \
  --skip-tags monitoring
```

## 🔒 Security Best Practices

### Before Deployment
1. **Backup your system** - Critical configurations will be modified
2. **Test in safe environment** - Use VM or test device first
3. **Verify SSH key access** - Password authentication will be disabled
4. **Document current config** - Backup important files
5. **Review firewall rules** - Ensure required services are accessible

### During Deployment
1. **Monitor execution** - Watch for any errors or warnings
2. **Keep SSH session open** - In case of connectivity issues
3. **Verify each role** - Check that changes are applied correctly
4. **Test connectivity** - Ensure SSH access remains functional

### After Deployment
1. **Verify SSH access** - Test connection before closing session
2. **Check firewall status** - Confirm UFW is active and rules are correct
3. **Monitor fail2ban** - Check for blocked attempts
4. **Test monitoring** - Access Netdata dashboard
5. **Review logs** - Check for any issues or warnings

### Ongoing Maintenance
1. **Regular backups** - Automated backups run daily at 2 AM
2. **Log monitoring** - Review security logs regularly
3. **Update playbooks** - Keep Ansible roles updated
4. **Security audits** - Regular security assessments
5. **Documentation** - Keep deployment notes updated

## 🐛 Troubleshooting

### Common Issues

#### SSH Connection Lost
```bash
# Check SSH service status
sudo systemctl status ssh

# Verify SSH configuration
sudo sshd -t

# Check authorized keys
cat ~/.ssh/authorized_keys
```

#### Firewall Blocking Access
```bash
# Check UFW status
sudo ufw status verbose

# Temporarily allow your IP
sudo ufw allow from YOUR_IP

# Check iptables rules
sudo iptables -L -n
```

#### Fail2ban Blocking Your IP
```bash
# Check fail2ban status
sudo fail2ban-client status sshd

# Unban your IP
sudo fail2ban-client set sshd unbanip YOUR_IP

# Check fail2ban logs
sudo tail -f /var/log/fail2ban.log
```

#### Service Issues
```bash
# Check service status
sudo systemctl status SERVICE_NAME

# View service logs
sudo journalctl -u SERVICE_NAME -f

# Restart service
sudo systemctl restart SERVICE_NAME
```

### Log Locations
- **SSH**: `/var/log/auth.log`
- **Fail2ban**: `/var/log/fail2ban.log`
- **UFW**: `/var/log/ufw.log`
- **Audit**: `/var/log/audit/audit.log`
- **System**: `/var/log/syslog`
- **Security**: `/var/log/security/`

### Debug Commands
```bash
# Test Ansible connectivity
ansible -i inventories/hosts all -m ping -v

# Check facts
ansible -i inventories/hosts all -m setup

# Run with maximum verbosity
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml -vvv

# Check specific role
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml --tags firewall --check
```

## 🔧 Configuration

### Environment Variables
```bash
# Set custom variables
export ANSIBLE_SSH_ARGS="-o ControlMaster=auto -o ControlPersist=60s"
export ANSIBLE_TIMEOUT=30
```

### Custom Variables
```yaml
# group_vars/all.yml
security:
  ssh_port: 2222  # Custom SSH port
  ssh_max_auth_tries: 5

firewall:
  allowed_ports:
    - 22   # SSH
    - 80   # HTTP
    - 443  # HTTPS
```

### Inventory Configuration
```ini
# inventories/cloud/hosts.ini
[web_servers]
web1 ansible_host=192.168.1.10 ansible_user=ubuntu
web2 ansible_host=192.168.1.11 ansible_user=ubuntu

[web_servers:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3
```

## 🤝 Contributing

### Development Setup
1. **Fork the repository**
2. **Create feature branch**: `git checkout -b feature/new-role`
3. **Make changes** following Ansible best practices
4. **Test thoroughly** on different environments
5. **Update documentation** for any new features
6. **Submit pull request** with detailed description

### Code Standards
- **Idempotent tasks** - All tasks must be idempotent
- **Error handling** - Use `ignore_errors` appropriately
- **Variable usage** - Use variables for configurable values
- **Documentation** - Comment complex tasks
- **Testing** - Test on multiple Ubuntu/Debian versions

### Testing
```bash
# Test on localhost
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml --check

# Test on remote server
ansible-playbook -i inventories/cloud/hosts.ini playbooks/secure-cloud.yml --check

# Run specific role tests
ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml --tags firewall --check
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **CIS Benchmarks** for security hardening guidelines
- **Ansible Community** for best practices and modules
- **Ubuntu Security Team** for security recommendations
- **Open Source Community** for tools and inspiration

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/BonnardValentin/ansible-raspberry/issues)
- **Discussions**: [GitHub Discussions](https://github.com/BonnardValentin/ansible-raspberry/discussions)
- **Documentation**: [Wiki](https://github.com/BonnardValentin/ansible-raspberry/wiki)

---

**⚠️ Disclaimer**: This project is for educational and security hardening purposes. Always test in a safe environment before deploying to production systems. The authors are not responsible for any damage or data loss resulting from the use of this project.
