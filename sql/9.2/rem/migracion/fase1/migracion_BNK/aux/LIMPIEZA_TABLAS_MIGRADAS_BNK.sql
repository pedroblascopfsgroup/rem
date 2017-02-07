WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

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
                                                            T_TABLAS('REM01','ACT_PRD_PROVEEDOR_DIRECCION'),
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
                                                            T_TABLAS('REM01','ACT_ACTIVO'),
                                                            T_TABLAS('REM01','ACT_LCO_LOTE_COMERCIAL'),
                                                            T_TABLAS('REM01','ACT_ABA_ACTIVO_BANCARIO')
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
  delete from rem01.ACT_ABA_ACTIVO_BANCARIO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PRO_PROPIETARIO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PRT_PRESUPUESTO_TRABAJO where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PRV_PARAMENTO_VERTICAL where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_PVC_PROVEEDOR_CONTACTO where usuariocrear= 'MIG2';
  DELETE FROM rem01.ACT_PRD_PROVEEDOR_DIRECCION WHERE USUARIOCREAR = 'MIG2';
  delete from rem01.ACT_PAC_PROPIETARIO_ACTIVO where usuariocrear= 'MIGRAREM01BNK';
  commit;
  delete from rem01.ACT_ETP_ENTIDAD_PROVEEDOR ETP where EXISTS (SELECT 1 FROM REM01.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_ID = ETP.PVE_ID AND PVE.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_PVE_PROVEEDOR where usuariocrear= 'MIG2';
  delete from rem01.ACT_REG_INFO_REGISTRAL where usuariocrear= 'MIGRAREM01BNK';
  delete from rem01.ACT_ONV_OBRA_NUEVA ONV where EXISTS (SELECT 1 FROM REM01.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_ID = ONV.AGR_ID AND AGR.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_RES_RESTRINGIDA RES where EXISTS (SELECT 1 FROM REM01.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_ID = RES.AGR_ID AND AGR.usuariocrear= 'MIGRAREM01BNK');
  delete from rem01.ACT_LCO_LOTE_COMERCIAL LCO WHERE EXISTS (SELECT 1 FROM REM01.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_ID = LCO.AGR_ID AND AGR.usuariocrear= 'MIGRAREM01BNK');
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
  
  UPDATE REM01.ACT_PVE_PROVEEDOR PVE 
      SET
	   PVE.DD_TPC_ID = NULL
	  ,PVE.DD_TPE_ID = NULL
	  ,PVE.PVE_NIF = NULL
	  ,PVE.PVE_FECHA_ALTA = NULL
	  ,PVE.PVE_FECHA_BAJA = NULL
	  ,PVE.PVE_LOCALIZADA = NULL
	  ,PVE.DD_EPR_ID = NULL
	  ,PVE.PVE_FECHA_CONSTITUCION = NULL
	  ,PVE.PVE_AMBITO = NULL
	  ,PVE.PVE_OBSERVACIONES = NULL
	  ,PVE.PVE_HOMOLOGADO = NULL
	  ,PVE.DD_CPR_ID = NULL
	  ,PVE.PVE_TOP = NULL
	  ,PVE.PVE_TITULAR_CUENTA = NULL
	  ,PVE.PVE_RETENER = NULL
	  ,PVE.DD_MRE_ID = NULL
	  ,PVE.PVE_FECHA_RETENCION = NULL
	  ,PVE.PVE_FECHA_PBC = NULL
	  ,PVE.DD_RPB_ID = NULL
      ,PVE.USUARIOMODIFICAR = NULL
      ,PVE.FECHAMODIFICAR = NULL
  WHERE PVE.USUARIOMODIFICAR = 'MIG2';
  
  UPDATE REM01.ACT_PRO_PROPIETARIO PRO
       SET	
	       PRO.DD_CRA_ID = NULL
	       /*FALTA AÑADIR LA SUBCARTERA CUANDO SE CREE EL CAMPO*/
          ,PRO.USUARIOMODIFICAR = NULL
          ,PRO.FECHAMODIFICAR = NULL;
	--WHERE PRO.USUARIOMODIFICAR = 'MIG2';
	
	
	/*Borrado querys adicionales */

	DELETE FROM AIN_ACTIVO_INTEGRADO AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM AIN_ACTIVO_INTEGRADO AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_VAL_VALORACIONES AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_VAL_VALORACIONES AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_TRA_TRAMITE AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_TRA_TRAMITE AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_HEP_HIST_EST_PUBLICACION AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_HEP_HIST_EST_PUBLICACION AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_HIC_EST_INF_COMER_HIST AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_HIC_EST_INF_COMER_HIST AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_OFR AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_OFR AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM TAC_TAREAS_ACTIVOS AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM TAC_TAREAS_ACTIVOS AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_ADA_ADJUNTO_ACTIVO AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_ADA_ADJUNTO_ACTIVO AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_CAT_CATASTRO AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_CAT_CATASTRO AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_TBJ AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_TBJ AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_TBJ_TRABAJO AIN
	WHERE ACT_ID IN(
	SELECT ACT_ID FROM ACT_TBJ_TRABAJO AIN WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE AIN.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM ACT_PRT_PRESUPUESTO_TRABAJO AIN
	WHERE AIN.TBJ_ID IN(
	SELECT AIN.TBJ_ID FROM ACT_PRT_PRESUPUESTO_TRABAJO AIN 
	INNER JOIN ACT_TBJ_TRABAJO ACT_TBJ
	  ON ACT_TBJ.TBJ_ID = AIN.TBJ_ID
	WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_ACTIVO ACT WHERE ACT_TBJ.ACT_ID = ACT.ACT_ID)
	);

	DELETE FROM PRG_PROVISION_GASTOS AIN
	WHERE AIN.PVE_ID_GESTORIA IN(
	SELECT AIN.PVE_ID_GESTORIA FROM PRG_PROVISION_GASTOS AIN 
	WHERE NOT EXISTS (  
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ACT WHERE AIN.PVE_ID_GESTORIA = ACT.PVE_ID)
	);
	
	DELETE FROM ACT_PRD_PROVEEDOR_DIRECCION GEX2
	WHERE GEX2.PVE_ID IN (
	SELECT GEX.PVE_ID FROM ACT_PRD_PROVEEDOR_DIRECCION GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.PVE_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_TAS_TASACION GEX2
	WHERE GEX2.BIE_VAL_ID IN (
	SELECT GEX.BIE_VAL_ID FROM ACT_TAS_TASACION TAS
	INNER JOIN BIE_VALORACIONES GEX
	  ON TAS.BIE_VAL_ID = GEX.BIE_VAL_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM BIE_BIEN ECO WHERE GEX.BIE_ID = ECO.BIE_ID));
	  
	DELETE FROM BIE_VALORACIONES GEX2
	WHERE GEX2.BIE_ID IN (
	SELECT GEX.BIE_ID FROM BIE_VALORACIONES GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM BIE_BIEN ECO WHERE GEX.BIE_ID = ECO.BIE_ID));
	  
	DELETE FROM ACT_OLE_OCUPANTE_LEGAL GEX2
	WHERE GEX2.SPS_ID IN (
	SELECT GEX.SPS_ID FROM ACT_OLE_OCUPANTE_LEGAL GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_SPS_SIT_POSESORIA ECO WHERE GEX.SPS_ID = ECO.SPS_ID));
	  
	DELETE FROM ACT_MLV_MOVIMIENTO_LLAVE GEX2
	WHERE GEX2.LLV_ID IN (
	SELECT GEX.LLV_ID FROM ACT_MLV_MOVIMIENTO_LLAVE GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_LLV_LLAVE ECO WHERE GEX.LLV_ID = ECO.LLV_ID));
	 
	DELETE FROM ACT_ADO_ADMISION_DOCUMENTO GEX2
	WHERE GEX2.ACT_ID IN (
	SELECT GEX.ACT_ID FROM ACT_ADO_ADMISION_DOCUMENTO GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.ACT_ID = ECO.ACT_ID));
	  
	DELETE FROM ACT_ETP_ENTIDAD_PROVEEDOR GEX2
	WHERE GEX2.PVE_ID IN (
	SELECT GEX.PVE_ID FROM ACT_ETP_ENTIDAD_PROVEEDOR GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.PVE_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_PVC_PROVEEDOR_CONTACTO GEX2
	WHERE GEX2.PVE_ID IN (
	SELECT GEX.PVE_ID FROM ACT_PVC_PROVEEDOR_CONTACTO GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.PVE_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_RES_RESTRINGIDA GEX2
	WHERE GEX2.AGR_ID IN (
	SELECT GEX.AGR_ID FROM ACT_RES_RESTRINGIDA RES
	INNER JOIN ACT_AGR_AGRUPACION GEX
	  ON GEX.AGR_ID = RES.AGR_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.AGR_ACT_PRINCIPAL = ECO.ACT_ID));
	  	  
	DELETE FROM ACT_AGA_AGRUPACION_ACTIVO GEX2
	WHERE GEX2.AGR_ID IN (
	SELECT GEX.AGR_ID FROM ACT_AGA_AGRUPACION_ACTIVO RES
	INNER JOIN ACT_AGR_AGRUPACION GEX
	  ON GEX.AGR_ID = RES.AGR_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.AGR_ACT_PRINCIPAL = ECO.ACT_ID));
	  
	DELETE FROM ACT_AAH_AGRUP_ACTIVO_HIST GEX2
	WHERE GEX2.AGR_ID IN (
	SELECT GEX.AGR_ID FROM ACT_AAH_AGRUP_ACTIVO_HIST RES
	INNER JOIN ACT_AGR_AGRUPACION GEX
	  ON GEX.AGR_ID = RES.AGR_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.AGR_ACT_PRINCIPAL = ECO.ACT_ID));
	
	DELETE FROM ACT_AGR_AGRUPACION GEX2
	WHERE GEX2.AGR_ACT_PRINCIPAL IN (
	SELECT GEX.AGR_ACT_PRINCIPAL FROM ACT_AGR_AGRUPACION GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.AGR_ACT_PRINCIPAL = ECO.ACT_ID));
	  
	DELETE FROM ACT_TRA_TRAMITE GEX2
	WHERE GEX2.TBJ_ID IN (
	SELECT GEX.TBJ_ID FROM ACT_TRA_TRAMITE GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_TBJ_TRABAJO ECO WHERE GEX.TBJ_ID = ECO.TBJ_ID));
	  
	DELETE FROM ACT_COE_CONDICION_ESPECIFICA GEX2
	WHERE GEX2.ACT_ID IN (
	SELECT GEX.ACT_ID FROM ACT_COE_CONDICION_ESPECIFICA GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.ACT_ID = ECO.ACT_ID));
	  
	DELETE FROM GEX_GASTOS_EXPEDIENTE GEX2
	WHERE GEX2.GEX_PROVEEDOR IN (
	SELECT GEX.GEX_PROVEEDOR FROM GEX_GASTOS_EXPEDIENTE GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.GEX_PROVEEDOR = ECO.PVE_ID));
	  
	DELETE FROM ACT_ICM_INF_COMER_HIST_MEDI GEX2
	WHERE GEX2.ICO_MEDIADOR_ID IN (
	SELECT GEX.ICO_MEDIADOR_ID FROM ACT_ICM_INF_COMER_HIST_MEDI GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_ICM_INF_COMER_HIST_MEDI GEX2
	WHERE GEX2.ACT_ID IN (
	SELECT GEX.ACT_ID FROM ACT_ICM_INF_COMER_HIST_MEDI GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.ACT_ID = ECO.ACT_ID));
	  
	DELETE FROM ACT_PTE_PROVEED_TERRITORIAL GEX2
	WHERE GEX2.PVE_ID IN (
	SELECT GEX.PVE_ID FROM ACT_PTE_PROVEED_TERRITORIAL GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.PVE_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_PRT_PRESUPUESTO_TRABAJO GEX2
	WHERE GEX2.TBJ_ID IN (
	SELECT GEX.TBJ_ID FROM ACT_PRT_PRESUPUESTO_TRABAJO GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_TBJ_TRABAJO ECO WHERE GEX.TBJ_ID = ECO.TBJ_ID));
	  
	DELETE FROM ACT_PTO_PRESUPUESTO GEX2
	WHERE GEX2.ACT_ID IN (
	SELECT GEX.ACT_ID FROM ACT_PTO_PRESUPUESTO GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.ACT_ID = ECO.ACT_ID));
	  
	DELETE FROM ACT_ADT_ADJUNTO_TRABAJO GEX2
	WHERE GEX2.TBJ_ID IN (
	SELECT GEX.TBJ_ID FROM ACT_ADT_ADJUNTO_TRABAJO GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_TBJ_TRABAJO ECO WHERE GEX.TBJ_ID = ECO.TBJ_ID));
	  
	DELETE FROM ACT_CRG_CARGAS GEX2
	WHERE GEX2.ACT_ID IN (
	SELECT GEX.ACT_ID FROM ACT_CRG_CARGAS GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ACTIVO ECO WHERE GEX.ACT_ID = ECO.ACT_ID));
	  
	DELETE FROM ACT_EDI_EDIFICIO GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_EDI_EDIFICIO EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_PRV_PARAMENTO_VERTICAL GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_PRV_PARAMENTO_VERTICAL EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_SOL_SOLADO GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_SOL_SOLADO EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_COC_COCINA GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_COC_COCINA EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_BNY_BANYO GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_BNY_BANYO EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_INS_INSTALACION GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_INS_INSTALACION EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_ZCO_ZONA_COMUN GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_ZCO_ZONA_COMUN EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_INF_INFRAESTRUCTURA GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_INF_INFRAESTRUCTURA EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_CRI_CARPINTERIA_INT GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_CRI_CARPINTERIA_INT EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_CRE_CARPINTERIA_EXT GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_CRE_CARPINTERIA_EXT EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_VIV_VIVIENDA GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT EDI.ICO_ID FROM ACT_VIV_VIVIENDA EDI
	INNER JOIN ACT_ICO_INFO_COMERCIAL GEX
	  ON EDI.ICO_ID = GEX.ICO_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM ACT_ICO_INFO_COMERCIAL GEX2
	WHERE GEX2.ICO_MEDIADOR_ID IN (
	SELECT GEX.ICO_MEDIADOR_ID FROM ACT_ICO_INFO_COMERCIAL GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_PVE_PROVEEDOR ECO WHERE GEX.ICO_MEDIADOR_ID = ECO.PVE_ID));
	  
	DELETE FROM BIE_CAR_CARGAS GEX2
	WHERE GEX2.BIE_ID IN (
	SELECT GEX.BIE_ID FROM BIE_CAR_CARGAS GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM BIE_BIEN ECO WHERE GEX.BIE_ID = ECO.BIE_ID));
	  
	DELETE FROM ACT_DIS_DISTRIBUCION GEX2
	WHERE GEX2.ICO_ID IN (
	SELECT GEX.ICO_ID FROM ACT_DIS_DISTRIBUCION GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ACT_ICO_INFO_COMERCIAL ECO WHERE GEX.ICO_ID = ECO.ICO_ID));
		
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
