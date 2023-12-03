# nix
NixOS related files

## Create partitions (`fdisk`)
```
dev=/dev/nvme0n1
```
```
fdisk ${dev}
```

Create new GPT partition table
```
g
```

Create boot partition
```
n
<partition# - default>
+1G
```

Change partition type for boot to "EFI System"
```
t
1
```

Create system partition
```
n
<partition# - default>
<size - default/remaining>
```

Apply partitions
```
w
```

## Format

Check partition names:
```
lsblk
```

Expect: (sample)
```
nvme0n1     259:0    0 931.5G  0 disk 
├─nvme0n1p1 259:1    0     1G  0 part 
└─nvme0n1p2 259:2    0 930.5G  0 part 
```

### Make boot partition
```
sudo mkfs.fat -F 32 ${dev}p1
sudo fatlabel ${dev}p1 BOOT
```

### Setup cryptsetup

```
sudo cryptsetup -y -v luksFormat ${dev}p2
sudo cryptsetup config /dev/nvme0n1p2 --label NIX-ENC
```
(Note: `Are you sure? (Type 'yes' in capital letters): YES` needs to be in *CAPITAL LETTERS*)

Open it for use
```
sudo cryptsetup open /dev/<root-partition> root
```


### [Alt 1] Make root partition (`btrfs`)
Create and mount btrfs root partition
```
sudo mkfs.btrfs /dev/mapper/root -L NIX
```

Check:
```
lsblk -o name,label,size,uuid
```
Expect:
```
nvme0n1                              931.5G 
├─nvme0n1p1 BOOT                         1G 199D-4E10
└─nvme0n1p2 NIX-ENC                  930.5G 4aec46fe-24a5-4a06-abca-514ea4e58c8c
  └─root    NIX                      930.5G 8b2e600a-deb0-49db-8ca7-caed5093fbbe
```

#### Create subvolumes in btrfs.
Mount to a temp location
```
mkdir /tmp/root
sudo mount /dev/mapper/root -o compress-force=zstd,noatime,ssd /tmp/root
cd /tmp/root
```

Create subvolumes
```
sudo btrfs subvolume create nix
sudo btrfs subvolume create home
sudo btrfs subvolume create persist
sudo btrfs subvolume create nixos
```

Check
```
sudo btrfs subvolume list /tmp/root
```

### [Alt 2] Make system partition (`ext4`)
Create the base btrfs partition:
```
sudo mkfs.ext4 /dev/mapper/root -L NIX
```

Check again:
```
lsblk -o name,label,size,uuid
```

Expect: (sample)
```
NAME        LABEL                      SIZE UUID
nvme0n1                              931.5G 
├─nvme0n1p1 BOOT                         1G 199D-4E10
└─nvme0n1p2 NIX                      930.5G f0d4d235-569d-4930-8a7d-ee3e804d9fb1
```


## Mount drives
Mount root into tmpfs: (Yes! nix goes poof on reboot and recreates itself)
```
sudo mount -t tmpfs none /mnt
```
Make dirs:
```
mkdir -p /mnt/{boot,nix,home,persist}
```


Mount boot
```
sudo mount /dev/disk/by-label/BOOT /mnt/boot
```

## Mount rest (btrfs)
```
for p in nix home persist; do
  sudo mount /dev/disk/by-label/NIX -o compress-force=zstd,noatime,ssd,subvol=$p /mnt/$p;
done
```

(OR individually)
```
sudo mount /dev/disk/by-label/NIX -o compress-force=zstd,noatime,ssd,subvol=nix /mnt/nix;
sudo mount /dev/disk/by-label/NIX -o compress-force=zstd,noatime,ssd,subvol=home /mnt/home;
sudo mount /dev/disk/by-label/NIX -o compress-force=zstd,noatime,ssd,subvol=persist /mnt/persist;
```

Check:
```
mount | grep /mnt/
```
Expect:
```
/dev/nvme0n1p1 on /mnt/boot type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
/dev/mapper/root on /mnt/nix type btrfs (rw,noatime,compress-force=zstd:3,ssd,space_cache=v2,subvolid=256,subvol=/nix)
/dev/mapper/root on /mnt/home type btrfs (rw,noatime,compress-force=zstd:3,ssd,space_cache=v2,subvolid=257,subvol=/home)
/dev/mapper/root on /mnt/nix type btrfs (rw,noatime,compress-force=zstd:3,ssd,space_cache=v2,subvolid=256,subvol=/nix)
/dev/mapper/root on /mnt/home type btrfs (rw,noatime,compress-force=zstd:3,ssd,space_cache=v2,subvolid=257,subvol=/home)
/dev/mapper/root on /mnt/persist type btrfs (rw,noatime,compress-force=zstd:3,ssd,space_cache=v2,subvolid=258,subvol=/persist)
```

## Install

### Ready dotfiles

1. Clone/Download dotfiles (`.nix/`) to `/home` and `cd /home/.nix` (because simpler)
2. Update `flake.nix` to your settings.
3. Verify/Update `configuration.nix` for your users and hardware
  1. If you are not me, update `initialHashedPassword` with something that you know.  
     Generate it using: `mkpasswd -m sha-512`
  2. Note: This is only used initially. Select something that you will be okay committing to git.
4. Update `hardware-configuration.nix` for any hardware specific changes
  1. Use `nixos-generate-config` if unsure or need a reference.

### Really install

```
sudo nixos-install --flake .#  #or /home/.nix/#
```

## Reboot

```
sudo reboot
```
