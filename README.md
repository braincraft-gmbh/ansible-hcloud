bc.hcloud
=========

This role can be used to create, destroy, start or stop the servers
in a Hetzner Cloud cluster (project).


Requirements
------------

Access to the API is given via a token, which needs to be defined on the Hetzner Console.
The token is specific to a project and should be made available to ansible on the control machine
via the `HCLOUD_API` environment variable.


Role Variables
--------------

The cluster configuration is given by the variable `nodes`, which should contain an array of
dictionary items. Each list element contains one or more hosts to be deployed. This can be
used to aggregate nodes according to their typology. Each node item will be sent with one
single `hcloud_server` task, allowing the creation or destruction of multiple servers at once
(read the [hcloud_server module documentation](https://github.com/thetechnick/hcloud-ansible/blob/master/docs/hcloud_server.md) for more information).

Here is a definition of `nodes`:

```
nodes:
  - name:
      - serverA
      - serverB
    type: cx11
    profile: web  
  - name:
      - serverC
    type: cx11-ceph
    profile: storage
    volumes:
    - mount: srv
      size: 20
```

The variable `cluster_state` further controls whether the cluster hosts should be
`present` or `absent`.


Dependencies
------------

A [dynamic inventory script `hcloud.py`](https://github.com/hg8496/ansible-hcloud-inventory/)
is used to gather the hosts available under the project with the respective API token
and should be present in the playbook inventory path.

The [`hcloud_server` module](https://github.com/thetechnick/hcloud-ansible)
needs to be present on the `library` path.


Example Playbook
----------------

```
    - hosts: hcloud_cluster
      roles:
         - { role: bc.hcloud, state: present }
```


License
-------

GNU GPL v3


Author Information
------------------

* Gualter Barbas Baptista <gualter@ecobytes.net>
* Michael Langermann <mila@braincraft.de>
