--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8857
--## PRODUCTO=SI
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8857'; --Usuario modificar
    V_TABLA VARCHAR2(100 CHAR):='ACT_EDI_EDIFICIO';
    V_TABLA_AUX VARCHAR2(100 CHAR):='AUX_REMVIP_8857';

BEGIN
	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  

	    	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                    USING ( 
                        SELECT EDI.EDI_ID,AUX.EDI_DESCRIPCION FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO=AUX.ACT_NUM_ACTIVO
                            JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID=ACT.ACT_ID
                            JOIN '||V_ESQUEMA||'.'||V_TABLA||' EDI ON EDI.ICO_ID=ICO.ICO_ID
                            WHERE EDI.BORRADO=0 AND ICO.BORRADO=0 AND ACT.BORRADO=0
                        ) T2
                    ON (T1.EDI_ID = T2.EDI_ID)
                    WHEN MATCHED THEN
                        UPDATE SET 
                            T1.EDI_DESCRIPCION = REPLACE(T2.EDI_DESCRIPCION, ''#'', CHR(10)),
                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                            FECHAMODIFICAR = SYSDATE
			 ';
		
	EXECUTE IMMEDIATE V_MSQL;  

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||SQL%ROWCOUNT||' registros');
   
	COMMIT;

EXCEPTION
     WHEN OTHERS THEN
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
