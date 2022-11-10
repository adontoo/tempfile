#!/system/bin/sh

DISPLAY_ID=`/system/bin/getprop ro.vivo.os.build.display.id`
/system/bin/toybox echo "DISPLAY_ID=${DISPLAY_ID}"

if [ -d /data/vivo-apps/com.vivo.healthcode ] && [ -f "/data/vivo-apps-os/HealthCode.apk" ];then
  if [ "${DISPLAY_ID}" == "OriginOS Ocean" ] || [ "${DISPLAY_ID}" == "OriginOS 2.0" ];then
    /system/bin/toybox mv /data/vivo-apps-os/HealthCode.apk /data/vivo-apps/com.vivo.healthcode/HealthCode.apk
    /system/bin/toybox chcon -vRh u:object_r:apk_data_file:s0 /data/vivo-apps/com.vivo.healthcode
    /system/bin/toybox chown -R system:system /data/vivo-apps/com.vivo.healthcode
    /system/bin/toybox chmod 771 /data/vivo-apps/com.vivo.healthcode
    /system/bin/toybox chmod 644 /data/vivo-apps/com.vivo.healthcode/HealthCode.apk
    apps_oem_list=`/system/bin/toybox ls /data/vivo-apps | /system/bin/toybox grep .list | /system/bin/toybox tr "\n" " "`
    for apps_list in ${apps_oem_list}
    do
        /system/bin/toybox echo "Operate on ${apps_list}"
        crc_exists=`/system/bin/toybox grep com.vivo.healthcode /data/vivo-apps/${apps_list}`
        /system/bin/toybox echo "crc_exists=${crc_exists}"
        if [ "${crc_exists}" != "" ];then
            /system/bin/toybox grep -v com.vivo.healthcode /data/vivo-apps/${apps_list} 1> /data/vivo-apps/${apps_list}.tmp
            /system/bin/toybox echo "com.vivo.healthcode/HealthCode.apk  E2654117" 1>> /data/vivo-apps/${apps_list}.tmp
            /system/bin/toybox mv /data/vivo-apps/${apps_list}.tmp /data/vivo-apps/${apps_list}
        fi
    done
  fi
fi

