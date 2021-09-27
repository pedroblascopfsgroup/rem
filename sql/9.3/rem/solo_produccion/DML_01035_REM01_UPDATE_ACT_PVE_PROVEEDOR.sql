--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10399
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10399'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_COUNT NUMBER(16);

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    --Actualizamos el dato
    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR SET  
    PVE_NOMBRE = 
        CASE WHEN LENGTH(PVE_COD_API_PROVEEDOR) = 1 THEN ''Oficina Cajamar 000'' || PVE_COD_API_PROVEEDOR
                WHEN LENGTH(PVE_COD_API_PROVEEDOR) = 2 THEN ''Oficina Cajamar 00'' || PVE_COD_API_PROVEEDOR
                WHEN LENGTH(PVE_COD_API_PROVEEDOR) = 3 THEN ''Oficina Cajamar 0'' || PVE_COD_API_PROVEEDOR
                ELSE ''Oficina Cajamar '' || PVE_COD_API_PROVEEDOR END,
    USUARIOMODIFICAR = '''||V_USUARIO||''',
    FECHAMODIFICAR = SYSDATE             
    WHERE DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''29'')';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ACT_PVE_PROVEEDOR'); 	

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