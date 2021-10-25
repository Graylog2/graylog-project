Graylog Project
===============

The purpose of this project is to make it easier to develop Graylog and its
plugins.

Graylog consists of the core [server](https://github.com/Graylog2/graylog2-server)
project and several plugins (e.g. the [collector plugin](https://github.com/Graylog2/graylog-plugin-collector))
which are all separate [maven](https://maven.apache.org/) projects.

To make it possible to build all of those project with a single `mvn package`
command, we built this meta project which pulls in the core server and all
plugins into a single maven reactor.

The [graylog-project CLI](https://github.com/Graylog2/graylog-project-cli) tool
is used to manage this meta project and is a requirement.

## Setup

1. be able connect via ssh to github (process described [here](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), can be tested with `ssh -T git@github.com` )
1. Install the latest version of the graylog-project CLI tool
1. Bootstrap the graylog-project repository
1. Import the graylog-project repository into your IDE


### Install CLI Tool

Go to the [releases](https://github.com/Graylog2/graylog-project-cli/releases)
page of the CLI tool and download the latest version for your platform.

Put the binary somewhere into your PATH.

Example:

```
$ mkdir -p $HOME/bin
$ cp graylog-project.linux $HOME/bin/graylog-project
$ chmod +x $HOME/bin/graylog-project
```

If you use the example above, please make sure your `$HOME/bin` is in your PATH!

### Bootstrap

Use the `graylog-project` tool to bootstrap the graylog-project repository via
the `graylog-project bootstrap github://Graylog2/graylog-project.git` command.

Example:

```
$ graylog-project bootstrap github://Graylog2/graylog-project.git
    git clone git@github.com:Graylog2/graylog-project.git graylog-project
      Cloning into 'graylog-project'...
    git checkout master
      Already on 'master'
      Your branch is up-to-date with 'origin/master'.
Repository: git@github.com:Graylog2/graylog2-server.git
Cloning git@github.com:Graylog2/graylog2-server.git into graylog-project-repos/graylog2-server
    git clone git@github.com:Graylog2/graylog2-server.git graylog-project-repos/graylog2-server
      Cloning into 'graylog-project-repos/graylog2-server'...
Checkout revision: master
    git branch master origin/master
    git checkout master
      Already on 'master'
      Your branch is up-to-date with 'origin/master'.
Repository: git@github.com:Graylog2/graylog-plugin-anonymous-usage-statistics.git
Cloning git@github.com:Graylog2/graylog-plugin-anonymous-usage-statistics.git into graylog-project-repos/graylog-plugin-anonymous-usage-statistics
    git clone git@github.com:Graylog2/graylog-plugin-anonymous-usage-statistics.git graylog-project-repos/graylog-plugin-anonymous-usage-statistics
      Cloning into 'graylog-project-repos/graylog-plugin-anonymous-usage-statistics'...
Checkout revision: master
    git branch master origin/master
    git checkout master
      Already on 'master'
      Your branch is up-to-date with 'origin/master'.
Repository: git@github.com:Graylog2/graylog-plugin-map-widget.git
Cloning git@github.com:Graylog2/graylog-plugin-map-widget.git into graylog-project-repos/graylog-plugin-map-widget
    git clone git@github.com:Graylog2/graylog-plugin-map-widget.git graylog-project-repos/graylog-plugin-map-widget
      Cloning into 'graylog-project-repos/graylog-plugin-map-widget'...
Checkout revision: master
    git branch master origin/master
    git checkout master
      Already on 'master'
      Your branch is up-to-date with 'origin/master'.

[...]

Generating pom.xml file from template pom.xml.tmpl
Generating runner/pom.xml file from template runner/pom.xml.tmpl
Generating src/main/assembly/server-tarball.xml file from template src/main/assembly/server-tarball.xml.tmpl
Writing manifest state to .graylog-project-manifest-state
```

#### Checking out a particular version

The project contains various manifest files specifying the version of Graylog project repositories to be checked out. The `manifests/master.json` file is used by default. The `--manifest` argument allows you to check out a different version:
```
graylog-project bootstrap github://Graylog2/graylog-project.git --manifest manifests/4.2.json
```

### IDE Import

Now you can import the `graylog-project` folder into your IDE of choice.

At Graylog we are using [IntelliJ IDEA](https://www.jetbrains.com/idea/) so we
are using that for the following example.

After importing the project into your IDE, create a server run configuration:

[![IntelliJ Run Config](/docs/images/intellij-run-config.png)](https://raw.githubusercontent.com/Graylog2/graylog-project/master/docs/images/intellij-run-config.png)

- Make sure to use the **runner** module for the *Use classpath of module* option
- Use the **graylog2-server** directory as *Working directory*
- In *Program arguments* use `server -f graylog.conf --local`
  (`--local` to avoid sending usage stats and running version checks)

This allows the listed plugins to be on the same classpath and thus loaded
directly without having to go through mvn package and symlinking/copying into
Graylog's plugins folder.

### Server Configuration File

Create a `graylog.conf` file inside the `graylog2-server` directory based on
the `misc/graylog.conf` example configuration.

### Initial Build

Before you can run the server from the IDE, you have to run an initial build
to create some assets.

```
$ mvn compile
```

This will build the backend and frontend parts.

For a faster compile, you can skip building the frontend, building javadocs, and running tests:

```
mvn -Dmaven.javadoc.skip=true -DskipTests -Dskip.web.build compile
```


## Usage

### Elasticsearch & MongoDB

Before you start the server, make sure you have an Elasticsearch and MongoDB
service running. If you're just testing this out and you don't care about persistent data, you can run:

```
sudo sysctl -w vm.max_map_count=262144
docker run -d -p 27017:27017 --name mongo mongo:latest
docker run -d -p 9200:9200 -p 9300:9300 elasticsearch:7.10.2
```

Make sure that `graylog.conf` contains the correct connection details for Elasticsearch and MongoDB.


### Server Start

Now you should be able to start the server from your IDE by using the
run configuration that you created before.

### Web Interface Start

For development we are using the webpack-dev-server. You can start it by
using the following command inside the `graylog2-server/graylog2-web-interface`
directory.

```
$ ./node/yarn/dist/bin/yarn start
```

If you are running the 2.4 branch or earlier, you have to use npm to start the
development webserver:

```
$ ./node/npm run start
```

The web interface is now reachable via [http://localhost:8080/](http://localhost:8080/).

### Working with Proxy

To be able to run builds in environments that needs proxy settings to access the internet, first run `mvn` with the option to disable proxy by-pass to yarn.

```
mvn -Dfrontend.yarn.yarnInheritsProxyConfigFromMaven=false
```

Add the Proxy settings to the users *.yarnrc*:

```
proxy "https://<user>:<password>@proxy.in.lan:8080"
https-proxy "https://<user>:<password>@proxy.in.lan:8080"
```
