--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20170616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2208
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= 'REM_IDX'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de ID
    
    V_TABLA VARCHAR2(30 CHAR) := 'MIG2_RELACION_DAT_MIG_MODELO';  -- Tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        T_VAL('ACTIVO_ADJ_JUDICIAL', 'REM01.MIG_ADJ_JUDICIAL', 'REM01.ACT_AJD_ADJJUDICIAL', '1'),
        T_VAL('ACTIVO_ADJ_NO_JUDICIAL', 'REM01.MIG_ADJ_NO_JUDICIAL', 'REM01.ACT_ADN_ADJNOJUDICIAL', '1'),
        T_VAL('ACTIVO_CABECERA', 'REM01.MIG_ACA_CABECERA', 'REM01.ACT_ACTIVO', '1'),
        T_VAL('ACTIVO_DATOSADICIONALES', 'REM01.MIG_ADA_DATOS_ADI', 'REM01.ACT_SPS_SIT_POSESORIA', '1'),
        T_VAL('ACTIVO_PLANDINVENTAS', 'REM01.MIG_APL_PLANDINVENTAS', 'REM01.ACT_PDV_PLAN_DIN_VENTAS', '1'),
        T_VAL('ACTIVO_PRECIO', 'REM01.MIG_APC_PRECIO', 'REM01.ACT_VAL_VALORACIONES', '1'),
        T_VAL('ACTIVO_PROPUESTAS', 'REM01.MIG2_ACT_PRP', 'REM01.ACT_PRP', '0'),
        T_VAL('ACTIVOS', 'REM01.MIG2_ACT_ACTIVO', 'REM01.ACT_ACTIVO', '1'),
        T_VAL('ACTIVOS_DATOS_ALQUILERES', 'REM01.MIG2_ACQ_ACTIVO_ALQUILER', 'REM01.ACT_HAL_HIST_ALQUILERES', '1'),
        T_VAL('ACTIVO_TITULO', 'REM01.MIG_ATI_TITULO', 'REM01.ACT_TIT_TITULO', '1'),
        T_VAL('ADMISION_DOCUMENTOS', 'REM01.MIG_ADD_ADMISION_DOC', 'REM01.ACT_ADO_ADMISION_DOCUMENTO', '1'),
        T_VAL('AGRUPACIONES_ACTIVO', 'REM01.MIG_AAA_AGRUPACION_ACTIVO', 'REM01.ACT_AGR_AGRUPACION', '1'),
        T_VAL('AGRUPACIONES', 'REM01.MIG_AAG_AGRUPACIONES', 'REM01.ACT_AGR_AGRUPACION', '1'),
        T_VAL('AGRUPACIONES2', 'REM01.MIG2_AGR_AGRUPACIONES', 'REM01.ACT_AGR_AGRUPACION', '1'),
        T_VAL('CALIDADES_ACTIVO', 'REM01.MIG_ACA_CALIDADES_ACTIVO', 'REM01.ACT_CRI_CARPINTERIA_INT', '1'),
        T_VAL('CARGAS_ACTIVO', 'REM01.MIG_ACA_CARGAS_ACTIVO', 'REM01.ACT_CRG_CARGAS', '1'),
        T_VAL('CATASTRO_ACTIVO', 'REM01.MIG_ACA_CATASTRO_ACTIVO', 'REM01.ACT_CAT_CATASTRO', '1'),
        T_VAL('CLIENTES_COMERCIALES', 'REM01.MIG2_CLC_CLIENTE_COMERCIAL', 'REM01.CLC_CLIENTE_COMERCIAL', '1'),
        T_VAL('COMISIONES_GASTOS', 'REM01.MIG2_GEX_GASTOS_EXPEDIENTE', 'REM01.GEX_GASTOS_EXPEDIENTE', '1'),
        T_VAL('COMPRADORES', 'REM01.MIG2_COM_COMPRADORES', 'REM01.COM_COMPRADOR', '1'),
        T_VAL('COMPRADOR_EXPEDIENTE', 'REM01.MIG2_CEX_COMPRADOR_EXPEDIENTE', 'REM01.CEX_COMPRADOR_EXPEDIENTE', '0'),
        T_VAL('COM_PROPIETARIOS_CABECERA', 'REM01.MIG_CPC_PROP_CABECERA', 'REM01.ACT_CPR_COM_PROPIETARIOS', '1'),
        T_VAL('COND_ESPEC_ACTIVOS_PUBLICADOS', 'REM01.MIG2_ACT_COE_CONDICIONES_ESPEC', 'REM01.ACT_COE_CONDICION_ESPECIFICA', '1'),
        T_VAL('CONDICIONANTE_OFERTA_ACEPTADA', 'REM01.MIG2_COE_CONDICIONAN_OFR_ACEP', 'REM01.COE_CONDICIONANTES_EXPEDIENTE', '1'),
        T_VAL('DETALLE_ECONOMICO_GASTOS', 'REM01.MIG2_GDE_GASTOS_DET_ECONOMICO', 'REM01.GDE_GASTOS_DETALLE_ECONOMICO', '1'),
        T_VAL('ENTIDAD_PROVEEDOR', 'REM01.MIG_AEP_ENTIDAD_PROVEEDOR', 'REM01.ACT_ETP_ENTIDAD_PROVEEDOR', '1'),
        T_VAL('FORMALIZACIONES', 'REM01.MIG2_FOR_FORMALIZACIONES', 'REM01.FOR_FORMALIZACION', '1'),
        T_VAL('GASTOS_IMPUGNACIONES', 'REM01.MIG2_GIM_GASTOS_IMPUGNACION', 'REM01.GIM_GASTOS_IMPUGNACION', '1'),
        T_VAL('GASTOS_INFORMACION_CONTABILIDAD', 'REM01.MIG2_GIC_GASTOS_INFO_CONTABI', 'REM01.GIC_GASTOS_INFO_CONTABILIDAD', '1'),
        T_VAL('GASTOS_PROVEEDORES_ACT_TBJ', 'REM01.MIG2_GPV_ACT_TBJ', 'REM01.GPV_ACT', '0'),
        T_VAL('GASTOS_PROVEEDORES', 'REM01.MIG2_GPV_GASTOS_PROVEEDORES', 'REM01.GPV_GASTOS_PROVEEDOR', '1'),
        T_VAL('GASTOS_PROVISIONES', 'REM01.MIG2_GPR_PROVISION_GASTOS', 'REM01.PRG_PROVISION_GASTOS', '1'),
        T_VAL('GESTION_GASTOS', 'REM01.MIG2_GGE_GASTOS_GESTION', 'REM01.GGE_GASTOS_GESTION', '1'),
        T_VAL('GESTORES_ACTIVO', 'REM01.MIG2_GEA_GESTORES_ACTIVOS', 'REM01.GAC_GESTOR_ADD_ACTIVO', '0'),
        T_VAL('GESTORES_OFERTAS', 'REM01.MIG2_GEO_GESTORES_OFERTAS', 'REM01.GCO_GESTOR_ADD_ECO', '1'),
        T_VAL('GRUPOS_USUARIOS', 'REM01.MIG2_GRU_GRUPOS_USUARIOS', 'REMMASTER.GRU_GRUPOS_USUARIOS', '1'),
        T_VAL('HIST_ACTIVOS_PRECIOS', 'REM01.MIG2_ACT_HVA_HIST_VALORACIONES', 'REM01.ACT_HVA_HIST_VALORACIONES', '1'),
        T_VAL('HIST_ESTADOS_PUBLICACIONES', 'REM01.MIG2_ACT_HEP_HIST_EST_PUBLI', 'REM01.ACT_HEP_HIST_EST_PUBLICACION', '1'),
        T_VAL('INFOCOMERCIAL_ACTIVO', 'REM01.MIG_AIA_INFCOMERCIAL_ACT', 'REM01.ACT_ICO_INFO_COMERCIAL', '1'),
        T_VAL('INFOCOMERCIAL_DISTRIBUCION', 'REM01.MIG_AID_INFCOMERCIAL_DISTR', 'REM01.ACT_DIS_DISTRIBUCION', '1'),
        T_VAL('LLAVES_ACTIVO', 'REM01.MIG_ALA_LLAVES_ACTIVO', 'REM01.ACT_LLV_LLAVE', '1'),
        T_VAL('MOVIMIENTOS_LLAVE', 'REM01.MIG_AML_MOVIMIENTOS_LLAVE', 'REM01.ACT_MLV_MOVIMIENTO_LLAVE', '1'),
        T_VAL('OBSERVACIONES_ACTIVOS', 'REM01.MIG_AOA_OBSERVACIONES_ACTIVOS', 'REM01.ACT_AOB_ACTIVO_OBS', '1'),
        T_VAL('OBSERVACIONES_AGRUPACION', 'REM01.MIG_AOA_OBSERVACION_AGRUP', 'REM01.ACT_AGO_AGRUPACION_OBS', '1'),
        T_VAL('OFERTAS_ACTIVO', 'REM01.MIG2_OFA_OFERTAS_ACTIVO', 'REM01.ACT_OFR', '0'),
        T_VAL('OFERTAS', 'REM01.MIG2_OFR_OFERTAS', 'REM01.OFR_OFERTAS', '1'),
        T_VAL('OFERTAS_OBSERVACIONES', 'REM01.MIG2_OBF_OBSERVACIONES_OFERTAS', 'REM01.TXO_TEXTOS_OFERTA', '1'),
        T_VAL('PERIMETRO_ACTIVOS', 'REM01.MIG2_PAC_PERIMETRO_ACTIVO', 'REM01.ACT_PAC_PERIMETRO_ACTIVO', '1'),
        T_VAL('POSICIONAMIENTOS', 'REM01.MIG2_POS_POSICIONAMIENTO', 'REM01.POS_POSICIONAMIENTO', '1'),
        T_VAL('PRESUPUESTO_TRABAJO', 'REM01.MIG_APT_PRESUPUESTO_TRABAJ', 'REM01.ACT_PRT_PRESUPUESTO_TRABAJO', '1'),
        T_VAL('PROPIETARIOS_ACTIVO', 'REM01.MIG_APA_PROP_ACTIVO', 'REM01.ACT_PAC_PROPIETARIO_ACTIVO', '1'),
        T_VAL('PROPIETARIOS_CABECERA', 'REM01.MIG_APC_PROP_CABECERA', 'REM01.ACT_PRO_PROPIETARIO', '1'),
        T_VAL('PROPIETARIOS', 'REM01.MIG2_PRO_PROPIETARIOS', 'REM01.ACT_PRO_PROPIETARIO', '1'),
        T_VAL('PROPUESTAS_PRECIOS', 'REM01.MIG2_PRP_PROPUESTAS_PRECIOS', 'REM01.PRP_PROPUESTAS_PRECIOS', '1'),
        T_VAL('PROVEEDOR_CONTACTO', 'REM01.MIG2_PVC_PROVEEDOR_CONTACTO', 'REM01.ACT_PVC_PROVEEDOR_CONTACTO', '1'),
        T_VAL('PROVEEDORES', 'REM01.MIG2_PVE_PROVEEDORES', 'REM01.ACT_PVE_PROVEEDOR', '1'),
        T_VAL('PROVEEDORES_DIRECCIONES', 'REM01.MIG2_PRD_PROVEEDOR_DIRECCION', 'REM01.ACT_PRD_PROVEEDOR_DIRECCION', '1'),
        T_VAL('RESERVAS', 'REM01.MIG2_RES_RESERVAS', 'REM01.RES_RESERVAS', '1'),
        T_VAL('SUBSANACIONES', 'REM01.MIG2_SUB_SUBSANACIONES', 'REM01.SUB_SUBSANACIONES', '1'),
        T_VAL('TASACIONES_ACTIVO', 'REM01.MIG_ATA_TASACIONES_ACTIVO', 'REM01.ACT_TAS_TASACION', '1'),
        T_VAL('TITULARES_ADICIONALES_OFERTA', 'REM01.MIG2_OFR_TIA_TITULARES_ADI', 'REM01.OFR_TIA_TITULARES_ADICIONALES', '1'),
        T_VAL('TRABAJO', 'REM01.MIG_ATR_TRABAJO', 'REM01.ACT_TBJ_TRABAJO', '1'),
        T_VAL('USUARIOS', 'REM01.MIG2_USU_USUARIOS', 'REMMASTER.USU_USUARIOS', '1'),
        T_VAL('VISITAS', 'REM01.MIG2_VIS_VISITAS', 'REM01.VIS_VISITAS', '1')
    );  
    V_TMP_VAL T_VAL; 
    
BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    -- Verificar si la tabla existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
    
    IF V_NUM_TABLAS > 0 THEN    
        DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');
    
        FOR I IN V_VAL.FIRST .. V_VAL.LAST 
        LOOP
            V_TMP_VAL := V_VAL(I);  
            
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE FICHERO_DAT = '''||V_TMP_VAL(1)||''' AND TABLA_MIG = '''||V_TMP_VAL(2)||''' AND TABLA_MODELO = '''||V_TMP_VAL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 0 THEN
            
                DBMS_OUTPUT.PUT_LINE('      [INFO] Insertando FICHERO_DAT = '''||V_TMP_VAL(1)||''' AND TABLA_MIG = '''||V_TMP_VAL(2)||''' AND TABLA_MODELO = '''||V_TMP_VAL(3)||'''...');
                EXECUTE IMMEDIATE '
                INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                	FICHERO_DAT  
                	, TABLA_MIG
                    , TABLA_MODELO
                    , TABLA_MODELO_AUDITORIA         
                )
                SELECT
                	'''||V_TMP_VAL(1)||'''
                	, '''||V_TMP_VAL(2)||'''
                    , '''||V_TMP_VAL(3)||'''
                    , '''||V_TMP_VAL(4)||'''
                FROM DUAL
                '
                ;
            
            ELSE
                DBMS_OUTPUT.PUT_LINE('      [INFO] FICHERO_DAT = '''||V_TMP_VAL(1)||''' AND TABLA_MIG = '''||V_TMP_VAL(2)||''' AND TABLA_MODELO = '''||V_TMP_VAL(3)||'''... Existe.');
            END IF;
            
        END LOOP;  
    
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... No existe.');
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
