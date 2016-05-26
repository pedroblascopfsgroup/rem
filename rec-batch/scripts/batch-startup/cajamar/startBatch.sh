#!/bin/bash
export NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1

export JAVA_HOME=/opt/java/jre
export PATH=$JAVA_HOME/bin:$PATH

export BATCH_INSTALL_DIR=/recovery/batch-server/programas/batch
export BATCH_USER=recbatch
export PATH

export DEVON_HOME=recovery/batch-server
export LANG=es_ES.UTF-8
export ORACLE_HOME=/ora11g/instantclient
export PATH=$PATH:$ORACLE_HOME/bin

BATCH_LOG=/recovery/batch-server/log

cd $(dirname $0)

if [ -z $BATCH_INSTALL_DIR ]; then
        echo "ERROR: No conozco donde esta el batch"
        exit 2
fi

PID="$(ps aux | grep appname=batch  | grep -v grep | head -n 1 | awk '{print $2}')"

if [ "x$PID" != "x" ]; then
        echo "PFS-BATCH [Arrancado]"
        exit 0
fi

if [ -x $BATCH_INSTALL_DIR/run.sh ]; then
        BATCH_ON=false
        cd $BATCH_INSTALL_DIR
        if [ -f $BATCH_LOG/nohup.out ]; then
            rm $BATCH_LOG/nohup.out
        fi
        nohup ./run.sh >$BATCH_LOG/nohup.out 2>&1 &
        echo -n "PFS-BATCH | "
        while [ $BATCH_ON = false ]; do
                status=$(cat $BATCH_LOG/nohup.out | grep 'JobExecutor started!')
                if [ "x$status" != "x" ]; then
                        BATCH_ON=true
                else
                        echo -n "."
                fi
                sleep 2
        done

        echo " | Batch arrancado"


else
        echo "ERROR: El batch no es ejecutable"
        exit 3
fi
