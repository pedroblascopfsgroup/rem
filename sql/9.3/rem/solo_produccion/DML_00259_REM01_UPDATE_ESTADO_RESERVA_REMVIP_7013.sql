--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7013
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. Cambios DD_ERE_ID para firmadas
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

    DBMS_OUTPUT.PUT_LINE('[INFO] Merge res_reservas.dd_ere_id a Firmada.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.res_reservas VAL USING (
        select distinct res_num_reserva, res_fecha_firma from '||V_ESQUEMA||'.res_reservas res 
        where res_fecha_firma is not null 
        and dd_ere_id <> 2 
        and dd_ere_id = 1
        and usuariocrear = ''MIG_DIVARIAN'' order by 1 asc
    ) TMP
    ON (TMP.res_num_reserva = VAL.res_num_reserva)
    WHEN MATCHED THEN UPDATE SET
    VAL.dd_ere_id = 2,
    VAL.USUARIOMODIFICAR = ''REMVIP-7013'',
    VAL.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. (Deberian de ser 204)');


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
