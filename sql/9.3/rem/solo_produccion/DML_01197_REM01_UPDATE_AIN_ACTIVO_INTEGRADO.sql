--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20230112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11694
--## PRODUCTO=NO
--##
--## Finalidad: Script ELIMINA COMUNIDAD PROPIETARIO
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-11694'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_CONDICION VARCHAR2(32000 CHAR) := 'ACT_NUM_ACTIVO NOT IN (7496492,7512624,7512629,7512658,7512661)';

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAR COMUNIDAD DE PROPIETARIOS DE ACTIVOS CON CODIGO 110250009 ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.AIN_ACTIVO_INTEGRADO T1 USING (
            
            SELECT DISTINCT AIN_ID FROM '||V_ESQUEMA||'.AIN_ACTIVO_INTEGRADO AIN
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AIN.ACT_ID AND ACT.BORRADO = 0 AND '||V_CONDICION||'
            WHERE AIN.BORRADO = 0 AND PVE_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 110250009)) T2
        ON (T1.AIN_ID = T2.AIN_ID)
        WHEN MATCHED THEN UPDATE SET
        T1.BORRADO = 1,
        T1.USUARIOBORRAR = '''||V_USU||''',
        T1.FECHABORRAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS EN '|| SQL%ROWCOUNT ||' REGISTROS');

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