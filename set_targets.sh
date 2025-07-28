set_target() {
  local target="$HOME/work/target_scope_manager/_conf/target.conf"
  local ip=""
  local host=""
  local show_status=0
  local show_help=0
  local reset=0
  local updated_ip=0
  local updated_host=0

  while [ $# -gt 0 ]; do
    case "$1" in
      -I)
        shift
        ip="$1"
        updated_ip=1
        ;;
      -V)
        shift
        host="$1"
        updated_host=1
        ;;
      -s)
        show_status=1
        ;;
      -h|--help)
        show_help=1
        ;;
      -r)
        reset=1
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
    shift
  done

  # -r: 設定値のリセット
  if [ $reset -eq 1 ]; then
    echo "IP: " > "$target"
    echo "HOST: " >> "$target"
    export TARGET_IP=""
    export TARGET_HOST=""
    echo "Target configuration reset."
    return 0
  fi

  # -s: 現在値の表示のみ
  if [ $show_status -eq 1 ]; then
    [ -f "$target" ] && grep -E '^(IP|HOST):' "$target"
    return 0
  fi

  # -h または引数省略時: ヘルプ表示
  if [ $show_help -eq 1 ] || ( [ -z "$ip" ] && [ -z "$host" ] ); then
    echo "Usage: tsm -I <IP> -V <HOST>"
    echo "  -I    Set target IP address"
    echo "  -V    Set target host name"
    echo "  -r    Reset target configuration"
    echo "  -s    Show current values only"
    echo "  -h    Show this help"
    echo "Current values:"
    [ -f "$target" ] && grep -E '^(IP|HOST):' "$target"
    return 0
  fi

  # 現在値の読込
  if [ -f "$target" ]; then
    [ -z "$ip" ] && ip=$(grep '^IP:' "$target" | awk '{print $2}')
    [ -z "$host" ] && host=$(grep '^HOST:' "$target" | awk '{print $2}')
  fi

  # ファイル更新
  echo "IP: $ip" > "$target"
  echo "HOST: $host" >> "$target"

  export TARGET_IP="$ip"
  export TARGET_HOST="$host"

  # 出力制御
  if [ $updated_ip -eq 1 ]; then
    echo "IP set to $TARGET_IP"
  fi
  if [ $updated_host -eq 1 ]; then
    echo "HOST set to $TARGET_HOST"
  fi
}
