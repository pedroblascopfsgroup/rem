--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200908
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8038
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar prescriptor de ofertas 6012853 y 6012726
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8038'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='OFR_OFERTAS'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_PROVEEDOR VARCHAR2(100 CHAR):='ACT_PVE_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla de los proveedores
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- OFR_NUM_OFERTA	          CODIGO_REM PROVEEDOR
        T_TIPO_DATA('90266285'			,'110082778')
       
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN OFR_OFERTAS ');
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_NUM_OFERTA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo actualizamos
        IF V_NUM_TABLAS > 0 THEN				

          --Comprobamos si existe el proveedor
          V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

          --Si existe, se actualiza
          IF V_NUM_TABLAS > 0 then
            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
            
            V_SQL:='SELECT PVE_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM='||TRIM(V_TMP_TIPO_DATA(2))||'';
            EXECUTE IMMEDIATE V_SQL INTO V_ID;
            
            V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                      PVE_ID_PRESCRIPTOR='||V_ID||',
                      USUARIOMODIFICAR = '''||V_USUARIO||''', 
                      FECHAMODIFICAR = SYSDATE
                      WHERE OFR_NUM_OFERTA='||TRIM(V_TMP_TIPO_DATA(1))||'';

            EXECUTE IMMEDIATE V_SQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');

            --Si no existe no se hace nada
          ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL PROVEEDOR CON EL CODIGO INDICADO: '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
          END IF;
          
         
       --Si no existe, no hacemos nada
       ELSE
       DBMS_OUTPUT.PUT_LINE('[INFO]: LA OFERTA A ACTUALIZAR NO EXISTE');       
        
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