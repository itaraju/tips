LVM (fedora) tips
-----------------

## Adding new disk / partition / Volume

ref:
http://blogs.kasa.ws/how-to-install-new-disk-drives-in-fedora/

1- Partition of the new disk drive

Listing partitions
# fdisk -l
# ls -l /dev/sd*

new disk on /dev/sdb, partitioning
# fdisk /dev/sdb
> m
> n (add new partition)
> e (extended kind)
> enter (default number 1, default sector, and size)
> p
> n (adding new logical partition, as all space is filled up with sdb1)
> p (partition created as sdb5)
> w (write this)

Extended partitions do not hold data, instead they hold logical partitions.
So the new disk drive is in /dev/sdb5

2- Create Logical Volumes with LVM

Create a physical volume (PV)
# pvcreate /dev/sdb5

List PVs
# pvdisplay

Create Volume Group (VG)
# vgcrate vg_home /dev/sdb5

List VGs
# vgdisplay

Create Logical Volume (LV) leaving some free space
# lvcreate -L 5GB -n lv_home vg_home

3- Format the logical volume with the ext4 file system

mke2fs -t ext4 /dev/vg_home/lv_home

4- Mount it
# mkdir /media/newhome
# chmod 777 /media/newhome
# mount /dev/vg_home/lv_home /media/newhome

## Extending size of logical volume

ref: https://www.tecmint.com/extend-and-reduce-lvms-in-linux/

useful commands, summary of Physical Volumes/Volume Groups/Logical Volumes:
pvs
vgs
lvs

- here, volume group already has free space, so skipping first steps
    vgs / vgdisplay vg home shows free space


