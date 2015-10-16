--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-173
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que almacena los campos de las opercaiones de los términos.
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

	DBMS_OUTPUT.PUT_LINE('******** ACU_OPERACIONES_TERMINOS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACU_OPERACIONES_TERMINOS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_OPERACIONES_TERMINOS... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.ACU_OPERACIONES_TERMINOS...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_ACU_OPERACIONES_TERMINOS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_ACU_OPERACIONES_TERMINOS... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS
		(
		  OP_TERM_ID           NUMBER(16)                   NOT NULL,
		  TEA_ID               NUMBER(16)                   NOT NULL,
		  OP_IMP_PAG_PREV_FORM	  NUMBER(16,2),
		  OP_PLZ_PAG_PREV_FORM    NUMBER(4),
	      OP_CARENCIA          NUMBER(16,2),
		  OP_CUOTA_ASUMIBLE    NUMBER(16,2),
		  OP_CARGAS_POSTERIORES NUMBER(16,2),
		  OP_GARANTIAS_EXTRAS NUMBER(16,2),
		  OP_NUM_EXPEDIENTE   VARCHAR2(500 BYTE),
		  OP_SOLICITAR_ALQUILER  NUMBER(1),
		  OP_LIQUIDEZ 	   NUMBER(16,2),
		  OP_TASACION     NUMBER(16,2),
		  OP_IMPORTE_PAGAR_QUITA     NUMBER(16,2),
		  OP_PORCENTAJE_QUITA    NUMBER(3),
		  OP_IMPORTE_VENCIDO     NUMBER(16,2),
		  OP_IMPORTE_NO_VENCIDO     NUMBER(16,2),
		  OP_IMP_INTERESES_MORATORIOS    NUMBER(16,2),
		  OP_IMP_INTERESES_ORDINARIOS    NUMBER(16,2),
		  OP_COMISION    NUMBER(16,2),
		  OP_GASTOS    NUMBER(16,2),
		  OP_NOM_CESIONARIO      VARCHAR2(500 BYTE),
		  OP_REL_CES_TIT       VARCHAR2(500 BYTE),
		  OP_SOLVENCIA_CESIONARIO    NUMBER(16,2),
		  OP_IMPORTE_CESION    NUMBER(16,2),
          OP_FECHA_PAGO      DATE,
		  OP_PLAN_PGS_FECHA      DATE,
		  OP_PLAN_PGS_FRECUENCIA     VARCHAR2(30),
		  OP_PLAN_PGS_NUM_PAGOS   NUMBER(5),
		  OP_PLAN_PGS_IMPORTE 		NUMBER(16),
          OP_ANALISIS_SOLVENCIA    	VARCHAR2(4000 BYTE),
		  OP_DESC_ACUERDO    	VARCHAR2(4000 BYTE),
          VERSION                  INTEGER,
          USUARIOCREAR             VARCHAR2(10 CHAR),
          FECHACREAR               TIMESTAMP(6),
          BORRADO                  NUMBER(1),
		  USUARIOMODIFICAR VARCHAR2(10 CHAR), 
		  FECHAMODIFICAR TIMESTAMP (6), 
	      USUARIOBORRAR VARCHAR2(10 CHAR), 
		  FECHABORRAR TIMESTAMP (6) 
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS_PK ON '||V_ESQUEMA|| '.ACU_OPERACIONES_TERMINOS
					(OP_TERM_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS ADD (
						CONSTRAINT ACU_OPERACIONES_TERMINOS_PK PRIMARY KEY (OP_TERM_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS_PK... Creando PK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS ADD (
						CONSTRAINT TERMINOS_ACUERODS_FK FOREIGN KEY (TEA_ID) REFERENCES '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO (TEA_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.TERMINOS_ACUERODS_FK... Creando FK');
		
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS... OK');
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