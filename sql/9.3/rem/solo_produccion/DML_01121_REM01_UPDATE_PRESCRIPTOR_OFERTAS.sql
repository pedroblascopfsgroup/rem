--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10950
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar prescriptor de ofertas 
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-11134'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='OFR_OFERTAS'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_PROVEEDOR VARCHAR2(100 CHAR):='ACT_PVE_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla de los proveedores
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_ECO NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- OFR_NUM_OFERTA	          CODIGO_REM PROVEEDOR
T_TIPO_DATA('90359673','110224457'),
T_TIPO_DATA('90360103','110224457'),
T_TIPO_DATA('90362429','110224457'),
T_TIPO_DATA('90363125','110224457'),
T_TIPO_DATA('90365440','110224457'),
T_TIPO_DATA('90365884','110224457'),
T_TIPO_DATA('90370839','110224457'),
T_TIPO_DATA('90370971','110224457'),
T_TIPO_DATA('90371319','110224457'),
T_TIPO_DATA('90371327','110224457'),
T_TIPO_DATA('90371896','110224457'),
T_TIPO_DATA('90372217','110224457'),
T_TIPO_DATA('90372702','110224457'),
T_TIPO_DATA('90373399','110224457'),
T_TIPO_DATA('90373817','110224457'),
T_TIPO_DATA('90373828','110224457'),
T_TIPO_DATA('90374287','110224457'),
T_TIPO_DATA('90374402','110224457'),
T_TIPO_DATA('90374543','110224457'),
T_TIPO_DATA('90374780','110224457'),
T_TIPO_DATA('90374913','110224457'),
T_TIPO_DATA('90375423','110224457'),
T_TIPO_DATA('90376163','110224457'),
T_TIPO_DATA('90376099','110224457'),
T_TIPO_DATA('90376821','110224457'),
T_TIPO_DATA('90376792','110224457'),
T_TIPO_DATA('90377556','110224457'),
T_TIPO_DATA('90377735','110224457'),
T_TIPO_DATA('90377868','110224457'),
T_TIPO_DATA('90378678','110224457'),
T_TIPO_DATA('90378625','110224457'),
T_TIPO_DATA('90379095','110224457'),
T_TIPO_DATA('90379483','110224457'),
T_TIPO_DATA('90379832','110224457'),
T_TIPO_DATA('90361076','110224457'),
T_TIPO_DATA('90362456','110224457')
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' OFR
        JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=OFR.OFR_ID
        WHERE OFR.OFR_NUM_OFERTA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo actualizamos
        IF V_NUM_TABLAS > 0 THEN				

          --Comprobamos si existe el proveedor
          V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

          --Si existe, se actualiza
          IF V_NUM_TABLAS > 0 then
            
            V_SQL:='SELECT PVE_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM='||TRIM(V_TMP_TIPO_DATA(2))||'';
            EXECUTE IMMEDIATE V_SQL INTO V_ID;

            V_SQL := 'SELECT ECO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' OFR
                    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=OFR.OFR_ID
                    WHERE OFR.OFR_NUM_OFERTA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_ID_ECO;
            
            V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                      PVE_ID_PRESCRIPTOR='||V_ID||',
                      USUARIOMODIFICAR = '''||V_USUARIO||''', 
                      FECHAMODIFICAR = SYSDATE
                      WHERE OFR_NUM_OFERTA='||TRIM(V_TMP_TIPO_DATA(1))||'';

            EXECUTE IMMEDIATE V_SQL;

            V_SQL := 'UPDATE '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE SET
                    GEX_PROVEEDOR='||V_ID||',
                    USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    FECHAMODIFICAR = SYSDATE
                    WHERE ECO_ID='||V_ID_ECO||'';

            EXECUTE IMMEDIATE V_SQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE '''||TRIM(V_TMP_TIPO_DATA(1))||''' - '''||TRIM(V_TMP_TIPO_DATA(2))||'''');

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