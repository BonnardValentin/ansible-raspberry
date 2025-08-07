#!/bin/bash

# Create project structure
mkdir -p roles/{unattended-upgrades,firewall,ssh_hardening,fail2ban,p2p_disable,disable_bluetooth_audio,monitoring}/{tasks,handlers,templates,files,vars,defaults,meta}
mkdir -p inventories
mkdir -p playbooks

# Create ansible.cfg
cat > ansible.cfg << 'EOF'
[defaults]
inventory = inventories/
roles_path = roles/
host_key_checking = False
stdout_callback = yaml
gathering = smart
fact_caching = memory
EOF

# Create inventory for localhost
cat > inventories/hosts << 'EOF'
[raspberry_pi]
localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3
EOF

# Create main playbook
cat > playbooks/secure-rpi.yml << 'EOF'
---
- name: Secure Raspberry Pi
  hosts: raspberry_pi
  become: yes
  roles:
    - unattended-upgrades
    - firewall
    - ssh_hardening
    - fail2ban
    - p2p_disable
    - disable_bluetooth_audio
    - monitoring
EOF

# Create unattended-upgrades role
cat > roles/unattended-upgrades/tasks/main.yml << 'EOF'
---
- name: Update apt cache
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Install unattended-upgrades
  apt:
    name: unattended-upgrades
    state: present

- name: Configure unattended-upgrades
  template:
    src: 20auto-upgrades.j2
    dest: /etc/apt/apt.conf.d/20auto-upgrades
    mode: '0644'
  notify: restart unattended-upgrades
EOF

cat > roles/unattended-upgrades/templates/20auto-upgrades.j2 << 'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Verbose "1";
EOF

cat > roles/unattended-upgrades/handlers/main.yml << 'EOF'
---
- name: restart unattended-upgrades
  systemd:
    name: unattended-upgrades
    state: restarted
    daemon_reload: yes
EOF

cat > roles/unattended-upgrades/defaults/main.yml << 'EOF'
# Default variables for unattended-upgrades role
EOF

# Create firewall role
cat > roles/firewall/tasks/main.yml << 'EOF'
---
- name: Install UFW
  apt:
    name: ufw
    state: present

- name: Reset UFW rules
  ufw:
    state: reset

- name: Allow SSH
  ufw:
    rule: allow
    name: ssh

- name: Enable UFW
  ufw:
    state: enabled
    direction: incoming
    policy: deny
EOF

cat > roles/firewall/defaults/main.yml << 'EOF'
# Default variables for firewall role
EOF

# Create ssh_hardening role
cat > roles/ssh_hardening/tasks/main.yml << 'EOF'
---
- name: Backup sshd_config
  copy:
    src: /etc/ssh/sshd_config
    dest: /etc/ssh/sshd_config.backup
    remote_src: yes
    backup: yes

- name: Disable password authentication
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#?PasswordAuthentication'
    line: 'PasswordAuthentication no'
    state: present

- name: Disable root login
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#?PermitRootLogin'
    line: 'PermitRootLogin no'
    state: present

- name: Restart SSH service
  systemd:
    name: ssh
    state: restarted
EOF

cat > roles/ssh_hardening/defaults/main.yml << 'EOF'
# Default variables for ssh_hardening role
EOF

# Create fail2ban role
cat > roles/fail2ban/tasks/main.yml << 'EOF'
---
- name: Install fail2ban
  apt:
    name: fail2ban
    state: present

- name: Create fail2ban configuration
  template:
    src: jail.local.j2
    dest: /etc/fail2ban/jail.local
    mode: '0644'
  notify: restart fail2ban

- name: Enable and start fail2ban
  systemd:
    name: fail2ban
    state: started
    enabled: yes
EOF

cat > roles/fail2ban/templates/jail.local.j2 << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

cat > roles/fail2ban/handlers/main.yml << 'EOF'
---
- name: restart fail2ban
  systemd:
    name: fail2ban
    state: restarted
EOF

cat > roles/fail2ban/defaults/main.yml << 'EOF'
# Default variables for fail2ban role
EOF

# Create p2p_disable role
cat > roles/p2p_disable/tasks/main.yml << 'EOF'
---
- name: Create modprobe.d directory
  file:
    path: /etc/modprobe.d
    state: directory
    mode: '0755'

- name: Disable Wi-Fi P2P mode
  copy:
    content: "options brcmfmac p2pon=0"
    dest: /etc/modprobe.d/brcmfmac.conf
    mode: '0644'
  notify: reload modules
EOF

cat > roles/p2p_disable/handlers/main.yml << 'EOF'
---
- name: reload modules
  modprobe:
    name: brcmfmac
    state: reloaded
EOF

cat > roles/p2p_disable/defaults/main.yml << 'EOF'
# Default variables for p2p_disable role
EOF

# Create disable_bluetooth_audio role
cat > roles/disable_bluetooth_audio/tasks/main.yml << 'EOF'
---
- name: Blacklist bluetooth modules
  lineinfile:
    path: /etc/modprobe.d/blacklist.conf
    line: "{{ item }}"
    state: present
  loop:
    - "blacklist btusb"
    - "blacklist bluetooth"
    - "blacklist snd-bcm2835"
    - "blacklist snd-pcm"
  notify: reload modules

- name: Disable bluetooth service
  systemd:
    name: bluetooth
    state: stopped
    enabled: no
EOF

cat > roles/disable_bluetooth_audio/handlers/main.yml << 'EOF'
---
- name: reload modules
  modprobe:
    name: "{{ item }}"
    state: absent
  loop:
    - btusb
    - bluetooth
    - snd-bcm2835
    - snd-pcm
EOF

cat > roles/disable_bluetooth_audio/defaults/main.yml << 'EOF'
# Default variables for disable_bluetooth_audio role
EOF

# Create monitoring role
cat > roles/monitoring/tasks/main.yml << 'EOF'
---
- name: Install required packages
  apt:
    name:
      - curl
      - wget
    state: present

- name: Install Netdata
  shell: |
    bash <(curl -Ss https://my-netdata.io/kickstart.sh) --non-interactive
  args:
    creates: /usr/sbin/netdata

- name: Enable and start Netdata
  systemd:
    name: netdata
    state: started
    enabled: yes
EOF

cat > roles/monitoring/defaults/main.yml << 'EOF'
# Default variables for monitoring role
EOF

# Create README.md
cat > README.md << 'EOF'
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
EOF

echo "Ansible project structure created successfully!"
echo "You can now run: ansible-playbook -i inventories/hosts playbooks/secure-rpi.yml"
