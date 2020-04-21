--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200414
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-6962
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. Oferta fecha anulacion (OFR_FECHA_RECHAZO)
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge OFR_OFERTAS.OFR_FECHA_RECHAZO carga masiva.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS T1
                USING (
                    SELECT ECO.ECO_FECHA_ANULACION,  ECO.ECO_ID, OFR.OFR_ID, OFR.OFR_NUM_OFERTA, OFR.DD_EOF_ID, 
                    OFR.USUARIOMODIFICAR, to_date(AUX.OFR_FECHA_ANULACION,''YYYYMMDD'') OFR_FECHA_RECHAZO 
					FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
					INNER JOIN '||V_ESQUEMA||'.AUX_OFR_FECHA_ANULACION_REMVIP_6962 AUX
					ON to_number(substr(AUX.OFR_COD_OFERTA,10,length(AUX.OFR_COD_OFERTA))) = OFR.OFR_NUM_OFERTA
					left JOIN '||V_ESQUEMA||'.eco_expediente_comercial ECO
					ON ECO.OFR_ID = OFR.OFR_ID
					WHERE OFR.USUARIOCREAR = ''MIG_DIVARIAN'' 
                ) T2
                ON (T1.OFR_ID = T2.OFR_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.OFR_FECHA_RECHAZO = T2.OFR_FECHA_RECHAZO,
                    T1.USUARIOMODIFICAR = ''REMVIP-6962'',
                    T1.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. (Deberian de ser 4.996)');


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
