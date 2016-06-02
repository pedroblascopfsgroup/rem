--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160524
--## ARTEFACTO=proc_convivencia_contratos_litios
--## VERSION_ARTEFACTO=2.18
--## INCIDENCIA_LINK=BKREC-2416
--## PRODUCTO=NO
--##
--## Finalidad: Modificamos 
--## INSTRUCCIONES: Definir las variables de esquema antes de ejecutarlo.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count_copy number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_column_count_fk number(3); -- Vble. para validar la existencia de las Columnas deFK.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    v_constraint_name varchar2(32 char); -- Vble. para trabajar con una Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    TABLA VARCHAR2(30 CHAR) :='MINIRECOVERY_CNT_PROC_VIVOS';
	  COLUMNA VARCHAR2(32 CHAR) := 'MR_CNT_ID';
    NUEVA_DEFI_COLUMNA VARCHAR(100 CHAR) :='NUMBER(16) NULL';
    V_EXISTE NUMBER (1);
    PK_EXISTE NUMBER (1);
    PK_NAME varchar2(32 char);
    PK_COLUMNS varchar2(500 char);
    IDX_EXISTE NUMBER (1);
    IDX_NAME NUMBER (1);
    PK_SAME NUMBER (1) := 0;
	 v_column_not_null number(3); -- Vble. para validar si la columna ya esta indicada como not null.
    -- Otras variables
	
BEGIN 
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||TABLA||'... Modificamos definicion de la columna ['||COLUMNA||'].');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE table_name ='''||TABLA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count > 0 THEN
		V_MSQL := 'SELECT count(1) FROM all_tab_columns 
					WHERE trim(upper(table_name)) =trim(upper('''||TABLA||'''))
					and trim(upper(column_name)) = trim(upper('''||COLUMNA||'''))';
		EXECUTE IMMEDIATE V_MSQL INTO v_column_count;
		IF v_column_count > 0 THEN
			V_MSQL := 'SELECT count(1) FROM all_tab_columns 
						WHERE trim(upper(table_name)) =trim(upper('''||TABLA||'''))
						and trim(upper(column_name)) = trim(upper('''||COLUMNA||'''))
						and NULLABLE = ''N''';
			EXECUTE IMMEDIATE V_MSQL INTO v_column_not_null;
			IF v_column_not_null > 0 THEN
				V_MSQL := 'ALTER TABLE '||TABLA||' MODIFY '||COLUMNA||' '||NUEVA_DEFI_COLUMNA||'';
				DBMS_OUTPUT.PUT_LINE ('[TRAZA] ['||V_MSQL||'].');
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE ('[INFO] Se ha cambiado la definicion de la columna ['||COLUMNA||'] de la tabla ['||TABLA||'] a ['||NUEVA_DEFI_COLUMNA||']');
			ELSE 
				DBMS_OUTPUT.PUT_LINE ('[INFO] La columna ya esta definida como nullable.');
			END IF;
		ELSE 
			DBMS_OUTPUT.PUT_LINE ('[ERROR] La columna no existe ['||COLUMNA||'].');
		END IF;
	ELSE 
		DBMS_OUTPUT.PUT_LINE ('[ERROR] La tabla no existe ['||TABLA||']..');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||TABLA||'... Modificamos definicion de la columna ['||COLUMNA||'].');
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

