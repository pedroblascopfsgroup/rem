DECLARE
        TABLE_COUNT NUMBER(3);
        EXISTE    NUMBER;
        V_SQL VARCHAR2(4000 CHAR);
        V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';

        ERR_NUM NUMBER(25);  
        ERR_MSG VARCHAR2(1024 CHAR);     
        TYPE T_TABLAS IS TABLE OF VARCHAR2(150);      
        TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;          
        V_TEMP_TABLAS  T_TABLAS;
        V_NUMBER    NUMBER;    
        
   V_TABLA T_ARRAY_TABLAS := T_ARRAY_TABLAS(
                                                            T_TABLAS('REM01','ACT_ADM_INF_ADMINISTRATIVA'),
                                                            T_TABLAS('REM01','ACT_ADN_ADJNOJUDICIAL'),
                                                            T_TABLAS('REM01','ACT_AGO_AGRUPACION_OBS'),
                                                            T_TABLAS('REM01','ACT_AJD_ADJJUDICIAL'),
                                                            T_TABLAS('REM01','ACT_BNY_BANYO'),
                                                            T_TABLAS('REM01','ACT_CAT_CATASTRO'),
                                                            T_TABLAS('REM01','ACT_COC_COCINA'),
                                                            T_TABLAS('REM01','ACT_CPR_COM_PROPIETARIOS'),
                                                            T_TABLAS('REM01','ACT_CRE_CARPINTERIA_EXT'),
                                                            T_TABLAS('REM01','ACT_CRG_CARGAS'),
                                                            T_TABLAS('REM01','ACT_CRI_CARPINTERIA_INT'),
                                                            T_TABLAS('REM01','ACT_DIS_DISTRIBUCION'),
                                                            T_TABLAS('REM01','ACT_EDI_EDIFICIO'),
                                                            T_TABLAS('REM01','ACT_INF_INFRAESTRUCTURA'),
                                                            T_TABLAS('REM01','ACT_INS_INSTALACION'),
                                                            T_TABLAS('REM01','ACT_LLV_LLAVE'),
                                                            T_TABLAS('REM01','ACT_LOC_LOCALIZACION'),
                                                            T_TABLAS('REM01','ACT_MLV_MOVIMIENTO_LLAVE'),
                                                            T_TABLAS('REM01','ACT_PDV_PLAN_DIN_VENTAS'),
                                                            T_TABLAS('REM01','ACT_PRO_PROPIETARIO'),
                                                            T_TABLAS('REM01','ACT_PRT_PRESUPUESTO_TRABAJO'),
                                                            T_TABLAS('REM01','ACT_PRV_PARAMENTO_VERTICAL'),
                                                            T_TABLAS('REM01','ACT_PVC_PROVEEDOR_CONTACTO'),
                                                            T_TABLAS('REM01','ACT_PAC_PROPIETARIO_ACTIVO'),
                                                            T_TABLAS('REM01','ACT_ETP_ENTIDAD_PROVEEDOR ETP'),
                                                            T_TABLAS('REM01','ACT_PVE_PROVEEDOR'),
                                                            T_TABLAS('REM01','ACT_REG_INFO_REGISTRAL'),
                                                            T_TABLAS('REM01','ACT_ONV_OBRA_NUEVA ONV'),
                                                            T_TABLAS('REM01','ACT_RES_RESTRINGIDA RES'),
                                                            T_TABLAS('REM01','ACT_AGR_AGRUPACION'),
                                                            T_TABLAS('REM01','ACT_AGA_AGRUPACION_ACTIVO'),
                                                            T_TABLAS('REM01','ACT_SDV_SUBDIVISION_ACTIVO'),
                                                            T_TABLAS('REM01','ACT_SOL_SOLADO'),
                                                            T_TABLAS('REM01','ACT_SPS_SIT_POSESORIA'),
                                                            T_TABLAS('REM01','ACT_TAS_TASACION'),
                                                            T_TABLAS('REM01','ACT_TBJ TBJ'),
                                                            T_TABLAS('REM01','ACT_TBJ_TRABAJO'),
                                                            T_TABLAS('REM01','ACT_TIT_TITULO'),
                                                            T_TABLAS('REM01','ACT_VAL_VALORACIONES'),
                                                            T_TABLAS('REM01','ACT_LCO_LOCAL_COMERCIAL'),
                                                            T_TABLAS('REM01','ACT_APR_PLAZA_APARCAMIENTO'),
                                                            T_TABLAS('REM01','ACT_VIV_VIVIENDA VIV'),
                                                            T_TABLAS('REM01','ACT_ZCO_ZONA_COMUN'),
                                                            T_TABLAS('REM01','ACT_ICO_INFO_COMERCIAL'),
                                                            T_TABLAS('REM01','BIE_ADJ_ADJUDICACION'),
                                                            T_TABLAS('REM01','lob_lote_bien'),
                                                            T_TABLAS('REM01','BIE_CAR_CARGAS'),
                                                            T_TABLAS('REM01','BIE_DATOS_REGISTRALES'),
                                                            T_TABLAS('REM01','BIE_LOCALIZACION'),
                                                            T_TABLAS('REM01','BIE_VALORACIONES'),
                                                            T_TABLAS('REM01','ACT_GES_DISTRIBUCION'),
                                                            T_TABLAS('REM01','ACT_ADA_ADJUNTO_ACTIVO'),
                                                            T_TABLAS('REM01','GEE_GESTOR_ENTIDAD'),
                                                            T_TABLAS('REM01','GEH_GESTOR_ENTIDAD_HIST'),
                                                            T_TABLAS('REM01','BIE_BIEN'),
                                                            T_TABLAS('REM01','bie_adicional'),
                                                            T_TABLAS('REM01','bie_anc_analisis_contratos'),
                                                            T_TABLAS('REM01','bie_bien_entidad'),
                                                            T_TABLAS('REM01','bie_sui_subasta_instrucciones'),
                                                            T_TABLAS('REM01','emp_nmbembargos_procedimientos'),
                                                            T_TABLAS('REM01','GAH_GESTOR_ACTIVO_HISTORICO'),
                                                            T_TABLAS('REM01','GAC_GESTOR_ADD_ACTIVO'),
                                                            T_TABLAS('REM01','VIS_VISITAS'),
                                                            T_TABLAS('REM01','ACT_ACTIVO')
                        );
       
BEGIN
 
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
     BEGIN
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
       LOOP
           BEGIN
               
                  DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );    
                  EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        
           END;    
       END LOOP;    
       
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    END;
  END LOOP;
  COMMIT;   
 
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
     BEGIN
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
       LOOP
           BEGIN
               
                  DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );    
                  EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME || ' CASCADE ';        
           END;    
       END LOOP;    
       
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    END;
  END LOOP;
  COMMIT;   
 
  /*BORRADO*/
  delete from rem01.ACT_ADM_INF_ADMINISTRATIVA where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_ADN_ADJNOJUDICIAL where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_AGO_AGRUPACION_OBS where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_AJD_ADJJUDICIAL where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_BNY_BANYO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_CAT_CATASTRO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_COC_COCINA where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_CPR_COM_PROPIETARIOS where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_CRE_CARPINTERIA_EXT where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_CRG_CARGAS where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_CRI_CARPINTERIA_INT where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_DIS_DISTRIBUCION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_EDI_EDIFICIO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_INF_INFRAESTRUCTURA where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_INS_INSTALACION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_LLV_LLAVE where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_LOC_LOCALIZACION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_MLV_MOVIMIENTO_LLAVE where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_PDV_PLAN_DIN_VENTAS where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PRO_PROPIETARIO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PRT_PRESUPUESTO_TRABAJO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PRV_PARAMENTO_VERTICAL where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PVC_PROVEEDOR_CONTACTO where usuariocrear= 'MIG2';
  delete from rem01.ACT_PAC_PROPIETARIO_ACTIVO where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_ETP_ENTIDAD_PROVEEDOR ETP where EXISTS (SELECT 1 FROM REM01.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_ID = ETP.PVE_ID AND PVE.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_PVE_PROVEEDOR where usuariocrear= 'MIG2';
  delete from rem01.ACT_REG_INFO_REGISTRAL where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_ONV_OBRA_NUEVA ONV where EXISTS (SELECT 1 FROM REM01.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_ID = ONV.AGR_ID AND AGR.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_RES_RESTRINGIDA RES where EXISTS (SELECT 1 FROM REM01.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_ID = RES.AGR_ID AND AGR.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_AGR_AGRUPACION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_AGA_AGRUPACION_ACTIVO where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_SDV_SUBDIVISION_ACTIVO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_SOL_SOLADO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_SPS_SIT_POSESORIA where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_TAS_TASACION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_TBJ TBJ where EXISTS (SELECT 1 FROM rem01.ACT_TBJ_TRABAJO TBJT WHERE TBJT.TBJ_ID = TBJ.TBJ_ID AND TBJT.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_TBJ_TRABAJO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_TIT_TITULO where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_VAL_VALORACIONES where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_LCO_LOCAL_COMERCIAL LCO WHERE EXISTS (SELECT 1 FROM rem01.ACT_ICO_INFO_COMERCIAL ICO WHERE LCO.ICO_ID = ICO.ICO_ID AND ICO.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_APR_PLAZA_APARCAMIENTO APR WHERE EXISTS (SELECT 1 FROM rem01.ACT_ICO_INFO_COMERCIAL ICO WHERE APR.ICO_ID = ICO.ICO_ID AND ICO.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_VIV_VIVIENDA VIV where EXISTS (SELECT 1 FROM rem01.ACT_ICO_INFO_COMERCIAL ICO WHERE VIV.ICO_ID = ICO.ICO_ID AND ICO.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_ZCO_ZONA_COMUN where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_ICO_INFO_COMERCIAL where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.BIE_ADJ_ADJUDICACION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.lob_lote_bien lob1 where exists (select 1 from rem01.BIE_BIEN bie where bie.BIE_ID = lob1.bie_id and BIE.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.BIE_CAR_CARGAS where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.BIE_DATOS_REGISTRALES where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.BIE_LOCALIZACION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.BIE_VALORACIONES where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_GES_DISTRIBUCION where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_ADA_ADJUNTO_ACTIVO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.GEE_GESTOR_ENTIDAD where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.GEH_GESTOR_ENTIDAD_HIST where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.BIE_BIEN where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.bie_adicional where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.bie_anc_analisis_contratos where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.bie_bien_entidad where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.bie_sui_subasta_instrucciones where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.emp_nmbembargos_procedimientos where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.GAH_GESTOR_ACTIVO_HISTORICO GAH where EXISTS (SELECT 1 FROM rem01.ACT_ACTIVO ACT WHERE ACT.ACT_ID = GAH.ACT_ID AND ACT.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.GAC_GESTOR_ADD_ACTIVO GAC where EXISTS (SELECT 1 FROM rem01.ACT_ACTIVO ACT WHERE ACT.ACT_ID = GAC.ACT_ID AND ACT.usuariocrear= 'MIGRAREM01BNK');
  commit;
  delete from rem01.VIS_VISITAS vis where EXISTS (SELECT 1 FROM rem01.ACT_ACTIVO ACT WHERE ACT.ACT_ID = VIS.ACT_ID AND ACT.usuariocrear= 'MIGRAREM01BNK');
  commit;
  delete from rem01.ACT_ACTIVO where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_NOT_EXISTS where TABLA_MIG LIKE '%_BNK%';
  delete from rem01.AGR_NOT_EXISTS where TABLA_MIG LIKE '%_BNK%'; 
  delete from rem01.CPR_NOT_EXISTS where TABLA_MIG LIKE '%_BNK%'; 
  delete from rem01.TBJ_NOT_EXISTS where TABLA_MIG LIKE '%_BNK%'; 
  delete from rem01.PVE_NOT_EXISTS where TABLA_MIG LIKE '%_BNK%'; 
  delete from rem01.PRO_NOT_EXISTS where TABLA_MIG LIKE '%_BNK%'; 
  delete from rem01.DD_COD_NOT_EXISTS
  commit;  
  /*FIN BORRADO*/
  
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P'
                 AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
       LOOP
           BEGIN              
                      DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );    
                      EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        
 
 
                      FOR H IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE R_CONSTRAINT_NAME=J.CONSTRAINT_NAME )
                       LOOP
                           BEGIN              
                               DBMS_OUTPUT.PUT_LINE('Activando : '|| H.table_name ||'.'|| H.constraint_name );    
                               EXECUTE IMMEDIATE 'ALTER TABLE ' || H.TABLE_NAME || ' ENABLE CONSTRAINT ' || H.CONSTRAINT_NAME;
                             
                           EXCEPTION WHEN OTHERS THEN
                               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
                           END;
                       END LOOP H;            
                     
        EXCEPTION WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
        END;
       END LOOP;            
  END LOOP;
  COMMIT;   

 
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R'
                 AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
       LOOP
           BEGIN              
                      DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );    
                      EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                      
        EXCEPTION WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
        END;
       END LOOP;            
  END LOOP;
  COMMIT;   
 
  DBMS_OUTPUT.PUT_LINE('*******************************' );
  DBMS_OUTPUT.PUT_LINE('**FALTA ACTIVAR RESTRICCIONES**' );
  DBMS_OUTPUT.PUT_LINE('*******************************' );
 
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE  STATUS='DISABLED'
               AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
       LOOP
           BEGIN              
               DBMS_OUTPUT.PUT_LINE('Activación extra : '|| J.table_name ||'.'|| J.constraint_name );    
                EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                      
        EXCEPTION WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
        END;
       END LOOP;       

DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );

  EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('                             -'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;   

END;
