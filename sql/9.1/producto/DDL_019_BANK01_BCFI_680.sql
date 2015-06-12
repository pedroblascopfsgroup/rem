--/*
--##########################################
--## AUTOR=ALBERTO_RAMIREZ
--## FECHA_CREACION=20150611
--## ARTEFACTO=ONLINE
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=BCFI-680
--## PRODUCTO=SI
--##
--## Finalidad: Nueva clave ajena en ADC_ADECUACIONES_CNT para apuntar a la tabla DD_REA_RECOMENDA_ADECUA
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



DBMS_OUTPUT.PUT_LINE('[START]');

DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR LA COLUMNA DD_CODIGO_RECOMENDACION DE LA TABLA ADC_ADECUACIONES_CNT');
	
	-- Comprobamos si existe la columna
	v_sql := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ADC_ADECUACIONES_CNT'' and owner = '''||v_schema||''' and column_name = ''DD_CODIGO_RECOMENDACION''';
    EXECUTE IMMEDIATE v_sql INTO v_table_count;
    
    -- Si existe el campo lo indicamos sino lo creamos
    IF v_table_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL CAMPO DD_CODIGO_RECOMENDACION');
    ELSE	
        DBMS_OUTPUT.PUT_LINE('[INFO]: EL CAMPO DD_CODIGO_RECOMENDACION EXISTE');
		v_sql := 'ALTER TABLE '||v_schema||'.ADC_ADECUACIONES_CNT MODIFY DD_CODIGO_RECOMENDACION VARCHAR2(20 CHAR)';
        EXECUTE IMMEDIATE v_sql; 
        DBMS_OUTPUT.PUT_LINE('[INFO]: CAMPO DD_CODIGO_RECOMENDACION MODIFICADO CORRECTAMENTE');
		
		EXECUTE IMMEDIATE 'select count(*)
		from(
		SELECT consa.constraint_name, colsa.table_name table_a,  colsa.column_name column_a, consb.table_name table_b, colsb.column_name column_b, consa.status, consa.owner
		                    FROM all_constraints consa
		                        inner join all_constraints consb on consa.r_constraint_name = consb.constraint_name
		                        inner join all_cons_columns colsa on consa.constraint_name = colsa.constraint_name and consa.owner = colsa.owner
		                        inner join all_cons_columns colsb on consa.r_constraint_name = colsb.constraint_name and consb.owner = colsb.owner
		                    WHERE colsa.table_name = ''ADC_ADECUACIONES_CNT'' 
		                    AND consa.constraint_type = ''R''
		                    AND consa.owner = '''||v_schema||'''
		                    AND consb.owner = '''||v_schema||'''
		                    AND consa.constraint_name = ''FK_ADC_REA_CODIGO'')' into v_constraint_count;
		
		if v_constraint_count > 0 then
		    DBMS_OUTPUT.PUT_LINE('[INFO]: FK_ADC_REA_CODIGO... YA EXISTE');
		else 
		
		    EXECUTE IMMEDIATE 'ALTER TABLE '||v_schema||'.ADC_ADECUACIONES_CNT ADD CONSTRAINT FK_ADC_REA_CODIGO FOREIGN KEY (DD_CODIGO_RECOMENDACION)
		    REFERENCES '|| v_schema ||'.DD_REA_RECOMENDA_ADECUA (DD_REA_CODIGO)';
		
		    DBMS_OUTPUT.PUT_LINE('[INFO]: FK_ADC_REA_CODIGO CREADA CORRECTAMENTE');
		
		end if;
END IF;



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