--/*
--##########################################
--## Author: Roberto Lavalle
--## Finalidad: DML de Diccionario Entidad Adjudicataria Propietaria
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE

	v_seq_count number(3);
	v_table_count number(3);
	V_ESQUEMA varchar(30) := 'BANK01';
	v_constraint_count number(3);
	v_sql varchar2(4000);

	TYPE T_TIPO_SEC IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_SEC IS TABLE OF T_TIPO_SEC;

	V_ENTIDAD_ID NUMBER(16); 
	V_MSQL VARCHAR2(5000);


	V_TIPO_SEC T_ARRAY_SEC := T_ARRAY_SEC(
		T_TIPO_SEC('BANKIA','BANKIA','BANKIA'),
		T_TIPO_SEC('SAREB','SAREB','SAREB')
	); 

	V_TMP_TIPO_SEC T_TIPO_SEC;

BEGIN

	v_seq_count := 0;
	v_table_count := 0;

	DBMS_OUTPUT.PUT_LINE('Truncate DD_EAS_ENTIDAD_ADJUD_PROP');
	EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA || '.DD_EAS_ENTIDAD_ADJUD_PROP');
	
	
	DBMS_OUTPUT.PUT_LINE('Cargando DD_EAS_ENTIDAD_ADJUD_PROP......');
   
	FOR I IN V_TIPO_SEC.FIRST .. V_TIPO_SEC.LAST
	LOOP
		V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_EAS_ENTIDAD_ADJUD_PROP.NEXTVAL FROM DUAL';

		EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;

		V_TMP_TIPO_SEC := V_TIPO_SEC(I);

		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EAS_ENTIDAD_ADJUD_PROP (DD_EAS_ID,DD_EAS_CODIGO,DD_EAS_DESCRIPCION,' || 'DD_EAS_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
			' SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_SEC(1)||''','''||TRIM(V_TMP_TIPO_SEC(2))||''','''||TRIM(V_TMP_TIPO_SEC(3))||''','||'0,''DD'',SYSDATE,0 FROM DUAL';

		DBMS_OUTPUT.PUT_LINE('INSERTANDO: '||V_TMP_TIPO_SEC(1)||''','''||TRIM(V_TMP_TIPO_SEC(2))||'''');

		EXECUTE IMMEDIATE V_MSQL;

	END LOOP;
   
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
       rollback;
	RAISE;
END;
/
EXIT;