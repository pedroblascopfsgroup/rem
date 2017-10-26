--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20171023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3018
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES: Relanzable
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_MAX_ID NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    		-- CODIGO,	DESCRIPCION,	DESCRIPCION_LARGA
	  T_FUNCION('01', 'Acepta', 'Acepta'),
	  T_FUNCION('02', 'Rechaza', 'Rechaza'),
	  T_FUNCION('03', 'Contraoferta', 'Contraoferta')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	

	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
      
		V_TMP_FUNCION := V_FUNCION(I);
		
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ROF_RESPUESTA_OFERTANTE WHERE DD_ROF_CODIGO = '''||V_TMP_FUNCION(1)||'''
	    '
	    ;
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN	

			
			DBMS_OUTPUT.PUT_LINE('[INFO] Uno de los campos o ambos ya existen en la tabla '||V_ESQUEMA||'.DD_ROF_RESPUESTA_OFERTANTE. Se modifican sus campos.');
			V_MSQL := '
			  UPDATE '||V_ESQUEMA||'.DD_ROF_RESPUESTA_OFERTANTE ROF
			  SET 
				DD_ROF_DESCRIPCION = '''||V_TMP_FUNCION(2)||''',
				DD_ROF_DESCRIPCION_LARGA = '''||V_TMP_FUNCION(3)||''',
				VERSION = 1,
				USUARIOMODIFICAR = ''HREOS-3018'',
				FECHAMODIFICAR = SYSDATE
			  WHERE ROF.ROF_CODIGO = '''||V_TMP_FUNCION(1)||'''
			  '
			  ;
			EXECUTE IMMEDIATE V_MSQL;
		ELSE
		
			V_MSQL := '
			  INSERT INTO '||V_ESQUEMA||'.DD_ROF_RESPUESTA_OFERTANTE (DD_ROF_ID, DD_ROF_CODIGO, DD_ROF_DESCRIPCION, DD_ROF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
			  SELECT '||V_ESQUEMA||'.S_DD_ROF_RESPUESTA_OFERTANTE.NEXTVAL AS DD_ROF_ID,
			  '''||V_TMP_FUNCION(1)||''' AS DD_ROF_CODIGO,
			  '''||V_TMP_FUNCION(2)||''' AS DD_ROF_DESCRIPCION,
			  '''||V_TMP_FUNCION(3)||''' AS DD_ROF_DESCRIPCION_LARGA,
			  0 AS VERSION,
			  ''HREOS-3018'' AS USUARIOCREAR,
			  SYSDATE AS FECHACREAR,
			  0 AS BORRADO
			  FROM DUAL
			  '
			  ;
			EXECUTE IMMEDIATE V_MSQL;
			
			COMMIT;
			
			DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '||V_ESQUEMA||'.DD_ROF_RESPUESTA_OFERTANTE a finalizado correctamente');
		
		END IF;
	END LOOP;
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
