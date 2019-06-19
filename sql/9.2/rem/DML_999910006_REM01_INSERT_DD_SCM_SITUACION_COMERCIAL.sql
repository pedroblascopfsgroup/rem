--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20190225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5600
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-5600'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERCION DD_SCM_SITUACION_COMERCIAL');
	
	V_SQL := 'SELECT COUNT(1)
			   FROM DD_SCM_SITUACION_COMERCIAL
			   WHERE DD_SCM_CODIGO = ''13''
			   AND DD_SCM_DESCRIPCION = ''Alquilado parcialmente''';
			   
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL 
				  (DD_SCM_ID, 
				  DD_SCM_CODIGO, 
				  DD_SCM_DESCRIPCION, 
				  DD_SCM_DESCRIPCION_LARGA,
				  VERSION, 
				  USUARIOCREAR, 
				  FECHACREAR,
				  BORRADO)
				  SELECT 
						'||V_ESQUEMA||'.S_DD_SCM_SITUACION_COMERCIAL.NEXTVAL,
						''13'',
						''Alquilado parcialmente'',
						''Alquilado parcialmente'',
						0,
						'''||V_USR||''' ,
						SYSDATE,
						0
				  FROM DUAL';
		
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[FIN] INSERTADO DD_SCM_SITUACION_COMERCIAL');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[FIN] EL REGISTRO A INSERTAR YA EXISTE');
		
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
