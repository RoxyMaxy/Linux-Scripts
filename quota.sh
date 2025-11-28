#!/bin/bash

FILESYS="/data"
GRACE="7 days"
INODES=5000
SOFT="6G"
HARD="7G"

mounting()
{
mount -o remount,usrquota,grpquota $FILESYS
quotacheck -cugm $FILESYS
quotaon -ug $FILESYS
}

grace_period()
{
printf "grace period: $GRACE block, $GRACE inode\n" | edquota -u root
}

data_quota()
{
setquota -u root 0 0 $INODES $INODES $FILESYS
}

user_quota()
{
for u in $(awk -F: '$3>=1000{print $1}' /etc/passwd); do
    setquota -u "$u" $SOFT $HARD 0 0 $FILESYS
done
}

group_quota()
{
for g in $(awk -F: '$3>=1000{print $1}' /etc/group); do
    setquota -g "$g" $SOFT $HARD 0 0 $FILESYS
done
}

mailing()
{
repquota -aug $FS | grep expired | while read user reste; do
    echo "Quota dépassé" | \
         mail -s "Quota $FILESYS dépassé par" "$user" root
done
}

update_every_week()
{
(crontab -l | grep -v "$0" ; echo "0 0 * * 4 $0") | crontab -

#Jeudis à 00h00, grâce = $GRACE
}

main()
{
mounting
grace_period
data_quota
user_quota
group_quota
mailing
update_every_week
}

#Exécution
main