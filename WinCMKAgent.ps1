# Define variables
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$agentInstallerPath = Join-Path $scriptDirectory "check-mk-agent.msi"
$agentDirectory = "C:\Program Files (x86)\checkmk\service"

# Check if the Checkmk agent installer exists
If (Test-Path $agentInstallerPath) {
    Write-Output "Agent installer found: $agentInstallerPath"
} Else {
    Write-Error "Agent installer not found at: $agentInstallerPath"
    Exit 1
}

# Install the Checkmk agent silently or normal
Try {
    Start-Process msiexec.exe -ArgumentList "/i `"$agentInstallerPath`" /quiet" -Wait -ErrorAction Stop
    #Start-Process msiexec.exe -ArgumentList "/i `"$agentInstallerPath` -Wait -ErrorAction Stop
    Write-Output "Agent installed successfully."
} Catch {
    Write-Error "Failed to install the agent: $_"
    Exit 1
}

# Wait for the service to start (optional)
Start-Sleep -Seconds 10

# Define registration variables
$checkmkServer = "http://your-checkmk-server"
$checkmkSite = "yoursite"
$checkmkHost = "yourhostname"
$checkmkSecret = "yoursecret"

# Register the agent with the Checkmk server
Try {
    & "$agentDirectory\check_mk_agent.exe" updater register -s $checkmkServer -i $checkmkSite -H $checkmkHost -S $checkmkSecret -ErrorAction Stop
    Write-Output "Agent registered successfully."
} Catch {
    Write-Error "Failed to register the agent: $_"
    Exit 1
}

# (Optional) Function to update registration if needed
Function Update-CheckMKRegistration {
    Try {
        & "$agentDirectory\check_mk_agent.exe" updater update -ErrorAction Stop
        Write-Output "Agent registration updated successfully."
    } Catch {
        Write-Error "Failed to update the agent registration: $_"
    }
}

# Update the agent registration
Update-CheckMKRegistration

# Clean up downloaded installer
Try {
    Remove-Item $agentInstallerPath -ErrorAction Stop
    Write-Output "Installer removed successfully."
} Catch {
    Write-Error "Failed to remove the installer: $_"
}
