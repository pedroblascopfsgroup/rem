--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151002
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-532
--## PRODUCTO=NO
--## 
--## Finalidad: validaciones Efectos Cnt y Efectos Personas
--## INSTRUCCIONES:  validaciones Efectos Cnt y Efectos Personas
--## VERSIONES:
--## 0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
  
 TYPE T_JVI IS TABLE OF VARCHAR2(250);
 TYPE T_ARRAY_JVI IS TABLE OF T_JVI;
 
 TYPE T_JVS IS TABLE OF VARCHAR2(250);
 TYPE T_ARRAY_JVS IS TABLE OF T_JVS;
 
 TYPE T_JBV IS TABLE OF VARCHAR2(4000);
 TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
 
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

  -- Configuracion Esquemas
 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
 seq_count NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
 table_count NUMBER(3); -- Vble. para validar la existencia de las Tablas.
 v_column_count  NUMBER(3); -- Vble. para validar la existencia de las Columnas.
 v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
 err_num  NUMBER; -- Numero de errores
 err_msg  VARCHAR2(2048); -- Mensaje de error 
 V_MSQL VARCHAR2(4000 CHAR);
 V_EXIST  NUMBER(10);
 V_ENTIDAD_ID  NUMBER(16); 
 V_ENTIDAD NUMBER(16);

 V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
 
 

 
--Código del grupo de carga 
--Configuracion  EXT_DD_JVI_JOB_VAL_INTERFAZ
  
 V_JVI T_ARRAY_JVI := T_ARRAY_JVI(
     T_JVI('APR_AUX_EFC_EFECTOS_CNT','Tabla tmp de Efectos Contratos', 'Tabla tmp de Efectos Contratos', 'EFECTOS')
   , T_JVI('APR_AUX_EFP_EFEC_PER','Tabla tmp de Efectos Personas', 'Tabla tmp de Efectos Personas', 'EFECTOS')
  );
  

 V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
-- Validaciones de EFECTOS
            T_JBV('efe-00.countValidator',1,'select count(1) from APR_AUX_EFC_EFECTOS_CNT',8,2,0)
           ,T_JBV('efe-01.entityValidator',1,'SELECT EFC_CODIGO_EFECTO AS ERROR_FIELD, to_char(EFC_CODIGO_ENTIDAD) AS ENTITY_CODE FROM APR_AUX_EFC_EFECTOS_CNT WHERE EFC_CODIGO_ENTIDAD <> #TOKEN_ENTITY#',8,2,0)
           ,T_JBV('efe-02.loadDateValidator',1,'SELECT EFC_FECHA_EXTRACCION AS ERROR_FIELD, TO_CHAR(EFC_CODIGO_EFECTO) AS ENTITY_CODE from APR_AUX_EFC_EFECTOS_CNT where EFC_FECHA_EXTRACCION <> to_date(#TOKEN_DATE#,''''YYYYMMDD'''')',8,2,0)
           ,T_JBV('efe-03.entityValidatorRelation',1,'SELECT CODIGO_EFECTO AS ERROR_FIELD, to_char(CODIGO_ENTIDAD) AS ENTITY_CODE FROM APR_AUX_EFP_EFEC_PER WHERE CODIGO_ENTIDAD <> #TOKEN_ENTITY#',8,2,0)
		   ,T_JBV('efe-02.loadDateValidatorRelation',1,'SELECT FECHA_EXTRACCION AS ERROR_FIELD, to_char(CODIGO_EFECTO) AS ENTITY_CODE from APR_AUX_EFP_EFEC_PER where FECHA_EXTRACCION <> to_date(#TOKEN_DATE#,''''YYYYMMDD'''')',8,2,0)
           ,T_JBV('efe-03.cntContratoValidator',1,'select efc.efc_numero_contrato as ERROR_FIELD, to_char(efc.EFC_CODIGO_EFECTO) AS ENTITY_CODE from APR_AUX_EFC_EFECTOS_CNT efc where not exists(select 1 from cnt_contratos cnt where cnt.cnt_contrato = efc.efc_numero_contrato )',8,1,0)
		   ,T_JBV('efe-04.cntinsertBiePropietarioValidator',1,'INSERT INTO DD_PRO_PROPIETARIOS  (DD_PRO_ID, DD_PRO_CODIGO, DD_PRO_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_PRO_PROPIETARIOS.NEXTVAL, PROX.DD_PRO_CODIGO, PROX.DD_PRO_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_PRO_CODIGO, ''''Propietario pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_PRO_DESCRIPCION  from (  SELECT (''''''''||efc.EFC_CODIGO_PROPIETARIO) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE    FROM APR_AUX_EFC_EFECTOS_CNT efc  WHERE   efc.EFC_CODIGO_PROPIETARIO is not null and   not exists( SELECT 1 FROM DD_PRO_PROPIETARIOS WHERE DD_PRO_CODIGO = trim(efc.EFC_CODIGO_PROPIETARIO)) )) PROX',8,1,0)
		   ,T_JBV('efe-04.cntPropietarioValidator',1,'SELECT (EFC.EFC_CODIGO_PROPIETARIO) AS ERROR_FIELD, (EFC.EFC_CODIGO_ENTIDAD || EFC.EFC_CODIGO_EFECTO) AS ENTITY_CODE FROM APR_AUX_EFC_EFECTOS_CNT EFC WHERE EFC.EFC_CODIGO_PROPIETARIO IS NOT NULL AND NOT EXISTS( SELECT 1 FROM DD_PRO_PROPIETARIOS WHERE DD_PRO_CODIGO = TRIM(EFC.EFC_CODIGO_PROPIETARIO))',8,1,0)
		   ,T_JBV('efe-05.cntUniqueValidator',1,'select efc_numero_contrato as ERROR_FIELD, efc_codigo_efecto as ENTITY_CODE  from APR_AUX_EFC_EFECTOS_CNT group by efc_numero_contrato, efc_codigo_efecto having count(efc_codigo_efecto) > 1',8,1,0)
		   ,T_JBV('efe-06.cntinsertTipoEfectoValidator',1,'INSERT INTO DD_TEF_TIPO_EFECTO  (DD_TEF_ID, DD_TEF_CODIGO, DD_TEF_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TEF_TIPO_EFECTO.NEXTVAL, PROX.DD_TEF_CODIGO, PROX.DD_TEF_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_TEF_CODIGO, ''''Tipo Efecto pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TEF_DESCRIPCION  from (  SELECT (''''''''||efc.DD_TIPO_EFECTO) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE  FROM APR_AUX_EFC_EFECTOS_CNT efc WHERE efc.DD_TIPO_EFECTO is not null and not exists( SELECT 1 FROM DD_TEF_TIPO_EFECTO  WHERE DD_TEF_CODIGO = trim(efc.DD_TIPO_EFECTO)) )) PROX',8,1,0)
		   ,T_JBV('efe-06.cntTipoValidator',1,'SELECT (EFC.DD_TIPO_EFECTO) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFC_EFECTOS_CNT efc WHERE EFC.DD_TIPO_EFECTO is not null and  not exists( SELECT 1 FROM DD_TEF_TIPO_EFECTO WHERE DD_TEF_CODIGO = trim(efc.DD_TIPO_EFECTO))',8,1,0)
		   ,T_JBV('efe-07.cntSituacionValidator',1,'SELECT (EFC.DD_SITUACION_EFECTO) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFC_EFECTOS_CNT efc WHERE EFC.DD_SITUACION_EFECTO is not null and not exists( SELECT 1 FROM DD_SEF_SITUACION_EFECTO WHERE DD_SEF_CODIGO = trim(efc.DD_SITUACION_EFECTO))',8,1,0)
		   ,T_JBV('efe-08.cntinsertMonedaValidator',1,'INSERT INTO DD_MON_MONEDAS  (DD_MON_ID, DD_MON_CODIGO, DD_MON_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_MON_MONEDAS.NEXTVAL, PROX.DD_MON_CODIGO, PROX.DD_MON_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_MON_CODIGO, ''''Moneda pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_MON_DESCRIPCION  from (  SELECT (''''''''||efc.DD_MONEDA) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE    FROM APR_AUX_EFC_EFECTOS_CNT efc  WHERE   efc.DD_MONEDA is not null and   not exists( SELECT 1 FROM DD_MON_MONEDAS  WHERE DD_MON_CODIGO = trim(efc.DD_MONEDA)))   ) PROX',8,1,0)
		   ,T_JBV('efe-08.cntMonedaValidator',1,'SELECT (EFC.DD_MONEDA) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFC_EFECTOS_CNT efc WHERE EFC.DD_MONEDA is not null and not exists( SELECT 1 FROM DD_MON_MONEDAS WHERE DD_MON_CODIGO = trim(efc.DD_MONEDA))',8,1,0)
		   ,T_JBV('efe-09.cntinsertTipofechavencValidator',1,'INSERT INTO DD_TFV_TIPO_FECHA_VENC  (DD_TFV_ID, DD_TFV_CODIGO, DD_TFV_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TFV_TIPO_FECHA_VENC.NEXTVAL, PROX.DD_TFV_CODIGO, PROX.DD_TFV_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_TFV_CODIGO, ''''Tipo Fecha Vencimiento pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TFV_DESCRIPCION  from (  SELECT (''''''''||efc.DD_TIPO_FECHA_VENCIMIENTO) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE    FROM APR_AUX_EFC_EFECTOS_CNT efc WHERE   efc.DD_TIPO_FECHA_VENCIMIENTO is not null and   not exists( SELECT 1 FROM DD_TFV_TIPO_FECHA_VENC WHERE DD_TFV_CODIGO = trim(efc.DD_TIPO_FECHA_VENCIMIENTO)) ) ) PROX',8,1,0)
		   ,T_JBV('efe-09.cntTipofechavencValidator',1,'SELECT (EFC.DD_TIPO_FECHA_VENCIMIENTO) as ERROR_FIELD, (efc.EFC_CODIGO_ENTIDAD || efc.EFC_CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFC_EFECTOS_CNT efc WHERE EFC.DD_TIPO_FECHA_VENCIMIENTO is not null and not exists( SELECT 1 FROM DD_TFV_TIPO_FECHA_VENC WHERE DD_TFV_CODIGO = trim(efc.DD_TIPO_FECHA_VENCIMIENTO))',8,1,0)
		   ,T_JBV('efe-11.perPersonaValidator',1,'select efp.codigo_persona as ERROR_FIELD, TO_CHAR(efp.codigo_efecto) AS ENTITY_CODE from APR_AUX_EFP_EFEC_PER efp where not exists(select 1 from PER_PERSONAS per where per.PER_ID = efp.codigo_persona )',9,1,0)
		   ,T_JBV('efe-12.insertperProductoValidator',1,'INSERT INTO DD_TPR_TIPO_PROD  (DD_TPR_ID, DD_TPR_CODIGO, DD_TPR_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TPR_TIPO_PROD.NEXTVAL, PROX.DD_TPR_CODIGO, PROX.DD_TPR_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_TPR_CODIGO, ''''Tipo Producto pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPR_DESCRIPCION  from (  SELECT (''''''''||efp.TIPO_PRODUCTO) as ERROR_FIELD, (efp.CODIGO_ENTIDAD || efp.CODIGO_EFECTO) as ENTITY_CODE    FROM APR_AUX_EFP_EFEC_PER efp  WHERE   efp.TIPO_PRODUCTO is not null and   not exists( SELECT 1     FROM DD_TPR_TIPO_PROD        WHERE DD_TPR_CODIGO = trim(efp.TIPO_PRODUCTO))       )   ) PROX',9,1,0)
		   ,T_JBV('efe-12.perProductoValidator',1,'SELECT (EFP.TIPO_PRODUCTO) as ERROR_FIELD, (efP.CODIGO_ENTIDAD || EfP.CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFP_EFEC_PER efp WHERE EFP.TIPO_PRODUCTO is not null and not exists( SELECT 1 FROM DD_TPR_TIPO_PROD WHERE DD_TPR_CODIGO = trim(efp.TIPO_PRODUCTO))',9,1,0)
		   ,T_JBV('efe-13.perUniqueValidator',1,'select CODIGO_PERSONA as ERROR_FIELD, CODIGO_EFECTO as ENTITY_CODE  from APR_AUX_EFP_EFEC_PER group by CODIGO_PERSONA, CODIGO_EFECTO having count(CODIGO_EFECTO) > 1',9,1,0)
		   ,T_JBV('efe-14.perinsertTipoValidator',1,'INSERT INTO DD_TPE_TIPO_PERSONA  (DD_TPE_ID, DD_TPE_CODIGO, DD_TPE_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TPE_TIPO_PERSONA.NEXTVAL, PROX.DD_TPE_CODIGO, PROX.DD_TPE_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_TPE_CODIGO, ''''Tipo Persona pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPE_DESCRIPCION  from (  SELECT (''''''''||efp.TIPO_PERSONA) as ERROR_FIELD, (efp.CODIGO_ENTIDAD || efp.CODIGO_EFECTO) as ENTITY_CODE    FROM APR_AUX_EFP_EFEC_PER efp  WHERE   efp.TIPO_PERSONA is not null and   not exists( SELECT 1     FROM DD_TPE_TIPO_PERSONA        WHERE DD_TPE_CODIGO = trim(efp.TIPO_PERSONA))       )   ) PROX',9,1,0)
		   ,T_JBV('efe-14.perTipoValidator',1,'SELECT (EFP.TIPO_PERSONA) as ERROR_FIELD, (efP.CODIGO_ENTIDAD || EfP.CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFP_EFEC_PER efp WHERE   EFP.TIPO_PERSONA is not null and   not exists( SELECT 1     FROM DD_TPE_TIPO_PERSONA   WHERE DD_TPE_CODIGO = trim(efp.TIPO_PERSONA))',9,1,0)
		   ,T_JBV('efe-15.insertperTipoDocValidator',1,'INSERT INTO DD_TDI_TIPO_DOCUMENTO_ID  (DD_TDI_ID, DD_TDI_CODIGO, DD_TDI_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TDI_TIPO_DOCUMENTO_ID.NEXTVAL, PROX.DD_TDI_CODIGO, PROX.DD_TDI_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_TDI_CODIGO, ''''Tipo Documento pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TDI_DESCRIPCION from (  SELECT (''''''''||efp.TIPO_DOCUMENTO) as ERROR_FIELD, (efp.CODIGO_ENTIDAD || efp.CODIGO_EFECTO) as ENTITY_CODE    FROM APR_AUX_EFP_EFEC_PER efp WHERE   efp.TIPO_DOCUMENTO is not null and   not exists( SELECT 1     FROM DD_TDI_TIPO_DOCUMENTO_ID        WHERE DD_TDI_CODIGO = trim(efp.TIPO_DOCUMENTO))       )   ) PROX',9,1,0)
		   ,T_JBV('efe-15.perTipoDocValidator',1,'SELECT (EFP.TIPO_DOCUMENTO) as ERROR_FIELD, (efP.CODIGO_ENTIDAD || EfP.CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFP_EFEC_PER efp WHERE EFP.TIPO_DOCUMENTO is not null and   not exists( SELECT 1 FROM DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = trim(efp.TIPO_DOCUMENTO))',9,1,0)
		   ,T_JBV('efe-17.perContratoValidator',1,'select efp.codigo_persona as ERROR_FIELD,to_char(efp.NUMERO_CONTRATO) AS ENTITY_CODE from APR_AUX_EFP_EFEC_PER efp where not exists(select 1 from CNT_CONTRATOS CNT where CNT.CNT_ID = efp.NUMERO_CONTRATO )',9,1,0)
		   ,T_JBV('efe-18.insertperPropietarioValidator',1,'INSERT INTO DD_PRO_PROPIETARIOS  (DD_PRO_ID, DD_PRO_CODIGO, DD_PRO_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_PRO_PROPIETARIOS.NEXTVAL, PROX.DD_PRO_CODIGO, PROX.DD_PRO_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_PRO_CODIGO, ''''Propietario pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_PRO_DESCRIPCION from (  SELECT (''''''''||efp.CODIGO_PROPIETARIO) as ERROR_FIELD, (efp.CODIGO_ENTIDAD || efp.CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFP_EFEC_PER efp  WHERE   efp.CODIGO_PROPIETARIO is not null and   not exists( SELECT 1 FROM DD_PRO_PROPIETARIOS WHERE DD_PRO_CODIGO = trim(efp.CODIGO_PROPIETARIO)) )) PROX',8,1,0)
		   ,T_JBV('efe-18.perPropietarioValidator',1,'SELECT (EFP.CODIGO_PROPIETARIO) as ERROR_FIELD, (efP.CODIGO_ENTIDAD || EfP.CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFP_EFEC_PER efp WHERE   EFP.CODIGO_PROPIETARIO is not null and   not exists( SELECT 1 FROM DD_PRO_PROPIETARIOS WHERE DD_PRO_CODIGO = trim(efp.CODIGO_PROPIETARIO))',9,1,0)
		   
		   ,T_JBV('efe-19.insertperTipoRelacionEfecValidator',1,'INSERT INTO DD_TIE_TIPO_INTERV_EFECTO  (DD_TIE_ID, DD_TIE_CODIGO, DD_TIE_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TIE_TIPO_INTERV_EFECTO.NEXTVAL, PROX.DD_TIE_CODIGO, PROX.DD_TIE_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0 FROM (       SELECT DISTINCT ERROR_FIELD as DD_TIE_CODIGO, ''''Tipo Relacion Efecto pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TIE_DESCRIPCION from (  SELECT (''''''''||efp.TIPO_RELACION) as ERROR_FIELD, (efp.CODIGO_ENTIDAD || efp.CODIGO_EFECTO) as ENTITY_CODE  FROM APR_AUX_EFP_EFEC_PER efp WHERE   efp.TIPO_RELACION is not null and   not exists( SELECT 1  FROM DD_TIE_TIPO_INTERV_EFECTO  WHERE DD_TIE_CODIGO = trim(efp.TIPO_RELACION)) ) ) PROX',9,1,0)
		   ,T_JBV('efe-19.perTipoRelacionEfecValidator',1,'SELECT (EFP.TIPO_RELACION) as ERROR_FIELD, (efP.CODIGO_ENTIDAD || EfP.CODIGO_EFECTO) as ENTITY_CODE FROM APR_AUX_EFP_EFEC_PER efp WHERE EFP.TIPO_RELACION is not null and not exists( SELECT 1 FROM DD_TIE_TIPO_INTERV_EFECTO WHERE DD_TIE_CODIGO = trim(efp.TIPO_RELACION))',9,1,0)
  );   
  
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
 
 V_TMP_JVI T_JVI;
 V_TMP_JVS T_JVS;
 V_TMP_JBV T_JBV; 

 
BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de BATCH_JOB_VALIDATION');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.BATCH_JOB_VALIDATION WHERE JOB_VAL_INTERFAZ IN (8,9)');
 
 
 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_JVI_JOB_VAL_INTERFAZ');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_JVI_JOB_VAL_INTERFAZ WHERE DD_JVI_BLOQUE = ''EFECTOS''');
  

 --DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_JVS_JOB_VAL_SEVERITY');
 --EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_JVS_JOB_VAL_SEVERITY');
  

 DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_JVI_JOB_VAL_INTERFAZ' and sequence_owner=V_ESQUEMA_MASTER;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 1');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_JVI_JOB_VAL_INTERFAZ');
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_JVI_JOB_VAL_INTERFAZ
 START WITH 8
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 
 
/*
  V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_JVS_JOB_VAL_SEVERITY' and sequence_owner=V_ESQUEMA_MASTER;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 2');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_JVS_JOB_VAL_SEVERITY');
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_JVS_JOB_VAL_SEVERITY
 START WITH 1
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 
 */

/*
  V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_BATCH_JOB_VALIDATION' and sequence_owner=V_ESQUEMA_MASTER;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 3');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_BATCH_JOB_VALIDATION');
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_BATCH_JOB_VALIDATION
 START WITH 1
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 
  
*/


  V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_BATCH_JOB_VALIDATION' and sequence_owner=V_ESQUEMA_MASTER;

 DBMS_OUTPUT.PUT_LINE('Creando EXT_DD_JVI_JOB_VAL_INTERFAZ......');
 FOR I IN V_JVI.FIRST .. V_JVI.LAST
 LOOP
  V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_JVI_JOB_VAL_INTERFAZ.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
 V_TMP_JVI := V_JVI(I);
 DBMS_OUTPUT.PUT_LINE('Creando JVI: '||V_TMP_JVI(1)); 

 V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_JVI_JOB_VAL_INTERFAZ (DD_JVI_ID, DD_JVI_CODIGO, DD_JVI_DESCRIPCION,' ||
 'DD_JVI_DESCRIPCION_LARGA, DD_JVI_BLOQUE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_JVI(1)||''','''||SUBSTR(V_TMP_JVI(2),1, 50)||''','''
  ||V_TMP_JVI(3)||''','''
  ||V_TMP_JVI(4)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
 EXECUTE IMMEDIATE V_MSQL;
 END LOOP; 
 V_TMP_JVI := NULL;

 
/*
DBMS_OUTPUT.PUT_LINE('Creando EXT_DD_JVS_JOB_VAL_SEVERITY......');
 FOR I IN V_JVS.FIRST .. V_JVS.LAST
 LOOP
  V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_JVS_JOB_VAL_SEVERITY.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
 V_TMP_JVS := V_JVS(I);
 DBMS_OUTPUT.PUT_LINE('Creando JVS: '||V_TMP_JVS(1)); 

 V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_JVS_JOB_VAL_SEVERITY (DD_JVS_ID, DD_JVS_CODIGO, DD_JVS_DESCRIPCION,' ||
 'DD_JVS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_JVS(1)||''','''||SUBSTR(V_TMP_JVS(2),1, 50)||''','''
  ||V_TMP_JVS(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
 EXECUTE IMMEDIATE V_MSQL;
 END LOOP; 
 V_TMP_JVS := NULL;

*/

 --sacamos la el codigo entidad de la tabla ENTIDAD.
  
 V_ENTIDAD:=1;
 V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.ENTIDAD WHERE DESCRIPCION = ''CAJAMAR''';
 EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD;
  
 if V_ENTIDAD is null or V_ENTIDAD = 0 then 
	V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.ENTIDAD ( ID,
		    DESCRIPCION,
		    USUARIOCREAR,
		    FECHACREAR,
		    USUARIOMODIFICAR,
		    FECHAMODIFICAR,
		    USUARIOBORRAR,
		    FECHABORRAR,
    		    BORRADO
		) VALUES (
			'||V_ESQUEMA_MASTER||'.S_ENTIDAD.nextval,
			''CAJAMAR'',
			''DD'',
			SYSDATE,
			null,
			null,
			null,
			null,
			0
		)
		';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('INSERTAMOS LA ENTIDAD CAJAMAR......');
 end if;

-- UPDATE #ESQUEMA_MASTER#.ENTIDAD SET DESCRIPCION = 'CAJAMAR' WHERE ROWNUM < 2;

COMMIT;
  
 V_ENTIDAD:=1;
 
 V_MSQL := 'SELECT ID FROM '||V_ESQUEMA_MASTER||'.ENTIDAD WHERE DESCRIPCION = ''CAJAMAR''';
 EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD;

-- select ID INTO V_ENTIDAD from #ESQUEMA_MASTER#.ENTIDAD where DESCRIPCION = 'CAJAMAR';
 

 DBMS_OUTPUT.PUT_LINE('Creando BATCH_JOB_VALIDATION......');
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
  V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_BATCH_JOB_VALIDATION.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
 V_TMP_JBV := V_JBV(I);
 DBMS_OUTPUT.PUT_LINE('Creando BATCH_JOB_VALIDATION: '||V_TMP_JBV(1)); 

 V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.BATCH_JOB_VALIDATION (JOB_VAL_ID, JOB_VAL_CODIGO, JOB_VAL_ENTITY, JOB_VAL_ORDER, JOB_VAL_VALUE, JOB_VAL_INTERFAZ, JOB_VAL_SEVERITY ' ||
 ', VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
 ' VALUES ('||  V_ENTIDAD_ID || ','''
  ||V_TMP_JBV(1)||''','''
  ||V_ENTIDAD||''','''
  ||V_ENTIDAD_ID||''','''
  ||V_TMP_JBV(3)||''',''' 
  ||V_TMP_JBV(4)||''','''
  ||V_TMP_JBV(5)||''',0,'''
  ||V_USUARIO_CREAR||''',SYSDATE,'''
  ||V_TMP_JBV(6)||''')';
 EXECUTE IMMEDIATE V_MSQL;
 END LOOP; 
 V_TMP_JVI := NULL; 
 

 COMMIT;

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
