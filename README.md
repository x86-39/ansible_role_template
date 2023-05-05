Ansible Role Template
=========

This is an Ansible role to install and configure template.

Include more information about template in this section.

Requirements
------------
These platforms are supported:
- Ubuntu 20.04  
- Ubuntu 22.04  
- Debian 10  
- Debian 11  
- EL 8 (Tested on Rocky Linux 8)  
- EL 9 (Tested on Rocky Linux 9)  
- Fedora 38  

<!-- 
- List hardware requirements here  
-->

Role Variables
--------------

Variable | Default | Description
--- | --- | ---
<!--
`variable` | `default` | Variable example
`long_variable` | See [defaults/main.yml](./defaults/main.yml) | Variable referring to defaults
`distro_specific_variable` | See [vars/debian.yml](./vars/debian.yml) | Variable referring to distro-specific variables
-->

Dependencies
------------
<!-- List dependencies on other roles or criteria -->
None

Example Playbook
----------------

```yaml
- name: Use template role
  hosts: "{{ target | default('template') }}"
  roles:
    - diademiemi.template
```

License
-------

MIT

Author Information
------------------

- diademiemi (@diademiemi)

Role Testing
------------

This repository comes with Molecule tests for Docker on the supported platforms.
Install Molecule by running
```bash
pip3 install -r requirements.txt
```

Run the tests with
```bash
molecule test
```
Role Structure
--------------

Roles have an entrypoint `main.yml` which includes other files.  
It searches for files in `vars/`, `tasks/assert/` and `tasks/setup` for files named like the host platform. If no file is found, it falls back to `default.yml`.  

This is an easy way to provide distro-specific variables, assertions and tasks and allows me to keep the role structure clean.  

Using Template
--------------
To use this template for a new role, run
```bash
export NEW_ROLE_NAME="NEW_NAME"
export GITHUB_USER="diademiemi"
export GALAXY_API_KEY="YOUR_API_KEY"

find . -type f -exec sed -i "s/diademiemi/${GITHUB_USER}/g" {} + # Do not run this more than once
find . -type f -exec sed -i "s/template/${NEW_ROLE_NAME}/g" {} + # Do not run this more than once

# Assumes repo is named ansible_role_${NEW_ROLE_NAME}
gh secret set GALAXY_API_KEY -R ${GITHUB_USER}/ansible_role_${NEW_ROLE_NAME} -a actions -b ${GALAXY_API_KEY}

# Remove this section from README.md
sed -i "/Role Structure/Q" README.md
```