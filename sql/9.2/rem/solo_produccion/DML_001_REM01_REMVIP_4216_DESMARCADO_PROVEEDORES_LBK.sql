--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=201905110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4216
--## PRODUCTO=NO
--##
--## Finalidad: corrección de cambio de proveedor
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-4216';    
    S_PVE NUMBER(16) := 0;  
   
   
    
    
BEGIN	
	
	V_MSQL := 'MERGE INTO REM01.ACT_PVE_PROVEEDOR PVE
				USING REM_EXT.TMP_PVE_A_DESMARCAR TEM
				ON (PVE.PVE_DOCIDENTIF = TEM.NIF)
				WHEN MATCHED THEN UPDATE 
				SET  PVE.PVE_ENVIADO = NULL, PVE.USUARIOMODIFICAR = ''ITREM-7341'', PVE.FECHAMODIFICAR = SYSDATE';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
	
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
    COMMIT;

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
