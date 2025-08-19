#!/bin/bash
FLATPAK_EXPORTS="/var/lib/flatpak/exports"
#TARGET_DIR="${HOME}/bin"


usage() {
    cat >&2 <<-EOF
   usage: $0 [target_dir]

   Utility to create a shortname symlink for every flatpak app in exports/bin
   into a local directory you can add to your PATH.   The shortname is just the last part
   of the reverse DNS entry for a program downcased.  For example the flatpak installation
   for Chrome is "com.google.Chrome".   The symlink will therefore be named "chrome"

          target_dir -- where to create the symlinks back to the flatpak exports dir

EOF
}


if [ $# != 1 ]; then
    usage
    exit -1
fi

TARGET_DIR=${1}
if [ ! -d ${TARGET_DIR} ]; then
    echo "Target directory \"${TARGET_DIR}\" does not exist." >& 2
    exit -1
fi
    
#
# From https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash
#
function mfcb { local val="$4"; "$1"; eval "$2[$3]=\$val;"; };
function val_ltrim { if [[ "$val" =~ ^[[:space:]]+ ]]; then val="${val:${#BASH_REMATCH[0]}}"; fi; };
function val_rtrim { if [[ "$val" =~ [[:space:]]+$ ]]; then val="${val:0:${#val}-${#BASH_REMATCH[0]}}"; fi; };
function val_trim { val_ltrim; val_rtrim; };
# string="apple,berry,cherry,date"
# readarray -c1 -C 'mfcb val_trim a' -td, <<<"$string,"; unset 'a[-1]'; declare -p a;

split_string() {
    local str=$1  # the string to split
    local delimiter=$2 # delimiter (one character only, not checked)
    declare -n result_array=$3 # reference to array from caller (declare -a myarray)
    # Split using IFS and readarray (Bash 4+)
    # Old way: IFS="$delimiter" read -r -a result_array <<<$str
    readarray -c1 -C 'mfcb val_trim a' -td"$delimiter" result_array <<<"$str"    
}

for flatpakApp in $(ls "${FLATPAK_EXPORTS}/bin"); do
    # echo "flatpakApp is " $flatpakApp
    declare -a app_elems
    split_string "$flatpakApp" "." app_elems
    # echo 'app_elems[-1] is ' ${app_elems[-1]}
    short_name=$(echo -n ${app_elems[-1]} | tr '[:upper:]' '[:lower:]')
    symlink_src=${FLATPAK_EXPORTS}/bin/${flatpakApp}
    symlink_dst=${TARGET_DIR}/${short_name}
    
    if [ ! -f ${symlink_dst} ]; then	
	ln -s ${FLATPAK_EXPORTS}/bin/${flatpakApp} ${TARGET_DIR}/${short_name}
    fi
done



