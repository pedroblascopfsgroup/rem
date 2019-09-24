--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5107
--## PRODUCTO=NO
--##
--## Finalidad: Inserta gestores para cartera 'Third Parties' y subcartera 'Yubai'
--## 		
--##		
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
    V_NUM NUMBER(16); -- Vble. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-5107';

    ---------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ---------------------------------
    V_DD_PRV_CODIGO NUMBER(2);	


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    V_TMP_TIPO_DATA T_TIPO_DATA;
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		
         T_TIPO_DATA( 'SFORM'  , 'psanchez' ),
         T_TIPO_DATA( 'GIAFORM', 'garsa03' ),
         T_TIPO_DATA( 'SUPEDI' , 'oderivas' ),
         T_TIPO_DATA( 'SCOM'   , 'dtacero' ),
         T_TIPO_DATA( 'SCOM'   , 'prodriguezg' ),
         T_TIPO_DATA( 'SPUBL'  , 'ndelaossa' )


    ); 

    V_TIPO_DATA_CCAA T_ARRAY_DATA := T_ARRAY_DATA(
    		
         T_TIPO_DATA( 'GCOM', '09', 'tvaloria' ),
         T_TIPO_DATA( 'GCOM', '04', 'tvaloria' ),
         T_TIPO_DATA( 'GCOM', '01', 'mluqueo' ),
         T_TIPO_DATA( 'GCOM', '05', 'mluqueo' ),
         T_TIPO_DATA( 'GCOM', '08', 'ygarciam' ),
         T_TIPO_DATA( 'GCOM', '11', 'ygarciam' ),
         T_TIPO_DATA( 'GCOM', '10', 'mjbondia' ),
         T_TIPO_DATA( 'GCOM', '14', 'mjbondia' ),
         T_TIPO_DATA( 'GCOM', '13', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '07', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '12', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '02', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '16', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '06', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '15', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '03', 'mantequera' ),
         T_TIPO_DATA( 'GCOM', '17', 'mantequera' )

    ); 



BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INFO] Tratando gestores sin provincia asociada: ');


    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

          V_MSQL := 'SELECT COUNT(1) 
		     FROM '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
		     WHERE 1 = 1
		     AND TIPO_GESTOR = ''' || TRIM( V_TMP_TIPO_DATA(1) ) || '''
		     AND COD_CARTERA = 11
		     AND COD_SUBCARTERA = 139
		     AND COD_PROVINCIA IS NULL
		     AND COD_MUNICIPIO IS NULL
		     AND COD_POSTAL IS NULL
		     AND USERNAME = ''' || TRIM( V_TMP_TIPO_DATA(2) ) || '''
		     AND BORRADO = 0 ';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
        			
	  -- Existe el registro ?
	  IF ( V_NUM = 0 ) THEN
  
         -- V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
         -- EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

	  V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                      	(ID, 
                      	TIPO_GESTOR, 
                      	COD_CARTERA, 
			COD_SUBCARTERA,
                      	USERNAME,
                      	COD_PROVINCIA, 
                      	COD_MUNICIPIO, 
                      	COD_POSTAL,  
                      	NOMBRE_USUARIO, 
                      	VERSION, 
                      	USUARIOCREAR, 
                      	FECHACREAR, 
                      	BORRADO) 
                      	SELECT 
			'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                      	''' || TRIM( V_TMP_TIPO_DATA(1) ) || ''', 
			11,
			139,
			'''||TRIM(V_TMP_TIPO_DATA(2))||''',
			null,
			null, 
			null, 
			(SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 
			 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU 
			 WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
			 0,
			 '''||V_USU||''',
			 SYSDATE,
			 0 FROM DUAL';
			
	   EXECUTE IMMEDIATE V_MSQL;

           DBMS_OUTPUT.PUT_LINE('[INFO] Insertando gestor '||TRIM(V_TMP_TIPO_DATA(2))||' de tipo ' ||TRIM(V_TMP_TIPO_DATA(1))  );

	ELSE

           DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe gestor '||TRIM(V_TMP_TIPO_DATA(2))||' de tipo ' ||TRIM(V_TMP_TIPO_DATA(1))  );

	END IF;	
      
      END LOOP;

--------------------------------------------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE('[INFO] Tratando gestores asociados a provincias-- ');

    FOR I IN V_TIPO_DATA_CCAA.FIRST .. V_TIPO_DATA_CCAA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA_CCAA(I);

	   V_MSQL := ' SELECT PRV.DD_PRV_CODIGO
		       FROM '|| V_ESQUEMA_M ||'.DD_CCA_COMUNIDAD CCA, '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA PRV
		       WHERE CCA.DD_CCA_ID = PRV.DD_CCA_ID
		       AND CCA.DD_CCA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' ';
			
      	   OPEN v_cursor FOR V_MSQL;

      	   LOOP

            FETCH v_cursor INTO V_DD_PRV_CODIGO ;
            EXIT WHEN v_cursor%NOTFOUND;
	
            V_MSQL := 'SELECT COUNT(1) 
		       FROM '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
		       WHERE 1 = 1
		       AND TIPO_GESTOR = ''' || TRIM( V_TMP_TIPO_DATA(1) ) || '''
		       AND COD_CARTERA = 11
		       AND COD_SUBCARTERA = 139
		       AND COD_PROVINCIA = ' || V_DD_PRV_CODIGO || '
		       AND COD_MUNICIPIO IS NULL
		       AND COD_POSTAL IS NULL
		       AND USERNAME = ''' || TRIM( V_TMP_TIPO_DATA(3) ) || '''
		       AND BORRADO = 0 ';

          EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
        			
	  -- Existe el registro ?
	  IF ( V_NUM = 0 ) THEN 

     	     V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                      	(ID, 
                      	TIPO_GESTOR, 
                      	COD_CARTERA, 
			COD_SUBCARTERA,
                      	USERNAME,
                      	COD_PROVINCIA, 
                      	COD_MUNICIPIO, 
                      	COD_POSTAL,  
                      	NOMBRE_USUARIO, 
                      	VERSION, 
                      	USUARIOCREAR, 
                      	FECHACREAR, 
                      	BORRADO) 
                      	SELECT 
			'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                      	''' || TRIM( V_TMP_TIPO_DATA(1) ) || ''', 
			11,
			139,
			'''||TRIM(V_TMP_TIPO_DATA(3))||''',
			' || V_DD_PRV_CODIGO || ',
			null, 
			null, 
			(SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 
			 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU 
			 WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),
			 0,
			 '''||V_USU||''',
			 SYSDATE,
			 0 
			 FROM DUAL';
			
	      EXECUTE IMMEDIATE V_MSQL;

              DBMS_OUTPUT.PUT_LINE('[INFO] Insertando gestor '||TRIM(V_TMP_TIPO_DATA(2))||' de tipo ' ||TRIM(V_TMP_TIPO_DATA(1)) || ' en provincia ' || V_DD_PRV_CODIGO );

	     ELSE

              DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe gestor '||TRIM(V_TMP_TIPO_DATA(2))||' de tipo ' ||TRIM(V_TMP_TIPO_DATA(1)) || ' en provincia ' || V_DD_PRV_CODIGO );

	    END IF;	

	END LOOP;
      
      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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
