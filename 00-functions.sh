AconfNeedProgram augtool augeas n
aug() { augtool --root="$output_dir/files" "$@" > /dev/null; }
EnableUnit(){
    WantedBy=$1
    Unit=$2
    System=${3:-"system"}
    CreateLink /etc/systemd/${System}/${WantedBy}.wants/${Unit} /usr/lib/systemd/${System}/${Unit}
}
AliasUnit(){
    Alias=$1
    Source=$2
    System=${3:-"system"}
    CreateLink /etc/systemd/${System}/${Alias} /usr/lib/systemd/${System}/${Source}
}