--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5093
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
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5093'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERCION TABLA PEF_PERFILES');
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAPROMOMAN''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES 
					(PEF_ID, 
					PEF_CODIGO, 
					PEF_DESCRIPCION, 
					PEF_DESCRIPCION_LARGA,
					VERSION, 
					USUARIOCREAR, 
					FECHACREAR,
					BORRADO 
					)VALUES(
					'||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL,
					''HAYAPROMOMAN'',
					''Promontoria Manzana'',
					''Promontoria Manzana'',
					0,
					''REMVIP-5093'',
					SYSDATE,
					0
					)';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO INSERTADO');
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO YA EXISTE');
		
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
