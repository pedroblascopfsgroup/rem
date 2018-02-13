--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de las ofertas enviadas a webcom
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_OFERTAS_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'OWH_OFERTAS_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de las ofertas enviadas a webcom.'; -- Vble. para los comentarios de las tablas

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
		CAST(  NVL(LPAD(OFR.OFR_ID,16,0) , ''0'')   
				|| NVL(LPAD(ACT.ACT_ID,16,0) , ''0'') 											AS NUMBER(32,0)) AS ID_OFERTA_PK,
		CAST(OFR.OFR_WEBCOM_ID AS NUMBER(16,0)) 												AS ID_OFERTA_WEBCOM,
		CAST(OFR.OFR_NUM_OFERTA AS NUMBER(16,0)) 												AS ID_OFERTA_REM,
 		CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0)) 												AS ID_ACTIVO_HAYA, 
		CAST(DDEOF.DD_EOF_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_OFERTA,
		CAST(DDEEC.DD_EEC_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_EXPEDIENTE,
		CASE WHEN (DDEEC.DD_EEC_CODIGO = ''08'')
		      THEN CAST(''1'' AS NUMBER(1,0))
		      ELSE CAST(''0'' AS NUMBER(1,0))
	    END VENDIDO, 
		CAST(TO_CHAR(NVL(OFR.FECHAMODIFICAR, OFR.FECHACREAR), 
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 						AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = NVL(OFR.USUARIOMODIFICAR, OFR.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 					AS ID_USUARIO_REM_ACCION,
		CAST(AGR.AGR_NUM_AGRUP_REM AS NUMBER(16,0)) 												AS ID_AGRUPACION_REM
		FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
		LEFT JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = OFR.AGR_ID
		INNER JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DDEEC ON DDEEC.DD_EEC_ID = ECO.DD_EEC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA DDEOF ON DDEOF.DD_EOF_ID = OFR.DD_EOF_ID
		WHERE OFR.AGR_ID IS NULL AND (OFR.OFR_WEBCOM_ID IS NOT NULL or OFR.OFR_ORIGEN = ''REM'') and act.borrado = 0

		UNION ALL

		SELECT 
		CAST(  NVL(LPAD(OFR.OFR_ID,16,0) , ''0'')   
				|| NVL(LPAD(ACT2.ACT_ID,16,0) , ''0'') 											AS NUMBER(32,0)) AS ID_OFERTA_PK,
		CAST(OFR.OFR_WEBCOM_ID AS NUMBER(16,0)) 												AS ID_OFERTA_WEBCOM,
		CAST(OFR.OFR_NUM_OFERTA AS NUMBER(16,0)) 												AS ID_OFERTA_REM,
	    CASE WHEN (ACT_PRINCIPAL.ACT_NUM_ACTIVO IS NULL)
		      THEN CAST(ACT2.ACT_NUM_ACTIVO AS NUMBER(16,0))
		      ELSE CAST(ACT_PRINCIPAL.ACT_NUM_ACTIVO AS NUMBER(16,0))
  		END ID_ACTIVO_HAYA,  
		CAST(DDEOF.DD_EOF_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_OFERTA,
		CAST(DDEEC.DD_EEC_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_EXPEDIENTE,
		CASE WHEN (DDEEC.DD_EEC_CODIGO = ''08'')
		      THEN CAST(''1'' AS NUMBER(1,0))
		      ELSE CAST(''0'' AS NUMBER(1,0))
	    END VENDIDO, 
		CAST(TO_CHAR(NVL(OFR.FECHAMODIFICAR, OFR.FECHACREAR), 
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 						AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = NVL(OFR.USUARIOMODIFICAR, OFR.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 					AS ID_USUARIO_REM_ACCION,
		CAST(AGR.AGR_NUM_AGRUP_REM AS NUMBER(16,0)) 												AS ID_AGRUPACION_REM
		FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
		INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = OFR.AGR_ID
		INNER JOIN ( SELECT  OFR_ID,ACT_ID FROM (SELECT OFR_ID,ACT_ID, ROW_NUMBER() OVER (PARTITION BY OFR_ID ORDER BY ACT_ID) AS NUMFILA FROM '||V_ESQUEMA||'.ACT_OFR) WHERE NUMFILA = 1 ) AO ON AO.OFR_ID = OFR.OFR_ID
        LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT_PRINCIPAL ON ACT_PRINCIPAL.ACT_ID = AGR.AGR_ACT_PRINCIPAL
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON ACT2.ACT_ID = AO.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
		LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DDEEC ON DDEEC.DD_EEC_ID = ECO.DD_EEC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA DDEOF ON DDEOF.DD_EOF_ID = OFR.DD_EOF_ID
		WHERE OFR.AGR_ID IS NOT NULL AND (OFR.OFR_WEBCOM_ID IS NOT NULL or OFR.OFR_ORIGEN = ''REM'') and act2.borrado = 0 AND (TAG.DD_TAG_CODIGO = ''02'' OR TAG.DD_TAG_CODIGO = ''14'')';

		
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

 		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_OFERTA_PK) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_OFERTA_PK) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_OFERTA_PK) USING INDEX)';
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
