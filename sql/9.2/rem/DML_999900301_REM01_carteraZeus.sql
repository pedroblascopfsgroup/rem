--/*
--##########################################
--## AUTOR=JESSICA SAMPERE
--## FECHA_CREACION=20180816
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=HREOS-4419
--## PRODUCTO=NO
--##
--## Finalidad: alta cartera REM
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET TIMING ON
SET LINESIZE 2000
SET VERIFY OFF
SET TIMING ON
SET FEEDBACK ON


DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_SQL VARCHAR2(4000 CHAR); -- Vble. con sentencia SQL a ejecutar

	V_SQL_RES NUMBER(16);  --Vble. para volcar datos a utilizar en otras consultas.	
	V_SQL_RES_ID NUMBER(16);  --Vble. para volcar datos a utilizar en otras consultas.	

BEGIN	

	
	V_SQL:= 'INSERT INTO #ESQUEMA#.DD_CRA_CARTERA 
		(DD_CRA_ID,DD_CRA_CODIGO,DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
		VALUES 
		(#ESQUEMA#.S_DD_CRA_CARTERA.NEXTVAL,''14'',''ZEUS'',''ZEUS REAL STATE INVESTMENT 1 SL.'',0,''HREOS-4419'',sysdate,0)';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.put_line('[OK]');
	


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
