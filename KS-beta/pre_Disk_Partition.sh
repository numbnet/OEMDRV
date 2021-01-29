#!/bin/sh

##### pre_Disk_Partition.sh ####

outfile='/tmp/part-include'


CreatePartFile(){
        get_disktype=$1
        get_disknu=$2
        if [ $get_disknu -gt 1 ];then
                echo "#Disk partitioning information,datapool in ${get_disktype}b" >> $outfile
                echo "clearpart --all --initlabel" >> $outfile
                echo "part swap --fstype=\"swap\" --size=8192 --ondisk=${get_disktype}a">> $outfile
                echo "part / --fstype=\"ext4\" --grow --size=1 --ondisk=${get_disktype}a">> $outfile
                echo "part /boot --fstype="ext4" --size=100 --ondisk=${get_disktype}a">> $outfile
                echo "part /datapool --fstype="ext4" --grow --size=1  --ondisk=${get_disktype}b">> $outfile

        else
                echo "#Disk partitioning information,datapool in ${get_disktype}a" >> $outfile
                echo "clearpart --all --initlabel" >> $outfile
                echo "part swap --fstype=\"swap\" --size=8192  --ondisk=${get_disktype}a">> $outfile
                echo "part / --fstype=\"ext4\" --size=20480 --ondisk=${get_disktype}a">> $outfile
                echo "part /boot --fstype="ext4" --size=100 --ondisk=${get_disktype}a">> $outfile
                echo "part /datapool --fstype="ext4" --grow --size=1  --ondisk=${get_disktype}a">> $outfile
        fi
}

CheckDiskType(){
       disktype="default"
        disknu=0
        for t in "vd" "sd" "hd";do
                fdisk -l|grep -E "/dev/${t}[a-z]:" >>/dev/null
                if [ $? -eq 0 ];then
                        if [ `fdisk -l|grep -E "/dev/${t}[a-z]:"|wc -l` -gt 1 ];then
                                disknu=`fdisk -l|grep -E "/dev/${t}[a-z]:"|wc -l`
                        else
                                disknu=1
                        fi
                        disktype="$t"
                fi
        done
        CreatePartFile $disktype $disknu

}
CheckDiskType
