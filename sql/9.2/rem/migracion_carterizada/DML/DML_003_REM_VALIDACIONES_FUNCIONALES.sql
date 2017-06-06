--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20170229
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2043
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
    
    V_TABLA VARCHAR2(30 CHAR) := 'VIC_VAL_INTERFAZ_FUNC';  -- Tabla objetivo
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_VIC_VAL_INTERFAZ_FUNC';  --  Sequencia de la tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        --- CODIGO -------- SEVERIDAD ---- VALIDACION --------------------------------------------------------------------------------------------------------------------------------------------------------- NOMBRE_INTERFAZ -------------------- QUERY --------------------------------------
        
        --Validaciones para ofertas
        T_VAL('OFR_001'   ,'1'           ,'Ofertas en estado distinto a anulación con motivo de anulación informado'                                                                                          ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX WHERE AUX.OFR_COD_ESTADO_OFERTA != ''''01-07'''' AND AUX.OFR_COD_MOTIVO_ANULACION != 0'),
        T_VAL('OFR_002'   ,'1'           ,'Ofertas que o bien se solicita financiación y no está informada la entidad financiadora o bien no se solicita y viene informada'                                   ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX INNER JOIN REM01.MIG2_COE_CONDICIONAN_OFR_ACEP COE ON AUX.OFR_COD_OFERTA = COE.COE_COD_OFERTA WHERE (COE.COE_SOLICITA_FINANCIACION = 1 AND COE.COE_ENTIDAD_FINANCIACION_AJENA IS NULL) OR ((COE.COE_SOLICITA_FINANCIACION = 0 OR COE.COE_SOLICITA_FINANCIACION IS NULL) AND COE.COE_ENTIDAD_FINANCIACION_AJENA IS NOT NULL)'),
        T_VAL('OFR_003'   ,'1'           ,'Ofertas aceptadas sin importes'                                                                                                                                    ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX WHERE AUX.OFR_COD_ESTADO_OFERTA LIKE ''''01%'''' AND AUX.OFR_IMPORTE IS NULL'),
        T_VAL('OFR_004'   ,'1'           ,'Ofertas con contraoferta sin importe contraoferta o fecha de contraoferta'                                                                                         ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX WHERE AUX.OFR_COD_ESTADO_OFERTA = ''''01-04'''' AND ((AUX.OFR_IMPORTE_CONTRAOFERTA IS NULL AND AUX.OFR_FECHA_CONTRAOFERTA IS NOT NULL) OR (AUX.OFR_IMPORTE_CONTRAOFERTA IS NOT NULL AND AUX.OFR_FECHA_CONTRAOFERTA IS NULL))'),
                                                                                       
        --Validaciones para activos                                                                            
        T_VAL('ACT_001'   ,'1'           ,'Activos sin tipo'                                                                                                                                                  ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.TIPO_ACTIVO IS NULL'),
        T_VAL('ACT_002'   ,'1'           ,'Activos en estado "Disponible para la venta con oferta" creados por la migración que no posean fecha de venta externa o oferta en estado distinto a "Rechazada"'   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG2_OFA_OFERTAS_ACTIVO OFA ON AUX.ACT_NUMERO_ACTIVO = OFA.OFA_ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON AUX.ACT_NUMERO_ACTIVO = ACT2.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_OFR_OFERTAS OFR ON OFA.OFA_COD_OFERTA = OFR.OFR_COD_OFERTA WHERE AUX.SITUACION_COMERCIAL = ''''03'''' AND (ACT2.ACT_FECHA_VENTA IS NULL OR OFR.OFR_COD_ESTADO_OFERTA IS NULL OR OFR.OFR_COD_ESTADO_OFERTA != ''''02'''')'),
        T_VAL('ACT_003'   ,'1'           ,'Activos en estado "Disponible para la venta con reserva" creados por la migración que no dispongan de reserva'                                                     ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG2_OFA_OFERTAS_ACTIVO OFA ON OFA.OFA_ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_RES_RESERVAS RES ON RES.RES_COD_OFERTA = OFA.OFA_COD_OFERTA WHERE AUX.SITUACION_COMERCIAL = ''''04'''' AND RES.RES_COD_NUM_RESERVA IS NULL'),
        T_VAL('ACT_004'   ,'1'           ,'Activos sin título posesorio'                                                                                                                                      ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.TIPO_TITULO IS NULL'),
        T_VAL('ACT_005'   ,'1'           ,'Activos con situación comercial "Vendido" sin fecha de venta o dentro de perímetro'                                                                                ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG2_PAC_PERIMETRO_ACTIVO PAC ON PAC.PAC_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.SITUACION_COMERCIAL = ''''05'''' AND (PAC.PAC_IND_INCLUIDO = 1 OR ACT2.ACT_FECHA_VENTA IS NULL)'),
        T_VAL('ACT_006'   ,'1'           ,'Activos con situación comercial "Disponible" sin oferta asociada'                                                                                                  ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG2_OFA_OFERTAS_ACTIVO OFA ON OFA.OFA_ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.SITUACION_COMERCIAL = ''''03'''' AND OFA.OFA_COD_OFERTA IS NULL'),
        T_VAL('ACT_007'   ,'1'           ,'Activos con tipo y subtipo de activo incorrecto'                                                                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE NOT EXISTS (SELECT 1 FROM REM01.DD_SAC_SUBTIPO_ACTIVO SAC WHERE SAC.DD_TPA_ID = (SELECT DD_TPA_ID FROM REM01.DD_TPA_TIPO_ACTIVO DD_TPA WHERE DD_TPA.DD_TPA_CODIGO = AUX.TIPO_ACTIVO) AND SAC.DD_SAC_CODIGO = AUX.SUBTIPO_ACTIVO)'),
        T_VAL('ACT_008'   ,'1'           ,'Activos sin subtipo'                                                                                                                                               ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.SUBTIPO_ACTIVO IS NULL'),
        T_VAL('ACT_009'   ,'1'           ,'Activos sin estado'                                                                                                                                                ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.ESTADO_ACTIVO IS NULL'),
        T_VAL('ACT_010'   ,'1'           ,'Activos sin tipo titulo'                                                                                                                                           ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.TIPO_TITULO IS NULL'),
        T_VAL('ACT_011'   ,'1'           ,'Activos Financieros sin alguno de los gestores mínimos/obligatorios que debe tener'                                                                                ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_APL_PLANDINVENTAS APL ON APL.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_TIPO_GESTOR_OBLIGATORIOS GEO ON GEO.CARTERA = ACT2.ACT_COD_CARTERA AND GEO.ELEMENTO_BASE = ''''AAFF'''' WHERE NOT EXISTS ( SELECT 1 FROM REM01.MIG2_GEA_GESTORES_ACTIVO GEA WHERE GEA.GEA_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO AND GEA.GEA_TIPO_GESTOR = GEO.TIPO_GESTOR)'),
        T_VAL('ACT_012'   ,'1'           ,'Activos Inmobiliario sin alguno de los gestores mínimos/obligatorios que debe tener'                                                                               ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_APL_PLANDINVENTAS APL ON APL.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_TIPO_GESTOR_OBLIGATORIOS GEO ON GEO.CARTERA = ACT2.ACT_COD_CARTERA AND GEO.ELEMENTO_BASE = ''''AAII'''' WHERE APL.ACT_NUMERO_ACTIVO IS NULL AND NOT EXISTS ( SELECT 1 FROM REM01.MIG2_GEA_GESTORES_ACTIVO GEA WHERE GEA.GEA_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO AND GEA.GEA_TIPO_GESTOR = GEO.TIPO_GESTOR)'),
        T_VAL('ACT_013'   ,'1'           ,'Activos marcados como sin cargas que tienen cargas con estado distinto de "Cancelada"'                                                                             ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ACA_CARGAS_ACTIVO CAR ON CAR.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.ACT_CON_CARGAS = 0 AND CAR.SITUACION_CARGA != ''''CAN'''''),
        T_VAL('ACT_014'   ,'1'           ,'Activos con el indicador "Gestión HRE" vacio'                                                                                                                      ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.GESTION_HRE IS NULL'),
        T_VAL('ACT_015'   ,'1'           ,'Activos con el indicador "Ocupado" en "No" y el indicador "Con titulo" con valor'                                                                                  ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE ADA.SPS_CON_TITULO IS NOT NULL AND ADA.SPS_OCUPADO = 0'),
        T_VAL('ACT_016'   ,'1'           ,'Activos con "Llaves en poder de HRE" con valor y el campo "Fecha toma posesión inicial" sin informar'                                                              ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE ADA.ACT_LLV_LLAVES_HRE IS NOT NULL AND ADA.SPS_FECHA_TOMA_POSESION IS NULL'),
        T_VAL('ACT_017'   ,'1'           ,'Activos sin fecha de recepción de llaves y el indicador "Llaves en poder de HRE" con valor "Sí"'                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE (ADA.ACT_LLV_FECHA_RECEPCION IS NULL AND ADA.ACT_LLV_LLAVES_HRE = 1) OR (ADA.ACT_LLV_FECHA_RECEPCION IS NOT NULL AND ADA.ACT_LLV_LLAVES_HRE = 0)'),
        T_VAL('ACT_018'   ,'1'           ,'Activos sin municipio de registro o con el municipio de registro fuera de la provincia del activo'                                                                 ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON AUX.ACT_NUMERO_ACTIVO = ADA.ACT_NUMERO_ACTIVO WHERE NOT EXISTS ( SELECT 1 FROM REMMASTER.DD_LOC_LOCALIDAD LOC WHERE LOC.DD_PRV_ID = (SELECT DD_PRV_ID FROM REMMASTER.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = ADA.PROVINCIA) AND LOC.DD_LOC_CODIGO = ADA.MUNICIPIO_REGISTRO )'),
        T_VAL('ACT_019'   ,'1'           ,'Activos sin tipo titulo'                                                                                                                                           ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.TIPO_TITULO IS NULL'),
        T_VAL('ACT_020'   ,'1'           ,'Activos judiciales con fecha toma posesion anterior a la fecha firmeza del auto de adjudicación'                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADJ_JUDICIAL ADJ ON AUX.ACT_NUMERO_ACTIVO = ADJ.ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO  WHERE (AUX.TIPO_TITULO != ''''01'''') OR (AUX.TIPO_TITULO = ''''01'''' AND ADI.SPS_FECHA_TOMA_POSESION < ADJ.ADJ_FECHA_ADJUDICACION)'),
        T_VAL('ACT_021'   ,'1'           ,'Activos no judiciales con fecha toma posesion anterior a la fecha de titulo'                                                                                       ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADJ_NO_JUDICIAL ADJ ON AUX.ACT_NUMERO_ACTIVO = ADJ.ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE (AUX.TIPO_TITULO != ''''02'''') OR (AUX.TIPO_TITULO = ''''02'''' AND ADI.SPS_FECHA_TOMA_POSESION < ADJ.ADN_FECHA_TITULO)'),
        T_VAL('ACT_022'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin fecha de inscripción del titulo'                                                                          ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ATI_TITULO TIT ON TIT.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND TIT.TIT_FECHA_INSC_REG IS NULL'),
        T_VAL('ACT_023'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin fecha de toma de posesión inicial'                                                                        ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADI ON ADI.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND ADI.SPS_FECHA_TOMA_POSESION IS NULL'),
        T_VAL('ACT_024'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin fecha de validación de cargas'                                                                            ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.ESTADO_ADMISION = 1 AND AUX.ACT_FECHA_REV_CARGAS IS NULL'),
        T_VAL('ACT_025'   ,'1'           ,'Activos con cartera distinta de Sareb'                                                                                                                             ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON AUX.ACT_NUMERO_ACTIVO = ACT2.ACT_NUMERO_ACTIVO WHERE ACT2.ACT_COD_CARTERA IS NULL OR ACT2.ACT_COD_CARTERA != ''''02'''''),

        --Validaciones para agrupaciones
        T_VAL('AGR_001'   ,'1'           ,'Agrupaciones que tienen activos con distinta cartera'                                                                                                              ,'MIG_AAA_AGRUPACIONES_ACTIVO'       ,'SELECT DISTINCT #SELECT_STATEMENT# FROM ( SELECT AAA.AGR_UVEM, ACT2.ACT_COD_CARTERA FROM REM01.MIG_AAA_AGRUPACIONES_ACTIVO AAA INNER JOIN REM01.MIG_ACA_CABECERA ACA ON ACA.ACT_NUMERO_ACTIVO = AAA.ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = ACA.ACT_NUMERO_ACTIVO GROUP BY AAA.AGR_UVEM, ACT2.ACT_COD_CARTERA) AUX GROUP BY AGR_UVEM HAVING COUNT(1) > 1'),
                                                               
        --Validaciones para proveedores                                                            
        T_VAL('PVE_001'   ,'1'           ,'Proveedores sin estado "Vigente" / "Baja"'                                                                                                                         ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE NVL(AUX.PVE_COD_ESTADO,''''NULL_VALUE'''') IN (''''01'''',''''02'''',''''03'''',''''05'''',''''06'''',''''NULL_VALUE'''') GROUP BY AUX.PVE_COD_UVEM, AUX.PVE_COD_TIPO_PROVEEDOR'),
        T_VAL('PVE_002'   ,'1'           ,'Proveedores sin "Fecha de alta" / "Fecha de baja"'                                                                                                                 ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_FECHA_ALTA IS NULL AND AUX.PVE_FECHA_ALTA IS NULL GROUP BY AUX.PVE_COD_UVEM, AUX.PVE_COD_TIPO_PROVEEDOR'),
        T_VAL('PVE_003'   ,'1'           ,'Proveedores en estado "Vigente" sin contacto con usuario o email'                                                                                                  ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX LEFT JOIN REM01.MIG2_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVE_COD_UVEM = AUX.PVE_COD_UVEM WHERE AUX.PVE_COD_ESTADO = ''''04'''' AND (PVC.PVC_COD_USUARIO IS NULL OR PVC.PVC_EMAIL IS NULL) GROUP BY AUX.PVE_COD_UVEM, AUX.PVE_COD_TIPO_PROVEEDOR'),
        T_VAL('PVE_004'   ,'1'           ,'Proveedores en estado "Vigente" sin IBAN o titular'                                                                                                                ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_NUM_CUENTA IS NULL OR AUX.PVE_TITULAR IS NULL GROUP BY AUX.PVE_COD_UVEM, AUX.PVE_COD_TIPO_PROVEEDOR'),
        T_VAL('PVE_005'   ,'1'           ,'Proveedores con un tipo de documento identificativo distinto al NIF'                                                                                               ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_TIPO_DOCUMENTO != ''''15'''''),
        T_VAL('PVE_006'   ,'1'           ,'Proveedores con documento identificativo duplicado y distinto código UVEM'                                                                                         ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX INNER JOIN ( SELECT UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) PVE_DOCUMENTO_ID FROM (SELECT DISTINCT PVE_COD_UVEM, PVE_DOCUMENTO_ID FROM REM01.MIG2_PVE_PROVEEDORES WHERE PVE_COD_TIPO_PROVEEDOR NOT IN (''''28'''',''''29'''')) AUX GROUP BY UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) HAVING COUNT(1) > 1 ) SQLI ON UPPER(REPLACE(TRANSLATE(AUX.PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) = SQLI.PVE_DOCUMENTO_ID'),
        T_VAL('PVE_007'   ,'1'           ,'Proveedores en estado "Vigente" sin numero de cuenta'                                                                                                              ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO = ''''04'''' AND AUX.PVE_NUM_CUENTA IS NULL'),
        T_VAL('PVE_008'   ,'1'           ,'Proveedores en estado "Vigente" sin titular'                                                                                                                       ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO = ''''04'''' AND AUX.PVE_TITULAR IS NULL'),
        T_VAL('PVE_009'   ,'1'           ,'Proveedores con localidad informada y no tienen informada la provincia'                                                                                            ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_LOCALIDAD IS NOT NULL AND AUX.PVE_COD_PROVINCIA IS NULL'),
        T_VAL('PVE_010'   ,'1'           ,'Proveedores en estado "Baja" sin fecha de baja informada'                                                                                                          ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO = ''''07'''' AND AUX.PVE_FECHA_BAJA IS NULL'),
        T_VAL('PVE_011'   ,'1'           ,'Proveedores sin estado'                                                                                                                                            ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO IS NULL'),
        T_VAL('PVE_012'   ,'1'           ,'Proveedores duplicados con el mismo NIF y misma tipologia'                                                                                                         ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX INNER JOIN ( SELECT UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) PVE_DOCUMENTO_ID FROM REM01.MIG2_PVE_PROVEEDORES WHERE PVE_COD_TIPO_PROVEEDOR NOT IN (''''28'''',''''29'''') GROUP BY UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')), PVE_COD_TIPO_PROVEEDOR HAVING COUNT(1) > 1) SQLI ON UPPER(REPLACE(TRANSLATE(AUX.PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) = SQLI.PVE_DOCUMENTO_ID')
    );  
    V_TMP_VAL T_VAL;  
    
BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    -- Verificar si la tabla existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
    
    IF V_NUM_TABLAS > 0 THEN    
        DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');
        
        -- Verificar si la sequencia existe
        V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = '''||V_TABLA_SEQ||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
        
        IF V_NUM_TABLAS > 0 THEN
            
            DBMS_OUTPUT.PUT_LINE('    [INFO] La sequencia '||V_ESQUEMA|| '.'||V_TABLA_SEQ||'... Existe.');
            
            -- Comprobamos el estado de la sequencia
            -- Obtenemos el valor en el que se encuentra la sequencia
            V_SQL := 'SELECT '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
            
            -- Obtenemos el maximo valor de ID
            V_SQL := 'SELECT NVL(MAX(VALIDACION_ID), 0) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
            
            -- Igualamos la sequencia al maximo valor de ID
            WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
                EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL FROM DUAL';
            END LOOP;
    
            FOR I IN V_VAL.FIRST .. V_VAL.LAST 
            LOOP
                V_TMP_VAL := V_VAL(I);  
                
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CODIGO = '''||V_TMP_VAL(1)||''' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                
                IF V_NUM_TABLAS = 0 THEN
                
                    DBMS_OUTPUT.PUT_LINE('      [INFO] Insertando validación: '''||V_TMP_VAL(3)||'''...');
                    EXECUTE IMMEDIATE '
                    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                        VALIDACION_ID  
                        ,CODIGO         
                        ,SEVERIDAD      
                        ,VALIDACION     
                        ,NOMBRE_INTERFAZ
                        ,QUERY          
                        ,BORRADO        
                    )
                    SELECT
                        '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
                        , '''||V_TMP_VAL(1)||'''
                        , '''||V_TMP_VAL(2)||'''
                        , '''||V_TMP_VAL(3)||'''
                        , '''||V_TMP_VAL(4)||'''
                        , '''||V_TMP_VAL(5)||'''
                        , 0
                    FROM DUAL
                    '
                    ;
                
                ELSE
                    DBMS_OUTPUT.PUT_LINE('      [INFO] La validacion '''||V_TMP_VAL(3)||'''... Existe.');
                END IF;
                
            END LOOP;
        
        ELSE
            DBMS_OUTPUT.PUT_LINE('    [INFO] La sequencia '||V_ESQUEMA|| '.'||V_TABLA_SEQ||'... No existe.');
        END IF;  
    
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
