
# puppet-ipam

An Opinioned DHCP/DNS infrastructure.

[![License](https://img.shields.io/github/license/ppouliot/puppet-ipam.svg)](./LICENSE)
[![Source Code](https://img.shields.io/badge/source-GitHub-blue.svg?style=flat)](https://github.com/ppouliot/puppet-ipam)
[![Latest version](https://img.shields.io/github/tag/ppouliot/puppet-ipam.svg?label=release&style=flat&maxAge=2592000)](https://github.com/ppouliot/puppet-ipam/tags)
[![GitHub issues](https://img.shields.io/github/issues/ppouliot/puppet-ipam.svg)](https://github.com/ppouliot/puppet-ipam/issues)
[![GitHub forks](https://img.shields.io/github/forks/ppouliot/puppet-ipam.svg)](https://github.com/ppouliot/puppet-ipam/network)

#### Table of Contents

1. [Description](#description)
2. [Build - The basics of getting started with ipam](#build)
    * [Building with Docker](#building-with-docker)
    * [Building with Vagrant](#building-with-vagrant)
3. [Setup - Getting the module working on your system](setup-requirements)
    * [Puppetfile](#puppetfile)
    * [Beginning with ipam](#beginning-with-ipam)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Development - Guide for contributing to the module](#development)

## Description
Welcome to the puppet-ipam module.  This is an opinionated deployment of a DNS/DHCP Infrastructure.
It creates an Active/Active ISC-DHCP-Server Cluster and a Bind Primary/Secondary across two nodes.
All records are added via Hiera data.

This module was used to managed the IPAM networing infrastrucure for Microsoft's OpenStack CI Operations
from 2013 until june of 2017.  At it peak it processed 18,000 lines of hiera defining every network interface 
on every Server in the MS OpenStack CI.

![puppet-ipam](/assets/IPAM.svg)

## Build 
The process of building this puppet module has been distilled and encapsulated into two build methods in order to test the deployment
accuracy across multiple platforms and to ensure formatting of the information supplied to the module.
  
  * Dockerfiles (Centos/Debian/Ubuntu)
  * Vagrantfile

<script src="https://asciinema.org/a/174702.js" id="asciicast-174702" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Building with Docker

The following Dockerfiles and container images artifacts from testing are provided below.  A [docker-compose.yaml](./docker-compose.yaml) is 
used to build and label container images that versioned and pushed to the dockerhub.  Building all associated Dockerfiles can be achieved
by running the [build script](./build.sh) located in this directory with the "-d" flag as show in this example:

```
./build.sh  -d
```


* [![](https://images.microbadger.com/badges/image/ppouliot/puppet-ipam.svg)](https://microbadger.com/images/ppouliot/puppet-ipam) [![](https://images.microbadger.com/badges/version/ppouliot/puppet-ipam.svg)](https://microbadger.com/images/ppouliot/puppet-ipam) [ppouliot/puppet-ipam](./Dockerfile)
* [![](https://images.microbadger.com/badges/image/ppouliot/puppet-ipam-centos.svg)](https://microbadger.com/images/ppouliot/puppet-ipam-centos) [![](https://images.microbadger.com/badges/version/ppouliot/puppet-ipam.svg)](https://microbadger.com/images/ppouliot/puppet-ipam-centos) [ppouliot/puppet-ipam-centos](./Dockerfile.centos)
* [![](https://images.microbadger.com/badges/image/ppouliot/puppet-ipam-debian.svg)](https://microbadger.com/images/ppouliot/puppet-ipam-debian) [![](https://images.microbadger.com/badges/version/ppouliot/puppet-ipam.svg)](https://microbadger.com/images/ppouliot/puppet-ipam-debian) [ppouliot/puppet-ipam-debian](./Dockerfile.debian)
* [![](https://images.microbadger.com/badges/image/ppouliot/puppet-ipam-ubuntu.svg)](https://microbadger.com/images/ppouliot/puppet-ipam-ubuntu) [![](https://images.microbadger.com/badges/version/ppouliot/puppet-ipam.svg)](https://microbadger.com/images/ppouliot/puppet-ipam-ubuntu) [ppouliot/puppet-ipam-ubuntu](./Dockerfile.ubuntu)

### Building with Vagrant
A [Vagrantfile](./Vagrantfile) is supplied in order to test deployment and execution of the puppet code in a virtual machine environment.
This should validate that all services have started properly and also include a dhcpclient as a test to ensure everything 
is fully operational within the DHCP/DNS Cluster and that all services are in proper working order. To utilize Vagrant to test
this deployment run the same [build script](./build.sh) to initate the running.  The following is an example of building using vagrant:

``` 
./build.sh -v
```

## Setup Requirements
### Puppetfile

This module contains a [Puppetfile](./Puppetfile) which can be used to install all module dependencies.
To use the Puppetfile, place it directory above the modules folder and run:
```
r10k puppetfile install --verbose
```

### Beginning with ipam  

The simplest way to consume this module is to include it in your node definition and modify the provided [hieradata](./files/hiera)
an example configuration and include it in hiera on the system or puppetmaster.

## Usage
Basic usage:

```
class{'ipam':}
```


## Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

## Reference 

 * https://www.techrepublic.com/blog/linux-and-open-source/setting-up-a-dynamic-dns-service-part-2-dhcpd/
 * https://ubuntuforums.org/showthread.php?t=2161213
 * https://www.linuxquestions.org/questions/linux-server-73/dynamic-dhcp-update-to-dns-921318/

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 
