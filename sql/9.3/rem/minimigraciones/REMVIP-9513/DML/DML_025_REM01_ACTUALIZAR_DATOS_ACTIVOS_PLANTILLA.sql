--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210421
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9513
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9513';
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
    V_ACT_ORIGINAL NUMBER(16):= 7264097;
    
    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --Nº ACTIVO HAYA-TIPO DE ACTIVO-SUBTIPO DE ACTIVO-ESTADO FÍSICO-USO DOMINANTE-IPO DE VÍA-NOMBRE DE VÍA-Nº-ESCALERAPLANTA-PUERTA-PROVINCIA-MUNICIPIO-CÓDIGO POSTAL-	POBLACIÓN REGISTRO-Nº DE REGISTRO-TOMO-LIBRO-FOLIO-FINCA-IDUFIR/CRU-SUPERFICIE CONSTRUIDA-SUPERFICIE ÚTIL-GRADO PROPIEDAD-PROPIEDAD-REFERENCIA CATASTRAL-VPO (Si / No)-     PRECIO MÍNIMO-PRECIO VENTA WEB-VALOR TASACIÓN-FECHA TASACIÓN
        T_TIPO_DATA('7462324','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','1','8','08033','08140','08096','2','3289','348','162','12869','08078000769526','15,64','11,52','01','100','','No','','','',''),
        T_TIPO_DATA('7462325','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','4','8','08033','08140','08096','2','3289','348','165','12870','08078000769533','6,21','4,71','01','100','','No','','','',''),
        T_TIPO_DATA('7462326','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','5','8','08033','08140','08096','2','3289','348','168','12871','08078000769540','6,19','4,67','01','100','','No','','','',''),
        T_TIPO_DATA('7462327','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','6','8','08033','08140','08096','2','3289','348','171','12872','08078000769557','5,5','4,77','01','100','','No','','','',''),
        T_TIPO_DATA('7462328','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','7','8','08033','08140','08096','2','3289','348','174','12873','08078000769564','5,5','4,77','01','100','','No','','','',''),
        T_TIPO_DATA('7462329','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','10','8','08033','08140','08096','2','3289','348','177','12874','08078000769271','5,54','4,77','01','100','','No','','','',''),
        T_TIPO_DATA('7462330','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','11','8','08033','08140','08096','2','3289','348','180','12875','08078000769588','7,89','4,39','01','100','','No','','','',''),
        T_TIPO_DATA('7462331','07','25','03','05','CL','GUSTAVO ADOLFO BEQUER','1','','-2','12','8','08033','08140','08096','2','3289','348','183','12876','08078000769595','5,97','4,16','01','100','','No','','','','')

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

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'''');

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
    /*
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

	END IF;*/
        
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
