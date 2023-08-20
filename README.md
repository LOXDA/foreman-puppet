ansible-role-foreman-puppet
=========

Ansible role to deploy a puppetserver (puppet6, puppet7)

Requirements
------------

It is designed to be include as a submodule to a project with its siblings :

* `ansible-role-foreman-db`
* `ansible-role-foreman-puppet` (this one)
* `ansible-role-foreman-proxy` 
* `ansible-role-foreman-app`
* `ansible-role-foreman-custom`

`ansible-role-mirror` should help you get started with mirroring needed repositories.

Role Variables
--------------

The role needs some vars (default/main.yml)
The vars are self-explanatory, to look for answer one could use : foreman-installer --help
All vars are combined in `tasks/Setup_Options.yml` ( -vv is your friend )

Example Playbook
----------------

```
- hosts: tfm_puppet
  gather_facts: true
  roles:
    - role: foreman-puppet
```

License
-------

CC-BY-4.0

Author Information
------------------

Thomas Basset -- hobbyist sysadm <tomm+code@loxda.net>
