--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-9419
--## PRODUCTO=NO
--## 
--## Finalidad: Posicionamiento de trabajos.
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge DD_OAN cargas masivas.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
                USING (
                    SELECT DISTINCT ACT.ACT_NUM_ACTIVO, AUX.COD_PROCEDENCIA_ANTERIOR, OAN.DD_OAN_ID
                    FROM REM01.ACT_ACTIVO ACT
                    INNER JOIN '||V_ESQUEMA||'.dd_oan_id_20200409 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
                    LEFT JOIN '||V_ESQUEMA||'.DD_OAN_ORIGEN_ANTERIOR OAN ON OAN.DD_OAN_CODIGO = AUX.COD_PROCEDENCIA_ANTERIOR
                ) T2
                ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
                WHEN MATCHED THEN UPDATE SET
                    T1.DD_OAN_ID = T2.DD_OAN_ID,
                    T1.USUARIOMODIFICAR = ''MIG_DIVARIAN_DD_OAN_ID'',
                    T1.FECHAMODIFICAR = SYSDATE
                    where T2.DD_OAN_ID is not null
    ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Mergeado.');

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
