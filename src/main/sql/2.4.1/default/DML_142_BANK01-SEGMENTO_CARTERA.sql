--/*
--##########################################
--## Author: Francisco Gutiérrez
--## Finalidad: DML de Diccionario Segmento Cartera
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
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
		T_TIPO_SEC('80101','Bancos','Bancos'),
		T_TIPO_SEC('80203','Establecimientos Finan','Establecimientos Finan'),
		T_TIPO_SEC('80306','Seguros y Reaseguros','Seguros y Reaseguros'),
		T_TIPO_SEC('80104','Grandes Empresas','Grandes Empresas'),
		T_TIPO_SEC('80204','Medianas Empresas','Medianas Empresas'),
		T_TIPO_SEC('80304','Pequeñas Empresas','Pequeñas Empresas'),
		T_TIPO_SEC('80402','Empresas no Segmentada','Empresas no Segmentada'),
		T_TIPO_SEC('80103','Financiaciones Especia','Financiaciones Especia'),
		T_TIPO_SEC('80020','Particulares pasivo y servicio','Particulares pasivo y servicio'),
		T_TIPO_SEC('80021','Autonomos  pasivo y servicio','Autonomos  pasivo y servicio'),
		T_TIPO_SEC('80022','Microempresa pasivo y servicio','Microempresa pasivo y servicio'),
		T_TIPO_SEC('80023','Micropromotores pasivo y servicio','Micropromotores pasivo y servicio'),
		T_TIPO_SEC('80024','Microempresa publica pasivo y serv.','Microempresa publica pasivo y serv.'),
		T_TIPO_SEC('80106','Hipotecario','Hipotecario'),
		T_TIPO_SEC('80206','Tarjetas','Tarjetas'),
		T_TIPO_SEC('80301','Consumo','Consumo'),
		T_TIPO_SEC('80401','Comercio','Comercio'),
		T_TIPO_SEC('80501','Microempresas','Microempresas'),
		T_TIPO_SEC('80601','Autónomos','Autónomos'),
		T_TIPO_SEC('80107','Hipotecario SS','Hipotecario SS'),
		T_TIPO_SEC('80302','Consumo SS','Consumo SS'),
		T_TIPO_SEC('80502','Microempresas SS','Microempresas SS'),
		T_TIPO_SEC('80602','Autónomos SS','Autónomos SS'),
		T_TIPO_SEC('80701','Colectivos especialesS','Colectivos especialesS'),
		T_TIPO_SEC('80108','Tesoros','Tesoros'),
		T_TIPO_SEC('80202','Comunidades Autonomas','Comunidades Autonomas'),
		T_TIPO_SEC('80303','Corporaciones Locales','Corporaciones Locales'),
		T_TIPO_SEC('80025','Pasivo no Segmentado','Pasivo no Segmentado'),
		T_TIPO_SEC('80105','Grandes Promotores','Grandes Promotores'),
		T_TIPO_SEC('80205','Medianos Promotores','Medianos Promotores'),
		T_TIPO_SEC('80305','Pequeños Promotores','Pequeños Promotores'),
		T_TIPO_SEC('80403','Promotores no Segmenta','Promotores no Segmenta')
       ); 

V_TMP_TIPO_SEC T_TIPO_SEC;

BEGIN

v_seq_count := 0;
v_table_count := 0;

	DBMS_OUTPUT.PUT_LINE('Truncate DD_SEC_SEGMENTO_CARTERA');
	EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA || '.DD_SEC_SEGMENTO_CARTERA');
	
	
   DBMS_OUTPUT.PUT_LINE('Cargando DD_SEC_SEGMENTO_CARTERA......');
   
   FOR I IN V_TIPO_SEC.FIRST .. V_TIPO_SEC.LAST
   LOOP
 
      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SEC_SEGMENTO_CARTERA.NEXTVAL FROM DUAL';
      
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      
      V_TMP_TIPO_SEC := V_TIPO_SEC(I);
      
      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SEC_SEGMENTO_CARTERA (DD_SEC_ID, DD_SEC_CODIGO, DD_SEC_DESCRIPCION,' ||
                                                                               'DD_SEC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                ' SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_SEC(1)||''','''||TRIM(V_TMP_TIPO_SEC(2))||''','''||TRIM(V_TMP_TIPO_SEC(3))||''','||
                '0,''DD'',SYSDATE,0 FROM DUAL';
   
      DBMS_OUTPUT.PUT_LINE('INSERTANDO: '||V_TMP_TIPO_SEC(1)||''','''||TRIM(V_TMP_TIPO_SEC(2))||'''');
      EXECUTE IMMEDIATE V_MSQL;
   
   END LOOP; --LOOP 
   
   COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
       rollback;
	RAISE;
END;
/
