--/*
--##########################################
--## AUTOR=Gabriel De Toni
--## FECHA_CREACION=20200805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10506
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en TBJ_TPE_TRANS_PEF_ESTADO
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
	
    V_ID NUMBER(16);
    V_ID_ESTADO_INICIAL NUMBER(16);
    V_ID_ESTADO_FINAL NUMBER(16);
    V_ID_PERFIL NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'TBJ_TPE_TRANS_PEF_ESTADO';
    V_TABLA_ESTADO VARCHAR2(50 CHAR):= 'DD_EST_ESTADO_TRABAJO';
    V_TABLA_PERFIL VARCHAR2(50 CHAR):= 'PEF_PERFILES';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-10506';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- INICIAL        FINAL            PERFIL 
      T_TIPO_DATA('03',		  	'CAN',       'HAYAGESACT'),
      T_TIPO_DATA('CUR',	  	'CAN',			 'HAYAGESACT'),
      T_TIPO_DATA('03',		  	'FIN',			 'HAYAPROV'),
      T_TIPO_DATA('CUR',			'FIN',			 'HAYAPROV'),
      T_TIPO_DATA('FIN',			'REJ',	 		 'HAYAGESACT'),
      T_TIPO_DATA('FIN',			'13',			   'HAYAGESACT'),
      T_TIPO_DATA('FIN',			'CAN',			 'HAYAGESACT'),
      T_TIPO_DATA('SUB',			'REJ',		 	 'HAYAGESACT'),
      T_TIPO_DATA('SUB',			'13',			   'HAYAGESACT'),
      T_TIPO_DATA('SUB',			'CAN',			 'HAYAGESACT'),
      T_TIPO_DATA('13',		  	'CAN',			 'HAYAGESACT')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Buscamos el id del estado inicial
      DBMS_OUTPUT.PUT_LINE('[INFO]: Buscamos el id del estado inicial');
      V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ESTADO||' WHERE DD_EST_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_ID_ESTADO_INICIAL;

      --Buscamos el id del estado final
      DBMS_OUTPUT.PUT_LINE('[INFO]: Buscamos el id del estado final');
      V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ESTADO||' WHERE DD_EST_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_ID_ESTADO_FINAL;

      --Buscamos el id del perfil
      DBMS_OUTPUT.PUT_LINE('[INFO]: Buscamos el id del perfil');
      V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PERFIL||' WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_ID_PERFIL;
      
      --Si existe lo modificamos
      IF V_ID_ESTADO_INICIAL > 0 AND V_ID_ESTADO_FINAL > 0 AND V_ID_PERFIL > 0 THEN				

        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
				TPE_ID, TPE_EST_INI, TPE_EST_FIN, PEF_ID, 
				VERSION, USUARIOCREAR, FECHACREAR)
          	SELECT 
	            '|| V_ID || ',
	            '||V_ID_ESTADO_INICIAL||',
	            '||V_ID_ESTADO_FINAL||',
	            '||V_ID_PERFIL||',
	            0, '''||V_USUARIO||''', SYSDATE FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
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
