--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-6994
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. Cambios Origen Anterior
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge ACT_ACTIVO.DD_OAN_ID carga masiva.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
                USING (
                    SELECT distinct ACT.ACT_ID, OAN.DD_OAN_ID
					FROM '||V_ESQUEMA||'.AUX_DD_OAN_REMVIP_6994 aux
					inner join '||V_ESQUEMA||'.ACT_ACTIVO ACT on ACT.ACT_NUM_ACTIVO = aux.ACT_NUMERO_ACTIVO
					inner join '||V_ESQUEMA||'.DD_OAN_ORIGEN_ANTERIOR OAN on OAN.dd_OAN_CODIGO = aux.PROCEDENCIA_ANTERIOR
                ) T2
                ON (T1.ACT_ID = T2.ACT_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.DD_OAN_ID = T2.DD_OAN_ID,
                    T1.USUARIOMODIFICAR = ''REMVIP-6994'',
                    T1.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. (Deberian de ser 1.230)');


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
