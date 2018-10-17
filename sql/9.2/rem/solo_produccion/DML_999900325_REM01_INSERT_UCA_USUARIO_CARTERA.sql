--/*
--##########################################
--## AUTOR=Guillermo Llidó 
--## FECHA_CREACION=20180917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1897
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en UCA_USUARIO_CARTERA los datos añadidos en T_ARRAY_DATA.
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
	
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1897'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'UCA_USUARIO_CARTERA';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('ndelgado', 'Tango')
    ); 
    V_TMP_FUNCION T_FUNCION; 
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS
						WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FILA
			IF V_NUM_TABLAS > 0 THEN	  
                            
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||'
						WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''')';

                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                
                    IF V_NUM_TABLAS > 0 THEN	  
                    
                        DBMS_OUTPUT.PUT_LINE('[INFO] El usuario '||V_TMP_FUNCION(1)||' se encuentra carterizado en la tabla '||V_ESQUEMA||'.'||V_TABLA||' ...no se modifica nada.');     	
                    
                    ELSE
                    
                        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA (UCA_ID,
                                                                                    USU_ID,
                                                                                    DD_CRA_ID) 
                                    VALUES('||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL,
                                            (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||'''),
                                            (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_DESCRIPCION = '''||V_TMP_FUNCION(2)||''')
                                    )';

                        EXECUTE IMMEDIATE V_MSQL;
                        
                        DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' insertados correctamente.'); 
                    
                    END IF;
                    
                ELSE
                
       				DBMS_OUTPUT.PUT_LINE('[INFO] No existe el usuario '||V_ESQUEMA_M||'.USU_USUARIOS ...no se modifica nada.');

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
