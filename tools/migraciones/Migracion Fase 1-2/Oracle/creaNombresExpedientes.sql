/* Formatted on 2009/04/22 09:01 (Formatter Plus v4.8.8) */
col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

spool crearNombresExpedientes&v_entorno&v_date&v_time..log;

update EXP_EXPEDIENTES A
set A.exp_descripcion =
(
    SELECT CASE
                 WHEN (COALESCE (per.per_apellido1, NULL) || ' ' || COALESCE (per.per_apellido2, '') || ', ') = ' , '
                    THEN ''
                 ELSE COALESCE (per.per_apellido1, NULL) || ' ' || COALESCE (per.per_apellido2, '') || ', '
              END
           || COALESCE (per.per_nombre, '')
      FROM cex_contratos_expediente cex,
           cpe_contratos_personas cpe,
           dd_tin_tipo_intervencion tin,
           per_personas per
     WHERE cpe.cnt_id = cex.cnt_id
       AND cpe.dd_tin_id = tin.dd_tin_id
       AND cex.cex_pase = 1
       AND cex.exp_id = A.exp_id
       AND cpe.cpe_orden = 1
       AND cpe.per_id = per.per_id
       AND tin.dd_tin_titular = 1
);

spool off;
