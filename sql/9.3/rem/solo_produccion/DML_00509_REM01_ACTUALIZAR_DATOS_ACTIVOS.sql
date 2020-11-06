--/*
--#########################################
--## AUTOR=vIOREL rEMUS oVIDIU
--## FECHA_CREACION=20201103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8257
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_8257';
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
    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('7397445','07','24','05','-1','1','57','28060','17017000657028','','10,92','2862217EG0226S0001KA'),
	T_TIPO_DATA('7397446','07','24','05','-1','2','60','28061','17017000657035','','21,38','2862217EG0226S0002LS'),
	T_TIPO_DATA('7397447','07','24','05','-1','3','63','28062','17017000657042','','11,55','2862217EG0226S0003BD'),
	T_TIPO_DATA('7397448','07','24','05','-1','4','66','28063','17017000657059','','11,11','2862217EG0226S0004ZF'),
	T_TIPO_DATA('7397449','07','24','05','-1','5','69','28064','17017000657066','','11,54','2862217EG0226S0005XG'),
	T_TIPO_DATA('7397450','07','24','05','-1','6','72','28065','17017000657073','','10,92','2862217EG0226S0006MH'),
	T_TIPO_DATA('7397451','07','24','05','-1','7','75','28066','17017000657080','','10,92','2862217EG0226S0007QJ'),
	T_TIPO_DATA('7397452','07','25','05','BAJO','1','78','28067','17017000657097','','4,16','2862217EG0226S0008WK'),
	T_TIPO_DATA('7397453','07','25','05','BAJO','2','81','28068','17017000657103','','3,94','2862217EG0226S0009EL'),
	T_TIPO_DATA('7397454','07','25','05','BAJO','3','84','28069','17017000657110','','5,78','2862217EG0226S0010QJ'),
	T_TIPO_DATA('7397455','07','25','05','BAJO','4','87','28070','17017000657124','','6,05','2862217EG0226S0011WK'),
	T_TIPO_DATA('7397456','03','13','07','BAJA','','90','28071','17017000657134','85,83','73,80','2862217EG0226S0012EL'),
	T_TIPO_DATA('7397457','02','09','01','1','1','93','28072','17017000657141','86,57','72,98','2862217EG0226S0013RB'),
	T_TIPO_DATA('7397458','02','09','01','1','2','96','28073','17017000657158','56,80','48,54','2862217EG0226S0014TZ'),
	T_TIPO_DATA('7397459','02','09','01','1','3','99','28074','17017000657165','74,14','62,08','2862217EG0226S0015YX'),
	T_TIPO_DATA('7397460','02','10','01','2','1','102','28075','17017000657172','76,91','61,98','2862217EG0226S0016UM'),
	T_TIPO_DATA('7397461','02','10','01','2','2','105','28076','17017000657189','65,03','55,08','2862217EG0226S0017IQ'),
	T_TIPO_DATA('7397462','02','10','01','2','3','108','28077','17017000657196','91,95','75,36','2862217EG0226S0018OW'),
	T_TIPO_DATA('7397463','02','09','01','2','4','111','28078','17017000657202','70,38','57,77','2862217EG0226S0019PE')

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
                DD_TUD_ID =  (SELECT DD_TUD_ID FROM REM01.DD_TUD_TIPO_USO_DESTINO WHERE DD_TUD_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''),
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
                SET BIE_LOC_PISO = '''||V_TMP_TIPO_DATA(5)||''',
                BIE_LOC_PUERTA = '''||V_TMP_TIPO_DATA(6)||''',
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
                SET BIE_DREG_FOLIO = '''||V_TMP_TIPO_DATA(7)||''',
                BIE_DREG_NUM_FINCA = '''||V_TMP_TIPO_DATA(8)||''',
                BIE_DREG_REFERENCIA_CATASTRAL = '''||V_TMP_TIPO_DATA(12)||''',
                BIE_DREG_SUPERFICIE_CONSTRUIDA = '''||V_TMP_TIPO_DATA(10)||''',
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
                SET REG_IDUFIR = '''||V_TMP_TIPO_DATA(9)||''',
                REG_SUPERFICIE_UTIL = '''||V_TMP_TIPO_DATA(11)||''',
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
                SET CAT_REF_CATASTRAL = '''||V_TMP_TIPO_DATA(12)||''',
                CAT_SUPERFICIE_CONSTRUIDA = '''||V_TMP_TIPO_DATA(10)||''',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||''' EN LA TABLA ACT_CAT_CATASTRO');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' no existe');

	END IF;

END LOOP;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: SACAMOS DE PERIMETRO EL ACTIVO 7265361 Y HACEMOS UN BORRADO LOGICO');
      
      --Obtener ACT_ID a través del ACT_NUM_ACTIVO
        V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = 7265361';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
        DBMS_OUTPUT.PUT_LINE(V_ID);
          
        --Comprobar si existe en la tabla el activo.
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
								, USUARIOMODIFICAR  = '''||V_USUARIO||''' 
		  						, FECHAMODIFICAR    = SYSDATE 
							WHERE PAC.ACT_ID = '||V_ID||'';
							
		EXECUTE IMMEDIATE V_MSQL;
							
		DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado EL ACTIVO 7265361 EN LA TABLA ACT_PAC_PERIMETRO_ACTIVO');
		
		V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' 
                SET BORRADO = 1,
                USUARIOBORRAR = '''||V_USUARIO||''', 
                FECHABORRAR = SYSDATE 
                WHERE ACT_NUM_ACTIVO = 7265361';
                
                EXECUTE IMMEDIATE V_MSQL;
                
                DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha BORRADO EL ACTIVO 7265361');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: El activo  7265361  no existe');

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
