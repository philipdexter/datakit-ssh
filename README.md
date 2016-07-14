Original source is in `full_src` directory.

# Build

`docker build -t datakit-ssh .`

# Keys

Set up some keys

```bash
$ mkdir ~/.datakit-ssh
$ cd ~/.datakit-ssh
$ ssh-keygen
 enter ./id_rsa
 don't use a passphrase
```

# Server

```bash
$ docker run --net datakit-net --name datakit-ssh -v </path/to/git/repo>:/data -P -v $(realpath ~/.datakit-ssh/id_rsa.pub):/root/.ssh/authorized_keys -v $(realpath ~/.datakit-ssh/id_rsa):/root/.ssh/.id_rsa -it datakit-ssh
```

Multiple servers use different local checkouts of a git repository.

# Client

Use the original datakit client container

```bash
$ docker run -it --privileged -v </path/to/git/repo>:/peerN --net datakit-net docker/datakit:client
```

Note that the git repo mounted in the client would be used to perform
local modifications. This should be the same path used to set up the
server.

Multiple clients use different local checkouts of a git repository.

Remember to mount the necessary server when using multiple servers and
clients (**TODO**: this should be automated and not hardcoded):

```bash
$ getent hosts YOURHOST
this.is.an.ip
$ /usr/bin/datakit-mount -h this.is.an.ip
```

Set up a remote from peer1 to server2.

```bash
$ cd /db/remotes
$ mkdir server2
$ cd server2
$ echo -n 'root@172.18.0.3:/data' > url
$ echo master > fetch
```

At this point you must switch to the server (server1 in my example)q,
there will be a message about the authenticity of server2, type yes
and hit enter. (**TODO**: automate this step somehow)

This is as far as I've gotten. There should be erros in the server1
console.

# Notes

1. For testing it is very useful to have the private key (id_rsa) on
   the clients. For example, with the private key you can ssh from
   peer1 to server2 (git uses ssh). You can also do a normal git clone
   outside of the datakit protocol (e.g. `git clone
   root@172.18.0.3:/data`)
