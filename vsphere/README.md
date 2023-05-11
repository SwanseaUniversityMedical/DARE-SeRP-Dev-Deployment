# VSphere

This Terraform is for use with VMWare vSphere, notably vCenter Server and ESXi.

It will create a given number of VMs for the Teleport project to run on top of. The Terraform is flexible and can create a single monolithic VM for all services to run on, or can create a given number of VMs for each of the 3 necessary K8s clusters -- one for work, one for management, and one for monitoring.

## Pre-requsites

You will require a vSphere hypervisor, and a vSphere service account configured with the following permissions:

**Content Library** 

- Download files
- Read Storage

**Datastore**

- Allocate space
- Browse datastore
- Low level file operations

**Global** 

- Cancel task

**Network**

- Assign network

**Resource** 

- Assign virtual machine to resource pool

**Scheduled task** 

- Create tasks
- Modify task
- Remove task
- Run task

**Profile-driven storage** 

- Profile-driven storage view

**vApp** 

- Export

**Virtual machine** 

- Change Configuration
    - Acquire disk lease
    - Add existing disk
    - Add new disk
    - Add or remove device
    - Advanced configuration
    - Change CPU count
    - Change Memory
    - Change Settings
    - Change Swapfile placement
    - Change resource
    - Configure Host USB device
    - Configure Raw device
    - Configure managedBy
    - Display connection settings
    - Extend virtual disk
    - Modify device settings
    - Query Fault Tolerance compatibility
    - Query unowned files
    - Reload from path
    - Remove disk
    - Rename
    - Reset guest information
    - Set annotation
    - Toggle disk change tracking
    - Toggle fork parent
    - Upgrade virtual machine compatibility
    - privilege.VirtualMachine.Config.Unlock.label
- Edit Inventory
    - Create from existing
    - Create new
    - Move
    - Register
    - Remove
    - Unregister
- Guest operations
    - Guest operation alias modification
    - Guest operation alias query
    - Guest operation modifications
    - Guest operation program execution
    - Guest operation queries
- Interaction
    - Answer question
    - Backup operation on virtual machine
    - Configure CD media
    - Configure floppy media
    - Connect devices
    - Console interaction
    - Create screenshot
    - Defragment all disks
    - Drag and drop
    - Guest operating system management by VIX API
    - Inject USB HID scan codes
    - Install VMware Tools
    - Pause or Unpause
    - Perform wipe or shrink operations
    - Power off
    - Power on
    - Record session on virtual machine
    - Replay session on virtual machine
    - Reset
    - Resume Fault Tolerance
    - Suspend
    - Suspend Fault Tolerance
    - Test failover
    - Test restart Secondary VM
    - Turn off Fault Tolerance
    - Turn on Fault Tolerance
- Provisioning
    - Allow disk access
    - Allow file access
    - Allow read-only disk access
    - Allow virtual machine download
    - Allow virtual machine files upload
    - Clone template
    - Clone virtual machine
    - Create template from virtual machine
    - Customize guest
    - Deploy template
    - Mark as template
    - Mark as virtual machine
    - Modify customization specification
    - Promote disks
    - Read customization specifications
- Service configuration
    - Allow notifications
    - Allow polling of global event notifications
    - Manage service configurations
    - Modify service configuration
    - Query service configurations
    - Read service configuration
- Snapshot management
    - Create snapshot
    - Remove snapshot
    - Rename snapshot
    - Revert to snapshot


## Usage

Create two files, secret.tfvars and variables.tfvars from the two tfvars.template files in the folder.
You will need to fill in the credentials of the service account in secret.tfvars, and basic information about the VM(s) to be created in variables.tfvars. Extra values for other variables can be added here, see variables.tf for the full list of variables that can be used to customise the deployment.

When you first pull the repo you will need to run
```terraform init```

You can then run the terraform plan with
```terraform plan --var-file="secret.tfvars" --var-file="variables.tfvars"```

After checking that the plan looks correct, you can apply it with
```terraform apply --var-file="secret.tfvars" --var-file="variables.tfvars"```

And to tear down the created VMs use
```terraform destroy --var-file="secret.tfvars" --var-file="variables.tfvars"```