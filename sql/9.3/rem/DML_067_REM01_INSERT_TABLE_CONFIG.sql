--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20191113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5535
--## PRODUCTO=NO
--##
--## Finalidad: Insert tabla CONFIG
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_TICKET VARCHAR2(100 CHAR) := 'REMVIP-5535';

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		T_FUNCION('proveedor.paci','paci03')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a insertar datos en la tabla');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    	LOOP
            V_TMP_FUNCION := V_FUNCION(I);
                     
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CONFIG WHERE ID = '''||TRIM(V_TMP_FUNCION(1))||''' AND VALOR = '''||TRIM(V_TMP_FUNCION(2))||''' ';
			
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION PARA EL PERFIL
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro '''|| TRIM(V_TMP_FUNCION(1))||'''');
			ELSE
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CONFIG (ID,VALOR) VALUES ('''||TRIM(V_TMP_FUNCION(1))||''','''||TRIM(V_TMP_FUNCION(2))||''')';
		
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.CONFIG insertados correctamente.');		

    	END LOOP; 			
      		
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