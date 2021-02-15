--/*
--######################################### 
--## AUTOR=KEVIN HONORATO
--## FECHA_CREACION=20210215
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8905
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utiliz,o DBMS_OUTPUT.PUT_LINE


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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_2 VARCHAR2(2400 CHAR) := 'GDE_GASTOS_DETALLE_ECONOMICO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_3 VARCHAR2(2400 CHAR) := 'GGE_GASTOS_GESTION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-8905';
    V_GPV_ID NUMBER(16); --Vble para extraer el ID del registro a modificar, si procede.


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            --       GPV_NUM_GASTO_HAYA      PRG_NUM_PROVISION         DD_EGA_ID     GDE_FECHA_PAGO    DD_EAP_ID
            T_TIPO_DATA('10930753',             '192417307',              '05',        '25/10/2019',      '07'),
            T_TIPO_DATA('10930754',             '192417307',              '05',        '25/10/2019',      '07'),
            T_TIPO_DATA('10930755',             '192417307',              '05',        '25/10/2019',      '07'),
            T_TIPO_DATA('10930756',             '192417307',              '05',        '25/10/2019',      '07'),
            T_TIPO_DATA('10930757',             '192417307',              '05',        '25/10/2019',      '07'),
            T_TIPO_DATA('10930758',             '192417307',              '05',        '25/10/2019',      '07'),
            T_TIPO_DATA('10930759',             '192417307',              '05',        '25/10/2019',      '07')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	


 -- LOOP para actualizar los valores en las siguientes infertaces (GPV_GASTOS_PROVEEDOR, GDE_GASTOS_DETALLE_ECONOMICO y GGE_GASTOS_GESTION)-----------------------------------------------------------------

  DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA LA ACTUALZIACIÓN ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla (GPV_GASTOS_PROVEEDOR)  
        DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE LA TABLA (GPV_GASTOS_PROVEEDOR)');

        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
        
          --Comprobamos el dato a actualizar
          DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS LOS DATOS A ACTUALIZAR (GPV_GASTOS_PROVEEDOR)');

          V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
          WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
          IF V_NUM_TABLAS > 0 THEN

          DBMS_OUTPUT.PUT_LINE('[INFO]: SI EXISTEN LOS REGISTROS A MODIFICAR, LOS MODIFICAMOS)');

            V_MSQL := 'SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_GPV_ID;

            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
            ' SET PRG_ID = (SELECT PRG_ID FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS WHERE PRG_NUM_PROVISION = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
            ', DD_EGA_ID = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||            
            'WHERE GPV_ID = '''||V_GPV_ID||'''';
            EXECUTE IMMEDIATE V_MSQL;    

            DBMS_OUTPUT.PUT_LINE('[FIN]: INTERFAZ GPV_GASTOS_PROVEEDOR MODIFICADO CORRECTAMENTE ');  
          ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN LOS REGISTROS A MODIFICAR');  
          END IF;               
        END IF;
      ------------------------------------------------------------------------------------------------------------------------------------------------------
        -- Comprobamos si existe la tabla (GDE_GASTOS_DETALLE_ECONOMICO)  
        DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE LA TABLA (GDE_GASTOS_DETALLE_ECONOMICO)');
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_2||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
           --Comprobamos el dato a actualizar
          DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS LOS DATOS A ACTUALIZAR (GDE_GASTOS_DETALLE_ECONOMICO)');

          V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_2||'
          WHERE GPV_ID = (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
          IF V_NUM_TABLAS > 0 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: SI EXISTEN LOS REGISTROS A MODIFICAR, LOS MODIFICAMOS)');
            V_MSQL := 'SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_GPV_ID;

            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_2||' '||
            ' SET GDE_FECHA_PAGO = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(4))||''',''DD/MM/YYYY'') '||
            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||            
            'WHERE GPV_ID = '''||V_GPV_ID||'''';
            EXECUTE IMMEDIATE V_MSQL;    

            DBMS_OUTPUT.PUT_LINE('[FIN]: INTERFAZ GDE_GASTOS_DETALLE_ECONOMICO MODIFICADO CORRECTAMENTE ');  
          ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN LOS REGISTROS A MODIFICAR');  
          END IF;              
              
        END IF;    
       ------------------------------------------------------------------------------------------------------------------------------------------------------
        -- Comprobamos si existe la tabla (GGE_GASTOS_GESTION)  
        DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE LA TABLA (GGE_GASTOS_GESTION)');
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_3||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
           --Comprobamos el dato a actualizar
          DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS LOS DATOS A ACTUALIZAR (GGE_GASTOS_GESTION)');

          V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_3||'
          WHERE GPV_ID = (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
          IF V_NUM_TABLAS > 0 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: SI EXISTEN LOS REGISTROS A MODIFICAR, LOS MODIFICAMOS)');
            V_MSQL := 'SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_GPV_ID;

            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_3||' '||
            ' SET DD_EAP_ID = (SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') '||
            ', GGE_FECHA_EAP = SYSDATE '||
            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||            
            'WHERE GPV_ID = '''||V_GPV_ID||'''';
            EXECUTE IMMEDIATE V_MSQL;    

            DBMS_OUTPUT.PUT_LINE('[FIN]: INTERFAZ GGE_GASTOS_GESTION MODIFICADO CORRECTAMENTE ');  
          ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN LOS REGISTROS A MODIFICAR');  
          END IF;              
              
        END IF;   

      END LOOP;
    COMMIT;
        

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
