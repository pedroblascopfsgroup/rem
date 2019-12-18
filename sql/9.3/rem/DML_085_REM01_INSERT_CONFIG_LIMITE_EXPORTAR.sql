--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5930
--## PRODUCTO=NO
--##
--## Finalidad: Inserta en CONFIG limites para exportaciones
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --			ID													VALOR
      T_FUNCION( 'super.limite.exportar.excel.activos', 			'1000'  ),  
	  T_FUNCION( 'super.limite.maximo.exportar.excel.activos', 		'40000'  ),
	  T_FUNCION( 'limite.exportar.excel.activos', 					'1000'  ),
	  T_FUNCION( 'limite.maximo.exportar.excel.activos', 			'5000'  ),
	  
	  T_FUNCION( 'super.limite.exportar.excel.publicaciones', 		'1000'  ),
	  T_FUNCION( 'super.limite.maximo.exportar.excel.publicaciones','40000'  ),
	  T_FUNCION( 'limite.exportar.excel.publicaciones',				'1000'  ),
	  T_FUNCION( 'limite.maximo.exportar.excel.publicaciones',		'5000'  ),
	  
	  T_FUNCION( 'super.limite.exportar.excel.tareas', 				'1000'  ),  
	  T_FUNCION( 'super.limite.maximo.exportar.excel.tareas', 		'40000'  ),
	  T_FUNCION( 'limite.exportar.excel.tareas', 					'1000'  ),
	  T_FUNCION( 'limite.maximo.exportar.excel.tareas', 			'5000'  ),
	  
	  T_FUNCION( 'super.limite.exportar.excel.gastos', 				'1000'  ),
	  T_FUNCION( 'super.limite.maximo.exportar.excel.gastos',		'40000'  ),
	  T_FUNCION( 'limite.exportar.excel.gastos',					'1000'  ),
	  T_FUNCION( 'limite.maximo.exportar.excel.gastos',				'5000'  ),
	  
	  T_FUNCION( 'super.limite.exportar.excel.ofertas', 			'1000'  ),  
	  T_FUNCION( 'super.limite.maximo.exportar.excel.ofertas', 		'40000'  ),
	  T_FUNCION( 'limite.exportar.excel.ofertas', 					'1000'  ),
	  T_FUNCION( 'limite.maximo.exportar.excel.ofertas', 			'5000'  ),
	  
	  T_FUNCION( 'super.limite.exportar.excel.trabajos', 			'1000'  ),
	  T_FUNCION( 'super.limite.maximo.exportar.excel.trabajos',		'40000'  ),
	  T_FUNCION( 'limite.exportar.excel.trabajos',					'1000'  ),
	  T_FUNCION( 'limite.maximo.exportar.excel.trabajos',			'5000'  )
    );
    V_TMP_FUNCION T_FUNCION;

BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERCION EN '||V_ESQUEMA||'.CONFIG ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
      		V_TMP_FUNCION := V_FUNCION(I);
      
  			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CONFIG WHERE ID = '''||V_TMP_FUNCION(1)||'''';
  			
  			EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
  			
  			IF V_NUM_REGISTRO > 0 THEN
  				DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE!');
  			
  			ELSE
	
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CONFIG (ID, VALOR) VALUES ('''||V_TMP_FUNCION(1)||''', '''||V_TMP_FUNCION(2)||''')';
				EXECUTE IMMEDIATE V_MSQL;
	
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] TODOS REGISTROS INSERTADOS EN '||V_ESQUEMA||'.CONFIG CORRECTAMENTE!');


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