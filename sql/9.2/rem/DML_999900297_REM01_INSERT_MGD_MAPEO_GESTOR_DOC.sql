--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20180803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1342
--## PRODUCTO=NO
--##
--## Finalidad: Se añaden datos a la tabla MGD_MAPEO_GESTOR_DOC
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	  T_FUNCION('03', '08', 'Bankia'),
	  T_FUNCION('03', '06', 'Bankia'),
	  T_FUNCION('03', '07', 'Bankia'),
	  T_FUNCION('03', '05', 'Bankia'),
	  T_FUNCION('03', '15', 'Bankia'),
	  T_FUNCION('03', '19', 'Bankia'),
	  T_FUNCION('03', '14', 'Bankia'),
	  T_FUNCION('03', '09', 'Bankia'),
	  T_FUNCION('01', '01', 'Cajamar'),
	  T_FUNCION('01', '02', 'Cajamar'),
	  T_FUNCION('07', '39', 'Promontoria 227'),
	  T_FUNCION('07', '17', 'Cerberus'),
	  T_FUNCION('07', '38', 'Jaipur'),
	  T_FUNCION('07', '37', 'Jaipur'),
	  T_FUNCION('13', '131', ''),
	  T_FUNCION('13', '132', ''),
	  T_FUNCION('12', '33', 'Goldentree'),
	  T_FUNCION('12', '34', 'Goldentree'),
	  T_FUNCION('12', '35', 'Goldentree'),
	  T_FUNCION('12', '36', 'Goldentree'),
	  T_FUNCION('12', '32', 'Goldentree'),
	  T_FUNCION('06', '16', 'Haya Titulizacion'),
	  T_FUNCION('08', '18', 'Liberbank'),
	  T_FUNCION('04', '10', 'Otras carteras'),
	  T_FUNCION('04', '11', 'Otras carteras'),
	  T_FUNCION('04', '20', 'Otras carteras'),
	  T_FUNCION('02', '03', 'Sareb'),
	  T_FUNCION('02', '04', 'Sareb'),
	  T_FUNCION('05', '13', 'Otras carteras'),
	  T_FUNCION('05', '12', 'Otras carteras'),
	  T_FUNCION('10', '23', 'Waterfall'),
	  T_FUNCION('10', '24', 'Waterfall'),
	  T_FUNCION('11', '30', 'Ing'),
	  T_FUNCION('11', '31', ''),
	  T_FUNCION('11', '25', 'Bankia'),
	  T_FUNCION('11', '32', 'Cajamar'),
	  T_FUNCION('11', '27', ''),
	  T_FUNCION('11', '28', 'Ing'),
	  T_FUNCION('11', '26', 'Liberbank'),
	  T_FUNCION('11', '29', '')
    );          
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
    -- LOOP para insertar los valores en MGD_MAPEO_GESTOR_DOC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN MGD_MAPEO_GESTOR_DOC] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC WHERE DD_CRA_ID = 
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||(V_TMP_FUNCION(1))||''') 
							AND DD_SCR_ID = 
								(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||(V_TMP_FUNCION(2))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC...no se modifica nada.');
				
			ELSE

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC (' ||
					'MGD_ID, DD_CRA_ID, DD_SCR_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
					' SELECT '||V_ESQUEMA||'.S_MGD_MAPEO_GESTOR_DOC.NEXTVAL,' ||
					'(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_FUNCION(1)||'''), '||
					'(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_FUNCION(2)||'''), '''||
					(V_TMP_FUNCION(3)) ||''',''DML'',SYSDATE,0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: MGD_MAPEO_GESTOR_DOC ACTUALIZADO CORRECTAMENTE ');
   

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



   
