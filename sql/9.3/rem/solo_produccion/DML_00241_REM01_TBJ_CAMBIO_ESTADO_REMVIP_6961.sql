--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200414
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-6961
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. Cambios estado trabajos
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge act_tbj_trabajo.dd_est_id carga masiva.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.act_tbj_trabajo T1
                USING (
                    SELECT distinct tbj.tbj_num_trabajo, est.dd_est_id
					FROM '||V_ESQUEMA||'.AUX_TBJ_CAMBIO_ESTADO_REMVIP_6961 aux
					inner join '||V_ESQUEMA||'.act_tbj_trabajo tbj on tbj.tbj_num_trabajo = aux.tbj_num_trabajo
					inner join '||V_ESQUEMA||'.dd_est_estado_trabajo est
					on est.dd_est_descripcion = aux.estado
                ) T2
                ON (T1.tbj_num_trabajo = T2.tbj_num_trabajo)
                WHEN MATCHED THEN UPDATE SET
                    T1.dd_est_id = T2.dd_est_id,
                    T1.USUARIOMODIFICAR = ''REMVIP-6961'',
                    T1.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. (Deberian de ser 17)');


    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
