--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210331
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9356
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9356';
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
    V_ACT_ORIGINAL NUMBER(16):= 7279034;
    
    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --Nº ACTIVO HAYA-TIPO DE ACTIVO-SUBTIPO DE ACTIVO-ESTADO FÍSICO-USO DOMINANTE-IPO DE VÍA-NOMBRE DE VÍA-Nº-ESCALERAPLANTA-PUERTA-PROVINCIA-MUNICIPIO-CÓDIGO POSTAL-	POBLACIÓN REGISTRO-Nº DE REGISTRO-TOMO-LIBRO-FOLIO-FINCA-IDUFIR/CRU-SUPERFICIE CONSTRUIDA-SUPERFICIE ÚTIL-GRADO PROPIEDAD-PROPIEDAD-REFERENCIA CATASTRAL-VPO (Si / No)-     PRECIO MÍNIMO-PRECIO VENTA WEB-VALOR TASACIÓN-FECHA TASACIÓN

	T_TIPO_DATA('7461428','02','09','03','01','CL','FINCA AMADO II','64-00','','BAJO','1','','','','','','2197','211','197','8373','38004001013949','76,54','66,81','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461427','02','09','03','01','CL','FINCA AMADO II','64-01','','BAJO','2A','','','','','','2197','211','199','8374','38008001013963','109,99','89,45','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461429','02','09','03','01','CL','FINCA AMADO II','63-B-00','','BAJO','3A','','','','','','2197','211','201','8375','30004001013987','74,77','66,70','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461430','02','09','03','01','CL','FINCA AMADO II','63-B-01','','BAJO','4A','','','','','','2197','211','203','8376','38004001013994','107,49','89,45','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461431','02','09','03','01','CL','FINCA AMADO II','63-A-00','','BAJO','5A','','','','','','2197','211','205','8377','38004001014014','76,54','66,81','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461432','02','09','03','01','CL','FINCA AMADO II','63-A-01','','BAJO','6A','','','','','','2197','211','207','8378','38004001014038','110,54','89,45','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461487','02','06','03','01','CL','FINCA AMADO II','54-A','','BAJO','1B','','','','','','2197','211','209','8379','38004001014045','228,85','189,84','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461488','02','06','03','01','CL','FINCA AMADO II','54-B','','BAJO','2B','','','','','','2197','211','211','8380','38004001014052','223,97','189,84','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461489','02','06','03','01','CL','FINCA AMADO II','54-C','','BAJO','3B','','','','','','2197','211','213','8381','38004001014069','223,97','189,84','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461490','02','06','03','01','CL','FINCA AMADO II','55-A','','BAJO','4B','','','','','','2197','211','215','8382','38004001014076','223,97','189,84','01','100','','NO','0,01','0,01','',''),
	T_TIPO_DATA('7461491','02','06','03','01','CL','FINCA AMADO II','55-B','','BAJO','5B','','','','','','2197','211','217','8383','38004001014083','228,85','189,84','01','100','','NO','0,01','0,01','','')

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
        
                V_MSQL :='UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION 
                SET BIE_LOC_PISO = '''||V_TMP_TIPO_DATA(10)||''',
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
