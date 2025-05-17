# 1. Clone the repository
git clone https://github.com/Pushpenderrathore/brcm_automation_login

# 2. Navigate into the project directory
cd ./brcm_automation_login

# 3. Make the install script executable
chmod +x install.sh

# 4. Run the installer script
sudo ./install.sh

# For Windows run the command below as administrator in powershell (network must be saved before)
$code = '$ts=[int][double]::Parse((Get-Date -UFormat %s));Invoke-RestMethod -Uri "http://10.10.10.1:8090/login.xml" -Method POST -Body @{mode="191";username="1";password="brcm@@12";a=$ts;producttype="0"}'

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -Command `$code`"
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName "AutoCurlLogin" -Action $action -Trigger $trigger -RunLevel Highest -User "SYSTEM"
