--/*
--##########################################
--## AUTOR=SANTI MONZÓ
--## FECHA_CREACION=20220512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17840
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en la tabla ACT_LGE_LOCALIZACION_GEST las relaciones entre las tablas DD_ELO_ESTADO_LOCALIZACION y DD_SEG_SUBESTADO_GESTION
--## INSTRUCCIONES: Lanzar, con cuidado de que no se rompa.
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-17840'; -- USUARIOCREAR/USUARIOMODIFICAR.
        
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_LGE_LOCALIZACION_GEST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_ELO_ID NUMBER(16); -- Vble. que guarda el id de de la tabla DD_ELO_ESTADO_LOCALIZACION.
	V_SEG_ID NUMBER(16); -- Vble. que guarda el id de de la tabla DD_SEG_SUBESTADO_GESTION.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    -------------(DD_ELO_CODIGO, DD_SEG_CODIGO)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('IDENT', 'PDTE_DOC'),
        T_TIPO_DATA('NOE', 'EN_CONST'),
        T_TIPO_DATA('NOE', 'SIN_CONST'),
        T_TIPO_DATA('NOE', 'NA'),
        T_TIPO_DATA('NOE', 'ED_CONST'),
        T_TIPO_DATA('NOE', 'SUELO'),
        T_TIPO_DATA('SDF', 'SDF'),
        T_TIPO_DATA('SDF', 'PUT'),
        T_TIPO_DATA('SDF', 'SINT'),
        T_TIPO_DATA('PDTE', 'GEST_LOC'),
        T_TIPO_DATA('IDENT', 'GEST_CP'),
        T_TIPO_DATA('IDENT', 'NGCO')
    ); 


    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

         
    -- LOOP para insertar los valores en '||V_TEXT_TABLA||' -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[FIN]: INSERCION EN '||V_TEXT_TABLA||'');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT DD_ELO_ID FROM '||V_ESQUEMA||'.DD_ELO_ESTADO_LOCALIZACION WHERE DD_ELO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_ELO_ID;
        
        V_SQL := 'SELECT DD_SEG_ID FROM '||V_ESQUEMA||'.DD_SEG_SUBESTADO_GESTION WHERE DD_SEG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_SEG_ID;
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_ELO_ID = '||V_ELO_ID||' AND DD_SEG_ID = '||V_SEG_ID||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS = 0 THEN                                
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (DD_ELO_ID, DD_SEG_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
						VALUES ('||V_ELO_ID||', '||V_SEG_ID||', 0, '''||V_USR||''', SYSDATE, 0)';
						
						DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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



   

