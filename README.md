# DARE-SeRP-Dev-Deployment

An example deployment of DARE-Teleport to run on the SeRP Dev Cluster.

## Installing common Ansible Roles from the main DARE-Teleport repo

Every deployment is unique and every deployment needs to be versioned independently, but there are many common provisioning and configuration steps that most is not all deployments will need to perform during initial setup and rolling upgrades. 

Eventually when DARE-Teleport is public these common roles can be released publicly on Ansible Galaxy as the `dare.common` roles collection. 

For now, while DARE-Teleport is a private repo, the collection can be installed using the following procedure run on the Ansible host machine:

```
pwd

# /home/user/DARE-SeRP-Dev-Deployment/ansible

ansible-galaxy install -r requirements.yaml --force

# Cloning into '/home/bobross/.ansible/tmp/ansible-local-29005zk31oo0/tmpgoozy2p2/DARE-Teleportyo2gv4te'...
# Username for 'https://github.com': BobRoss
# Password for 'https://BobRoss@github.com': ***
# Starting galaxy collection install process
# Process install dependency map
# Starting collection install process
# Installing 'dare.common:1.0.0' to '/home/bobross/.ansible/collections/ansible_collections/dare/common'
# Created collection for dare.common:1.0.0 at /home/bobross/.ansible/collections/ansible_collections/dare/common
# dare.common:1.0.0 was installed successfully
```

Now in your ansible playbooks you can refer to the DARE-Teleport common ansible roles like follows:
```
# Example playbook test-roles.yaml
---
- hosts: localhost
  roles:
    - dare.common.k3s_bootstrap
```

The version of the DARE-Teleport Common Ansible Roles is defined in the ansible `requirements.yaml` file and official releases will be of the format `DARE-Teleport-Ansible-v1.0.0`. This version should be bumped by the deployment owner as needed to respect compatibility with the deployed version of the DARE-Telepot helm chart.

```
# Example requirements.yaml
collections:
  - name: dare.common
    source: git+https://github.com/SwanseaUniversityMedical/DARE-Teleport.git#/ansible,DARE-Teleport-Ansible-v1.0.0
    type: git
```
