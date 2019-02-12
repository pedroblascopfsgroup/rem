--/*
--##########################################
--## AUTOR=PIER GOTTA 
--## FECHA_CREACION=20190204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3271
--## PRODUCTO=NO
--##
--## Finalidad: Modificar la fecha ingreso cheque.
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3271'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        T_FUNCION('150044','18/10/2018'),
        T_FUNCION('141512','05/10/2018'),
        T_FUNCION('145912','18/10/2018'),
        T_FUNCION('145915','18/10/2018'),
        T_FUNCION('145906','18/10/2018')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO 
                        WHERE ECO.ECO_NUM_EXPEDIENTE IN ('||V_TMP_FUNCION(1)||')';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FILA
			IF V_NUM_TABLAS = 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe el expediente en la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' ... no se modifica nada.');
				
			ELSE
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO SET 
                            ECO.ECO_FECHA_CONT_PROPIETARIO = TO_DATE('''||V_TMP_FUNCION(2)||''',''DD/MM/YYYY''),
                            ECO.USUARIOMODIFICAR = '''||V_USUARIO||''',
                            ECO.FECHAMODIFICAR = SYSDATE
                            WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_TMP_FUNCION(1)||'' ;
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' insertados correctamente.');
				
		    END IF;	
      END LOOP;
      
      COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
EXIT;
