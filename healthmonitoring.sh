

CPU_THRESHOLD=80.0
MEM_THRESHOLD=80.0
DISK_THRESHOLD=80.0



LOG_FILE="$HOME/systemhealth.log"



send_alert() {

  metric=$1
  value=$2
  threshold=$3
  echo "ALERT: ${metric} is above threshold: ${value}% (Threshold: ${threshold}%)" | tee -a $LOG_FILE
}



monitor_system() {

  while true; do
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    proc_count=$(ps aux | wc -l)
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
      send_alert "CPU usage" "$cpu_usage" "$CPU_THRESHOLD"
    fi
    if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
      send_alert "Memory usage" "$mem_usage" "$MEM_THRESHOLD"
    fi

    if (( $(echo "$disk_usage > $DISK_THRESHOLD" | bc -l) )); then
      send_alert "Disk usage" "$disk_usage" "$DISK_THRESHOLD"
    fi

    echo "Number of running processes: $proc_count" | tee -a $LOG_FILE
    sleep 60

  done

}



monitor_system


