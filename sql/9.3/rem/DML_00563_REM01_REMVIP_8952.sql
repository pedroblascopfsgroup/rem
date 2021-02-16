--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20210215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8952
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##
--##########################################-
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
	
    V_TABLA VARCHAR2(50 CHAR):= 'CVD_CONF_DOC_OCULTAR_PERFIL';
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-8952';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- MATRICULA  			      PERFIL                        
        T_TIPO_DATA('AI-03-PRES-15' ,'CARTERA_BBVA'),
        T_TIPO_DATA('AI-03-PRES-01' ,'CARTERA_BBVA')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos Dato '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
      --Comprobamos el dato a insertar
      V_SQL :=   'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
				 AND DD_TDO_ID in (SELECT DD_TDO_ID FROM '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD  WHERE DD_TDO_MATRICULA  = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
         
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
      
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Insertado ANTERIORMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS');   
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (CVD_ID,PEF_ID,DD_TDO_ID,USUARIOCREAR,FECHACREAR,BORRADO) 
            SELECT S_'||V_TABLA||'.NEXTVAL,
            (SELECT PEF_ID FROM '|| V_ESQUEMA ||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
            DD_TDO_ID,
            ''HREOS-13072'',
            SYSDATE,
            0
            FROM '|| V_ESQUEMA ||'.DD_TDO_TIPO_DOC_ENTIDAD WHERE DD_TDO_MATRICULA in ('''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')';
        EXECUTE IMMEDIATE V_MSQL;
       
      
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
