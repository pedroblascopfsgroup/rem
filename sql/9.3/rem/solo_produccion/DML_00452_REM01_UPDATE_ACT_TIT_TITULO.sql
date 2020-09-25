--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8065
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar titulo de activos
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
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8065'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_TIT_TITULO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_ESTADO VARCHAR2(100 CHAR):='DD_ETI_ESTADO_TITULO'; --Vble. auxiliar para almacenar la tabla de los estados
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):='ACT_ACTIVO';
    V_TABLA_HIST VARCHAR2(100 CHAR):='ACT_AHT_HIST_TRAM_TITULO';
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- NUMERO ACTIVO	          CODIGO ESTADO TITULO DESCONOCIDO
        T_TIPO_DATA('7076014'			,'04'),
        T_TIPO_DATA('7076015'			,'04'),
        T_TIPO_DATA('7076016'			,'04')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN ACT_TIT_TITULO ');
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos si existe el activo
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo actualizamos
        IF V_NUM_TABLAS > 0 THEN				

          --Comprobamos si existe el titulo
          V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO='||TRIM(V_TMP_TIPO_DATA(1))||') ';
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

          --Si existe, se actualiza
          IF V_NUM_TABLAS > 0 then

            --Comprobamos si existe el estado del diccionario
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ESTADO||' WHERE DD_ETI_CODIGO ='||TRIM(V_TMP_TIPO_DATA(2))||' ';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;


            IF V_NUM_TABLAS > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS EL TITULO DEL ACTIVO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
                
                V_SQL:='SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ESTADO||' WHERE DD_ETI_CODIGO='||TRIM(V_TMP_TIPO_DATA(2))||'';
                EXECUTE IMMEDIATE V_SQL INTO V_ID;
                
                V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        DD_ETI_ID='||V_ID||',
                        TIT_FECHA_INSC_REG=NULL,
                        TIT_FECHA_ENTREGA_GESTORIA=NULL,
                        TIT_FECHA_PRESENT_HACIENDA=NULL,
                        TIT_FECHA_PRESENT1_REG=NULL,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE ACT_ID=(SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO='''||TRIM(V_TMP_TIPO_DATA(1))||''')';

                EXECUTE IMMEDIATE V_SQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');

                

                V_SQL:='SELECT TIT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' TIT
                JOIN '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT ON ACT.ACT_ID=TIT.ACT_ID
                WHERE ACT.ACT_NUM_ACTIVO='||TRIM(V_TMP_TIPO_DATA(1))||'';
                EXECUTE IMMEDIATE V_SQL INTO V_ID;

                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_HIST||' WHERE TIT_ID ='||V_ID||' ';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                if V_NUM_TABLAS > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS BORRADO A 1 EN TABLA HISTORICA');

                    V_SQL:='UPDATE '||V_ESQUEMA||'.'||V_TABLA_HIST||' SET
                            BORRADO=1,
                            FECHABORRAR=SYSDATE,
                            USUARIOBORRAR='''||V_USUARIO||'''
                            WHERE TIT_ID='||V_ID||'';
                    EXECUTE IMMEDIATE V_SQL;
                  
                ELSE
                  DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE REGISTRO EN LA HISTORICA PARA EL NUMERO ACTIVO '||TRIM(V_TMP_TIPO_DATA(1))||'');
                END IF;

            ELSE
            --Si no existe el codigo del diccionario no se hace nada
                 DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL ESTADO CON EL CODIGO INDICADO: '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
            END IF;            

            --Si no existe no se hace nada
          ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE TITULO PARA EL ACTIVO INDICADO');
          END IF;          
         
       --Si no existe, no hacemos nada
       ELSE
       DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO A ACTUALIZAR EL TITULO NO EXISTE');        
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