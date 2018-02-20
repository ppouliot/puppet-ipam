
# puppet-ipam

An Opinioned DHCP/DNS infrastructure.

[![License](https://img.shields.io/github/license/ppouliot/puppet-ipam.svg)](https://github.com/ppouliot/puppet-ipam/blob/master/LICENSE)

#### Table of Contents

1. [Description](#description)
2. [Build - The basics of getting started with ipam](#build)
    * [Building with Docker](#build with docker)
    * [Building with Vagrant](#build with vagrant)
    * [Beginning with ipam](#beginning-with-ipam)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description
Welcome to the puppet-ipam module.  This is an opinionated deployment of a DNS/DHCP Infrastructure.
It creates an Active/Active ISC-DHCP-Server Cluster and a Bind Primary/Secondary across two nodes.
All records are added via Hiera data.

This module was used to managed the IPAM networing infrastrucure for Microsoft's OpenStack CI Operations
from 2003 until june of 2017.  At it peak it processed 18,000 lines of hiera defining every network interface 
on every Server in the MS OpenStack CI.

## Build 
The process of building this puppet module has been distilled and encapsulated into two build methods in order to test the deployment
accuracy across multiple platforms and to ensure formatting of the information supplied to the module.
  
  * Dockerfiles (Centos/Debian/Ubuntu)
  * Vagrantfile

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

## Setup
### What ipam affects **OPTIONAL**

If it's obvious what your module touches, you can skip this section. For example, folks can probably figure out that your mysql_instance module affects their MySQL instances.

If there's more that they should know about, though, this is the place to mention:

* Files, packages, services, or operations that the module will alter, impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, another module, etc.), mention it here. 
  
If your most recent release breaks compatibility or requires particular steps for upgrading, you might want to include an additional "Upgrading" section here.

### Beginning with ipam  

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

This section is where you describe how to customize, configure, and do the fancy stuff with your module here. It's especially helpful if you include usage examples and code samples for doing things with your module.

## Reference

Users need a complete list of your module's classes, types, defined types providers, facts, and functions, along with the parameters for each. You can provide this list either via Puppet Strings code comments or as a complete list in the README Reference section.

* If you are using Puppet Strings code comments, this Reference section should include Strings information so that your users know how to access your documentation.

* If you are not using Puppet Strings, include a list of all of your classes, defined types, and so on, along with their parameters. Each element in this listing should include:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 
