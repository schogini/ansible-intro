## Managing Windows Machine with Ansible

## Setting up the Windows Server

The VM should have rules to allow RDP access via port 3389, custom ICMP rule (with protocol as Echo Request) and WinRM access via port 5986.

#### Login to the machine

1. Once the Windows machines are ready, collect the Username and Password for logging in to the machine.

2. Now open any Remote Desktop application and use the Public IP address/Public DNS name of the server as PC name along with the username and password obtained in the previous step.

3. This will open the server on your remote desktop application.

Note: On AWS, you will have to use your pem file to get the password for your Windows machine.

#### Setup WinRM and other Ansible dependencies

1. Open the PowerShell app on your Windows server.

2. Download the configuration script by executing the below commands.
```bash
Import-Module bitstransfer
start-bitstransfer -source https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -destination  C:\Users\Administrator\
```

3. Execute the downloaded configuration script by executing the command:
```bash
powershell.exe -File ConfigureRemotingForAnsible.ps1
```

4. This will setup WinRM and other necessary dependencies for Ansible to work on your Windows machine.

#### Configuring Ansible Control Server
```bash
sudo su
apt-get update -y

# Install the libraries required for Ansible
apt-get install build-essential checkinstall
apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

# Download and install Python
wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
tar xzf Python-2.7.13.tgz
cd Python-2.7.13

./configure
make install
python --version
cd ..

# Using pip to install tools including winrm and ansible
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
sudo python get-pip.py
sudo pip install markupsafe
sudo pip install xmltodict
sudo pip install pywinrm
sudo pip install ansible
```

Note: Make sure to give ICMP protocol inbound rule to your Ansible control server.

#### Create an Inventory file with Windows server IP on your Ansible Control Server
```bash
mkdir windowsplaybook
cd windowsplaybook/

# Creating the inventory file with the Windows machine public ip address. Here the hostgrup name is win
nano inventory
	[win]
	<windows_machine_public_ip>
```

#### Create a credentials/variables file for your hostgroup
```bash
mkdir group_vars

# Creating custom variables specific to your Windows machine. Use the hostgroup name win as the name of the file
nano group_vars/win
	ansible_user: <windows_machine_username>
	ansible_password: <windows_machine_password>
	ansible_port: 5986
	ansible_connection: winrm
	ansible_winrm_server_cert_validation: ignore
```

So far we have installed and configured the control server and the Windows server. Now the setup is ready.

Let's test it.

#### Check the Connection to Windows machine from Ansible control server

Using the win_ping module to ping the Windows machine.
```bash
# Executing the win_ping module on the win hostgroup inside inventory file named inventory. This will use the win file available inside the group_vars directory to get the variables to be used
ansible win -i inventory -m win_ping
```
If the setup is correct, then you will get the pong response back from the Windows server.
