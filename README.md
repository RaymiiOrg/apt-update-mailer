# Apt-update-mailer

This is a bash script which can be ran from a cronjob. It mails which packages can be updated, the current version you have installed, the version you are updating to and (on an ubuntu system) an URL to the Ubuntu package archive with more info on the update. If there are no updates, you won't get an email.

## Example output:

    --- Updates for host: vps11.sparklingclouds.nl ---
    Date: 21.09.2012 

    Total updates available: 44

    -- Package: apport --
     Installed: 2.0.1-0ubuntu12
     Candidate: 2.0.1-0ubuntu13
    Package Information: http://packages.ubuntu.com/precise/apport
    -- End package apport --

    -- Package: build-essential --
     Installed: 11.5ubuntu2
     Candidate: 11.5ubuntu2.1
    Package Information: http://packages.ubuntu.com/precise/build-essential
    -- End package build-essential --

    -- Package: dbus --
     Installed: 1.4.18-1ubuntu1
     Candidate: 1.4.18-1ubuntu1.1
    Package Information: http://packages.ubuntu.com/precise/dbus
    -- End package dbus --

## Installation

Create a folder for the scripts (doesn't need to be root):

    mkdir ~/scripts

Place the script there (or git clone the repo):

    nano ~/scripts/apt-update-mailer.sh

Make it executable:

    chmox +x ~/scripts/apt-update-mailer.sh

Add the cronjob:
    
    crontab -e
    # [ADD, CHECKS ONCE A DAY AT 01:01 AM]
    1 1 * * * ~/scripts/updatemail.sh

If you don't receive any emails it either means the script did not find any updates, or that your MTA is not setup correctly. Check /etc/aliases, the postfix/sendmail installation and the cron email address.

## Links

[Page on raymii.org](https://raymii.org/cms/p_Ubuntu_update_mailer)
