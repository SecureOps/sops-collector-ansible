# Scanning using Greenbone Management Protocol (GMP) Version 20.08

### Table of Contents
- Executing API calls using gvm-cli
- Ungrouped fetches
- Fetching available port lists
- Fetching available scanners
- Fetching available scan configurations
- Credentials
 - Creating credentials
 - Fetching available credentials
- Targets
 - Creating a target
 - Fetching available targets
- Tasks
 - Creating a task
 - Fetching tasks
 - Starting and stopping tasks
- Reports
 - Fetching available report formats
 - Fetching CSV report for a task


## Executing API calls using gvm-cli

*Note, all code related below is available from https://github.com/SecureOps/sops-remoteCollector-ansible

The playbook is received by the remote node using files/sqs_poller.py. This poller takes an input via JSON. Note, when SQS sends a message, it assigns a unique message_id which is used to tag the report. This must be obtained from the script used to submit the SQS command or from the AWS SQS Web UI.

The format is as follows:
```json
{
  "command": "ansible-pull",
  "params": {
    "playbook": "hosted_playbooks/gvm-cli.yaml",
    "host": "<ansible target | localhost>",
    "playbook_url": "https://github.com/SecureOps/sops-remoteCollector-ansible.git",
    "branch": "centos8",
    "variables": {
      "scan_command": "<gvm_command>",
      "scan_result_bucket": "<name of S3 bucket to upload the results to>",
      "scan_var1": "<var1 used inside the template>",
      "scan_var2": "<var2 used inside the template>"
    }
  }
}
```

The variables in the JSON above do the following:
- playbook:
  - This is the playbook executed by ansible-pull. These are located in the Github repository under the <i>hosted_playbooks</i> directory. In this case, this should be a constant for this document and doesn't need to be changed
- host:
  - This is only used when the ansible-pull needs to be executed against an inventory. This should be <i>localhost</i> in regular circumstances.
- playbook_url:
  - This is the URL of the repository containing the playbook. If you're using the Github version then this should remained fixed to https://github.com/SecureOps/sops-remoteCollector-ansible.git
- branch:
  - The name of the Git branch. GVM is implemented on centos8 unless otherwise specified.
- variables:
  - This dictionary contains variables passed to the hosted_playbooks/gvm_cli.yaml playbook in the format of
  ```-e {"var1": "val1", "var2": "val2"}```
  - The following variables are used by the gvm_cli.yaml playbook
    - scan_command: This is the name of the XML command to be executed. Refer to <b>templates/gvm_xml_inputs</b> for a list of available commands. Further variables can be defined inside these templates, which would also be included in this variable list.
    - scan_result_bucket: This is the name of an S3 bucket to be used. This should be a bucket created alongside the customer definitions with permissions assigned to the remote_node via AWS key/secret. This is not mandatory, if not provided, the results will be stored on the remote node in /tmp/ansible/<message_id>.xml
    - scan_<varX>: Any other variable would be defined inside the templates located in <b>templates/gvm_xml_inputs</b>. See the sections described below for what variables are required for each command.
      - For example, get_reports.xml requires two variables:
        - scan_report_id: ID of the report to get
        - scan_report_format_id: ID of the type to be used for the report

The ansible-pull playbook (hosted_playbooks/gvm_cli.yaml) executes based on the <i>scan_command</i>

![uncached image](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/SecureOps/sops-remoteCollector-ansible/centos8/doc/puml/gvm_cli.puml)


## Ungrouped fetches
### Fetching available port lists
**Scan Command**

get_port_lists

**Variables**

None

### Fetching available scanners

**Scan Command**

get_scanners

**Variables**

None

### Fetching available scan configurations
**Scan Command**

get_scanners

**Variables**

None

## Credentials

### Creating credentials
**Scan Command**

create_credential

**Variables**
- scan_credential_label : Label to assign to the credentials
- scan_credential_username : Username
- scan_credential_password : Password

### Fetching available credentials
**Scan Command**

get_credentials

**Variables**

None

## Targets
### Creating a target
**Scan Command**

create_target

**Variables**
- scan_target_label : Label to assign to the target
- scan_target_host_csv : CSV delimited list of hosts to scan
- scan_port_list_id : (Optional) ID assigned to a port list item
- scan_ssh_credential_id : (Optional) ID assigned to an SSH credential
- scan_smb_credential_id : (Optional) ID assigned to an SMB credential
- scan_esxi_credential_id : (Optional) ID assigned to an ESXI credential

### Fetching available targets
**Scan Command**

get_targets

**Variables**

None

## Tasks
### Creating a task
**Scan Command**

create_task

**Variables**
- scan_task_label : Label to assign to the task
- scan_task_comment : Comment describing the task
- scan_config_id : ID of the config object to use with the scan
- scan_target_id : ID of the target object to scan
- scan_scanner_id : ID of the scanner object to use to perform the scan

### Fetching tasks
**Scan Command**

get_tasks

**Variables**
- scan_task_id : (Optional) ID of the scan_task to return.

### Starting a task
**Scan Command**
start_task

**Variables**
scan_task_id : ID of the task to start

### Stopping a task
**Scan Command**

stop_task

**Variables**

scan_task_id : ID of the task to stop

## Reports

### Fetching available report formats
**Scan Command**

get_report_formats

**Variables**

None

### Fetching CSV report for a task
**Scan Command**

get_reports

**Variables**
- scan_report_id
- scan_report_format_id