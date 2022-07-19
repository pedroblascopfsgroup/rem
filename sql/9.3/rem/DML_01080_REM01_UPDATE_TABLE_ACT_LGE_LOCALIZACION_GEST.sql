--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20220720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18402
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra lógicamente en ACT_LGE_LOCALIZACION_GEST los datos añadidos en T_ARRAY_DATA
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
    DD_SEG_ID NUMBER(16);
    DD_ELO_ID NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_LGE_LOCALIZACION_GEST';  -- Tabla a modificar  
    V_TABLA_DD_SEG VARCHAR2(30 CHAR) := 'DD_SEG_SUBESTADO_GESTION';
    V_TABLA_DD_ELO VARCHAR2(30 CHAR) := 'DD_ELO_ESTADO_LOCALIZACION';
    V_USR VARCHAR2(30 CHAR) := 'HREOS-18402'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_CDG VARCHAR2(30 CHAR) := 'SEG';
    V_CDG_ELO VARCHAR2(30 CHAR) := 'ELO';
      
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

       	T_TIPO_DATA('IDENT','PDTE_DOC'),
        T_TIPO_DATA('IDENT','GEST_CP'),
        T_TIPO_DATA('IDENT','NGCO')
	    
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para borrar lógicamente los valores en ACT_LGE_LOCALIZACION_GEST -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR LOGICAMENTE EN '||V_TABLA||'] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Obtenemos el DD_SEG_ID
        V_SQL := 'SELECT DD_SEG_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SEG||' WHERE DD_'||V_CDG||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO DD_SEG_ID;

        --Obtenemos el DD_ELO_ID
        V_SQL := 'SELECT DD_ELO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_ELO||' WHERE DD_'||V_CDG_ELO||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO DD_ELO_ID;

          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS CON DD_SEG_ID = '''|| DD_SEG_ID ||''' y DD_ELO_ID = '''|| DD_ELO_ID ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' '||
                  	'SET BORRADO = 1,				   	
					USUARIOBORRAR = '''||V_USR||''', 
                    FECHABORRAR = SYSDATE 
					WHERE DD_SEG_ID = '''||DD_SEG_ID||'''
          AND DD_ELO_ID = '''||DD_ELO_ID||'''';
                   
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

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
