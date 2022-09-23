--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220831
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12346
--## PRODUCTO=NO
--##
--## Finalidad: Script actualiza codigo caixa provedores
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-12346'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

    V_COUNT_REG NUMBER(16):=0;
    V_COUNT_REG_TOTAL NUMBER(16):=0;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: INFORMAR PVE_COD_UVEM EN '||V_TEXT_TABLA);

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1
                USING (
                    SELECT PVE.PVE_ID,AUX.COD_UVEM FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
                    JOIN '||V_ESQUEMA||'.AUX_REMVIP_12346 AUX ON AUX.PROVEEDOR=PVE.PVE_DOCIDENTIF
                    WHERE (PVE.PVE_COD_UVEM!=AUX.COD_UVEM OR PVE.PVE_COD_REM IS NULL) AND PVE.BORRADO = 0 AND PVE_FECHA_BAJA IS NULL
                ) T2
                ON (T1.PVE_ID = T2.PVE_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.PVE_COD_UVEM = T2.COD_UVEM,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USU||'''	 		
                ';
        
    EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' Proveedores actualizados  ');

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