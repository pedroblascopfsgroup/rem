--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190328
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--##
--## Finalidad: Guardamos todas las tablas MIG de la migracion de APPLE en tablas *_AP
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  
	V_USUARIO VARCHAR2(100 CHAR) := 'HREOS-5915';
	V_TABLA_MIG VARCHAR2(30 CHAR);
	V_SUFIJO  VARCHAR2(3 CHAR) := '_AP';
    V_COUNT NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
		T_TIPO_DATA('MIG_ACA_CABECERA'),
		T_TIPO_DATA('MIG_ATI_TITULO'),
		T_TIPO_DATA('MIG_APL_PLANDINVENTAS'),
		T_TIPO_DATA('MIG_ADJ_JUDICIAL'),
		T_TIPO_DATA('MIG_ADJ_NO_JUDICIAL'),
		T_TIPO_DATA('MIG_CPC_PROP_CABECERA'),
		T_TIPO_DATA('MIG_ADA_DATOS_ADI'),
		T_TIPO_DATA('MIG2_PRO_PROPIETARIOS'),
		T_TIPO_DATA('MIG_APC_PROP_CABECERA'),
		T_TIPO_DATA('MIG_APA_PROP_ACTIVO'),
		T_TIPO_DATA('MIG_ACA_CATASTRO_ACTIVO'),
		T_TIPO_DATA('MIG_ACA_CARGAS_ACTIVO'),
		T_TIPO_DATA('MIG_PRESUPUESTO_ACTIVO'),
		T_TIPO_DATA('MIG_ALA_LLAVES_ACTIVO'),
		T_TIPO_DATA('MIG_AML_MOVIMIENTOS_LLAVE'),
		T_TIPO_DATA('MIG_ATA_TASACIONES_ACTIVO'),
		T_TIPO_DATA('MIG_AIA_INFCOMERCIAL_ACT'),
		T_TIPO_DATA('MIG_ACA_CALIDADES_ACTIVO'),
		T_TIPO_DATA('MIG_AID_INFCOMERCIAL_DISTR'),
		T_TIPO_DATA('MIG_AOA_OBSERVACIONES_ACTIVOS'),
		T_TIPO_DATA('MIG_AAA_AGRUPACION_ACTIVO'),
		T_TIPO_DATA('MIG_AAG_AGRUPACIONES'),
		T_TIPO_DATA('MIG_AOA_OBSERVACION_AGRUP'),
		T_TIPO_DATA('MIG_APC_PRECIO'),
		T_TIPO_DATA('MIG_ADD_ADMISION_DOC'),
		T_TIPO_DATA('MIG2_ACT_PRP'),
		T_TIPO_DATA('MIG2_PAC_PERIMETRO_ACTIVO'),
		T_TIPO_DATA('MIG2_ACT_ACTIVO'),
		T_TIPO_DATA('MIG2_USU_USUARIOS'),
		T_TIPO_DATA('MIG2_GRU_GRUPOS_USUARIOS'),
		T_TIPO_DATA('MIG2_GEA_GESTORES_ACTIVOS'),
		T_TIPO_DATA('MIG2_ACT_AHP_HIST_PUBLICACION'),
		T_TIPO_DATA('MIG2_DESPACHOS_PERFILES')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I); 
          
        IF TRIM(V_TMP_TIPO_DATA(1)) = 'MIG_AOA_OBSERVACIONES_ACTIVOS' THEN
			 V_TABLA_MIG := 'MIG_AOA_OBS_ACTIVOS';
        ELSIF TRIM(V_TMP_TIPO_DATA(1)) = 'MIG2_ACT_AHP_HIST_PUBLICACION' THEN
			 V_TABLA_MIG := 'MIG2_ACT_AHP_HIST_PUBLI';
        ELSE
			 V_TABLA_MIG := TRIM(V_TMP_TIPO_DATA(1))||V_SUFIJO;
        END IF;
 
        
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT = 1 THEN
        
				V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_MIG||''' AND OWNER = '''||V_ESQUEMA||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
				IF V_COUNT = 1 THEN
					DBMS_OUTPUT.PUT_LINE('	[INFO] EXISTE LA TABLA '||V_TABLA_MIG||'. LA BORRAMOS.');
					V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_MIG;
					EXECUTE IMMEDIATE V_MSQL;     	
				ELSE    
					DBMS_OUTPUT.PUT_LINE('	[INFO] NO EXISTE LA TABLA '||V_TABLA_MIG||'.');        
				END IF;
        
				DBMS_OUTPUT.PUT_LINE('	[INFO] CREAMOS LA TABLA '||V_TABLA_MIG);
				V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA_MIG||' AS SELECT * FROM '||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(1));
				EXECUTE IMMEDIATE V_MSQL;
				EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA_MIG||'" TO "REM_QUERY" WITH GRANT OPTION';
				EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA_MIG||'" TO "PFSREM" WITH GRANT OPTION';
        
        ELSE    
				DBMS_OUTPUT.PUT_LINE('	[INFO] NO EXISTE LA TABLA '||TRIM(V_TMP_TIPO_DATA(1))||'. NO HACEMOS NADA');        
		END IF;

    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   

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
