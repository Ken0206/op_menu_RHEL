#SCRIPT_VERSION=1.0.2

if ! [ -f /etc/redhat-release ]; then
    echo ""
    echo "This script is for Red Hat/CentOS Linux!"
    echo ""
    exit
fi

touch mw_hc2.err
touch mw_hc2.log
chmod 640 mw_hc2.err
chmod 640 mw_hc2.log
chmod 740 mw_hc2.sh
chmod 740 r1_check_unsuccessful_login_count.sh
chmod 740 r2_show_machine_serial.sh
chmod 740 r3_execute_sosreport.sh
chmod 740 r4_check_FS_size.sh
chmod 740 r5_show_cpu_usage.sh
chmod 740 r6_show_mem_usage.sh
chmod 740 rotatelogs.sh
chmod 740 writelog.sh

chown root:system mw_hc2.err
chown root:system mw_hc2.log
chown root:system mw_hc2.sh
chown root:system r1_check_unsuccessful_login_count.sh
chown root:system r2_show_machine_serial.sh
chown root:system r3_execute_sosreport.sh
chown root:system r4_check_FS_size.sh
chown root:system r5_show_cpu_usage.sh
chown root:system r6_show_mem_usage.sh
chown root:system rotatelogs.sh
chown root:system writelog.sh
