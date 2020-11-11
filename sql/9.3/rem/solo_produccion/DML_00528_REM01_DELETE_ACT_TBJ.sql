--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8351
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva de aprobación del informe comercial
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-8351'; -- USUARIOCREAR/USUARIOMODIFICAR.
	V_TBJ_ID NUMBER(16):= 745345;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INFO] BUSCAMOS TRABAJO BORRADO');

	V_MSQL := 'SELECT COUNT(*) FROM '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO WHERE TBJ_ID = '||V_TBJ_ID||' AND BORRADO = 1' ;	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN

		V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_TBJ WHERE TBJ_ID = '||V_TBJ_ID||'' ;	
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] RELACION ACTIVO/TRABAJO BORRADO POR CONFLICTO: TRABAJO BORRADO');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] TRABAJO ESTA VIVO O NO EXISTE');

	END IF;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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