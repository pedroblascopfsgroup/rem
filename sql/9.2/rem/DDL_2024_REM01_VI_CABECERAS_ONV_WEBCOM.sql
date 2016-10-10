--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de las cabeceras de Obra Nueva enviadas a webcom.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_CABEC_ONV_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CWH_CABEC_ONV_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de las cabeceras de Obra Nueva enviadas a webcom.'; -- Vble. para los comentarios de las tablas

    CUENTA NUMBER;
    
BEGIN
	

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_VISTA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Comprobaciones previas');
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');	
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'MATERIALIZED VIEW';
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista materializada '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'VIEW';  
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
	END IF;
  
  
  	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
  
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||'..');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';		
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe secuencia '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'..');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	END IF; 

   -- Creamos vista materializada
	DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'..');
  	EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
	
		SELECT 
		CAST(ACT_SD.ID AS NUMBER(16,0))                       	              							AS ID_SUBDIVISION_REM,
		CAST(ACT_SD.AGR_ID AS NUMBER(16,0))                       	              						AS ID_AGRUPACION_REM,
		CAST(ACT_SD.DD_TPA_CODIGO AS VARCHAR2(5 CHAR))                       							AS COD_TIPO_ACTIVO,
		CAST(ACT_SD.DD_SAC_CODIGO AS VARCHAR2(5 CHAR))                       							AS COD_SUBTIPO_ACTIVO,
		CAST(ACT_SD.DESCRIPCION AS VARCHAR2(50 CHAR))                       							AS NOMBRE,
		CAST(ACT_SD.PLANTAS AS NUMBER(16,0))                       	          							AS PLANTAS,
		CAST(ACT_SD.DORMITORIOS AS NUMBER(16,0))                       	      							AS HABITACIONES,
		CAST(ACT_SD.BANYO AS NUMBER(16,0))                       	                    				AS BANYOS,
		CAST(COUNT(*)  AS NUMBER(16,0))                                       							AS ASOCIADOS_ACTIVOS,
		CAST(NVL(ACT_SD.FECHA_ACCION, TO_CHAR((SELECT SYSDATE FROM DUAL),''YYYY-MM-DD'') || 
			''T'' ||TO_CHAR((SELECT SYSDATE FROM DUAL),''HH24:MM:SS'')) AS VARCHAR2(50 CHAR))           AS FECHA_ACCION,  
		CAST(NVL(ACT_SD.ID_USUARIO_REM_ACCION, 
		    (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		    WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER(16,0))                             		AS ID_USUARIO_REM_ACCION 
		FROM(
			SELECT 
		  	AGA.AGR_ID||SUBD.DD_TPA_ID||SUBD.DD_SAC_ID||SUBD.PLANTAS||SUBD.DORMITORIOS||SUBD.BANYO 		ID,
			CASE WHEN (AGA.FECHACREAR IS NOT NULL) 
	            THEN CAST(TO_CHAR(AGA.FECHACREAR,''YYYY-MM-DD'') || 
	            ''T'' ||TO_CHAR(AGA.FECHACREAR,''HH24:MM:SS'') AS VARCHAR2(50 CHAR))
	            ELSE NULL
	        END FECHA_ACCION, 
			CASE WHEN (AGA.USUARIOCREAR IS NOT NULL) 
	            THEN (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
	            WHERE USU.USU_USERNAME = AGA.USUARIOCREAR)
	            ELSE NULL 
	        END ID_USUARIO_REM_ACCION
		  	SUBD.ACT_ID,
		  	AGA.AGR_ID,
			TPA.DD_TPA_CODIGO,
			SAC.DD_SAC_CODIGO,
		  	CASE TPA.DD_TPA_CODIGO
				WHEN ''02''	
					THEN TPA.DD_TPA_DESCRIPCION || '' - '' || SAC.DD_SAC_DESCRIPCION || 
						NVL2(SUBD.PLANTAS,'' - '' || SUBD.PLANTAS ||'' PLANTA'' || 
						DECODE(SUBD.PLANTAS,1,'''',''S''),NULL) || NVL2(SUBD.DORMITORIOS,'' - '' || 
						SUBD.DORMITORIOS ||'' DORMITORIO''|| DECODE(SUBD.DORMITORIOS,1,'''',''S'')  ,NULL)
					ELSE TPA.DD_TPA_DESCRIPCION || '' - '' || SAC.DD_SAC_DESCRIPCION
				END DESCRIPCION,
			NVL(SUBD.DORMITORIOS,0) AS DORMITORIOS, NVL(SUBD.PLANTAS,0) AS PLANTAS, NVL(SUBD.BANYO,0) AS BANYO
			FROM (
					SELECT ACT.ACT_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID, VIV.VIV_NUM_PLANTAS_INTERIOR PLANTAS, 
		      		SUM (DECODE (DIS.DD_TPH_ID, 1, DIS.DIS_CANTIDAD, NULL)) DORMITORIOS,
					SUM (DECODE (DIS.DD_TPH_ID, 2, DIS.DIS_CANTIDAD, NULL)) BANYO					
					FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO 
					INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
					LEFT JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV ON VIV.ICO_ID = ICO.ICO_ID
					LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = VIV.ICO_ID
					GROUP BY ACT.ACT_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID, VIV.VIV_NUM_PLANTAS_INTERIOR
			) SUBD
			INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = SUBD.DD_TPA_ID
			INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = SUBD.DD_SAC_ID
		  	INNER JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = SUBD.ACT_ID
		  	INNER JOIN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA ONV ON ONV.AGR_ID = AGA.AGR_ID 
		) ACT_SD
		GROUP BY ACT_SD.ID, ACT_SD.AGR_ID, ACT_SD.DESCRIPCION,
		ACT_SD.DORMITORIOS,ACT_SD.PLANTAS, ACT_SD.BANYO, 
		ACT_SD.DD_TPA_CODIGO, ACT_SD.DD_SAC_CODIGO';
		   
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_SUBDIVISION_REM) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_SUBDIVISION_REM) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');	
	
		-- Creamos comentario	
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');	
	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;