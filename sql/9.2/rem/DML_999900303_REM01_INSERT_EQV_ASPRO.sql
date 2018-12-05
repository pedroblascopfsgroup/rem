--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4494
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4494'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERCION DD_EQV_ASPRO_REM');
	
	V_SQL := 'SELECT COUNT(1)
			   FROM DD_EQV_ASPRO_REM
			   WHERE DD_CODIGO_ASPRO = ''0100008''';
			   
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_EQV_ASPRO_REM 
				  (DD_NOMBRE_ASPRO, 
				  DD_CODIGO_ASPRO, 
				  DD_DESCRIPCION_ASPRO, 
				  DD_DESCRIPCION_LARGA_ASPRO,
				  DD_NOMBRE_REM,
				  DD_CODIGO_REM,
				  DD_DESCRIPCION_REM,
				  DD_DESCRIPCION_LARGA_REM,
				  VERSION, 
				  USUARIOCREAR, 
				  FECHACREAR,
				  BORRADO)
				  SELECT 
						''DD_CARTERA_ASPRO'',
						''0100008'',
						''ZEUS'',
						''ZEUS'',
						''DD_CRA_CARTERA'',
						''14'',
						''ZEUS'',
						''ZEUS REAL STATE INVESTMENT 1 SL.'',
						0,
						'''||V_USR||''' ,
						SYSDATE,
						0
				  FROM DUAL';
		
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[FIN] INSERTADO DD_EQV_ASPRO_REM');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[FIN] El registro ya existe');
		
	END IF;
	
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
