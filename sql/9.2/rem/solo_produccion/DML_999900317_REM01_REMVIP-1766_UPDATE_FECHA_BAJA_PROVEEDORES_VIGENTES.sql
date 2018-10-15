--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180911
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1766
--## PRODUCTO=NO
--##
--## Finalidad: Ponemos la fecha de baja a null a los proveedores que estén vigentes y tengan la fecha de baja en: (08/09/2018) o (30/08/2018)
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_PVE_PROVEEDOR';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1766';    
    
BEGIN	
	

	    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' PVE2
	              SET 
						PVE2.PVE_FECHA_BAJA = NULL,
						PVE2.USUARIOMODIFICAR = '''||V_USUARIO||''',
						PVE2.FECHAMODIFICAR = SYSDATE
				  WHERE 
				  EXISTS (
							SELECT 1    
							FROM REM01.ACT_PVE_PROVEEDOR       PVE
							JOIN REM01.DD_EPR_ESTADO_PROVEEDOR EPR
							  ON PVE.DD_EPR_ID = EPR.DD_EPR_ID
							JOIN REM01.DD_TPR_TIPO_PROVEEDOR   TPR
							  ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
							WHERE TRUNC(PVE_FECHA_BAJA) IN ( TRUNC(TO_DATE(''30/08/2018'',''dd/mm/yy'')) , TRUNC(TO_DATE(''08/09/2018'',''dd/mm/yy'')) )
							  AND EPR.DD_EPR_CODIGO = ''04'' AND PVE.PVE_ID = PVE2.PVE_ID
				  )
	    ';
        EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA);   
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
