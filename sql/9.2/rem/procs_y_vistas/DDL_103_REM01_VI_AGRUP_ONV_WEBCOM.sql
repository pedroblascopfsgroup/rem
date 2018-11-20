--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4757
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de las agrupaciones de Obra Nueva enviadas a webcom. HREOS-1551 - Se añaden agrupaciones Asistidas.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 HREOS-4757: Filtrar por agrupaciones de tipo comercial
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_AGRUP_ONV_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AWH_AGRUP_ONV_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de las agrupaciones de Obra Nueva y Asistidas enviadas a webcom.'; -- Vble. para los comentarios de las tablas

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
		WITH INFO_ACTIVO_AGRUPACION AS (
			SELECT AUX.* FROM (
				SELECT AGA.AGR_ID, AGA.ACT_ID, DDCRA.DD_CRA_CODIGO, DDSCR.DD_SCR_CODIGO, PVE.PVE_COD_REM,
				ROW_NUMBER() OVER (PARTITION BY AGA.AGR_ID ORDER BY AGA.ACT_ID DESC) ORDEN
				FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
				LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID and act.borrado = 0
				LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA DDCRA ON DDCRA.DD_CRA_ID = ACT.DD_CRA_ID
				LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA DDSCR ON DDSCR.DD_SCR_ID = ACT.DD_SCR_ID
				LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID	
        		LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ICO.ICO_MEDIADOR_ID) AUX
			WHERE AUX.ORDEN = 1
		),
		DIRECCION_AGRUPA AS (
			SELECT ONV.AGR_ID, ONV.ONV_CP AS CP, DDPRV.DD_PRV_CODIGO, DDLOC.DD_LOC_CODIGO
			FROM '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA ONV
			LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = ONV.DD_PRV_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = ONV.DD_LOC_ID
			UNION
			SELECT ASI.AGR_ID, ASI.ASI_CP AS CP, DDPRV.DD_PRV_CODIGO, DDLOC.DD_LOC_CODIGO
			FROM '||V_ESQUEMA||'.ACT_ASI_ASISTIDA ASI
			LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = ASI.DD_PRV_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = ASI.DD_LOC_ID
		)
		SELECT 
		CAST(AGR.AGR_NUM_AGRUP_REM  AS NUMBER(16,0))                       						AS ID_AGRUPACION_REM,
		CAST(DDTAG.DD_TAG_CODIGO AS VARCHAR2(5 CHAR))                       					AS COD_TIPO_AGRUPACION,
		CAST(IAG.DD_CRA_CODIGO AS VARCHAR2(5 CHAR))                         					AS COD_CARTERA,
		CAST(AGR.AGR_NOMBRE AS VARCHAR2(250 CHAR))                          					AS NOMBRE,
		CASE WHEN (AGR.AGR_FECHA_ALTA IS NOT NULL) 
		  THEN CAST(TO_CHAR(AGR.AGR_FECHA_ALTA ,
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		  ELSE NULL
		END 																				    AS DESDE,
		CASE WHEN (AGR.AGR_FECHA_BAJA IS NOT NULL) 
		  THEN CAST(TO_CHAR(AGR.AGR_FECHA_BAJA ,
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		  ELSE NULL
		END 																				    AS HASTA,	
		CASE WHEN (AGR.BORRADO = 1 OR 
			(AGR.AGR_FECHA_BAJA IS NOT NULL 
			AND AGR.AGR_FECHA_BAJA < TO_DATE(SYSDATE, ''DD/MM/YY''))) 
		  THEN CAST(''2'' AS VARCHAR2(5 CHAR))
		  ELSE CAST(''1'' AS VARCHAR2(5 CHAR))
		END                                                                 					AS COD_ESTADO_AGRUPACION,
		CAST(DIR.DD_LOC_CODIGO AS VARCHAR2(5 CHAR))                       						AS COD_MUNICIPIO,
		CAST(DIR.CP AS VARCHAR2(5 CHAR))                                						AS CODIGO_POSTAL,
		CAST(DIR.DD_PRV_CODIGO AS VARCHAR2(5 CHAR))                       						AS COD_PROVINCIA,
		CAST(AGR.AGR_GESTOR_ID AS NUMBER(16,0))                             					AS ID_GESTOR_COMERCIAL,
		CAST(IAG.PVE_COD_REM AS NUMBER(16,0))                           						AS ID_PROVEEDOR_REM,
		CAST(AGR.AGR_DESCRIPCION AS VARCHAR2(500 CHAR))                     					AS DESCRIPCION,
		CAST((SELECT COUNT(*) 
	        FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA 
	        WHERE AGA.AGR_ID = AGR.AGR_ID) AS NUMBER(16,0))  	                        		AS ASOCIADOS_ACTIVOS,
		CAST(IAG.DD_SCR_CODIGO AS VARCHAR2(5 CHAR))                     						AS COD_SUB_CARTERA,
		CAST(TO_CHAR(NVL(AGR.FECHAMODIFICAR, AGR.FECHACREAR), 
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 						AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = NVL(AGR.USUARIOMODIFICAR, AGR.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 					AS ID_USUARIO_REM_ACCION
		FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
		LEFT JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION DDTAG ON DDTAG.DD_TAG_ID = AGR.DD_TAG_ID 
		LEFT JOIN INFO_ACTIVO_AGRUPACION IAG ON IAG.AGR_ID = AGR.AGR_ID
		LEFT JOIN DIRECCION_AGRUPA DIR ON DIR.AGR_ID = AGR.AGR_ID
		WHERE agr.borrado = 0
		and (AGR.AGR_NUM_AGRUP_REM IS NOT NULL AND DDTAG.DD_TAG_CODIGO IS NOT NULL AND (DDTAG.DD_TAG_CODIGO = ''14'' OR DDTAG.DD_TAG_CODIGO = ''15''))';
		   
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

 		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_AGRUPACION_REM) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_AGRUPACION_REM) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_AGRUPACION_REM) USING INDEX)';
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