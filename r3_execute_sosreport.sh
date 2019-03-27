#!/bin/bash
#
#
###############################################################################
# execute_sosreport.sh 
# Use sosreport --batch to gather system configuration information.
###############################################################################
# Globals variable :
#   OUTPUT_DIR              # Identifies the optional sosreport command
#                           # specify in mw_hc2.sh
###############################################################################
# date : 2019-01-21

comfirm_and_show_warning() {
    echo ''
    echo ''
    echo 'sosreport will take a few minutes to produce the log files.'
    echo ''
    echo 'Do you want Use sosreport to gather system configuration information?(Y/N)'
    read input
    if [[ "${input}" =~ [Yy]+ ]]; then
        return 0
    else
        exit 1
    fi
}


execute_sosreport() {
    if [ "${OUTPUT_DIR}" == "" ]; then
        echo "OUTPUT_DIR variable must be set."
        return 1
    fi

    echo ''
    writelog "Start sosreport."
    sos_file=$(sosreport --batch 2>/dev/null | grep "\/tmp\/sosreport" | sed -r "s/\  //")
    rc=$?
    chmod -R 775 ${OUTPUT_DIR}
    if [[ $rc -eq 0 ]]; then
        mv ${sos_file} ${OUTPUT_DIR}
	mv ${sos_file}.md5 ${OUTPUT_DIR}
	sos_basename=$(basename ${sos_file})
	chmod 744 ${OUTPUT_DIR}/${sos_basename}
	chmod 744 ${OUTPUT_DIR}/${sos_basename}.md5
        echo ''
        writelog "sosreport done at ${OUTPUT_DIR}/${sos_basename}"
        echo ''
        echo ''
    else
        err "sosreport failed."
        echo 'sosreport failed.'
    fi
}


sosreport_rotate() {
    all_files=a.${RANDOM}.temp
    keep_files=k.${RANDOM}.temp
    delete_files=d.${RANDOM}.temp
    #find /source/sosreport/ -name sosreport-* -type f | sort > ${all_files}
    ls -tr /source/sosreport/sosreport-* > ${all_files}
    declare -i all_files_no=$(cat ${all_files} | wc -l)
    if [ ${all_files_no} -gt 4 ] ; then
        tail -4 ${all_files} > ${keep_files}
        diff ${all_files} ${keep_files} | grep "^<" | awk '{print $2}' > ${delete_files}
        for del in $(cat ${delete_files}) ; do
            rm -f ${del}
        done
    fi
    rm -f ${all_files} ${keep_files} ${delete_files}
}


main() {
    comfirm_and_show_warning
    execute_sosreport || return $to_adv_opmenu
    sosreport_rotate
    #$ROOT_DIR/scp_to_file_server.sh ${OUTPUT_DIR}/${sos_basename}
}

main

