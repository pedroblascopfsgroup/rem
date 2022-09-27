--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12492
--## PRODUCTO=NO
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12492'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.AUX_GEE_BORRADOS_NO_TGE (GEE_ID) 
                        SELECT GEE_ID FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD WHERE DD_TGE_ID IS NULL AND BORRADO = 1';	

    DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' REGISTROS INSERTADOS ');
                
    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO WHERE GEE_ID IN (
                        SELECT GEE_ID FROM '||V_ESQUEMA||'AUX_GEE_BORRADOS_NO_TGE)';	

    DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' REGISTROS BORRADO GAC ');
                
    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD WHERE GEE_ID IN (
                        SELECT GEE_ID FROM '||V_ESQUEMA||'AUX_GEE_BORRADOS_NO_TGE)';	

    DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' REGISTROS BORRADO GEE ');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT