--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20170510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1975
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		--  	TGE	   CRA	EAC  TCR	PRV	 LOC  POSTAL	USERNAME
    		
-- GRUPO GESTORES --
   --------------
   
-- GRUPO - GESTORES ADMISIÓN 
		T_TIPO_DATA('GADM'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'GESTADM'),
		
-- GRUPO - GESTORES PUBLICACIÓN 		
		T_TIPO_DATA('GPUBL'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'GESTPUBL'),

-- GRUPO - GESTORES PRECIOS
		T_TIPO_DATA('GPREC'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'GESTPREC'),
		
-- GRUPO - GESTORES ADMINISTRACIÓN
		T_TIPO_DATA('GADMT'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'HAYAADM'),
		
-- GRUPO - GESTORES CALIDAD		
		T_TIPO_DATA('GCAL'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'HAYACAL'),

-- GRUPO - GESTORES LLAVES		
		T_TIPO_DATA('GLLA'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'HAYALLA'),

		
-- GRUPO SUPERVISORES --
   ------------------
   
	-- GRUPO - SUPERVISORES ADMINISTRACIÓN		
		T_TIPO_DATA('SADM'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'HAYASADM'),
		
	-- GRUPO - SUPERVISORES ADMISIÓN		
		T_TIPO_DATA('SUPADM'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'SUPADM'),
				
	-- GRUPO - SUPERVISORES CALIDAD		
		T_TIPO_DATA('GCOMSIN'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'HAYASUPCAL'),
						
	-- GRUPO - SUPERVISORES PUBLICACIÓN		
		T_TIPO_DATA('SPUBL'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'SUPPUBL'),
								
	-- GRUPO - SUPERVISORES PRECIOS		
		T_TIPO_DATA('SPREC'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'SUPPREC'),
		
	-- GRUPO - SUPERVISORES FORMALIZACIÓN		
		T_TIPO_DATA('SFORM'  ,'NULL'  ,''  ,''  , 'NULL'  ,''  ,''  ,'SUPFORM'),
		
	/*		
	-- GRUPO - SUPERVISORES ACTIVO SUELO	
		T_TIPO_DATA('SUPACT'  ,''  ,'01'  ,''  , ''  ,''  ,''  ,'jcordoba'),
		
	-- GRUPO - SUPERVISORES ACTIVO RESTO	
		T_TIPO_DATA('SUPACT'  ,''  ,'02'  ,''  , ''  ,''  ,''  ,'---------'),
		T_TIPO_DATA('SUPACT'  ,''  ,'03'  ,''  , ''  ,''  ,''  ,'---------'),
		T_TIPO_DATA('SUPACT'  ,''  ,'04'  ,''  , ''  ,''  ,''  ,'---------'),
		T_TIPO_DATA('SUPACT'  ,''  ,'05'  ,''  , ''  ,''  ,''  ,'---------'),
		T_TIPO_DATA('SUPACT'  ,''  ,'06'  ,''  , ''  ,''  ,''  ,'---------'),
	*/
		
	
		
-- GESTORES COMERCIALES BACKOFFICE CAJAMAR --
   ---------------------------------------
   
		T_TIPO_DATA('GCBO'  ,'01'  ,''  ,''  , 'NULL'  ,''  ,''  ,'asalag'),
		T_TIPO_DATA('GCBO'  ,'01'  ,''  ,''  , 'NULL'  ,''  ,''  ,'ateruel'),
		T_TIPO_DATA('GCBO'  ,'01'  ,''  ,''  , 'NULL'  ,''  ,''  ,'gcarbonell'),
		T_TIPO_DATA('GCBO'  ,'01'  ,''  ,''  , 'NULL'  ,''  ,''  ,'igomezr'),
		T_TIPO_DATA('GCBO'  ,'01'  ,''  ,''  , 'NULL'  ,''  ,''  ,'jcardenal'),
		T_TIPO_DATA('GCBO'  ,'01'  ,''  ,''  , 'NULL'  ,''  ,''  ,'mmaldonado'),
		T_TIPO_DATA('GCBO'  ,'01'  ,''  ,''  , 'NULL'  ,''  ,''  ,'rsanchez'),
		
		
-- GESTORES CAPA CONTROL BANKIA --	
   ----------------------------
   	
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A107937'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A149429'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A104218'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A133647'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A107592'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A112826'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A104392'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A154454'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A117866'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A105194'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A027805'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A110337'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A136045'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A127543'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A110141'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A117521'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A135765'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'mpastorg'),
		T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , 'NULL'  ,''  ,''  ,'A122400')
		--T_TIPO_DATA('GCCBANKIA'  ,'03'  ,''  ,''  , ''  ,''  ,''  ,'--------')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- TRUNCATE - Primer script de carga, por tanto podemos truncarla, el resto que siguen a este, no hacermos un truncate.
	-- Mientras sea una tabla de configuración de la que extraemos información y no haya ninguna FK apuntando a su id, 
    -- podemos borrar la tabla completa y volver a generar la configuración.
    V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');

	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = ''HREOS-1683'' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''','||V_TMP_TIPO_DATA(5)||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, ''HREOS-1683'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
       END IF;
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