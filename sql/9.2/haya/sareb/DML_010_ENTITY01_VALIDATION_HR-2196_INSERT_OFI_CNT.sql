--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ 
--## FECHA_CREACION=20160614
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=HR-2196
--## PRODUCTO=NO
--## 
--## Finalidad: Insert cnt-04.insertOfficeZoneCodeValidator
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--## 0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

  TYPE T_JBV IS TABLE OF VARCHAR2(4000);
  TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuración Esquemas
 V_ESQUEMA                  VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				            	-- Configuracion Esquema
 V_ESQUEMA_MASTER           VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		      -- Configuracion Esquema Master
 seq_count                  NUMBER(3); 										                  	-- Vble. para validar la existencia de las Secuencias.
 table_count                NUMBER(3); 										                  -- Vble. para validar la existencia de las Tablas.
 v_column_count             NUMBER(3); 								                	-- Vble. para validar la existencia de las Columnas.
 v_constraint_count         NUMBER(3); 							              		-- Vble. para validar la existencia de las Constraints.
 err_num                    NUMBER; 												                    -- Numero de errores
 err_msg                    VARCHAR2(2048); 										                -- Mensaje de error 
 V_MSQL                     VARCHAR2(4000 CHAR);
 V_EXIST                    NUMBER(10);
 V_ENTIDAD_ID               NUMBER(16); 
 V_ENTIDAD                  NUMBER(16);
 V_USUARIO_CREAR            VARCHAR2(50) := 'VALIDACION_PCR_HAYA';

 V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
-- Validaciones de contratos 
			T_JBV('cnt-04.insertOfficeZoneCodeValidator',1,'DECLARE CURSOR c_NEWOFFICE IS SELECT DISTINCT TMP_CNT_COD_ENT_OFI_CNTBLE, TMP_CNT_COD_OFI_CNTBLE, TMP_CNT_COD_SUBSC_OFI_CNTBLE, TMP_CNT_COD_OFICINA FROM tmp_cnt_contratos X WHERE NOT EXISTS ( SELECT 1 FROM ofi_oficinas o WHERE X.TMP_CNT_COD_OFICINA = O.OFI_CODIGO_ENTIDAD_OFICINA||LPAD(O.OFI_CODIGO_OFICINA, 5, ''''0'''')||LPAD(O.OFI_CODIGO_SUBSECCION_OFICINA, 2, ''''0'''') );
								v_SQL VARCHAR2(32000); v_SQLInsert VARCHAR2(32000); n_OFI_ID NUMBER;  n_OFI_CODE VARCHAR2 (100); n_ZON_ID NUMBER;  v_ZON_COD VARCHAR2(50);  n_ZON_PID NUMBER;  ifExist NUMBER; BEGIN  FOR i IN c_NEWOFFICE LOOP  v_SQL := ''''--> VALORES DEL LOOP ''''||i.TMP_CNT_COD_ENT_OFI_CNTBLE||'''' - ''''||i.TMP_CNT_COD_OFI_CNTBLE||'''' - ''''||i.TMP_CNT_COD_SUBSC_OFI_CNTBLE||''''.''''; select S_OFI_OFICINAS.NEXTVAL into n_OFI_ID from dual; select i.TMP_CNT_COD_OFICINA into n_OFI_CODE FROM DUAL; select count(1) into ifExist FROM OFI_OFICINAS where OFI_CODIGO = i.TMP_CNT_COD_OFICINA; if ifExist = 0 then v_SQLInsert := ''''Insert into OFI_OFICINAS ( OFI_ID, OFI_CODIGO, OFI_NOMBRE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, OFI_FECHA_EXTRACCION, OFI_FECHA_DATO, OFI_CODIGO_ENTIDAD_OFICINA, OFI_CODIGO_OFICINA, OFI_CODIGO_SUBSECCION_OFICINA ) SELECT ''''||n_OFI_ID||'''', ''''''''''''||n_OFI_CODE||'''''''''''', ''''''''Oficina pendiente de definir'''''''', ''''''''0'''''''', ''''''''Batch'''''''',sysdate, ''''''''0'''''''', sysdate, sysdate, ''''||i.TMP_CNT_COD_ENT_OFI_CNTBLE||'''',''''||i.TMP_CNT_COD_OFI_CNTBLE||'''',''''||i.TMP_CNT_COD_SUBSC_OFI_CNTBLE||'''' FROM DUAL WHERE ''''''''''''||n_OFI_CODE||'''''''''''' NOT IN (SELECT DISTINCT OFI_CODIGO FROM OFI_OFICINAS)  ''''; EXECUTE IMMEDIATE v_SQLInsert; select s_ZON_ZONIFICACION.nextval into n_ZON_ID from dual;  select to_char(''''01''''||newzoncod) zoncod into v_ZON_COD from ( select max(hijo)+1 newzoncod from (select zon_cod, to_number(substr(zon_cod, 3, 6)) hijo from zon_zonificacion where length(zon_cod) = 6 ) ); SELECT ZON_ID into n_ZON_PID FROM ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''''CENTRO EMPRESA''''; v_SQLInsert := ''''Insert into ZON_ZONIFICACION ( ZON_ID, ZON_COD, ZON_PID, NIV_ID, OFI_ID, VERSION, USUARIOCREAR,FECHACREAR, BORRADO, ZON_FECHA_EXTRACCION,ZON_FECHA_DATO ) SELECT ''''||n_ZON_ID||'''', ''''''''''''||v_ZON_COD||'''''''''''', ''''||n_ZON_PID||'''', (SELECT NIV_ID FROM niv_nivel WHERE niv_descripcion = ''''''''Oficina'''''''' and borrado = 0), ''''||n_OFI_ID||'''', ''''''''0'''''''', ''''''''Batch'''''''',sysdate, ''''''''0'''''''', sysdate, sysdate FROM DUAL ''''; EXECUTE IMMEDIATE v_SQLInsert; end if; END LOOP; END; ',1,1,0)
  );   
  
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
  V_TMP_JBV T_JBV; 
 
BEGIN

--Sacamos la el codigo entidad de la tabla ENTIDAD.
  SELECT ID INTO V_ENTIDAD FROM HAYAMASTER.ENTIDAD WHERE DESCRIPCION = 'HAYA';

  DBMS_OUTPUT.PUT_LINE('Rellenando BATCH_JOB_VALIDATION. .. ... .... .....');
  FOR I IN V_JBV.FIRST .. V_JBV.LAST
	LOOP
		V_TMP_JBV := V_JBV(I);
			V_MSQL :=	'SELECT COUNT(1)
                  FROM '||V_ESQUEMA_MASTER||'.BATCH_JOB_VALIDATION 
                  WHERE JOB_VAL_CODIGO LIKE '''||V_TMP_JBV(1)||''' AND JOB_VAL_ENTITY = '||V_ENTIDAD;
      EXECUTE IMMEDIATE V_MSQL INTO v_column_count;
			IF v_column_count = 0 THEN
				V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_BATCH_JOB_VALIDATION.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
				DBMS_OUTPUT.PUT_LINE('Creando el registro número '||I||' en BATCH_JOB_VALIDATION: '||V_TMP_JBV(1)); 
				V_MSQL :=	'
								INSERT INTO 
									'||V_ESQUEMA_MASTER||'.BATCH_JOB_VALIDATION 
									(JOB_VAL_ID, JOB_VAL_CODIGO, JOB_VAL_ENTITY
									, JOB_VAL_ORDER, JOB_VAL_VALUE, JOB_VAL_INTERFAZ
									, JOB_VAL_SEVERITY, VERSION, USUARIOCREAR, FECHACREAR
									, BORRADO) 
									VALUES  ('
											  ||V_ENTIDAD_ID||'
											  ,'''||V_TMP_JBV(1)||'''
											  ,'||V_ENTIDAD||'
											  ,'||V_ENTIDAD_ID||'
											  ,'''||V_TMP_JBV(3)||'''
											  ,'||V_TMP_JBV(4)||'
											  ,'||V_TMP_JBV(5)||'
											  ,0
											  ,'''||V_USUARIO_CREAR||'''
											  ,SYSDATE
											  ,'||V_TMP_JBV(6)||'
											)
							';
				EXECUTE IMMEDIATE V_MSQL;
			ELSE
				DBMS_OUTPUT.PUT_LINE('Registro número '||I||' existente.');
			END IF;
    END LOOP; 

EXCEPTION
  WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  ROLLBACK;
  RAISE;
  
END;
/
EXIT;
