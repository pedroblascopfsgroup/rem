--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14974
--## PRODUCTO=NO
--## Finalidad: Creación diccionario EQV_CAIXA_TUD
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14344';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
                  --TIPO(TPA)  --SUBTIPO(SAC)  --USO_DOMINANTE(TUD)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('03','15','02'),
        T_TIPO_DATA('03','29','05'),
        T_TIPO_DATA('03','16','02'),
        T_TIPO_DATA('03','13','02'),
        T_TIPO_DATA('03','14','02'),
        T_TIPO_DATA('03','28','05'),
        --T_TIPO_DATA('09','','05'),
        --T_TIPO_DATA('08','','04'),
        T_TIPO_DATA('05','19','02'),
        T_TIPO_DATA('05','22','07'),
        T_TIPO_DATA('05','20','02'),
        T_TIPO_DATA('05','21','02'),
        --T_TIPO_DATA('06','','05'),
        T_TIPO_DATA('04','18','03'),
        T_TIPO_DATA('04','17','03'),
        T_TIPO_DATA('04','37','03'),
        T_TIPO_DATA('07','24','02'),
        T_TIPO_DATA('07','35','04'),
        T_TIPO_DATA('07','26','05'),
        T_TIPO_DATA('07','38','05'),
        T_TIPO_DATA('07','36','04'),
        T_TIPO_DATA('07','25','02'),
        T_TIPO_DATA('01','27','03'),
        T_TIPO_DATA('01','01','08'),
        T_TIPO_DATA('01','02','05'),
        T_TIPO_DATA('01','03','05'),
        T_TIPO_DATA('01','04','05')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN EQV_CAIXA_TUD ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EQV_CAIXA_TUD WHERE TIPO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND SUBTIPO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO TIPO: '''||TRIM(V_TMP_TIPO_DATA(1))||''', SUBTIPO: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.EQV_CAIXA_TUD '||
                    'SET   USO_DOMINANTE = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
                    'WHERE TIPO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND SUBTIPO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.EQV_CAIXA_TUD 
                      (' ||'
                            TIPO
                          , SUBTIPO
                          , USO_DOMINANTE) ' ||
                      'SELECT 
                           '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(3))||'''
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO EQV_CAIXA_TUD MODIFICADO CORRECTAMENTE ');
   

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
