--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20201229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12585
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CFG_COMISION_COSTES_ACTIVO los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-12585';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CFG_COMISION_COSTES_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    V_ID_ACT NUMBER(16,0); 
    V_ID_SACT NUMBER(16,0); 
    V_ID_TCM NUMBER(16,0); 
    V_ID_TCT NUMBER(16,0); 
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- CFG_COMISION_COSTES_ACTIVO   DD_TCT_CODIGO  DD_TCT_PORCENTAJE  
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('03','13','B','C'),
        T_TIPO_DATA('03','14','B','C'),
        T_TIPO_DATA('03','15',null,'C'),
        T_TIPO_DATA('03','16','B','C'),
        T_TIPO_DATA('03','28',null,'C'),
        T_TIPO_DATA('03','29',null,'C'),
        T_TIPO_DATA('09','33',null,'C'),
        T_TIPO_DATA('08','34',null,'C'),
        T_TIPO_DATA('08','30',null,'C'),
        T_TIPO_DATA('08','37',null,'C'),
        T_TIPO_DATA('08','32',null,'C'),
        T_TIPO_DATA('08','31',null,'C'),
        T_TIPO_DATA('05','19',null,'C'),
        T_TIPO_DATA('05','20','B','C'),
        T_TIPO_DATA('05','21','B','C'),
        T_TIPO_DATA('05','22','B','C'),
        T_TIPO_DATA('06','23',null,'C'),
        T_TIPO_DATA('04','17','B','C'),
        T_TIPO_DATA('04','18','B','C'),
        T_TIPO_DATA('07','24','A','C'),
        T_TIPO_DATA('07','25','A','C'),
        T_TIPO_DATA('07','26',null,'C'),
        T_TIPO_DATA('07','35',null,'C'),
        T_TIPO_DATA('07','36',null,'C'),
        T_TIPO_DATA('01','01','C','C'),
        T_TIPO_DATA('01','02','C','B'),
        T_TIPO_DATA('01','03','C','B'),
        T_TIPO_DATA('01','04','C','B'),
        T_TIPO_DATA('01','27','C','B'),
        T_TIPO_DATA('02','05','A','A'),
        T_TIPO_DATA('02','06','A','A'),
        T_TIPO_DATA('02','07','A','A'),
        T_TIPO_DATA('02','08','A','A'),
        T_TIPO_DATA('02','09','A','A'),
        T_TIPO_DATA('02','10','A','A'),
        T_TIPO_DATA('02','11','A','A'),
        T_TIPO_DATA('02','12','A','A')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        DBMS_OUTPUT.PUT_LINE('SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''');


         EXECUTE IMMEDIATE 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''' INTO V_ID_ACT;


         EXECUTE IMMEDIATE 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''' INTO V_ID_SACT;


         EXECUTE IMMEDIATE 'SELECT DD_TCT_ID FROM '|| V_ESQUEMA ||'.DD_TCT_TIPO_COSTES WHERE DD_TCT_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''' INTO V_ID_TCT;


         IF V_TMP_TIPO_DATA(3) IS NULL THEN
          
           V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
           DD_TPA_ID = '||V_ID_TCT||' AND DD_SAC_ID = '||V_ID_SACT||' AND DD_TCT_ID = '||V_ID_TCT;
           
           V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
                      CFG_CCA_ID, DD_TPA_ID, DD_SAC_ID, DD_TCT_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
                       '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                       ,'||V_ID_ACT||','||V_ID_SACT||','||V_ID_TCT||'
                       ,0,'''||V_ITEM||''',SYSDATE,0)';
            
         ELSE
           
          EXECUTE IMMEDIATE 'SELECT DD_TCM_ID FROM '|| V_ESQUEMA ||'.DD_TCM_TIPO_COMISION WHERE DD_TCM_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''' INTO V_ID_TCM;

           V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
           DD_TPA_ID = '||V_ID_TCT||' AND DD_SAC_ID = '||V_ID_SACT||' AND DD_TCM_ID = '||V_ID_TCM||' AND DD_TCT_ID = '||V_ID_TCT;

           V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
                      CFG_CCA_ID, DD_TPA_ID, DD_SAC_ID, DD_TCM_ID, DD_TCT_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
                       '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                       ,'||V_ID_ACT||','||V_ID_SACT||','||V_ID_TCM||','||V_ID_TCT||'
                       ,0,'''||V_ITEM||''',SYSDATE,0)';

            
         END IF;

        
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
         
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');
   

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
