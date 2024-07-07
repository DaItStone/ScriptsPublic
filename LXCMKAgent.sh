#!/bin/bash

# Define variables
script_dir=$(dirname "$0")
agent_installer_path="$script_dir/check-mk-agent.msi"
agent_directory="/usr/lib/check_mk_agent"
checkmk_server="http://your-checkmk-server"
checkmk_site="yoursite"
checkmk_host="yourhostname"
checkmk_secret="yoursecret"

# Check if the Checkmk agent installer exists
if [ -f "$agent_installer_path" ]; then
    echo "Agent installer found: $agent_installer_path"
else
    echo "Agent installer not found at: $agent_installer_path"
    exit 1
fi

# Install the Checkmk agent silently
if dpkg -i "$agent_installer_path"; then
    echo "Agent installed successfully."
else
    echo "Failed to install the agent."
    exit 1
fi

# Wait for the service to start (optional)
sleep 10

# Register the agent with the Checkmk server
if "$agent_directory/check_mk_agent" updater register -s "$checkmk_server" -i "$checkmk_site" -H "$checkmk_host" -S "$checkmk_secret"; then
    echo "Agent registered successfully."
else
    echo "Failed to register the agent."
    exit 1
fi

# (Optional) Function to update registration if needed
update_checkmk_registration() {
    if "$agent_directory/check_mk_agent" updater update; then
        echo "Agent registration updated successfully."
    else
        echo "Failed to update the agent registration."
    fi
}

# Update the agent registration
update_checkmk_registration

# Clean up downloaded installer
if rm -f "$agent_installer_path"; then
    echo "Installer removed successfully."
else
    echo "Failed to remove the installer."
fi
