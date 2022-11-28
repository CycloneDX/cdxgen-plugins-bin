# Introduction

This repo contains binary executables that could be invoked by [cdxgen](https://github.com/AppThreat/cdxgen).

![cdxgen logo](cdxgen.png)

## Usage

## Installation

Install cdxgen first followed by the plugins.

```bash
sudo npm install -g @appthreat/cdxgen
sudo npm install -g @ngcloudsec/cdxgen-plugins-bin
```

cdxgen would automatically use the plugins from the global node_modules path to enrich the SBoM output for certain project types such as `docker`.
