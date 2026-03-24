# BuildVuln - Automated Vulnerable Lab Launcher

A Metasploit auxiliary module that automates the deployment of vulnerable web applications using Docker.

## Features
- Launch DVWA, Juice Shop, WebGoat
- Dynamic port selection
- Start / Stop / List containers
- Fully integrated with Metasploit

## Requirements
- Docker
- Metasploit Framework

## Usage

```bash
use auxiliary/custom/build_vuln
set ACTION start
set TARGET dvwa
run
