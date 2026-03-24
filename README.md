# BuildVuln - Automated Vulnerable Lab Launcher

A Metasploit auxiliary module for quickly deploying vulnerable web applications using Docker.

---

#Overview

BuildVuln simplifies the process of setting up vulnerable labs for penetration testing and security training.
It integrates directly with Metasploit and automates the deployment of multiple applications using Docker containers.

This module is designed for:

- Security learners
- Penetration testers
- CTF players
- Training environments

---

#Key Features

- Multi-target execution (run multiple labs at once)
- Support for dynamic targets (any Docker image)
- Automatic and custom port management
- Simple lab lifecycle control (start / stop / list)
- Seamless integration with Metasploit Framework

---

#Architecture

The module acts as a bridge between Metasploit and Docker:

Metasploit → Auxiliary Module → Docker Engine → Vulnerable Containers

---

#Supported Targets

Built-in targets

- DVWA (Damn Vulnerable Web Application)
- OWASP Juice Shop
- OWASP WebGoat
- bWAPP
- Mutillidae

Dynamic targets

Any Docker image can be used as a target by specifying its name.

Example:

set TARGET nginx
run

---

#Installation

Clone or copy the module into your Metasploit modules directory:

cd ~/.msf4/modules/auxiliary/custom
nano build_vuln.rb

Paste the module code and save the file.

Start Metasploit:

msfconsole

---

#Usage

Load the module:

use auxiliary/custom/build_vuln

---

#Start a single target

set ACTION start
set TARGET dvwa
run

---

#Start multiple targets

set TARGET dvwa,juice,bwapp
run

---

#Run dynamic target

set TARGET nginx
run

---

#Use custom port
set PORT 9000
run

---

#List running containers

set ACTION list
run

---

#Stop all containers

set ACTION stop
run

---

#Example Output

DVWA started at http://localhost:8080
Juice Shop started at http://localhost:3000

---

#Use Cases

- Setting up vulnerable labs for practice
- Preparing environments for penetration testing
- Running multiple training targets quickly
- Creating CTF-style local environments

---

#Limitations

- Requires Docker to be installed and running
- Some images may require manual configuration
- Dynamic targets depend on Docker Hub availability

---

#Future Improvements

- Assign custom container names
- Stop specific targets instead of all containers
- Add logging and monitoring features
- Web-based interface for lab management
