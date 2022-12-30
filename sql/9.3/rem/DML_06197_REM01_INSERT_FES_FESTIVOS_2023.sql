--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.8
--## INCIDENCIA_LINK=REMVIP-13047
--## PRODUCTO=SI
--##
--## Finalidad: Script que añade en FES_FESTIVOS los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Versión 2023
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
    V_USUARIO VARCHAR2(200 CHAR):='REMVIP-13047';
        
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                --   AÑO MES DIA_I DIA_F
        T_TIPO_DATA('2023','1','1','1'),    -- Año nuevo
        T_TIPO_DATA('2023','1','6','6'),    -- Reyes
        T_TIPO_DATA('2023','4','10','10'),  -- Viernes Santo
        T_TIPO_DATA('2023','5','1','1'),    -- Día del trabajador
        T_TIPO_DATA('2023','8','15','15'),  -- Virgen de Agosto
        T_TIPO_DATA('2023','10','12','12'), -- El Pilar
        T_TIPO_DATA('2023','11','1','1'),   -- Todos los santos
        T_TIPO_DATA('2023','12','6','6'),   -- Constitucion
        T_TIPO_DATA('2023','12','8','8'),   -- Inmaculada
        T_TIPO_DATA('2023','12','25','25')  -- Navidad
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
  DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  -- LOOP para insertar los valores en FES_FESTIVOS -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN FES_FESTIVOS ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP
      
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
    --Comprobamos el dato a insertar
    V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.FES_FESTIVOS FES 
					WHERE FES_YEAR = '|| TRIM(V_TMP_TIPO_DATA(1)) ||' 
					AND FES_MONTH = '|| TRIM(V_TMP_TIPO_DATA(2)) ||' 
					AND FES_DAY_START = '|| TRIM(V_TMP_TIPO_DATA(3)) ||' 
					AND FES_DAY_END = '|| TRIM(V_TMP_TIPO_DATA(4)) ||'';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    --Si existe lo modificamos
    IF V_NUM_TABLAS = 0 THEN                                
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO EN FES_FESTIVOS');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_FES_FESTIVOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;   
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.FES_FESTIVOS (' ||
                    'FES_ID, FES_YEAR, FES_MONTH, FES_DAY_START, FES_DAY_END, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '|| V_ID ||','||V_TMP_TIPO_DATA(1)||' ,'||V_TMP_TIPO_DATA(2)||','||TRIM(V_TMP_TIPO_DATA(3))||','||TRIM(V_TMP_TIPO_DATA(4))||', 0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE: AÑO: '||V_TMP_TIPO_DATA(1)||', MES: '||V_TMP_TIPO_DATA(2)||', DIA INICIO: '||V_TMP_TIPO_DATA(3)||', DIA FIN: '||V_TMP_TIPO_DATA(4)||'');
    ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: LA FECHA YA EXISTE EN FES_FESTIVOS: AÑO: '||V_TMP_TIPO_DATA(1)||', MES: '''||V_TMP_TIPO_DATA(2)||', DIA INICIO: '||V_TMP_TIPO_DATA(3)||', DIA FIN: '||V_TMP_TIPO_DATA(4)||'');   
    END IF;
  END LOOP;
      
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA FES_FESTIVOS ACTUALIZADA CORRECTAMENTE ');
   

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



   
