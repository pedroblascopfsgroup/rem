--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221401
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11041
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar e insertar en CONF_ALERTAS_PUBLICACION
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10529'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='CONF_ALERTAS_PUBLICACION'; --Vble. auxiliar para almacenar la tabla a insertar
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- CARTERA SUBCARTERA CARGAS

        T_TIPO_DATA('CAIXABANK','','0')
       

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
    TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2
    (
    	-- CARTERA  SUBCARTERA  INSCRIPCION    CARGAS  POSESION    TIPO_ALQUILER   ALQUILADO    TCO_ALQUILER  OCUPADO     DECRETO FIRME

        T_TIPO_DATA2('CERBERUS','JAGUAR','0','1','1','1','1','0','1','0')
       

    ); 
    V_TMP_TIPO_DATA2 T_TIPO_DATA2;


BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||'');

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            IF TRIM(V_TMP_TIPO_DATA(2)) IS NOT NULL THEN

                V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' AND SUBCARTERA='''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS >0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos Registro: cartera: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' subcartera: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''  ');

                V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        CARGAS = '|| TRIM(V_TMP_TIPO_DATA(3)) ||'
                        WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
                        AND SUBCARTERA= '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' ';
                        
                EXECUTE IMMEDIATE V_SQL;

                V_COUNT:=V_COUNT+1;

                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] No existe registro con la cartera y subcartera indicados');
                END IF;

            ELSE
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS > 0 THEN
            
                DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos Registro: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');

                V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        CARGAS = '|| TRIM(V_TMP_TIPO_DATA(3)) ||'
                        WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
                        
                EXECUTE IMMEDIATE V_SQL;
            
                V_COUNT:=V_COUNT+1;

                ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe registro con la cartera indicada');
                END IF;
            END IF;
        END LOOP;           
    
        DBMS_OUTPUT.PUT_LINE('[INFO]:                                                        ');
        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS CORRECTAMENTE: '''||V_COUNT||''' REGISTROS ');
        
        
        
        
        
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);
    FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
      LOOP

        V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);
        
        V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CARTERA='''||TRIM(V_TMP_TIPO_DATA2(1))||''' AND SUBCARTERA='''||TRIM(V_TMP_TIPO_DATA2(2))||''' ';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 0 THEN

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA2(2)) ||''' ');  
	
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (CARTERA, SUBCARTERA, INSCRIPCION, CARGAS, POSESION,TIPO_ALQUILER, ALQUILADO,TCO_ALQUILER, OCUPADO, FECHA_DECRETO) VALUES (' ||
                      ''''||V_TMP_TIPO_DATA2(1)||''','''||TRIM(V_TMP_TIPO_DATA2(2))||''',' ||
                      ''''||V_TMP_TIPO_DATA2(3)||''','''||TRIM(V_TMP_TIPO_DATA2(4))||''','''||TRIM(V_TMP_TIPO_DATA2(5))||''',' || 
		      ''''||V_TMP_TIPO_DATA2(6)||''','''||TRIM(V_TMP_TIPO_DATA2(7))||''','''||TRIM(V_TMP_TIPO_DATA2(8))||''','''||TRIM(V_TMP_TIPO_DATA2(9))||''','''||TRIM(V_TMP_TIPO_DATA2(10))||''')';
         
	
	  EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
          
          ELSE
          	DBMS_OUTPUT.PUT_LINE('[ERROR]: Ya existe el registro no se realiza inserccion');
          END IF;

      END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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
EXIT
