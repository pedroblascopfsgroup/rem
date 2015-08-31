--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150828
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-532
--## PRODUCTO=NO
--## 
--## Finalidad: Limpieza y carga inicial de tablas validaciones DD_JVI_JOB_VAL_INTERFAZ, DD_JVS_JOB_VAL_SEVERITY y BATCH_JOB_VALIDATION, esquema CMMASTER
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_JVI IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_JVI IS TABLE OF T_JVI;
   
   TYPE T_JVS IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_JVS IS TABLE OF T_JVS;
   
   TYPE T_JBV IS TABLE OF VARCHAR2(2500);
   TYPE T_ARRAY_JBV IS TABLE OF T_JBV;   
   
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master
   seq_count          NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);   

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código del grupo de carga   
--Configuracion  EXT_DD_JVI_JOB_VAL_INTERFAZ
                                   
   V_JVI T_ARRAY_JVI := T_ARRAY_JVI(
                              T_JVI('TMP_CNT_CONTRATOS','Tabla tmp de contratos', 'Tabla tmp de contratos')
                            , T_JVI('TMP_PER_PERSONAS','Tabla tmp de personas', 'Tabla tmp de personas')
                            , T_JVI('TMP_CPE_CONTRATOS_PERSONAS','Tabla tmp de relaciones', 'Tabla tmp de relaciones')                            
                            );
                            
   V_JVS T_ARRAY_JVS := T_ARRAY_JVS(
                              T_JVS('LOW','Severidad baja (no bloqueante)','Severidad baja (no bloqueante)')
                            , T_JVS('HIGH','Severidad alta (bloqueante)', 'Severidad alta (bloqueante)')
                            );
                            
   V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
                            T_JBV('cnt-02.loadDateValidator.Oracle9iDialect','3058','SELECT TMP_CNT_FECHA_EXTRACCION AS ERROR_FIELD, (TMP_CNT_COD_ENTIDAD ||''''-''''|| TMP_CNT_COD_OFICINA ||''''-''''|| TMP_CNT_CONTRATO) AS ENTITY_CODE from TMP_CNT_CONTRATOS where TMP_CNT_FECHA_EXTRACCION <> to_date(''''20150825'''',''''YYYYMMDD'''')','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-03.movementValidator','3058','SELECT tc.tmp_cnt_fecha_extraccion AS ERROR_FIELD, (tc.tmp_cnt_cod_entidad || ''''-'''' || tc.tmp_cnt_cod_oficina || ''''-'''' || tc.tmp_cnt_contrato) AS ENTITY_CODE FROM cnt_contratos c, tmp_cnt_contratos tc where c.cnt_contrato = tc.tmp_cnt_contrato and tc.TMP_CNT_COD_ENTIDAD = c.CNT_COD_ENTIDAD and tc.TMP_CNT_COD_OFICINA = c.CNT_COD_OFICINA and c.cnt_fecha_extraccion >= tc.tmp_cnt_fecha_extraccion','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-04.officeCodeValidator','3058',' SELECT distinct TMP_CNT_COD_OFICINA AS ERROR_FIELD FROM tmp_cnt_contratos tc WHERE not EXISTS ( SELECT * FROM ofi_oficinas ofi WHERE ofi.OFI_CODIGO_ENTIDAD_OFICINA = tc.TMP_CNT_COD_ENT_OFI_CNTBLE and ofi.OFI_CODIGO_OFICINA = tc.TMP_CNT_COD_OFI_CNTBLE)','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-05.zonaCodeValidator','3058','SELECT TMP_CNT_COD_CENTRO AS ERROR_FIELD,
                                                                         (tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt_contrato) AS ENTITY_CODE 
                                                                         FROM tmp_cnt_contratos tc WHERE NOT EXISTS(SELECT * FROM zon_zonificacion z WHERE tc.TMP_CNT_COD_CENTRO = z.zon_cod)
                                                                         ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-06.currencyCodeValidator','3058','SELECT TMP_CNT_MONEDA AS ERROR_FIELD,
                                                                             (tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt_contrato) AS ENTITY_CODE 
                                                                         FROM tmp_cnt_contratos tc 
                                                                         WHERE NOT EXISTS 
                                                                          (SELECT * FROM dd_mon_monedas m WHERE tc.TMP_CNT_MONEDA = m.DD_MON_CODIGO) 
                                                                         ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-07.productTypeCodeValidator','3058','SELECT tmp_cnt_tipo_producto AS ERROR_FIELD,
                                                                             (tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt_contrato) AS ENTITY_CODE 
                                                                         FROM tmp_cnt_contratos tc 
                                                                         WHERE NOT EXISTS 
                                                                          (SELECT * FROM dd_tpe_tipo_prod_entidad tpe where trim(tc.tmp_cnt_tipo_producto) = trim(tpe.DD_TPE_CODIGO))
                                                                         ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-08.contratoRelacionValidator','3058','SELECT ''''No existe relacion'''' AS ERROR_FIELD,
                                                                               (tc.tmp_cnt_cod_entidad || ''''-'''' || tc.tmp_cnt_cod_oficina || ''''-'''' || tc.tmp_cnt_contrato) AS ENTITY_CODE 
                                                                           from tmp_cnt_contratos tc where NOT EXISTS 
                                                                            ( 
                                                                               select * 
                                                                               from tmp_cnt_per tcp 
                                                                               where tc.TMP_CNT_CONTRATO = tcp.TMP_CNT_PER_CONTRATO
                                                                                   and tc.TMP_CNT_COD_ENTIDAD = tcp.TMP_CNT_PER_COD_ENTIDAD
                                                                                   and tc.TMP_CNT_COD_OFICINA = tcp.TMP_CNT_PER_COD_OFICINA
                                                                           )','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-09.movimientoPrevio','3058','SELECT cnt.cnt_id AS ERROR_FIELD,
                                                                               (CNT.CNT_COD_ENTIDAD ||''''-''''|| CNT.CNT_COD_OFICINA ||''''-''''|| CNT.CNT_CONTRATO) AS ENTITY_CODE
                                                                           FROM cnt_contratos cnt, ${master.schema}.DD_ESC_ESTADO_CNT ec
                                                                           WHERE (CNT.CNT_COD_ENTIDAD, CNT.CNT_COD_OFICINA, CNT.CNT_CONTRATO) not in 
                                                                           (
                                                                               select TMP.TMP_CNT_COD_ENTIDAD, TMP.TMP_CNT_COD_OFICINA, TMP.TMP_CNT_CONTRATO  
                                                                               from tmp_cnt_contratos tmp
                                                                           )
                                                                           AND CNT.BORRADO = 0
                                                                           AND CNT.DD_ESC_ID = ec.DD_ESC_ID
                                                                           AND ec.dd_esc_codigo = ''''?''''
                                                                           ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-10.fechaExtracionMenorHoy','3058','SELECT tc.tmp_cnt_fecha_extraccion AS ERROR_FIELD,
                                                                              (tc.tmp_cnt_cod_entidad ||''''-''''|| tc.tmp_cnt_cod_oficina ||''''-''''|| tc.tmp_cnt_contrato) AS ENTITY_CODE         
                                                                          FROM tmp_cnt_contratos tc
                                                                          WHERE tc.tmp_cnt_fecha_extraccion > ${sql.function.curdate}
                                                                          ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-11.fechaPosVencida','3058','SELECT tc.tmp_cnt_fecha_pos_vencida AS ERROR_FIELD,
                                                                              (tc.tmp_cnt_cod_entidad || ''''-'''' || tc.tmp_cnt_cod_oficina || ''''-'''' || tc.tmp_cnt_contrato) AS ENTITY_CODE         
                                                                          FROM tmp_cnt_contratos tc, cnt_contratos c, mov_movimientos m
                                                                          WHERE tc.tmp_cnt_contrato = c.cnt_contrato
                                                                              and tc.TMP_CNT_COD_ENTIDAD = c.CNT_COD_ENTIDAD
                                                                              and tc.TMP_CNT_COD_OFICINA = c.CNT_COD_OFICINA
                                                                              AND c.cnt_id = m.cnt_id
                                                                              AND tc.tmp_cnt_fecha_pos_vencida < m.mov_fecha_pos_vencida
                                                                          ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-12.activoPositvo','3058','SELECT tmp_cnt.TMP_CNT_POS_VIVA_NO_VENCIDA AS ERROR_FIELD,
                                                                      (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                  FROM tmp_cnt_contratos tmp_cnt,dd_tpe_tipo_prod_entidad tp
                                                                  WHERE TRIM(tp.dd_tpe_codigo) = TRIM(tmp_cnt.TMP_CNT_TIPO_PRODUCTO)
                                                                      AND tp.dd_tpe_activo=1
                                                                      AND tmp_cnt.TMP_CNT_POS_VIVA_VENCIDA < 0
                                                                  ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-13.finalidadOficial','3058','SELECT tmp_cnt.TMP_CNT_FINALIDAD_OFI AS ERROR_FIELD,
                                                                      (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                  FROM tmp_cnt_contratos tmp_cnt
                                                                  WHERE tmp_cnt.TMP_CNT_FINALIDAD_OFI is not null and NOT EXISTS 
                                                                      (
                                                                      SELECT * FROM DD_FNO_FINALIDAD_OFICIAL FNO
                                                                      WHERE tmp_cnt.TMP_CNT_FINALIDAD_OFI = FNO.DD_FNO_CODIGO
                                                                      )      
                                                                  ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-14.finalidadContrato','3058','SELECT tmp_cnt.TMP_CNT_FINALIDAD_CON AS ERROR_FIELD,
                                                                        (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                    FROM tmp_cnt_contratos tmp_cnt
                                                                    WHERE tmp_cnt.TMP_CNT_FINALIDAD_CON is not null and  NOT EXISTS 
                                                                     (
                                                                        SELECT * FROM DD_FCN_FINALIDAD_CONTRATO FCN
                                                                        WHERE tmp_cnt.TMP_CNT_FINALIDAD_CON = FCN.DD_FCN_CODIGO
                                                                        )      
                                                                    ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-15.garantia1','3058','SELECT tmp_cnt.TMP_CNT_GARANTIA_1 AS ERROR_FIELD,
                                                                       (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                   FROM tmp_cnt_contratos tmp_cnt
                                                                   WHERE tmp_cnt.TMP_CNT_GARANTIA_1 is not null and NOT EXISTS 
                                                                       (
                                                                       SELECT * FROM DD_GCN_GARANTIA_CONTRATO GCN
                                                                       WHERE tmp_cnt.TMP_CNT_GARANTIA_1 = GCN.DD_GCN_CODIGO
                                                                       )
                                                                   ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-16.garantia2','3058','SELECT tmp_cnt.TMP_CNT_GARANTIA_2 AS ERROR_FIELD,
                                                                       (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                   FROM tmp_cnt_contratos tmp_cnt
                                                                   WHERE tmp_cnt.TMP_CNT_GARANTIA_2 is not null and NOT EXISTS 
                                                                       (
                                                                       SELECT * FROM DD_GCO_GARANTIA_CONTABLE GCO
                                                                       WHERE tmp_cnt.TMP_CNT_GARANTIA_2 = GCO.DD_GCO_CODIGO
                                                                       )
                                                                   ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-17.catalogo1','3058','SELECT tmp_cnt.TMP_CNT_CATALOGO_1 AS ERROR_FIELD,
                                                                        (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                    FROM tmp_cnt_contratos tmp_cnt
                                                                    WHERE tmp_cnt.TMP_CNT_CATALOGO_1 is not null and NOT EXISTS 
                                                                        (
                                                                        SELECT * FROM DD_CT1_CATALOGO_1 CT1
                                                                        WHERE tmp_cnt.TMP_CNT_CATALOGO_1 = CT1.DD_CT1_CODIGO
                                                                        )
                                                                    ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-18.catalogo2','3058','SELECT tmp_cnt.TMP_CNT_CATALOGO_2 AS ERROR_FIELD,
                                                                         (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                     FROM tmp_cnt_contratos tmp_cnt
                                                                     WHERE tmp_cnt.TMP_CNT_CATALOGO_2 is not null and NOT EXISTS 
                                                                      (
                                                                     SELECT * FROM DD_CT2_CATALOGO_2 CT2
                                                                     WHERE tmp_cnt.TMP_CNT_CATALOGO_2 = CT2.DD_CT2_CODIGO
                                                                      )
                                                                     ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-19.catalogo3','3058','SELECT tmp_cnt.TMP_CNT_CATALOGO_3 AS ERROR_FIELD,
                                                                        (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                    FROM tmp_cnt_contratos tmp_cnt
                                                                    WHERE tmp_cnt.TMP_CNT_CATALOGO_3 is not null and NOT EXISTS 
                                                                        (
                                                                        SELECT * FROM DD_CT3_CATALOGO_3 CT3
                                                                        WHERE tmp_cnt.TMP_CNT_CATALOGO_3 = CT3.DD_CT3_CODIGO
                                                                        )
                                                                    ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-20.catalogo4','3058','SELECT tmp_cnt.TMP_CNT_CATALOGO_4 AS ERROR_FIELD,
                                                                        (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                    FROM tmp_cnt_contratos tmp_cnt
                                                                    WHERE tmp_cnt.TMP_CNT_CATALOGO_4 is not null and NOT EXISTS 
                                                                     (
                                                                        SELECT * FROM DD_CT4_CATALOGO_4 CT4
                                                                        WHERE tmp_cnt.TMP_CNT_CATALOGO_4 = CT4.DD_CT4_CODIGO
                                                                     )
                                                                    
                                                                    ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-21.extra3','3058','SELECT tmp_cnt.TMP_CNT_EXTRA_3_CODIGO AS ERROR_FIELD,
                                                                        (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                    FROM tmp_cnt_contratos tmp_cnt
                                                                    WHERE tmp_cnt.TMP_CNT_EXTRA_3_CODIGO is not null and NOT EXISTS 
                                                                     (
                                                                        SELECT * FROM DD_MX3_MOVIMIENTO_EXTRA_3 MX3
                                                                        WHERE tmp_cnt.TMP_CNT_EXTRA_3_CODIGO = MX3.DD_MX3_CODIGO
                                                                     )
                                                                    ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-22.extra4','3058','SELECT tmp_cnt.TMP_CNT_EXTRA_4_CODIGO AS ERROR_FIELD,
                                                                        (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE  
                                                                    FROM tmp_cnt_contratos tmp_cnt
                                                                    WHERE tmp_cnt.TMP_CNT_EXTRA_4_CODIGO is not null and NOT EXISTS 
                                                                     (
                                                                        SELECT * FROM DD_MX4_MOVIMIENTO_EXTRA_4 MX4
                                                                        WHERE tmp_cnt.TMP_CNT_EXTRA_4_CODIGO = MX4.DD_MX4_CODIGO
                                                                     )
                                                                    ','TMP_CNT_CONTRATOS','LOW')
                          , T_JBV('cnt-23.relacionesCatalogos','3058','select tmp_cnt.TMP_CNT_ID as ERROR_FIELD,
                                                                        (tmp_cnt.tmp_cnt_cod_entidad ||''''-''''|| tmp_cnt.tmp_cnt_cod_oficina ||''''-''''|| tmp_cnt.tmp_cnt_contrato) AS ENTITY_CODE
                                                                    from tmp_cnt_contratos tmp_cnt 
                                                                    where tmp_cnt.TMP_CNT_ID not in
                                                                    (
                                                                    select tmp_cnt.TMP_CNT_ID
                                                                    from tmp_cnt_contratos tmp_cnt,DD_CT1_CATALOGO_1 c1 
                                                                        JOIN DD_CT2_CATALOGO_2 c2 ON c2.dd_ct1_id = c1.dd_ct1_id 
                                                                        JOIN DD_CT3_CATALOGO_3 c3 ON c3.dd_ct2_id = c2.dd_ct2_id 
                                                                        JOIN DD_CT4_CATALOGO_4 c4 ON c4.dd_ct3_id = c3.dd_ct3_id 
                                                                        LEFT JOIN DD_CT5_CATALOGO_5 c5 ON c5.dd_ct4_id = c4.dd_ct4_id 
                                                                        LEFT JOIN DD_CT6_CATALOGO_6 c6 ON c6.dd_ct5_id = c5.dd_ct5_id 
                                                                    where c1.dd_ct1_codigo = tmp_cnt.TMP_CNT_CATALOGO_1
                                                                        and c2.dd_ct2_codigo = tmp_cnt.TMP_CNT_CATALOGO_2
                                                                        and c3.dd_ct3_codigo = tmp_cnt.TMP_CNT_CATALOGO_3
                                                                        and c4.dd_ct4_codigo = tmp_cnt.TMP_CNT_CATALOGO_4
                                                                        and c5.dd_ct5_codigo = tmp_cnt.TMP_CNT_CATALOGO_5
                                                                        and c6.dd_ct6_codigo = tmp_cnt.TMP_CNT_CATALOGO_6
                                                                    )
                                                                    ','TMP_CNT_CONTRATOS','LOW')
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
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.BATCH_JOB_VALIDATION');
 
    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_JVI_JOB_VAL_INTERFAZ');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_JVI_JOB_VAL_INTERFAZ');
       

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_JVS_JOB_VAL_SEVERITY');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_JVS_JOB_VAL_SEVERITY');
    
      
 
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
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    
 

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
  
 
 

   DBMS_OUTPUT.PUT_LINE('Creando EXT_DD_JVI_JOB_VAL_INTERFAZ......');
   FOR I IN V_JVI.FIRST .. V_JVI.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_JVI_JOB_VAL_INTERFAZ.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_JVI := V_JVI(I);
      DBMS_OUTPUT.PUT_LINE('Creando JVI: '||V_TMP_JVI(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_JVI_JOB_VAL_INTERFAZ (DD_JVI_ID, DD_JVI_CODIGO, DD_JVI_DESCRIPCION,' ||
        'DD_JVI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_JVI(1)||''','''||SUBSTR(V_TMP_JVI(2),1, 50)||''','''
         ||V_TMP_JVI(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
   V_TMP_JVI := NULL;

   
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
         ||V_TMP_JBV(2)||''','''
         ||V_ENTIDAD_ID||''','''
         ||V_TMP_JBV(3)||''','''        
         ||V_TMP_JBV(4)||''','''
         ||V_TMP_JBV(5)||''',0,'''
         ||V_USUARIO_CREAR||'''
         ,SYSDATE,0)';
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