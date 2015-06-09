--/*
--##########################################
--## AUTOR=ALBERTO_RAMIREZ
--## FECHA_CREACION=20150601
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=FASE-1335
--## PRODUCTO=SI
--##
--## Finalidad: Crear PK_ACN_ANTECED_CONTRATOS
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



DBMS_OUTPUT.PUT_LINE('[START] Crear PK_ACN_ANTECED_CONTRATOS');

EXECUTE IMMEDIATE 'select count(*)
					from(
					SELECT consa.constraint_name,  consa.status, consa.owner
					                    FROM all_constraints consa
					                    WHERE consa.TABLE_NAME = ''ACN_ANTECED_CONTRATOS''
					                    AND consa.constraint_type = ''P''
					                    AND consa.owner = '''||v_schema||'''  
					                    AND consa.constraint_name = ''PK_ACN_ANTECED_CONTRATOS'')' into v_table_count;

if v_table_count > 0 then
    DBMS_OUTPUT.PUT_LINE('[INFO] PK_ACN_ANTECED_CONTRATOS Ya existe');
else 

    EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.ACN_ANTECED_CONTRATOS ADD CONSTRAINT PK_ACN_ANTECED_CONTRATOS PRIMARY KEY (CNT_ID)';

    DBMS_OUTPUT.PUT_LINE('PK_ACN_ANTECED_CONTRATOS creada correctamente');

end if;

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