Role Name
=========

Simple VeLighthouse deploy role (nginx included).


Role Variables
--------------

| vars | default | description |
|------|-------------|---------|
| `lighthouse_vcs` | `https://github.com/VKCOM/lighthouse.git` | URL for lighthouse project |
| `lighthouse_location_dir` | `/var/www/lighthouse` | installing directory |
| `lighthouse_access_log_name` | `lighthouse` | access log  |


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: lighthouse }


Supported OS
------------

- Ubuntu
- Debian
- Fedora Core
- Redhat
- CentOS


License
-------

BSD

Author Information
------------------

DJ Eugene [https://github.com/mea2k/ansible-roles](https://github.com/mea2k/ansible-roles)
