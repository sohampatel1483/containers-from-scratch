# Containers From Scratch

## Overview

This task implements a Docker-like container management tool using Bash and core Linux primitives. The tool, called **Conductor**, enables you to build images, instantiate containers, manage networking, and layer filesystems using overlayfs—all from scratch, without relying on Docker or other container engines.

You will interact with two primary scripts:

- **conductor.sh**: The main container management tool.
- **setup.sh**: Configuration file for network and directory paths.

---

## Features

- **Image Building:** Create Debian/Ubuntu-based images using a Dockerfile-like Conductorfile. Supports `FROM`, `COPY`, and `RUN` instructions with layered overlayfs.
- **Container Lifecycle:** Instantiate, list, stop, and remove containers. Each container is isolated using Linux namespaces (PID, UTS, NET, MOUNT, IPC).
- **Overlay Filesystem:** Efficient image/container storage using overlayfs with support for multiple layers.
- **Networking:** Add veth-based networking, NAT, port forwarding, and peer connections between containers.
- **Exec Support:** Run commands inside running containers, joining all namespaces.
- **Resource Management:** Bind-mount `/dev`, mount `proc` and `sysfs` for full-featured environments.

---

## Directory Structure

```
task3/
├── conductor.sh
└── setup.sh
```

---

## Prerequisites

- **Operating System:** Linux (recommended inside provided VM)
- **Tools:** `ip`, `ping`, `iptables`, `top`, `debootstrap`, `sha256sum`
- **Install dependencies:**

```bash
sudo apt install debootstrap iptables
```

- **Network Configuration:**
  Edit `setup.sh` and set `DEFAULT_IFC` to your VM’s external network interface (see `ip a`).

---

## Usage

### 1. Build an Image

Prepare a `Conductorfile` (like a Dockerfile) with instructions:

```
FROM debian:bookworm
COPY ./myapp /opt/myapp
RUN apt update && apt install -y python3
```

Build the image:

```bash
sudo ./conductor.sh build myimage Conductorfile
```

### 2. List Images

```bash
sudo ./conductor.sh images
```

### 3. Run a Container

```bash
sudo ./conductor.sh run myimage mycontainer -- [command args]
# If no command is given, defaults to /bin/bash
```

### 4. List Running Containers

```bash
sudo ./conductor.sh ps
```

### 5. Execute a Command in a Running Container

```bash
sudo ./conductor.sh exec mycontainer -- [command args]
# Example: sudo ./conductor.sh exec mycontainer -- /bin/bash
```

### 6. Stop and Remove a Container

```bash
sudo ./conductor.sh stop mycontainer
```

### 7. Remove an Image

```bash
sudo ./conductor.sh rmi myimage
```

### 8. Clean Up All Caches

```bash
sudo ./conductor.sh rmcache
```

### 9. Networking

- **Add basic networking:**

```bash
sudo ./conductor.sh addnetwork mycontainer
```

- **Allow internet access:**

```bash
sudo ./conductor.sh addnetwork mycontainer -i
```

- **Expose a port:**

```bash
sudo ./conductor.sh addnetwork mycontainer -e 8080-80
# Maps host port 80 to container port 8080
```

- **Peer two containers:**

```bash
sudo ./conductor.sh peer container1 container2
```

---

## How It Works

| Feature       | Implementation Details                                                          |
| :------------ | :------------------------------------------------------------------------------ |
| Image Build   | Uses `debootstrap` for base, overlayfs for layers, parses `Conductorfile`       |
| Container Run | `unshare` for namespaces, `chroot` to overlayfs, mounts `/dev`, `proc`, `sysfs` |
| Exec          | `nsenter` joins all namespaces of the running container                         |
| Networking    | veth pairs, `ip` commands, iptables for NAT/port forwarding, static DNS         |
| OverlayFS     | Layered filesystem for images and containers, efficient storage                 |

---

## Example Workflow

```bash
# Build an image from a Conductorfile
sudo ./conductor.sh build testimage Conductorfile

# Run a container named 'eg' from 'testimage'
sudo ./conductor.sh run testimage eg

# Add networking and expose port 8080 in the container to 3000 on the host
sudo ./conductor.sh addnetwork eg -i -e 3000-8080

# Exec into the running container
sudo ./conductor.sh exec eg -- /bin/bash

# Stop the container
sudo ./conductor.sh stop eg
```

---

## References

- [OverlayFS Documentation](https://wiki.archlinux.org/title/Overlay_filesystem)
- [Debootstrap](https://wiki.debian.org/Debootstrap)
- [Linux Namespaces](https://lwn.net/Articles/531381/)

---

This project was created as part of the course **Virtualization and Cloud Computing (CS695)** at IIT Bombay, taught by Prof. Purushottam Kulkarni (Spring 2025).
