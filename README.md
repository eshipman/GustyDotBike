# GustyDotBike
CPSC 430 Project for Professor Gusty Cooper.

This repository contains a shell script that installs Wordpress and Mooshak onto an Ubuntu 18.04 AWS Instance. 

A user manual details the instructions on how to use the script to install Wordpress and Mooshak, which will be given to Gusty. An excerpt of this installation is given below.

Use the following steps to get the installer script and install Mooshak and Wordpress onto your machine.
1) SSH into your AWS Ubuntu 18.04 instance.
2) On your AWS instance, in your security groups, ensure that port 8180 is open for Mooshak to use.
3) Update: 
sudo apt-get update
4) Download Git:  
sudo apt-get -y install git
5) Clone the repository: You will receive the installer.sh file.
git clone https://github.com/eshipman/GustyDotBike
6) Run the installer Script to download Mooshak and Wordpress. This will also create a log file for debugging purposes.
cd GustyDotBike
sudo bash installer.sh | tee install.log
7) The script will ask you 
 a) A root password for the MySQL user. 
 b) mysql will ask for a password user for wordpressuser. Enter a password of your choosing.
8) Some portions of the script may appear to freeze, this is normal. Please do not stop the script from running
