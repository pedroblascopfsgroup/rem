--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20171127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3214
--## PRODUCTO=NO
--##
--## Finalidad: Activos vendidos publicados
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
    V_ACT_ID NUMBER(32);
    V_ID_ACTIVO NUMBER(16);
	V_FECHA VARCHAR2(100 CHAR);
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('68892'),
        T_TIPO_DATA('77021'),
        T_TIPO_DATA('78141'),
        T_TIPO_DATA('192129'),
        T_TIPO_DATA('195199'),
        T_TIPO_DATA('195627'),
        T_TIPO_DATA('196536'),
        T_TIPO_DATA('165346'),
        T_TIPO_DATA('68707 '),
        T_TIPO_DATA('165438'),
        T_TIPO_DATA('142746'),
        T_TIPO_DATA('154714'),
        T_TIPO_DATA('155207'),
        T_TIPO_DATA('172831'),
        T_TIPO_DATA('195034'),
        T_TIPO_DATA('193373'),
        T_TIPO_DATA('147652'),
        T_TIPO_DATA('132281'),
        T_TIPO_DATA('156681'),
        T_TIPO_DATA('147654'),
        T_TIPO_DATA('132494'),
        T_TIPO_DATA('156154'),
        T_TIPO_DATA('156156'),
        T_TIPO_DATA('144586'),
        T_TIPO_DATA('156686')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_EPU_ID != 
        (SELECT DD_EPU_ID FROM '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION WHERE DD_EPU_CODIGO = ''06'')';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
                    
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;
        
            V_MSQL := 'SELECT DD_EPU_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_TEXT1;
            
            V_MSQL := 'SELECT TRUNC(FECHAMODIFICAR) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_FECHA;
        
            IF V_FECHA IS NULL THEN
                V_FECHA := SYSDATE;
            END IF;
        
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION (HEP_ID, ACT_ID, DD_EPU_ID, HEP_FECHA_HASTA, HEP_FECHA_DESDE, USUARIOCREAR, FECHACREAR) VALUES 
            ('||S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL||', '''||TRIM(V_ACT_ID)||''', '||V_TEXT1||', '''||SYSDATE||''', '''||V_FECHA||''', ''HREOS-3214'', '''||SYSDATE||''')';
            EXECUTE IMMEDIATE V_MSQL;
            
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_EPU_ID = (SELECT DD_EPU_ID FROM '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION WHERE DD_EPU_CODIGO = ''06'') WHERE ACT_NUM_ACTIVO  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL;
        	
            DBMS_OUTPUT.PUT_LINE('ACTIVO '''||TRIM(V_TMP_TIPO_DATA(1))||''' HA PASADO A NO PUBLICADO');

        ELSE
            DBMS_OUTPUT.PUT_LINE('ACTIVO '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA ESTABA NO PUBLICADO');
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