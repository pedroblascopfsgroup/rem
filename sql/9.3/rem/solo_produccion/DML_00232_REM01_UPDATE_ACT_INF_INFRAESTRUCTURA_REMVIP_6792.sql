--/*
--##########################################
--## AUTOR=Juan Beltran
--## FECHA_CREACION=20200402
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6792
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización tabla 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

	-- Variables
	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6792';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);

	V_TABLA_ACT	VARCHAR2 (30 CHAR)	:= 'ACT_ACTIVO';	
	V_TABLA_ICO	VARCHAR2(50 CHAR)	:= 'ACT_ICO_INFO_COMERCIAL';
	V_TABLA_INF	VARCHAR2(50 CHAR)	:= 'ACT_INF_INFRAESTRUCTURA';
	V_TABLA_TMP	VARCHAR2(50 CHAR)	:= 'TMP_INFO_COMERCIAL_REMVIP_6792';
	V_NUM_TABLAS NUMBER(16);	
	V_DATOS_SET VARCHAR2(1000 CHAR) := '';

  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 		Tipo  , Apartado, Campo 
		T_TIPO_DATA('Restaurante'),
		T_TIPO_DATA('Escuela/Colegio/Instituto/Universidad'),
		T_TIPO_DATA('Parada de autobuses'),
		T_TIPO_DATA('Hotel/Hospedaje/Albergue'),
		T_TIPO_DATA('Gimnasio/Recinto deportivo'),
		T_TIPO_DATA('Hospital/Consultorio/Clinica'),
		T_TIPO_DATA('Estacion de metro'),
		T_TIPO_DATA('Tienda/Grandes almacenes'),
		T_TIPO_DATA('Teatro'),
		T_TIPO_DATA('Estacion de tren'),
		T_TIPO_DATA('Estacion de autobuses')
	);
	
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
   	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA '||V_ESQUEMA||'.'||V_TABLA_INF||'.');
	
	-- LOOP    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
	
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);                
        
      SELECT  
      	CASE TRIM(V_TMP_TIPO_DATA(1))
	        	WHEN 'Restaurante' THEN  ' INF_OCIO = 1, INF_OCIO_OTROS = '
				WHEN 'Escuela/Colegio/Instituto/Universidad' THEN ' INF_COLEGIOS = 1, INF_COLEGIOS_DESC = '
				WHEN 'Parada de autobuses' THEN ' INF_LINEAS_BUS = 1, INF_LINEAS_BUS_DESC = '
				WHEN 'Hotel/Hospedaje/Albergue' THEN ' INF_HOTELES = 1, INF_HOTELES_DESC = '
				WHEN 'Gimnasio/Recinto deportivo' THEN ' INF_INST_DEPORT = 1, INF_INST_DEPORT_DESC = '
				WHEN 'Hospital/Consultorio/Clinica' THEN ' INF_CENTROS_SALUD = 1, INF_CENTROS_SALUD_DESC = '
				WHEN 'Estacion de metro' THEN ' INF_METRO = 1, INF_METRO_DESC = '
				WHEN 'Tienda/Grandes almacenes' THEN ' INF_CENTROS_COMERC = 1, INF_CENTROS_COMERC_DESC = '
				WHEN 'Teatro' THEN ' INF_TEATROS = 1, INF_TEATROS_DESC = '
				WHEN 'Estacion de tren' THEN ' INF_EST_TREN = 1, INF_EST_TREN_DESC = '
				WHEN 'Estacion de autobuses' THEN ' INF_COMUNICACIONES = 1,  INF_COMUNICACIONES_OTRO = ' 
	       	END	
	    INTO V_DATOS_SET         
        FROM DUAL;  
        
      	
		V_SQL := '
			MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_INF||'  INF
				USING (
					SELECT						
						SUBSTR(LISTAGG (TEXTO, '' '') WITHIN GROUP (ORDER BY TMP.ID_AAII),1,250 ) TEXTO,
						ICO.ICO_ID
					FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
						JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON ACT.ACT_NUM_ACTIVO = TMP.ID_AAII
						JOIN '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO ON ICO.ACT_ID=ACT.ACT_ID AND ICO.BORRADO = 0
					WHERE TMP.TIPO= '''||TRIM(V_TMP_TIPO_DATA(1))||'''
					GROUP BY 	ICO.ICO_ID, TMP.TIPO
					) AUX
				ON (INF.ICO_ID = AUX.ICO_ID)
					WHEN MATCHED THEN UPDATE
				SET				
					INF.USUARIOMODIFICAR = '''||V_USUARIO||''',
					INF.FECHAMODIFICAR = SYSDATE,
					'||V_DATOS_SET||' AUX.TEXTO ';										
				
        EXECUTE IMMEDIATE V_SQL;
        
        
           V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_INF||' WHERE USUARIOMODIFICAR = '''||V_USUARIO||'''
							   AND TO_CHAR(FECHAMODIFICAR, ''DD/MM/YYYY'') = TO_CHAR(SYSDATE, ''DD/MM/YYYY'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	   	
			IF V_NUM_TABLAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: '||V_NUM_TABLAS||' REGISTROS ACTUALIZADOS TIPO = '||V_TMP_TIPO_DATA(1));
			END IF;
    
    END LOOP;   
    
		
  COMMIT;
 
 
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
