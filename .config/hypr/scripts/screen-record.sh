PIDFILE="/tmp/wf-recorder.pid"
OUT="$HOME/Videos/recorder-$(date +%Y-%m-%d_%H-%M-%S).mp4"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    kill -INT "$(cat "$PIDFILE")"
    rm -f "$PIDFILE"
    notify-send "Screen Recorder" "Recording stopped"
else
    wf-recorder -f "$OUT" &
    echo $! > "$PIDFILE"
    notify-send "Screen Recorder" "Recording started\nSaved to ~/Videos"
fi