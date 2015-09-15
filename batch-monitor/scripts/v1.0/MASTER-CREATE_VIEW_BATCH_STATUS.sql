create or replace view V_STATUS_BATCH as
select execu.job_instance_id as ID, 
    case 
        when ins.JOB_NAME = 'pasajePCRProduccionJob' then 'cargaPCRPasajeProduccionJob'
        when ins.JOB_NAME like 'precalculo%' or ins.JOB_NAME like 'analize%' then ins.JOB_NAME
        when ins.JOB_NAME like '%PCR%' then 'cargaPCR'||ins.JOB_NAME
    else ins.JOB_NAME end NOMBRE_JOB
    , (SELECT STRING_VAL from BATCH_JOB_PARAMS params where KEY_NAME = 'entidad' and  params.JOB_INSTANCE_ID = execu.JOB_INSTANCE_ID) ENTIDAD
    , '+' || substr(coalesce(execu.END_TIME - execu.START_TIME, sysdate - execu.START_TIME), 13, 7) TIEMPO 
    , execu.START_TIME  COMIENZA 
    , execu.END_TIME FINALIZA 
    , (SELECT STRING_VAL from BATCH_JOB_PARAMS params where KEY_NAME = 'contratosRowCount' and  params.JOB_INSTANCE_ID = execu.JOB_INSTANCE_ID) N_CNT
    , (SELECT STRING_VAL from BATCH_JOB_PARAMS params where KEY_NAME = 'fileName' and  params.JOB_INSTANCE_ID = execu.JOB_INSTANCE_ID) SEMAFORO
    , execu.STATUS  ESTADO 
    , execu.EXIT_CODE CODIGO_SALIDA
    , execu.EXIT_MESSAGE MENSAJE_SALIDA
from BATCH_JOB_INSTANCE ins, BATCH_JOB_EXECUTION execu
where ins.JOB_INSTANCE_ID = execu.JOB_INSTANCE_ID 
    and execu.START_TIME > sysdate-30
order by execu.start_time desc
