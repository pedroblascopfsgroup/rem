--/*
--##########################################
--## AUTOR=ALFONSO RODRIGUEZ VERDERA
--## FECHA_CREACION=20190909
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7487
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TDJ_TIPO_DOC_JUNTAS los datos añadidos en T_ARRAY_DATA
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

    V_TABLA VARCHAR2(30 CHAR) := 'DD_TDJ_TIPO_DOC_JUNTAS';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_TDJ_TIPO_DOC_JUNTAS';  -- Tabla a modificar   
    V_USR VARCHAR2(30 CHAR) := 'HREOS-7487'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_CDG VARCHAR2(30 CHAR) := 'TDJ';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

        T_TIPO_DATA('01', 'Comunidad de propietarios: Cuota extraordinaria (derrama) (Justificante de pago)', 'Comunidad de propietarios: Cuota extraordinaria (derrama) (Justificante de pago)', 'OP-33-CERA-AB'),
        T_TIPO_DATA('02', 'Comunidad de propietarios: Cuota extraordinaria (derrama) (Recibo)', 'Comunidad de propietarios: Cuota extraordinaria (derrama) (Recibo)', 'OP-33-FACT-46'),
        T_TIPO_DATA('03', 'Comunidad de propietarios: Cuota ordinaria (Justificante de pago)', 'Comunidad de propietarios: Cuota ordinaria (Justificante de pago)', 'OP-33-CERA-AD'),
        T_TIPO_DATA('04', 'Comunidad de propietarios: Cuota ordinaria (Recibo)', 'Comunidad de propietarios: Cuota ordinaria (Recibo)', 'OP-33-FACT-48'),
        T_TIPO_DATA('05', 'Junta de compensacion: Cuotas y derramas (Justificante de pago)', 'Junta de compensacion: Cuotas y derramas (Justificante de pago)', 'OP-33-CERA-AH'),
        T_TIPO_DATA('06', 'Junta de compensacion: Cuotas y derramas (Recibo)', 'Junta de compensacion: Cuotas y derramas (Recibo)', 'OP-33-FACT-52'),
        T_TIPO_DATA('07', 'Junta de compensacion / EUC: Gastos generales (Justificante de pago)', 'Junta de compensacion / EUC: Gastos generales (Justificante de pago)', 'OP-33-CERA-AG'),
        T_TIPO_DATA('08', 'Junta de compensacion / EUC: Gastos generales (Recibo)', 'Junta de compensacion / EUC: Gastos generales (Recibo)', 'OP-33-FACT-51'),
        T_TIPO_DATA('09', 'Recepcion convocatoria', 'Recepcion convocatoria', 'OP-33-ACTR-13')
	    
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_EQG_EQUIPO_GESTION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CDG||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' '||
                  	'SET DD_'||V_CDG||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
					   	DD_'||V_CDG||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
					   	USUARIOMODIFICAR = '''||V_USR||''', 
              DD_'||V_CDG||'_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                        FECHAMODIFICAR = SYSDATE 
					WHERE DD_'||V_CDG||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                   
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   	
          V_MSQL := '
                  INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
                    DD_'||V_CDG||'_ID, 
                    DD_'||V_CDG||'_CODIGO, 
                    DD_'||V_CDG||'_DESCRIPCION, 
                    DD_'||V_CDG||'_DESCRIPCION_LARGA, 
                    VERSION, 
                    USUARIOCREAR, 
                    FECHACREAR, 
                    BORRADO,
                    DD_'||V_CDG||'_MATRICULA_GD
                  ) 
                  SELECT '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL,
                  '''||TRIM(V_TMP_TIPO_DATA(1))||''',
                  '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                  '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                  0, 
                  '''||V_USR||''',
                  SYSDATE,
                  0,
                  '''||TRIM(V_TMP_TIPO_DATA(4))||''' FROM DUAL';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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



   
