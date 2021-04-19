--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210414
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9474
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR DATOS ACTIVOS
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE

    -- Esquemas
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9474';
    -- Tablas
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):= 'ACT_ACTIVO';
    V_TABLA_LOC  VARCHAR2(100 CHAR):= 'ACT_LOC_LOCALIZACION';
    V_TABLA_REG  VARCHAR2(100 CHAR):= 'ACT_REG_INFO_REGISTRAL';
    V_TABLA_CAT  VARCHAR2(100 CHAR):= 'ACT_CAT_CATASTRO';
    V_TABLA_PAC  VARCHAR2(100 CHAR):= 'ACT_PAC_PERIMETRO_ACTIVO';
    
    -- IDs
    V_ID NUMBER(16);
    V_BIE_LOC NUMBER(16);
    V_BIE_REG NUMBER(16);
    V_ACT_ORIGINAL NUMBER(16):= 7268083;
    
    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --Nº ACTIVO HAYA-TIPO DE ACTIVO-SUBTIPO DE ACTIVO-ESTADO FÍSICO-USO DOMINANTE-IPO DE VÍA-NOMBRE DE VÍA-Nº-ESCALERAPLANTA-PUERTA-PROVINCIA-MUNICIPIO-CÓDIGO POSTAL-	POBLACIÓN REGISTRO-Nº DE REGISTRO-TOMO-LIBRO-FOLIO-FINCA-IDUFIR/CRU-SUPERFICIE CONSTRUIDA-SUPERFICIE ÚTIL-GRADO PROPIEDAD-PROPIEDAD-REFERENCIA CATASTRAL-VPO (Si / No)-     PRECIO MÍNIMO-PRECIO VENTA WEB-VALOR TASACIÓN-FECHA TASACIÓN
        T_TIPO_DATA('7462148','03','13','03','07','CL','FERRAN RAMBLA','9','','BAJO','','25','25120','25007','25120','1','3038','2185','123','103856','25010001024614','153','139','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462149','03','13','03','07','CL','FERRAN RAMBLA','9','','ALTILLO','','25','25120','25007','25120','1','3038','2185','126','103857','25010001024621','178','167,54','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462150','02','09','03','01','CL','FERRAN RAMBLA','9','','1','1','25','25120','25007','25120','1','3038','2185','129','103858','25010001024690','36','30,3','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462151','02','09','03','01','CL','FERRAN RAMBLA','9','','1','2','25','25120','25007','25120','1','3038','2185','132','103859','25010001024706','37','30,7','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462152','02','09','03','01','CL','FERRAN RAMBLA','9','','1','3','25','25120','25007','25120','1','3038','2185','135','103860','25010001024713','55','47,4','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462153','02','09','03','01','CL','FERRAN RAMBLA','9','','1','4','25','25120','25007','25120','1','3038','2185','138','103861','25010001024720','38','32,3','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462154','02','09','03','01','CL','FERRAN RAMBLA','9','','2','1','25','25120','25007','25120','1','3038','2185','141','103862','25010001024737','36','30,3','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462155','02','09','03','01','CL','FERRAN RAMBLA','9','','2','2','25','25120','25007','25120','1','3038','2185','144','103863','25010001024744','37','30,7','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462156','02','09','03','01','CL','FERRAN RAMBLA','9','','2','3','25','25120','25007','25120','1','3038','2185','147','103864','25010001024751','55','47,4','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462157','02','09','03','01','CL','FERRAN RAMBLA','9','','2','4','25','25120','25007','25120','1','3038','2185','150','103865','25010001024768','38','32,3','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462158','02','09','03','01','CL','FERRAN RAMBLA','9','','3','1','25','25120','25007','25120','1','3038','2185','153','103866','25010001024775','36','30,3','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462159','02','09','03','01','CL','FERRAN RAMBLA','9','','3','2','25','25120','25007','25120','1','3038','2185','156','103867','25010001024782','37','30,7','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462160','02','09','03','01','CL','FERRAN RAMBLA','9','','3','3','25','25120','25007','25120','1','3038','2185','159','103868','25010001024799','55','47,4','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462161','02','09','03','01','CL','FERRAN RAMBLA','9','','3','4','25','25120','25007','25120','1','3038','2185','162','103869','25010001024805','38','32,3','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462162','02','09','03','01','CL','FERRAN RAMBLA','9','','4','1','25','25120','25007','25120','1','3038','2185','165','103870','25010001024812','63','51','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462163','02','09','03','01','CL','FERRAN RAMBLA','9','','4','2','25','25120','25007','25120','1','3038','2185','168','103871','25010001024849','37','30,7','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462164','02','09','03','01','CL','FERRAN RAMBLA','9','','4','3','25','25120','25007','25120','1','3038','2185','171','103872','25010001024836','55','47,4','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462165','02','09','03','01','CL','FERRAN RAMBLA','9','','4','4','25','25120','25007','25120','1','3038','2185','174','103873','25010001024843','38','32,3','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462166','02','09','03','01','CL','FERRAN RAMBLA','9','','5','1','25','25120','25007','25120','1','3038','2185','177','103874','25010001024850','103','84,05','01','100','No','0,01','0,01','',''),
        T_TIPO_DATA('7462167','02','09','03','01','CL','FERRAN RAMBLA','9','','5','2','25','25120','25007','25120','1','3038','2185','180','103875','25010001024867','38','32,3','01','100','No','0,01','0,01','','')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- INFO --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS DIVISION HORIZONTAL');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Obtener ACT_ID a través del ACT_NUM_ACTIVO
        V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          
        --Comprobar si existe en la tabla el activo.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN

                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' 
                SET DD_TPA_ID = (SELECT DD_TPA_ID FROM REM01.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                DD_SAC_ID = (SELECT DD_SAC_ID FROM REM01.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
                DD_TUD_ID =  (SELECT DD_TUD_ID FROM REM01.DD_TUD_TIPO_USO_DESTINO WHERE DD_TUD_CODIGO = '''||V_TMP_TIPO_DATA(5)||'''),
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' no existe');

	END IF;
	        
        --Comprobar si existe en la tabla el activo.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_LOC||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
        
		--Comprobar si existe en la tabla el activo.
		V_MSQL := 'SELECT BIE_LOC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_LOC||' WHERE ACT_ID = '''||V_ID||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_BIE_LOC;
        
                V_MSQL :='UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION SET
                BIE_LOC_DIRECCION = '''||V_TMP_TIPO_DATA(7)||''',
                BIE_LOC_NUMERO_DOMICILIO = '''||V_TMP_TIPO_DATA(8)||''',
                BIE_LOC_PORTAL = '''||V_TMP_TIPO_DATA(8)||''',
                BIE_LOC_PISO = '''||V_TMP_TIPO_DATA(10)||''',
                BIE_LOC_PUERTA = '''||V_TMP_TIPO_DATA(11)||''',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE BIE_LOC_ID = '||V_BIE_LOC||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||''' EN LA TABLA BIE_LOC');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' no existe');

	END IF;
	
	--Comprobar si existe en la tabla el activo.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_REG||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
	 IF V_NUM_TABLAS > 0 THEN
	
		--Comprobar si existe en la tabla el activo.
		V_MSQL := 'SELECT BIE_DREG_ID FROM '||V_ESQUEMA||'.'||V_TABLA_REG||' WHERE ACT_ID = '''||V_ID||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_BIE_REG;
        
                V_MSQL :='UPDATE '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES  
                SET BIE_DREG_FOLIO = '''||V_TMP_TIPO_DATA(19)||''',
                BIE_DREG_NUM_FINCA = '''||V_TMP_TIPO_DATA(20)||''',
                BIE_DREG_REFERENCIA_CATASTRAL = '''||V_TMP_TIPO_DATA(26)||''',
                BIE_DREG_SUPERFICIE_CONSTRUIDA = '''||V_TMP_TIPO_DATA(22)||''',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE BIE_DREG_ID = '||V_BIE_REG||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||''' EN LA TABLA BIE_DATOS_REGISTRALES');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' no existe');

	END IF;
	
	--Comprobar si existe en la tabla el activo.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_REG||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
        
        IF V_NUM_TABLAS > 0 THEN

                V_MSQL :='UPDATE '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL   
                SET REG_IDUFIR = '''||V_TMP_TIPO_DATA(21)||''',
                REG_SUPERFICIE_UTIL = '''||V_TMP_TIPO_DATA(23)||''',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||''' EN LA TABLA ACT_REG_INFO_REGISTRAL');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' no existe');

	END IF;
	
	--Comprobar si existe en la tabla el activo.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_CAT||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
        
        IF V_NUM_TABLAS > 0 THEN

                V_MSQL :='UPDATE '||V_ESQUEMA||'.ACT_CAT_CATASTRO   
                SET CAT_REF_CATASTRAL = '''||V_TMP_TIPO_DATA(26)||''',
                CAT_SUPERFICIE_CONSTRUIDA = '''||V_TMP_TIPO_DATA(22)||''',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||''' EN LA TABLA ACT_CAT_CATASTRO');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' no existe');

	END IF;

END LOOP;
      
    DBMS_OUTPUT.PUT_LINE('[INFO]: SACAMOS DE PERIMETRO EL ACTIVO '||V_ACT_ORIGINAL||' Y HACEMOS UN BORRADO LOGICO');
      
    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||V_ACT_ORIGINAL||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID;
    DBMS_OUTPUT.PUT_LINE(V_ID);
        
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PAC||' WHERE ACT_ID = '''||V_ID||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE(V_ID);
    IF V_NUM_TABLAS > 0 THEN
      	  
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC SET
							  PAC_INCLUIDO = 0
								, PAC_CHECK_TRA_ADMISION = 0
								, PAC_CHECK_GESTIONAR = 0
								, PAC_CHECK_ASIGNAR_MEDIADOR = 0
								, PAC_CHECK_COMERCIALIZAR = 0
								, PAC_CHECK_PUBLICAR = 0
								, PAC_CHECK_FORMALIZAR = 0
								, PAC_CHECK_ADMISION = 0
								, USUARIOMODIFICAR  = '''||V_USUARIO||''' 
		  						, FECHAMODIFICAR    = SYSDATE 
							WHERE PAC.ACT_ID = '||V_ID||'';
							
		EXECUTE IMMEDIATE V_MSQL;
							
		DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado EL ACTIVO '||V_ACT_ORIGINAL||' EN LA TABLA ACT_PAC_PERIMETRO_ACTIVO, SE HAN QUITADO TODOS LOS CHECKS');

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET
								USUARIOBORRAR = '''||V_USUARIO||''',
		  						FECHABORRAR = SYSDATE,
                                BORRADO = 1
							WHERE ACT_ID = '||V_ID||'';
							
		EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha borrado de manera lógica EL ACTIVO '||V_ACT_ORIGINAL||'');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: El activo  '||V_ACT_ORIGINAL||'  no existe');

	END IF;
        
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Activos MODIFICADOS con éxito');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
