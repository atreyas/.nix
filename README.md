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
```
(Note: `Are you sure? (Type 'yes' in capital letters): YES` needs to be in *CAPITAL LETTERS*)


### [Alt 1] Make root partition (`btrfs`)
Create and mount btrfs root partition
```
sudo mkfs.btrfs /dev/mapper/root -L NIXROOT
mkdir /tmp/root
sudo mount /dev/mapper/root -o compress-force=zstd,noatime,ssd /tmp/root
```

Check:
```
lsblk -o name,label,size,uuid
```
Expect:
```
nvme0n1                              931.5G 
├─nvme0n1p1 BOOT                         1G 199D-4E10
└─nvme0n1p2                          930.5G 4aec46fe-24a5-4a06-abca-514ea4e58c8c
  └─root    NIXROOT                  930.5G d8865779-5b1e-4bc8-8a3a-28ea75edda28
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



Mount boot
```
sudo mount /dev/disk/by-label/BOOT
```
