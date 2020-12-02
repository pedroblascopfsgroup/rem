--/*
--#########################################
--## AUTOR=vIOREL rEMUS oVIDIU
--## FECHA_CREACION=20201201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8437
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8437';
    -- Tablas
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):= 'ACT_ACTIVO';
    V_TABLA_TAS  VARCHAR2(100 CHAR):= 'ACT_TAS_TASACION';
    V_TABLA_BIE_VAL  VARCHAR2(100 CHAR):= 'BIE_VALORACIONES';
    V_TABLA_ACT_VAL  VARCHAR2(100 CHAR):= 'ACT_VAL_VALORACIONES';
    -- IDs
    V_ID NUMBER(16);
    V_BIE_ID NUMBER(16);
    V_BIE_LOC NUMBER(16);
    V_BIE_REG NUMBER(16);
    V_BIE_VAL_ID NUMBER(16);
    
    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --Nº ACTIVO -PRECIO VENTA WEB-VALOR TASACIÓN-FECHA TASACIÓN
	T_TIPO_DATA('7403180','290000','244188','04/09/2017'),
	T_TIPO_DATA('7403181','445000','488101','04/09/2017'),
	T_TIPO_DATA('7403182','465000','503679','04/09/2017'),
	T_TIPO_DATA('7403183','470000','519257','04/09/2017'),
	T_TIPO_DATA('7403184','475000','534834','04/09/2017'),
	T_TIPO_DATA('7403185','490000','550412','04/09/2017')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- INFO --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR/INSERTAR TASACIONES');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Obtener ACT_ID a través del ACT_NUM_ACTIVO
        V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
        
        --Obtener BIE_ID a través del ACT_NUM_ACTIVO
        V_MSQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_BIE_ID;
          
        --Comprobar si existe en la tabla BIE_VALORACIONES.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_BIE_VAL||' WHERE BIE_ID = '''||V_BIE_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN

                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_BIE_VAL||' 
                SET BIE_IMPORTE_VALOR_TASACION =  '||V_TMP_TIPO_DATA(3)||',
                BIE_FECHA_VALOR_TASACION = TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
                BIE_F_SOL_TASACION = TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE BIE_ID = '||V_BIE_ID||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado VALORACION AL ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'');

	ELSE

		V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_BIE_VAL||' 
		(BIE_VAL_ID,BIE_ID,BORRADO,FECHACREAR,USUARIOCREAR,VERSION,BIE_IMPORTE_VALOR_TASACION,BIE_FECHA_VALOR_TASACION,BIE_F_SOL_TASACION)
		VALUES
		(REM01.S_BIE_VALORACIONES.NEXTVAL,
		'||V_BIE_ID||',
		0,
		SYSDATE,
		'''||V_USUARIO||''',
		0,
		'||V_TMP_TIPO_DATA(3)||',
		TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
		TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY'')
		)';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha INSERTADO VALORACION AL ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'');

	END IF;
	
	
	 --Comprobar si existe en la tabla BIE_VALORACIONES.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TAS||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN

                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_TAS||' 
                SET TAS_FECHA_INI_TASACION =  TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
                TAS_IMPORTE_TAS_FIN = '||V_TMP_TIPO_DATA(3)||',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado TASACION AL ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'');

	ELSE
	
		 V_MSQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        	EXECUTE IMMEDIATE V_MSQL INTO V_BIE_ID;
	
		V_MSQL := 'SELECT BIE_VAL_ID FROM '||V_ESQUEMA||'.'||V_TABLA_BIE_VAL||' WHERE BIE_ID = '||V_BIE_ID||'';
        	EXECUTE IMMEDIATE V_MSQL INTO V_BIE_VAL_ID;

		V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAS||' 
		(TAS_ID,
		ACT_ID,
		BORRADO,
		FECHACREAR,
		USUARIOCREAR,
		VERSION,
		BIE_VAL_ID,
		TAS_FECHA_INI_TASACION,
		TAS_IMPORTE_TAS_FIN)
		VALUES
		(REM01.S_ACT_TAS_TASACION.NEXTVAL,
		'||V_ID||',
		0,
		SYSDATE,
		'''||V_USUARIO||''',
		0,
		'||V_BIE_VAL_ID||',
		TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
		'||V_TMP_TIPO_DATA(3)||'
		)';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha INSERTADO TASACION AL ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'');

	END IF;
	
	 --Comprobar si existe en la tabla V_TABLA_ACT_VAL.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT_VAL||' WHERE DD_TPC_ID = 2 AND ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN

                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACT_VAL||' 
                SET VAL_FECHA_INICIO =  TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
                VAL_FECHA_CARGA =  TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
                VAL_IMPORTE = '||V_TMP_TIPO_DATA(3)||',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||'';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado VALORACION AL ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'');

	ELSE
	
		V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT_VAL||' 
		(VAL_ID,		
		ACT_ID,
		DD_TPC_ID,
		FECHACREAR,
		USUARIOCREAR,
		BORRADO,
		VERSION,
		VAL_FECHA_INICIO,
		VAL_FECHA_CARGA,
		VAL_IMPORTE)
		VALUES
		(REM01.S_ACT_VAL_VALORACIONES.NEXTVAL,
		'||V_ID||',
		2,
		SYSDATE,
		'''||V_USUARIO||''',
		0,
		0,
		TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
		TO_DATE( '''||V_TMP_TIPO_DATA(4)||''', ''DD/MM/YYYY''),
		'||V_TMP_TIPO_DATA(3)||'
		)';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha INSERTADO VALORACION AL ACT_NUM_ACTIVO con codigo '''||V_TMP_TIPO_DATA(1)||'');

	END IF;
	        
	END LOOP;
           
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
