--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge los recordatorios.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_ENTIDAD#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** REC_RECORDATORIO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.REC_RECORDATORIO... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''REC_RECORDATORIO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.REC_RECORDATORIO... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.REC_RECORDATORIO...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_REC_RECORDATORIO';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_REC_RECORDATORIO... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.REC_RECORDATORIO
		(
		  REC_ID           NUMBER(16)                   NOT NULL,
		  REC_FECHA        TIMESTAMP(6)                 NOT NULL,
		  REC_TITULO       VARCHAR2(500 BYTE),
		  REC_DESCRIPCION  VARCHAR2(1000 BYTE),
		  TAR_ID_UNO       NUMBER(16),
		  TAR_ID_DOS       NUMBER(16),
		  TAR_ID_TRES      NUMBER(16),
		  USU_ID           NUMBER(16)                   NOT NULL,
		  REC_OPEN         NUMBER(1)                    DEFAULT 1                     NOT NULL,
		  CAT_ID           NUMBER(16)
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING;
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.REC_RECORDATORIO_PK ON '||V_ESQUEMA|| '.REC_RECORDATORIO
					(REC_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RECORDATORIO ADD (
						CONSTRAINT REC_RECORDATORIO_PK PRIMARY KEY (REC_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO_PK... Creando PK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RECORDATORIO ADD (
						CONSTRAINT REC_RECORDATORIO_R05 FOREIGN KEY (CAT_ID) REFERENCES '||V_ESQUEMA||'.CAT_CATEGORIAS (CAT_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO_R05... Creando FK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RECORDATORIO ADD (
						CONSTRAINT REC_RECORDATORIO_R01 FOREIGN KEY (TAR_ID_UNO) REFERENCES '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO_R01... Creando FK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RECORDATORIO ADD (
						CONSTRAINT REC_RECORDATORIO_R02 FOREIGN KEY (TAR_ID_DOS) REFERENCES '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO_R01... Creando FK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RECORDATORIO ADD (
						CONSTRAINT REC_RECORDATORIO_R03 FOREIGN KEY (TAR_ID_TRES) REFERENCES '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO_R03... Creando FK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RECORDATORIO ADD (
						FOREIGN KEY (USU_ID) REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO.USU_ID... Creando FK');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RECORDATORIO... OK');
	END IF;

	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;