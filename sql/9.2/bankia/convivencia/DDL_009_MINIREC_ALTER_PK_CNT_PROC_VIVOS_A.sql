--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160523
--## ARTEFACTO=proc_convivencia_contratos_litios
--## VERSION_ARTEFACTO=2.18
--## INCIDENCIA_LINK=BKREC-2416
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla para informacion de salida a clientes, con datos de procuradores y letrados.
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
    TABLA VARCHAR2(30 CHAR) :='MINIRECOVERY_CNT_PROC_VIVOS_A';
    PK_NEW_COLUMNS VARCHAR(100 CHAR) :='MR_CODIGO_PROPIETARIO,MR_TIPO_PRODUCTO,MR_NUMERO_CONTRATO,MR_NUMERO_ESPEC,MR_CD_PROCEDIMIENTO';
    V_EXISTE NUMBER (1);
    PK_EXISTE NUMBER (1);
    PK_NAME varchar2(32 char);
    PK_COLUMNS varchar2(500 char);
    IDX_EXISTE NUMBER (1);
    IDX_NAME NUMBER (1);
    PK_SAME NUMBER (1) := 0;
    -- Otras variables
	
BEGIN 
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||TABLA||'...');

  -- Comprobamos si existe PK asociadas a esa tabla	
  select COUNT(1) INTO PK_EXISTE
	from all_constraints ac
	where TRIM(UPPER(ac.owner)) = TRIM(UPPER(V_ESQUEMA))
    AND TRIM(UPPER(ac.table_name)) = TRIM(UPPER(TABLA))
		AND ac.CONSTRAINT_TYPE = 'P';	
  DBMS_OUTPUT.PUT_LINE ('[TRAZA] PK_EXISTE ('||PK_EXISTE||').');
  IF PK_EXISTE > 0 THEN 
    -- Si existe guardamos el nombre de la constraint que es PK
			select ac.CONSTRAINT_NAME INTO PK_NAME
			from all_constraints ac
			where TRIM(UPPER(ac.owner)) = TRIM(UPPER(V_ESQUEMA))
				AND TRIM(UPPER(ac.table_name)) = TRIM(UPPER(TABLA))
				AND ac.CONSTRAINT_TYPE = 'P';
    DBMS_OUTPUT.PUT_LINE ('[TRAZA] PK_NAME ('||PK_NAME||').');
    -- Luego, comprobamos si esa PK tiene la misma composición que la que vamos a crear, si fuera el caso no hariamos nada
    SELECT COUNT(1) INTO PK_SAME
      FROM (
        select listagg(column_name,',') within group (order by position) columnas
        from all_cons_columns
        where TRIM(UPPER(owner)) = TRIM(UPPER(V_ESQUEMA))
          AND TRIM(UPPER(constraint_name)) = TRIM(UPPER(PK_NAME))
          AND TRIM(UPPER(table_name)) = TRIM(UPPER(TABLA))
      ) sqli
    WHERE sqli.columnas = PK_NEW_COLUMNS;
    DBMS_OUTPUT.PUT_LINE ('[TRAZA] PK_SAME ('||PK_SAME||').');
	
    IF PK_SAME = 1 THEN
      DBMS_OUTPUT.PUT_LINE ('[INFO] La nueva PK es la misma PK que ya existe, no hacemos mas acciones.');
    ELSE 
			/*-- Buscamos la composicion de la PK existente
			select listagg(column_name,',') within group (order by position) columnas into PK_COLUMNS
			from all_cons_columns
			where TRIM(UPPER(owner)) = TRIM(UPPER(V_ESQUEMA))
				AND TRIM(UPPER(constraint_name)) = TRIM(UPPER(PK_NAME))
				AND TRIM(UPPER(table_name)) = TRIM(UPPER(TABLA));   
      DBMS_OUTPUT.PUT_LINE ('[TRAZA] PK_COLUMNS ('||PK_COLUMNS||').');
			-- Buscamos si existe un index con esa composicion de campos
			SELECT COUNT(1) INTO IDX_EXISTE
			FROM (
				SELECT index_name, listagg(column_name,',') within group (order by column_position) columnas
				FROM ALL_IND_COLUMNS
				WHERE TRIM(UPPER(index_owner)) = TRIM(UPPER(V_ESQUEMA))
					AND TRIM(UPPER(table_name)) = TRIM(UPPER(TABLA))
				GROUP BY index_name
			) sqli
			WHERE sqli.columnas = PK_COLUMNS;
      DBMS_OUTPUT.PUT_LINE ('[TRAZA] IDX_EXISTE ('||IDX_EXISTE||').');*/
			-- Borramos la PK
			DBMS_OUTPUT.PUT_LINE ('[INFO] '||V_ESQUEMA||'.'||TABLA||' Procedemos a borrar la PK ...');
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' DROP CONSTRAINT '||PK_NAME ||' DROP INDEX';
			DBMS_OUTPUT.PUT_LINE ('[INFO] '||V_MSQL);
			Execute Immediate V_MSQL;
			commit;
			DBMS_OUTPUT.PUT_LINE ('[INFO] '||V_ESQUEMA||'.'||TABLA||' PK borrada...');
			
			/*IF IDX_EXISTE > 0 THEN 
				-- Si existe buscamos el nombre del index para borrarlo
				SELECT index_name INTO IDX_NAME
				FROM (
					SELECT index_name, listagg(column_name,',') within group (order by column_position) columnas
					FROM ALL_IND_COLUMNS
					WHERE TRIM(UPPER(index_owner)) = TRIM(UPPER(V_ESQUEMA))
						AND TRIM(UPPER(table_name)) = TRIM(UPPER(TABLA))
					GROUP BY index_name
				) sqli
				WHERE sqli.columnas = PK_COLUMNS;
        DBMS_OUTPUT.PUT_LINE ('[TRAZA] IDX_NAME ('||IDX_NAME||').');
				-- Borramos la PK asociada a esa tabla
				DBMS_OUTPUT.PUT_LINE ('[INFO] '||V_ESQUEMA||'.'||TABLA||' Procedemos a borrar el indice con la misma composicion ...');
				V_MSQL := 'DROP INDEX '||V_ESQUEMA||'.'||IDX_NAME;
				DBMS_OUTPUT.PUT_LINE ('[INFO] '||V_MSQL);
				Execute Immediate V_MSQL;
				commit; 
				DBMS_OUTPUT.PUT_LINE ('[INFO] '||V_ESQUEMA||'.'||TABLA||' Indice borrado...');
			ELSE 
				DBMS_OUTPUT.PUT_LINE ('[INFO] No existe un indice con la misma composicion que la PK.');
			END IF;   */
		END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE ('[INFO] La tabla indicada no tiene PK.');
  END IF;
  
  IF PK_SAME <> 1 THEN
    -- Pasamos estaditicas a la tabla.
    DBMS_OUTPUT.PUT_LINE ('[INFO] Procedemos a pasar estadisticas de la tabla '||TABLA||'.');
    V_MSQL := 'analyze table '||V_ESQUEMA||'.'||TABLA||' compute statistics';
    Execute Immediate V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... Se han pasado estadisticas a la tabla.');
    -- Creamos PK a la tabla
    DBMS_OUTPUT.PUT_LINE ('[INFO] Creamos la nueva clave primaria... PK_MINIRE_CNT_PROC_VIVOS_A.');
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' ADD CONSTRAINT PK_MINIRE_CNT_PROC_VIVOS_A PRIMARY KEY ('||PK_NEW_COLUMNS||')';
    Execute Immediate V_MSQL;
    commit;
    DBMS_OUTPUT.PUT_LINE ('[INFO] Nueva clave primaria creada... PK_MINIRE_CNT_PROC_VIVOS_A.');
  ELSE 
    DBMS_OUTPUT.PUT_LINE ('[INFO] La nueva PK es la misma PK que ya existe, no hacemos mas acciones.');
  END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||TABLA||'...');
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
