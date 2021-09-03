# Troubleshooting Linux Fuck Ups

So your install/update failed and fucked everything up and you want to cry because you can't boot into your OS.

This guide will help with the pain.


## Making an Manjaro Bootable USB

Make sure you have an USB with high read/write speeds otherwise the USB OS will be extremely slow.

Download the latest Manjaro-i3: https://manjaro.org/downloads/community/i3/

To burn to the USB disk try [this guide](https://wiki.manjaro.org/index.php?title=Burn_an_ISO_File#Writing_to_a_USB_Stick_in_Linux)

Make sure you get the correct drive letter by checking `fdisk -l` output. Otherwise you will overwrite internal data (**!**).

Quick and dirty `dd` command to get it working:

```sh
sudo dd bs=4M if=/path/to/manjaro.iso of=/dev/sd[drive letter] status=progress oflag=sync
```

Insert USB device and mash f12 on start up and select the external USB device to boot into the external OS.

## Chroot Into Your Drive

Boot into a Bootable USB.

To chroot into the drive: 

```sh
# unencrypt the drive
sudo cryptsetup open /dev/nvme0n1p2 backup

# mount the main drive and boot partitions
sudo mount /dev/mapper/backup /mnt
sudo mount /dev/nvme0n1p1 /mnt/boot

# chroot into the mounted drive
sudo manjaro-chroot /mnt
```

When finished doing what you need to do in the internal OS:

```sh
# exit out internal root
exit

# unmount everything
umount /mnt/boot
umount /mnt
```


## Retry Update

[Chroot into your internal OS](#chroot-into-your-device)

Then simply try `sudo pacman -Syu`.

Wait for it to complete and reboot into your internal OS.


## Back Up Home Directory

If you do not know which disks to mount try listing them all with `lsblk`

[Chroot into your internal OS](#chroot-into-your-device)

Back up all system and python packages:

```sh
pacman -Qqen > ~/system-packages.txt
pip3 freeze > ~/python-system-packages.txt
```

Get out of chroot by executing `exit`.

Mount the external HDD

```sh
sudo mkdir /mnt/external
sudo mount /dev/sdb1 /mnt/external
```

You may need to `sudo chown manjaro:manjaro /mnt/home/david/* -R` to correct any permissions.

Back up home directory to external drive:

```sh
cd /mnt/home/david

tar -cpzf /mnt/external/home-backup.tar.gz \
  --exclude=.cache \
  --exclude=.gvfs \
  --exclude=.Trash \
  --exclude=.xsession-errors \
  --exclude=.npm \
  --warning=no-file-changed \
  .

```

It may be worth untarring and checking everything looks good before continuing.


## Install Backed Up Home Direct

In your new fancy sexy freshly installed Manjaro:

```sh
cd /home/david
tar -xpzf home-backup.tar.gz 
```


TBC...


