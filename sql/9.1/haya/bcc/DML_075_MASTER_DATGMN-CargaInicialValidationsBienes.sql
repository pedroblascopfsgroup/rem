--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20151013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-532
--## PRODUCTO=NO
--## 
--## Finalidad: Limpieza y carga inicial de tablas validaciones DD_JVI_JOB_VAL_INTERFAZ, y BATCH_JOB_VALIDATION para BIENES, esquema #ESQUEMA_MASTER#
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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

 
--Configuracion  DD_JVI_JOB_VAL_INTERFAZ para BIENES
  
   V_JVI T_ARRAY_JVI := T_ARRAY_JVI(
                                    T_JVI('APR_AUX_ABI_BIENES_CONSOL','Tabla tmp de Bienes', 'Tabla tmp de Bienes', 'BIENES')
                                  , T_JVI('APR_AUX_ABC_BIECNT_CONSOL','Tabla tmp de Bienes Contratos', 'Tabla tmp de Bienes Contratos', 'BIENES')
                                  , T_JVI('APR_AUX_ABC_BIEPER_CONSOL','Tabla tmp de Bienes Personas', 'Tabla tmp de Bienes Personas', 'BIENES')
  );
  
  
  
 V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
-- Validaciones bienes
               T_JBV('bie-00.countValidator',1,'select count(1) from APR_AUX_ABI_BIENES_CONSOL  ',10,2,0)
             , T_JBV('bie-01.entityValidator',1,'SELECT CODIGO_ENTIDAD AS ERROR_FIELD, to_char(CODIGO_BIEN) AS ENTITY_CODE  FROM APR_AUX_ABI_BIENES_CONSOL WHERE CODIGO_ENTIDAD <> #TOKEN_ENTITY#',10,2,0)
             , T_JBV('bie-02.entityValidatorRelCnt',1,'SELECT CODIGO_ENTIDAD AS ERROR_FIELD, to_char(CODIGO_BIEN)||''''-''''||to_char(NUMERO_CONTRATO) AS ENTITY_CODE  FROM APR_AUX_ABC_BIECNT_CONSOL WHERE CODIGO_ENTIDAD <> #TOKEN_ENTITY#',11,2,0)
             , T_JBV('bie-03.entityValidatorRelPer',1,'SELECT CODIGO_ENTIDAD AS ERROR_FIELD, to_char(CODIGO_BIEN)||''''-''''||to_char(CODIGO_PERSONA) AS ENTITY_CODE  FROM APR_AUX_ABC_BIEPER_CONSOL WHERE CODIGO_ENTIDAD <> #TOKEN_ENTITY#',12,2,0)             
             , T_JBV('bie-04.loadDateValidator',1,'SELECT FECHA_EXTRACCION AS ERROR_FIELD, TO_CHAR(CODIGO_BIEN) AS ENTITY_CODE from APR_AUX_ABI_BIENES_CONSOL where FECHA_EXTRACCION <> to_date(#TOKEN_DATE#,''''YYYYMMDD'''') ',10,2,0)
             , T_JBV('bie-05.loadDateValidatorRelCnt',1,'SELECT FECHA_EXTRACCION AS ERROR_FIELD, TO_CHAR(CODIGO_BIEN)||''''-''''||to_char(NUMERO_CONTRATO)  AS ENTITY_CODE from APR_AUX_ABC_BIECNT_CONSOL where FECHA_EXTRACCION <> to_date(#TOKEN_DATE#,''''YYYYMMDD'''') ',11,2,0)               
             , T_JBV('bie-06.loadDateValidatorRelPer',1,'SELECT FECHA_EXTRACCION AS ERROR_FIELD, TO_CHAR(CODIGO_BIEN)||''''-''''||to_char(CODIGO_PERSONA)  AS ENTITY_CODE from APR_AUX_ABC_BIEPER_CONSOL where FECHA_EXTRACCION <> to_date(#TOKEN_DATE#,''''YYYYMMDD'''') ',12,2,0)
             , T_JBV('bie-07.bieUniqueValidator',1,'select CODIGO_BIEN AS ERROR_FIELD, to_char(CODIGO_BIEN) AS ENTITY_CODE from APR_AUX_ABI_BIENES_CONSOL group by CODIGO_BIEN having count(*) > 1',10,2,0)                                                                 
             , T_JBV('bie-08.insertBiePropietarioValidator',1,'INSERT INTO DD_PRO_PROPIETARIOS  (DD_PRO_ID, DD_PRO_CODIGO, DD_PRO_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)   SELECT S_DD_PRO_PROPIETARIOS.NEXTVAL, PROX.DD_PRO_CODIGO, PROX.DD_PRO_DESCRIPCION,  0, #TOKEN_USR#,SYSTIMESTAMP, 0   FROM (       SELECT DISTINCT ERROR_FIELD as DD_PRO_CODIGO, ''''Propietario pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_PRO_DESCRIPCION        from (  SELECT (''''''''||bi.CODIGO_PROPIETARIO) as ERROR_FIELD, (bi.CODIGO_ENTIDAD || bi.CODIGO_BIEN) as ENTITY_CODE    FROM APR_AUX_ABI_BIENES_CONSOL bi    WHERE   bi.CODIGO_PROPIETARIO is not null and   not exists( SELECT 1     FROM DD_PRO_PROPIETARIOS        WHERE DD_PRO_CODIGO = trim(bi.CODIGO_PROPIETARIO))       )   ) PROX   ',10,1,0)
             , T_JBV('bie-08.biePropietarioValidator',1,'SELECT (''''''''||bi.CODIGO_PROPIETARIO) as ERROR_FIELD, (bi.CODIGO_ENTIDAD || bi.CODIGO_BIEN) as ENTITY_CODE    FROM APR_AUX_ABI_BIENES_CONSOL bi    WHERE   bi.CODIGO_PROPIETARIO is not null and   not exists( SELECT 1     FROM DD_PRO_PROPIETARIOS        WHERE DD_PRO_CODIGO = trim(bi.CODIGO_PROPIETARIO))  ',10,2,0)              
             , T_JBV('bie-09.insertBieTipoValidator',1,'INSERT INTO DD_TBI_TIPO_BIEN      (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO)  SELECT S_DD_TBI_TIPO_BIEN.NEXTVAL,   TBIX.DD_TBI_CODIGO,   TBIX.DD_TBI_DESCRIPCION,   #TOKEN_USR#,SYSTIMESTAMP,0  FROM (   SELECT DISTINCT ERROR_FIELD as DD_TBI_CODIGO, ''''Tipo grupo cliente pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TBI_DESCRIPCION    from (        SELECT TIPO_BIEN AS ERROR_FIELD, TIPO_BIEN || to_char(CODIGO_BIEN) AS ENTITY_CODE        from APR_AUX_ABI_BIENES_CONSOL  where not exists (select * from DD_TBI_TIPO_BIEN dd where dd.DD_TBI_CODIGO = TIPO_BIEN )   )  ) TBIX  ',10,2,0)
             , T_JBV('bie-09.bieTipoValidator',1,'SELECT DISTINCT ERROR_FIELD as DD_TBI_CODIGO, ''''Tipo bien pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TBI_DESCRIPCION    from (        SELECT TIPO_BIEN AS ERROR_FIELD, TIPO_BIEN || to_char(CODIGO_BIEN) AS ENTITY_CODE        from APR_AUX_ABI_BIENES_CONSOL  where not exists (select * from DD_TBI_TIPO_BIEN dd where dd.DD_TBI_CODIGO = TIPO_BIEN )   ) WHERE 1=1',10,2,0)
             , T_JBV('bie-10.insertBieTipoInmuebleValidator',1,'INSERT INTO DD_TPN_TIPO_INMUEBLE      (DD_TPN_ID, DD_TPN_CODIGO, DD_TPN_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO)  SELECT S_DD_TPN_TIPO_INMUEBLE.NEXTVAL,   TBIX.DD_TPN_CODIGO,   TBIX.DD_TPN_DESCRIPCION,   #TOKEN_USR#,SYSTIMESTAMP,0  FROM ( SELECT DISTINCT ERROR_FIELD as DD_TPN_CODIGO, ''''Tipo inmueble pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPN_DESCRIPCION from ( SELECT TIPO_INMUEBLE AS ERROR_FIELD, TIPO_INMUEBLE ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE from APR_AUX_ABI_BIENES_CONSOL  where TIPO_INMUEBLE is not null and not exists (select * from DD_TPN_TIPO_INMUEBLE dd where dd.DD_TPN_CODIGO = TIPO_INMUEBLE )  ) ) TBIX ',10,1,0)
             , T_JBV('bie-10.bieTipoInmuebleValidator',1,'SELECT DISTINCT ERROR_FIELD as DD_TPN_CODIGO, ''''Tipo inmueble pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPN_DESCRIPCION from ( SELECT TIPO_INMUEBLE AS ERROR_FIELD, TIPO_INMUEBLE ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE from APR_AUX_ABI_BIENES_CONSOL  where TIPO_INMUEBLE is not null and not exists (select * from DD_TPN_TIPO_INMUEBLE dd where dd.DD_TPN_CODIGO = TIPO_INMUEBLE )   )  WHERE 1=1 ',10,2,0)
             , T_JBV('bie-11.insertBieTipoProductoValidator',1,'INSERT INTO DD_TPR_TIPO_PROD      (DD_TPR_ID, DD_TPR_CODIGO, DD_TPR_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TPR_TIPO_PROD.NEXTVAL, TPRX.DD_TPR_CODIGO, TPRX.DD_TPR_DESCRIPCION, #TOKEN_USR#,SYSTIMESTAMP,0 FROM ( SELECT DISTINCT ERROR_FIELD as DD_TPR_CODIGO, ''''Tipo producto pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPR_DESCRIPCION   from ( SELECT TIPO_PROD_BANCARIO AS ERROR_FIELD, TIPO_PROD_BANCARIO ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE  from APR_AUX_ABI_BIENES_CONSOL  where TIPO_PROD_BANCARIO is not null and not exists (select * from DD_TPR_TIPO_PROD dd where dd.DD_TPR_CODIGO = TIPO_PROD_BANCARIO )  )  ) TPRX',10,1,0)
             , T_JBV('bie-11.bieTipoProductoValidator',1,'SELECT DISTINCT ERROR_FIELD as DD_TPR_CODIGO, ''''Tipo producto pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPR_DESCRIPCION   from ( SELECT TIPO_PROD_BANCARIO AS ERROR_FIELD, TIPO_PROD_BANCARIO ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE  from APR_AUX_ABI_BIENES_CONSOL  where TIPO_PROD_BANCARIO is not null and not exists (select * from DD_TPR_TIPO_PROD dd where dd.DD_TPR_CODIGO = TIPO_PROD_BANCARIO )  )  WHERE 1=1',10,2,0)               
             , T_JBV('bie-12.bieExtraccionValidator',1,'select TO_CHAR(a.FEMAX, ''''DDMMYYYY'''') AS ERROR_FIELD, TO_CHAR(b.FCMAX, ''''DDMMYYYY'''') AS ENTITY_CODE from (select MAX(FECHA_EXTRACCION) as FEMAX, MIN(FECHA_EXTRACCION) as FEMIN from APR_AUX_ABI_BIENES_CONSOL ) a , (select MAX(FECHACREAR) as FCMAX,  MAX(FECHAMODIFICAR) as FMMAX from BIE_BIEN)  b   where a.FEMAX <= b.FCMAX  OR a.FEMAX <= b.FMMAX OR a.FEMAX <> a.FEMIN',10,2,0)               
             , T_JBV('bie-13.bieCntUniqueValidator',1,'select CODIGO_BIEN AS ERROR_FIELD, to_char(CODIGO_BIEN)||''''-''''||to_char(NUMERO_CONTRATO) AS ENTITY_CODE from APR_AUX_ABC_BIECNT_CONSOL group by CODIGO_BIEN, NUMERO_CONTRATO  having count(*) > 1',11,2,0)
             , T_JBV('bie-14.insertBieCntTipoProductoValidator',1,'INSERT INTO DD_TPR_TIPO_PROD  (DD_TPR_ID, DD_TPR_CODIGO, DD_TPR_DESCRIPCION, DD_TPR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TPR_TIPO_PROD.NEXTVAL, TPRX.DD_TPR_CODIGO, TPRX.DD_TPR_DESCRIPCION, TPRX.DD_TPR_DESCRIPCION_LARGA ,#TOKEN_USR#,SYSTIMESTAMP,0 FROM ( SELECT DISTINCT ERROR_FIELD as DD_TPR_CODIGO, ''''Tipo producto pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPR_DESCRIPCION, ''''Tipo producto pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TPR_DESCRIPCION_LARGA   from ( SELECT TIPO_PRODUCTO AS ERROR_FIELD, TIPO_PRODUCTO ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE from APR_AUX_ABC_BIECNT_CONSOL  where TIPO_PRODUCTO is not null and not exists (select * from DD_TPR_TIPO_PROD dd where dd.DD_TPR_CODIGO = TIPO_PRODUCTO )  )  ) TPRX',11,1,0)
             , T_JBV('bie-14.bieCntTipoProductoValidator',1,'SELECT TIPO_PRODUCTO AS ERROR_FIELD, TIPO_PRODUCTO ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE from APR_AUX_ABC_BIECNT_CONSOL  where TIPO_PRODUCTO is not null and not exists (select * from DD_TPR_TIPO_PROD dd where dd.DD_TPR_CODIGO = TIPO_PRODUCTO ) ',11,2,0)                                         
             , T_JBV('bie-15.insertBieCntTipoRelacionValidator',1,'INSERT INTO DD_TBC_TIPO_REL_BIEN_CNT  (DD_TBC_ID, DD_TBC_CODIGO, DD_TBC_DESCRIPCION, DD_TBC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) SELECT S_DD_TBC_TIPO_REL_BIEN_CNT.NEXTVAL, TBCX.DD_TBC_CODIGO, TBCX.DD_TBC_DESCRIPCION, TBCX.DD_TBC_DESCRIPCION_LARGA ,#TOKEN_USR#,SYSTIMESTAMP,0  FROM ( SELECT DISTINCT ERROR_FIELD as DD_TBC_CODIGO, ''''Tipo rel contrato bien pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TBC_DESCRIPCION, ''''Tipo rel contrato bien pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_TBC_DESCRIPCION_LARGA  from ( SELECT TIPO_RELACION_CONTRATO_BIEN AS ERROR_FIELD, TIPO_RELACION_CONTRATO_BIEN ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE  from APR_AUX_ABC_BIECNT_CONSOL  where TIPO_RELACION_CONTRATO_BIEN is not null  and not exists (select * from DD_TBC_TIPO_REL_BIEN_CNT dd where dd.DD_TBC_CODIGO = TIPO_RELACION_CONTRATO_BIEN )  )  ) TBCX',11,1,0)
             , T_JBV('bie-15.bieCntTipoRelacionValidator',1,'SELECT TIPO_RELACION_CONTRATO_BIEN AS ERROR_FIELD, TIPO_RELACION_CONTRATO_BIEN ||''''-''''|| to_char(CODIGO_BIEN)||''''-''''||to_char(NUMERO_CONTRATO)  AS ENTITY_CODE  from APR_AUX_ABC_BIECNT_CONSOL  where TIPO_RELACION_CONTRATO_BIEN is not null  and not exists (select * from DD_TBC_TIPO_REL_BIEN_CNT dd where dd.DD_TBC_CODIGO = TIPO_RELACION_CONTRATO_BIEN )',11,2,0)
             , T_JBV('bie-16.bieCntExtraccionValidator',1,'select TO_CHAR(a.FEMAX, ''''DDMMYYYY'''') AS ERROR_FIELD, TO_CHAR(b.FCMAX, ''''DDMMYYYY'''') AS ENTITY_CODE from (select MAX(FECHA_EXTRACCION) as FEMAX, MIN(FECHA_EXTRACCION) as FEMIN from APR_AUX_ABC_BIECNT_CONSOL ) a , (select MAX(FECHACREAR) as FCMAX,  MAX(FECHAMODIFICAR) as FMMAX from BIE_BIEN)  b   where a.FEMAX <= b.FCMAX  OR a.FEMAX <= b.FMMAX OR a.FEMAX <> a.FEMIN',11,2,0)                            
             , T_JBV('bie-16.biePerExtraccionValidator',1,'select TO_CHAR(a.FEMAX, ''''DDMMYYYY'''') AS ERROR_FIELD, TO_CHAR(b.FCMAX, ''''DDMMYYYY'''') AS ENTITY_CODE from (select MAX(FECHA_EXTRACCION) as FEMAX, MIN(FECHA_EXTRACCION) as FEMIN from APR_AUX_ABC_BIEPER_CONSOL ) a , (select MAX(FECHACREAR) as FCMAX,  MAX(FECHAMODIFICAR) as FMMAX from BIE_BIEN)  b   where a.FEMAX <= b.FCMAX  OR a.FEMAX <= b.FMMAX OR a.FEMAX <> a.FEMIN',12,2,0)                                         
             , T_JBV('bie-17.biePerUniqueValidator',1,'select CODIGO_BIEN AS ERROR_FIELD, to_char(CODIGO_BIEN)||''''-''''||to_char(CODIGO_PERSONA) AS ENTITY_CODE from APR_AUX_ABC_BIEPER_CONSOL group by CODIGO_BIEN, CODIGO_PERSONA having count(*) > 1',12,2,0)
             , T_JBV('bie-18.biePerPersonaValidator',1,'select CODIGO_PERSONA AS ERROR_FIELD, to_char(CODIGO_BIEN)||''''-''''||to_char(CODIGO_PERSONA) AS ENTITY_CODE from APR_AUX_ABC_BIEPER_CONSOL   abc left join PER_PERSONAS per  on abc.codigo_persona = per.per_cod_cliente_entidad   where   per.per_cod_cliente_entidad is null',12,2,0)
             , T_JBV('bie-19.biePerBienValidator',1,'select abc.CODIGO_BIEN AS ERROR_FIELD, to_char(abc.CODIGO_BIEN)||''''-''''||to_char(CODIGO_PERSONA)  AS ENTITY_CODE from APR_AUX_ABC_BIEPER_CONSOL   abc left join APR_AUX_ABI_BIENES_CONSOL abi  on abc.codigo_bien = abi.codigo_bien where abi.codigo_bien is null',12,2,0)             
           );   
  
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
 
 V_TMP_JVI T_JVI;
 V_TMP_JBV T_JBV; 

 
BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de BATCH_JOB_VALIDATION');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.BATCH_JOB_VALIDATION WHERE JOB_VAL_INTERFAZ IN (10,11,12)');
 
 
 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_JVI_JOB_VAL_INTERFAZ');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_JVI_JOB_VAL_INTERFAZ  where DD_JVI_BLOQUE = ''BIENES''');
  

 
 
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
 START WITH 10
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
 WHERE sequence_name = 'S_JVI_JOB_VAL_INTERFAZ' and sequence_owner=V_ESQUEMA_MASTER;

 DBMS_OUTPUT.PUT_LINE('Creando DD_JVI_JOB_VAL_INTERFAZ......');
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


 
 --sacamos la el codigo entidad de la tabla ENTIDAD.
  V_ENTIDAD:=1;

--UPDATE #ESQUEMA_MASTER#.ENTIDAD SET DESCRIPCION = 'CAJAMAR' WHERE ROWNUM < 2;

COMMIT;
 
 V_ENTIDAD_ID:=0;

 V_MSQL := 'SELECT ID FROM '||V_ESQUEMA_MASTER||'.ENTIDAD where DESCRIPCION = ''CAJAMAR''';
 EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD;

/* select ID INTO V_ENTIDAD  from #ESQUEMA_MASTER#.ENTIDAD where DESCRIPCION = 'CAJAMAR'; */
 

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
