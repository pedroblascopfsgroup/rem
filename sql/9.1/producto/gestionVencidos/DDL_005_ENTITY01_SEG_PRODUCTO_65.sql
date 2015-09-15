--/*
--##########################################
--## AUTOR=ALBERTO_RAMIREZ
--## FECHA_CREACION=20150811
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-65
--## PRODUCTO=SI
--##
--## Finalidad: Crear nueva columna "prepolítica" en itinerario
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
v_schema   VARCHAR(25) := '#ESQUEMA#';
v_schema_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN



DBMS_OUTPUT.PUT_LINE('[START]: Crear columna TPL_ID y clave ajena FK_ITI_TPL en ITI_ITINERARIOS');

DBMS_OUTPUT.PUT_LINE('[INFO]: Creando columna TPL_ID ');
DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas');

EXECUTE IMMEDIATE 'select count(*)
					from(
					SELECT *
  						FROM all_cons_columns colsa 
 					WHERE colsa.table_name = ''ITI_ITINERARIOS''
   					AND colsa.owner = '''||v_schema||'''
   					AND colsa.COLUMN_NAME = ''TPL_ID'')' into v_table_count;

if v_table_count > 0 then
    DBMS_OUTPUT.PUT_LINE('[INFO]: La columna TPL_ID Ya existe');
else 

    EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.ITI_ITINERARIOS ADD TPL_ID NUMBER(16)';
    DBMS_OUTPUT.PUT_LINE('[INFO]: Columna TPL_ID añadida');
 
end if;

DBMS_OUTPUT.PUT_LINE('[INFO]: Creando clave ajena FK_ITI_TPL');
DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas');

EXECUTE IMMEDIATE 'select count(*)
					from(
					SELECT consa.constraint_name,  consa.status, consa.owner
					                    FROM all_constraints consa
					                    WHERE consa.TABLE_NAME = ''ITI_ITINERARIOS''
					                    AND consa.constraint_type = ''R''
					                    AND consa.owner = '''||v_schema||'''  
					                    AND consa.constraint_name = ''FK_ITI_TPL'')' into v_table_count;

if v_table_count > 0 then
	    DBMS_OUTPUT.PUT_LINE('[INFO]: La clave ajena FK_ITI_TPL ya existe');
else 
	
	    EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.ITI_ITINERARIOS 
						   ADD CONSTRAINT FK_ITI_TPL 
								FOREIGN KEY (TPL_ID)
								REFERENCES '|| v_schema ||'.TPL_TIPO_POLITICA (TPL_ID)';
	
		DBMS_OUTPUT.PUT_LINE('[INFO]: Clave ajena FK_ITI_TPL creada correctamente');
end if;

DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');	

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT