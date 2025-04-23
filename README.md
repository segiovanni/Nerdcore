The script automates the process of removing admin privileges from users who are not explicitly approved, ensuring that only authorized accounts (e.g., root, jamfadmin, administrator) retain administrative access. This is useful for maintaining security and compliance in environments where admin privileges need to be tightly controlled, such as in enterprise or managed macOS deployments.

Key Functionality
Error Handling and Logging:
The script exits on any error (set -e) to prevent unintended behavior.
All actions are logged to /var/log/admin_demotion.log with timestamps for auditing and troubleshooting.
Retrieve Admin Users:
Uses dscl (Directory Service Command Line) to fetch the list of users in the admin group.
Stores the list in an array (adminUsers) for safe processing.
Checks if the admin user list is empty; if so, logs an error and exits.
Define Approved Admins:
Maintains a hardcoded list of approved admin accounts (APPROVED_ADMINS) that should not be demoted.
Demote Non-Approved Admins:
Iterates through the list of admin users.
For each user, checks if they are in the APPROVED_ADMINS list.
If a user is not approved, removes them from the admin group using dseditgroup.
Logs success or failure for each demotion attempt.
Completion:
Logs the completion of the process and exits with a status code of 0 (success).
Use Case
This script is likely used in:

Enterprise IT environments to enforce security policies by limiting admin access.
Jamf Pro or MDM-managed macOS systems, as indicated by the inclusion of jamfadmin in the approved list, which is a common account used by Jamf for device management.
Automated maintenance tasks to periodically audit and correct admin group membership.
Notes
The script requires sudo privileges to modify group membership.
It assumes a macOS environment due to the use of dscl and dseditgroup.
Failures to demote a user are logged but do not stop the script, allowing it to process all users.
The log file (/var/log/admin_demotion.log) must be writable by the script’s user.
In summary, the script ensures that only approved users retain admin privileges, enhancing system security by systematically demoting unauthorized admin accounts.
