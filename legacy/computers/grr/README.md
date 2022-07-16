ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@grr

mirror-0

* ata-ADATA_SP550_2G0420003186-part3
* ata-ADATA_SP550_2G0420001801-part3

mirror-1

* ata-ADATA_SP550_2G0420002543-part3
* ata-ADATA_SP550_2G0420001635-part3

mirror-2

* ata-ADATA_SP550_2G3220055024-part3
* ata-ADATA_SP550_2G3220055124-part3

zpool add -o ashift=12 rpool mirror /dev/disk/by-id/ata-ADATA_SP550_2G3220055024-part3 /dev/disk/by-id/ata-ADATA_SP550_2G3220055124-part3

zpool create -o ashift=13 rpool mirror /dev/disk/by-id/ata-ADATA_SP550_2G0420003186-part3 /dev/disk/by-id/ata-ADATA_SP550_2G3220055024-part3 \
                   mirror /dev/disk/by-id/ata-ADATA_SP550_2G0420001801-part3 /dev/disk/by-id/ata-ADATA_SP550_2G0420002543-part3 \
                   mirror /dev/disk/by-id/ata-ADATA_SP550_2G0420001635-part3 /dev/disk/by-id/ata-ADATA_SP550_2G3220055124-part3

cat /mnt/storage/backup/grr/grr\@2017-05-21.gz | ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@grr 'gunzip | zfs recv -Fvu rpool'
