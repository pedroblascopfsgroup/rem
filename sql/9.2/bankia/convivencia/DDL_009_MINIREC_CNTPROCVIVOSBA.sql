--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160525
--## ARTEFACTO=proc_convivencia_contratos_litios
--## VERSION_ARTEFACTO=2.18
--## INCIDENCIA_LINK=BKREC-2416
--## PRODUCTO=SI
--##
--## Finalidad: Crear tabla auxiliar para cargar los datos de vivos del esquema Bankia
--## INSTRUCCIONES: Definir las variables de esquema antes de ejecutarlo.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
--## Configuraciones a rellenar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count_copy number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_column_count_fk number(3); -- Vble. para validar la existencia de las Columnas deFK.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
 
    -- Otras variables
	
BEGIN 
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.MINIRECOVERY_CNT_PROC_VIVOS_BA... Crear tabla auxiliar.');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE table_name =''MINIRECOVERY_CNT_PROC_VIVOS_BA''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF (table_count = 0) THEN
		-- Copiar los datos a una temporal
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MINIRECOVERY_CNT_PROC_VIVOS_BA
				(MR_CNT_ID NUMBER(16, 0)  
				,MR_CODIGO_PROPIETARIO NUMBER(5, 0) NOT NULL 
				,MR_TIPO_PRODUCTO VARCHAR2(5 CHAR) NOT NULL 
				,MR_NUMERO_CONTRATO NUMBER(17, 0) NOT NULL 
				,MR_NUMERO_ESPEC NUMBER(15, 0) NOT NULL 
				,MR_FECHA_PROCESO DATE NOT NULL 
				,MR_PROCESADO VARCHAR2(2 CHAR) 
				,MR_MOTIVO VARCHAR2(50 CHAR) 
				,MR_CD_PROCEDIMIENTO NUMBER(16, 0) NOT NULL)
				'; 
		EXECUTE IMMEDIATE V_MSQL;
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MINIRECOVERY_CNT_PROC_VIVOS_BA... Se ha creado la tabla auxiliar.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MINIRECOVERY_CNT_PROC_VIVOS_BA... La tabla indicada ya existe.');	
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.MINIRECOVERY_CNT_PROC_VIVOS_BA... Crear tabla auxiliar.');
	
		
EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;	  
END;

/
 
EXIT;
