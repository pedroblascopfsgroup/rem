--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211025
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10529
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
    	-- CARTERA   CARTERA_NUEVA
        T_TIPO_DATA('BANKIA','CAIXABANK'),
        T_TIPO_DATA('LIBERBANK','UNICAJA')
       

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    

    TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2
    (
    	-- CARTERA  SUBCARTERA  INSCRIPCION    CARGAS  POSESION    TIPO_ALQUILER   ALQUILADO   OCUPADO     DECRETO FIRME
        T_TIPO_DATA2('BANKIA DACION','','1','1','1','1','1','1','0'),
        T_TIPO_DATA2('CAIXABANK','','1','1','1','1','1','1','0'),
        T_TIPO_DATA2('OTRA CARTERA','','1','1','1','1','0','0','0')
       

    ); 
    V_TMP_TIPO_DATA2 T_TIPO_DATA2;


BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||'');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Cambiamos nombres ....');
    DBMS_OUTPUT.PUT_LINE('[INFO]:                                                        ');
    --########### CAMBIAR NOMBRE ###################
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
           

            IF TRIM(V_TMP_TIPO_DATA(2)) IS NOT NULL THEN

                V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS >0 THEN

                    DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos Registro: cartera: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' a cartera: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''  ');

                    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                            CARTERA = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
                            WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ';
                            
                    EXECUTE IMMEDIATE V_SQL;

                    V_COUNT:=V_COUNT+1;

                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] No existe registro con la cartera indicada');
                END IF;
            END IF;
        END LOOP; 

--############# FIN CAMBIAR NOMBRE ##################
DBMS_OUTPUT.PUT_LINE('[INFO]: Nombres cambiados!!!');
DBMS_OUTPUT.PUT_LINE('[INFO]:                                                        ');
--############# ACTUALIZAR CAMBIOS ################

V_COUNT:=0;


        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS CORRECTAMENTE: '''||V_COUNT||''' REGISTROS ');
        DBMS_OUTPUT.PUT_LINE('[INFO]:                                                        ');
            
        FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
        LOOP
        
            V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);

            IF TRIM(V_TMP_TIPO_DATA2(2)) IS NOT NULL THEN

                V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''' AND SUBCARTERA='''|| TRIM(V_TMP_TIPO_DATA2(2)) ||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS >0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos Registro: cartera: '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''' subcartera: '''|| TRIM(V_TMP_TIPO_DATA2(2)) ||'''  ');

                V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        INSCRIPCION = '|| TRIM(V_TMP_TIPO_DATA2(3)) ||',
                        CARGAS = '|| TRIM(V_TMP_TIPO_DATA2(4)) ||',
                        POSESION = '|| TRIM(V_TMP_TIPO_DATA2(5)) ||',
                        TIPO_ALQUILER = '|| TRIM(V_TMP_TIPO_DATA2(6)) ||',
                        ALQUILADO = '|| TRIM(V_TMP_TIPO_DATA2(7)) ||',
                        OCUPADO = '|| TRIM(V_TMP_TIPO_DATA2(8)) ||',
                        FECHA_DECRETO = '|| TRIM(V_TMP_TIPO_DATA2(9)) ||'
                        WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''
                        AND SUBCARTERA= '''|| TRIM(V_TMP_TIPO_DATA2(2)) ||''' ';
                        
                EXECUTE IMMEDIATE V_SQL;

                V_COUNT:=V_COUNT+1;

                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] No existe registro con la cartera y subcartera indicados');
                END IF;

            ELSE
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''' ';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS > 0 THEN
            
                DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos Registro: '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''' ');

                V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        INSCRIPCION = '|| TRIM(V_TMP_TIPO_DATA2(3)) ||',
                        CARGAS = '|| TRIM(V_TMP_TIPO_DATA2(4)) ||',
                        POSESION = '|| TRIM(V_TMP_TIPO_DATA2(5)) ||',
                        TIPO_ALQUILER = '|| TRIM(V_TMP_TIPO_DATA2(6)) ||',
                        ALQUILADO = '|| TRIM(V_TMP_TIPO_DATA2(7)) ||',
                        OCUPADO = '|| TRIM(V_TMP_TIPO_DATA2(8)) ||',
                        FECHA_DECRETO = '|| TRIM(V_TMP_TIPO_DATA2(9)) ||'
                        WHERE CARTERA='''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''';
                        
                EXECUTE IMMEDIATE V_SQL;
            
                V_COUNT:=V_COUNT+1;

                ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe registro con la cartera indicada');
                END IF;
            END IF;
        END LOOP;           
    
        DBMS_OUTPUT.PUT_LINE('[INFO]:                                                        ');
        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS CORRECTAMENTE: '''||V_COUNT||''' REGISTROS ');

--################## FIN CAMBIAR NOMBRE ###############
    
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