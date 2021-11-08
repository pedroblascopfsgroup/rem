--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210915
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15045
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CVD_CONF_DOC_OCULTAR_PERFIL los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##
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
    V_TABLA VARCHAR2(50 CHAR):= 'CVD_CONF_DOC_OCULTAR_PERFIL';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-15045';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- MATRICULA  			      PERFIL                        
        T_TIPO_DATA('AI-15-FACT-AM' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AK' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AJ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AI' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AH' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AG' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AF' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AE' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AD' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AC' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AB' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-AA' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-99' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-98' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-97' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-96' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-95' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-94' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-93' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-92' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-91' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-90' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-89' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-88' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-87' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-86' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-85' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-84' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-83' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-82' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-81' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-80' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-79' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-78' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-77' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-76' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-75' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-74' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-71' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-70' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-69' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-68' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-67' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-66' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-65' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-63' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-62' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-61' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-60' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-59' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-58' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-45' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-44' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-43' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-FACT-42' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CP' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CN' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CM' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CL' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CK' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CJ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CI' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CH' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CG' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CF' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CE' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CD' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CC' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CB' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-CA' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BZ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BY' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BX' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BW' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BV' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BU' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BT' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BS' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BR' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BQ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BP' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BO' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BN' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BM' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BL' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BK' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BJ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BI' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BH' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BG' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BF' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BE' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BD' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-BA' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AZ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AY' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AX' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AW' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AV' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AU' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AS' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AR' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AQ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AP' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AO' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AN' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-AA' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-99' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-98' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-15-CERA-97' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-10-CERT-26' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-09-ESIN-45' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-05-FOTO-01' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-05-CERJ-85' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-04-TASA-29' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-03-ESIN-BZ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-02-ESIN-97' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-02-CNCV-40' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-02-CERJ-AR' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-02-CERJ-AQ' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-02-CERJ-43' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-01-FACT-10' ,'USUARIOS_BC'),
        T_TIPO_DATA('AI-01-ESIN-BR' ,'USUARIOS_BC')

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
         
       DBMS_OUTPUT.PUT_LINE(V_SQL);
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
            ''HREOS-15045'',
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
