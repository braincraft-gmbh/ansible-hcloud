bc.hcloud
=========

This role can be used to provision and manage hosts, volumes and SSH keys
in the Hetzner Cloud.


Requirements
------------

Access to the API is given via a token, which needs to be defined on the Hetzner
Console. The token is specific to a project and should be made available to
ansible on the control machine via the `HCLOUD_API` environment variable.


Role Variables
--------------

The cluster configuration is given by the variable `nodes`, which should contain
an array of dictionary items. Each list element contains one or more hosts to be
deployed. This can be used to aggregate nodes according to their typology. Each
node item will be sent with one single `hcloud_server` task, allowing the
creation or destruction of multiple servers at once (read the [hcloud_server
module
documentation](https://github.com/thetechnick/hcloud-ansible/blob/master/docs/hcloud_server.md)
for more information).

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

*Note: currently only one volume per host is supported, due to an issue with the
`getvolumes-json.sh` script*

The variable `cluster_state` further controls whether the cluster hosts should be
`present` or `absent`.

Furthermore, you need to set at least one key from the control user in the
`hcloud_ssh_keys` array, in order for the role to successfully access and
prepare the new hosts. This defaults to `~/.ssh/id_rsa.pub`.

Following are the vars defaults for this role:

```
nodes: []
cluster_state: present
default_image: ubuntu-18.04
default_location: nbg11
default_type: cx11
hcloud_ssh_keys:
  - "{{ lookup('file', '~/.ssh/id_rsa.pub' )}}"
```


Dependencies
------------

The [`hcloud-ansible` modules](https://github.com/thetechnick/hcloud-ansible)
are used and have been added to the role under `library/` for convenience.

Due to limitations on the `hcloud_server` module (no support for
[volumes](https://github.com/thetechnick/hcloud-ansible/issues/26) and
[labels](https://github.com/thetechnick/hcloud-ansible/issues/25)), this role
currently uses the [`hcloud-cli`](https://github.com/hetznercloud/cli) (included
in the role under `files/` for convenience).


Example Playbook
----------------

```
    - hosts: all
      roles:
         - { role: bc.hcloud, state: present }
```


License
-------

GNU GPLv3


Author Information
------------------

* Gualter Barbas Baptista @gandhiano gualter [at] ecobytes.net
* Michael Langfermann @versable versable [at] gmail.com
