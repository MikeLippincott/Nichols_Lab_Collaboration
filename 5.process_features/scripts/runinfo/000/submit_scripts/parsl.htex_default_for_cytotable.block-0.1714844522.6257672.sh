
export JOBNAME=$parsl.htex_default_for_cytotable.block-0.1714844522.6257672
set -e
export CORES=$(getconf _NPROCESSORS_ONLN)
[[ "1" == "1" ]] && echo "Found cores : $CORES"
WORKERCOUNT=1
FAILONANY=0
PIDS=""

CMD() {
process_worker_pool.py   -a 172.17.0.1,10.13.161.59,10.53.188.1,140.226.13.16,127.0.0.1 -p 0 -c 1.0 -m None --poll 10 --task_port=54554 --result_port=54073 --cert_dir None --logdir=/home/lippincm/Documents/Nichols_Lab_Collaboration/5.process_features/scripts/runinfo/000/htex_default_for_cytotable --block_id=0 --hb_period=30  --hb_threshold=120 --cpu-affinity none --available-accelerators
}
for COUNT in $(seq 1 1 $WORKERCOUNT); do
    [[ "1" == "1" ]] && echo "Launching worker: $COUNT"
    CMD $COUNT &
    PIDS="$PIDS $!"
done

ALLFAILED=1
ANYFAILED=0
for PID in $PIDS ; do
    wait $PID
    if [ "$?" != "0" ]; then
        ANYFAILED=1
    else
        ALLFAILED=0
    fi
done

[[ "1" == "1" ]] && echo "All workers done"
if [ "$FAILONANY" == "1" ]; then
    exit $ANYFAILED
else
    exit $ALLFAILED
fi
