# redquasar-postinst

Postinstall scripts for redquasar-ublue

## !! IMPORTANT WARNING !!

### The included post-installation scripts perform destructive actions such as removing users and deleting network configs without confirmation or warning! This applies to rebasing to this image via `rpm-ostree rebase` for the first time.

### You *WILL* lose data and VPN network connectivity during setup!

### Make sure you have adequite backups and physical access to the box if connected remotely.

<details>
  <summary><strong>Click here ONLY when you have read the above warning. There is no going back!</strong></summary>
  
  To rebase to this image run the following command in your terminal.

  `rpm-ostree rebase ...; reboot`
</details>