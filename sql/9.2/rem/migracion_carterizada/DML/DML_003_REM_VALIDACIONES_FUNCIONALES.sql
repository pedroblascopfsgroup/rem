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
                                                                                       
        --Validaciones para activos                                                                            
        T_VAL('ACT_000'   ,'1'           ,'Activos con cartera distinta de Sareb'                                                                                                                             ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON AUX.ACT_NUMERO_ACTIVO = ACT2.ACT_NUMERO_ACTIVO WHERE ACT2.ACT_COD_CARTERA IS NULL OR ACT2.ACT_COD_CARTERA != ''''02'''''),
        T_VAL('ACT_001'   ,'1'           ,'Activos sin tipo de activo'                                                                                                                                        ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.TIPO_ACTIVO IS NULL'),
        T_VAL('ACT_002'   ,'1'           ,'Activos sin subtipo de activo'                                                                                                                                     ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.SUBTIPO_ACTIVO IS NULL'),
        T_VAL('ACT_003'   ,'1'           ,'Activos sin estado de activo'                                                                                                                                      ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.ESTADO_ACTIVO IS NULL'),
        T_VAL('ACT_004'   ,'1'           ,'Activos sin tipo titulo'                                                                                                                                           ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.TIPO_TITULO IS NULL'),
        T_VAL('ACT_005'   ,'1'           ,'Activos en estado "Disponible para la venta con oferta" creados por la migración que no posean oferta en estado distinto a "Rechazada"'                            ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.SITUACION_COMERCIAL = ''''03'''' AND NOT EXISTS ( SELECT 1 FROM REM01.MIG_ACA_CABECERA AUX2 INNER JOIN REM01.MIG2_OFA_OFERTAS_ACTIVO OFA ON AUX2.ACT_NUMERO_ACTIVO = OFA.OFA_ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG2_OFR_OFERTAS OFR ON OFA.OFA_COD_OFERTA = OFR.OFR_COD_OFERTA WHERE AUX2.SITUACION_COMERCIAL = ''''03'''' AND OFR.OFR_COD_ESTADO_OFERTA != ''''02'''' AND AUX2.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO)'),
        T_VAL('ACT_006'   ,'1'           ,'Activos en estado "Disponible para la venta con reserva" creados por la migración que no dispongan de reserva'                                                     ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG2_OFA_OFERTAS_ACTIVO OFA ON OFA.OFA_ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_RES_RESERVAS RES ON RES.RES_COD_OFERTA = OFA.OFA_COD_OFERTA WHERE AUX.SITUACION_COMERCIAL = ''''04'''' AND RES.RES_COD_NUM_RESERVA IS NULL'),
        T_VAL('ACT_007'   ,'1'           ,'Activos con situación comercial "Disponible" sin oferta asociada'                                                                                                  ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG2_OFA_OFERTAS_ACTIVO OFA ON OFA.OFA_ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.SITUACION_COMERCIAL = ''''03'''' AND OFA.OFA_COD_OFERTA IS NULL'),
        T_VAL('ACT_008'   ,'1'           ,'Activos con situación comercial "Vendido" sin fecha de venta'                                                                                                      ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG2_PAC_PERIMETRO_ACTIVO PAC ON PAC.PAC_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.SITUACION_COMERCIAL = ''''05'''' AND ACT2.ACT_FECHA_VENTA IS NULL'),
        T_VAL('ACT_009'   ,'1'           ,'Activos ocupados con titulo sin título posesorio'                                                                                                                  ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE ADA.SPS_OCUPADO = 1 AND ADA.SPS_CON_TITULO = 1 AND AUX.TIPO_TITULO IS NULL'),        
        T_VAL('ACT_010'   ,'1'           ,'Activos con tipo y subtipo de activo incorrecto'                                                                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE NOT EXISTS (SELECT 1 FROM REM01.DD_SAC_SUBTIPO_ACTIVO SAC WHERE SAC.DD_TPA_ID = (SELECT DD_TPA_ID FROM REM01.DD_TPA_TIPO_ACTIVO DD_TPA WHERE DD_TPA.DD_TPA_CODIGO = AUX.TIPO_ACTIVO) AND SAC.DD_SAC_CODIGO = AUX.SUBTIPO_ACTIVO)'),
        T_VAL('ACT_011'   ,'1'           ,'Activos Financieros sin alguno de los gestores mínimos/obligatorios que debe tener'                                                                                ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_APL_PLANDINVENTAS APL ON APL.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_TIPO_GESTOR_OBLIGATORIOS GEO ON GEO.CARTERA = ACT2.ACT_COD_CARTERA AND GEO.ELEMENTO_BASE = ''''AAFF'''' WHERE NOT EXISTS ( SELECT 1 FROM REM01.MIG2_GEA_GESTORES_ACTIVOS GEA WHERE GEA.GEA_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO AND GEA.GEA_TIPO_GESTOR = GEO.TIPO_GESTOR)'),
        T_VAL('ACT_012'   ,'1'           ,'Activos Inmobiliario sin alguno de los gestores mínimos/obligatorios que debe tener'                                                                               ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_APL_PLANDINVENTAS APL ON APL.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO LEFT JOIN REM01.MIG2_TIPO_GESTOR_OBLIGATORIOS GEO ON GEO.CARTERA = ACT2.ACT_COD_CARTERA AND GEO.ELEMENTO_BASE = ''''AAII'''' WHERE APL.ACT_NUMERO_ACTIVO IS NULL AND NOT EXISTS ( SELECT 1 FROM REM01.MIG2_GEA_GESTORES_ACTIVOS GEA WHERE GEA.GEA_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO AND GEA.GEA_TIPO_GESTOR = GEO.TIPO_GESTOR)'),
        T_VAL('ACT_013'   ,'1'           ,'Activos marcados como sin cargas que tienen cargas con estado distinto de "Cancelada"'                                                                             ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ACA_CARGAS_ACTIVO CAR ON CAR.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.ACT_CON_CARGAS = 0 AND CAR.SITUACION_CARGA != ''''CAN'''''),
        T_VAL('ACT_014'   ,'1'           ,'Activos con el indicador "Gestión HRE" vacio'                                                                                                                      ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.GESTION_HRE IS NULL'),
        T_VAL('ACT_015'   ,'1'           ,'Activos con el indicador "Ocupado" en "No" y el indicador "Con titulo" con valor'                                                                                  ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE ADA.SPS_CON_TITULO IS NOT NULL AND ADA.SPS_OCUPADO = 0'),
        T_VAL('ACT_016'   ,'1'           ,'Activos con "Llaves en poder de HRE" con valor "Si" y el campo "Fecha toma posesión inicial" sin informar'                                                         ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE ADA.ACT_LLV_LLAVES_HRE = 1 AND ADA.SPS_FECHA_TOMA_POSESION IS NULL'),
        T_VAL('ACT_017'   ,'1'           ,'Activos sin fecha de recepción de llaves y el indicador "Llaves en poder de HRE" con valor "Sí"'                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE (ADA.ACT_LLV_FECHA_RECEPCION IS NULL AND ADA.ACT_LLV_LLAVES_HRE = 1) OR (ADA.ACT_LLV_FECHA_RECEPCION IS NOT NULL AND ADA.ACT_LLV_LLAVES_HRE = 0)'),
        T_VAL('ACT_018'   ,'1'           ,'Activos sin municipio de registro o con el municipio de registro fuera de la provincia del activo'                                                                 ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADA ON AUX.ACT_NUMERO_ACTIVO = ADA.ACT_NUMERO_ACTIVO WHERE NOT EXISTS ( SELECT 1 FROM REMMASTER.DD_LOC_LOCALIDAD LOC WHERE LOC.DD_PRV_ID = (SELECT DD_PRV_ID FROM REMMASTER.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = ADA.PROVINCIA) AND LOC.DD_LOC_CODIGO = ADA.MUNICIPIO_REGISTRO )'),
        T_VAL('ACT_019'   ,'1'           ,'Activos sin tipo titulo'                                                                                                                                           ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.TIPO_TITULO IS NULL'),
        T_VAL('ACT_020'   ,'1'           ,'Activos judiciales con fecha toma posesion anterior a la fecha firmeza del auto de adjudicación'                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADJ_JUDICIAL ADJ ON AUX.ACT_NUMERO_ACTIVO = ADJ.ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO  WHERE (AUX.TIPO_TITULO != ''''01'''') OR (AUX.TIPO_TITULO = ''''01'''' AND ADI.SPS_FECHA_TOMA_POSESION < ADJ.ADJ_FECHA_ADJUDICACION)'),
        T_VAL('ACT_021'   ,'1'           ,'Activos no judiciales con fecha toma posesion anterior a la fecha de titulo'                                                                                       ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADJ_NO_JUDICIAL ADJ ON AUX.ACT_NUMERO_ACTIVO = ADJ.ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE (AUX.TIPO_TITULO != ''''02'''') OR (AUX.TIPO_TITULO = ''''02'''' AND ADI.SPS_FECHA_TOMA_POSESION < ADJ.ADN_FECHA_TITULO)'),
        T_VAL('ACT_022'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Fecha de inscripción del titulo'                                                                         ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ATI_TITULO TIT ON TIT.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND TIT.TIT_FECHA_INSC_REG IS NULL'),
        T_VAL('ACT_023'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Fecha de toma de posesión inicial'                                                                       ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADA_DATOS_ADI ADI ON ADI.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND ADI.SPS_FECHA_TOMA_POSESION IS NULL'),
        T_VAL('ACT_024'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Fecha de validación de cargas'                                                                           ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX WHERE AUX.ESTADO_ADMISION = 1 AND AUX.ACT_FECHA_REV_CARGAS IS NULL'),
        T_VAL('ACT_025'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Tipo de vía'                                                                                             ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND ADI.TIPO_VIA IS NULL'),
        T_VAL('ACT_026'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Nombre de vía'                                                                                           ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND ADI.LOC_NOMBRE_VIA IS NULL'),
        T_VAL('ACT_027'   ,'0'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Nº'                                                                                                      ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND ADI.LOC_NUMERO_DOMICILIO IS NULL'),
        T_VAL('ACT_028'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Provincia'                                                                                               ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.PROVINCIA IS NULL OR ADI.PROVINCIA = 0)'),
        T_VAL('ACT_029'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Municipio'                                                                                               ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.MUNICIPIO IS NULL OR ADI.MUNICIPIO = 0)'),
        T_VAL('ACT_030'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Código Postal'                                                                                           ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.LOC_COD_POST IS NULL OR ADI.LOC_COD_POST = 0)'),
        T_VAL('ACT_031'   ,'0'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Latitud'                                                                                                 ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.LOC_LATITUD IS NULL OR ADI.LOC_LATITUD = 0)'),
        T_VAL('ACT_032'   ,'0'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Longitud'                                                                                                ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.LOC_LONGITUD IS NULL OR ADI.LOC_LONGITUD = 0)'),
        T_VAL('ACT_033'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Población del registro'                                                                                  ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.MUNICIPIO_REGISTRO IS NULL OR ADI.MUNICIPIO_REGISTRO = 0)'),
        T_VAL('ACT_034'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: nº de registro'                                                                                          ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.REG_NUM_REGISTRO IS NULL OR ADI.MUNICIPIO_REGISTRO = 0)'),
        T_VAL('ACT_035'   ,'0'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Tomo'                                                                                                    ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.REG_TOMO IS NULL OR ADI.REG_TOMO = 0)'),
        T_VAL('ACT_036'   ,'0'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Libro'                                                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.REG_LIBRO IS NULL OR ADI.REG_LIBRO = 0)'),
        T_VAL('ACT_037'   ,'0'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Folio'                                                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.REG_FOLIO IS NULL OR ADI.REG_FOLIO = 0)'),
        T_VAL('ACT_038'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Finca'                                                                                                   ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ADA_DATOS_ADI ADI ON AUX.ACT_NUMERO_ACTIVO = ADI.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADI.REG_NUM_FINCA IS NULL OR ADI.REG_NUM_FINCA = ''''0'''')'),
        T_VAL('ACT_039'   ,'0'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Referencia catastral'                                                                                    ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX LEFT JOIN REM01.MIG_ACA_CATASTRO_ACTIVO CAT ON AUX.ACT_NUMERO_ACTIVO = CAT.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND CAT.CAT_REF_CATASTRAL IS NULL'),
        T_VAL('ACT_040'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Fecha título (en caso de adjudicación no judicial)'                                                      ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADJ_NO_JUDICIAL ADN ON AUX.ACT_NUMERO_ACTIVO = ADN.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND ADN.ADN_FECHA_TITULO IS NULL'),
        T_VAL('ACT_041'   ,'1'           ,'Activos marcados con "Sí" en el estado de admisión y sin: Fecha auto adjudicación y fecha firmeza auto adjudicación (en caso de adjudicación judicial)'            ,'MIG_ACA_CABECERA'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG_ACA_CABECERA AUX INNER JOIN REM01.MIG_ADJ_JUDICIAL ADJ ON AUX.ACT_NUMERO_ACTIVO = ADJ.ACT_NUMERO_ACTIVO WHERE AUX.ESTADO_ADMISION = 1 AND (ADJ.ADJ_FECHA_ADJUDICACION IS NULL OR ADJ.ADJ_FECHA_DECRETO_FIRME IS NULL)'),
        
        --Validaciones para agrupaciones
        T_VAL('AGR_001'   ,'1'           ,'Agrupaciones que tienen activos con distinta cartera'                                                                                                              ,'MIG_AAG_AGRUPACIONES'              ,'SELECT #SELECT_STATEMENT# FROM ( SELECT AAA.AGR_UVEM, ACT2.ACT_COD_CARTERA FROM REM01.MIG_AAA_AGRUPACION_ACTIVO AAA INNER JOIN REM01.MIG_ACA_CABECERA ACA ON ACA.ACT_NUMERO_ACTIVO = AAA.ACT_NUMERO_ACTIVO INNER JOIN REM01.MIG2_ACT_ACTIVO ACT2 ON ACT2.ACT_NUMERO_ACTIVO = ACA.ACT_NUMERO_ACTIVO GROUP BY AAA.AGR_UVEM, ACT2.ACT_COD_CARTERA) AUX GROUP BY AGR_UVEM HAVING COUNT(1) > 1'),

        --Validaciones para ofertas
        T_VAL('OFR_001'   ,'1'           ,'Ofertas en estado distinto a anulación con motivo de anulación informado'                                                                                          ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX WHERE AUX.OFR_COD_ESTADO_OFERTA != ''''01-07'''' AND AUX.OFR_COD_MOTIVO_ANULACION != 0'),
        T_VAL('OFR_002'   ,'1'           ,'Ofertas que o bien se solicita financiación y no está informada la entidad financiadora o bien no se solicita y viene informada'                                   ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX INNER JOIN REM01.MIG2_COE_CONDICIONAN_OFR_ACEP COE ON AUX.OFR_COD_OFERTA = COE.COE_COD_OFERTA WHERE (COE.COE_SOLICITA_FINANCIACION = 1 AND COE.COE_ENTIDAD_FINANCIACION_AJENA IS NULL) OR ((COE.COE_SOLICITA_FINANCIACION = 0 OR COE.COE_SOLICITA_FINANCIACION IS NULL) AND COE.COE_ENTIDAD_FINANCIACION_AJENA IS NOT NULL)'),
        T_VAL('OFR_003'   ,'1'           ,'Ofertas aceptadas sin importes'                                                                                                                                    ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX WHERE AUX.OFR_COD_ESTADO_OFERTA LIKE ''''01%'''' AND AUX.OFR_IMPORTE IS NULL'),
        T_VAL('OFR_004'   ,'1'           ,'Ofertas con contraoferta sin importe contraoferta o fecha de contraoferta'                                                                                         ,'MIG2_OFR_OFERTAS'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_OFR_OFERTAS AUX WHERE AUX.OFR_COD_ESTADO_OFERTA = ''''01-04'''' AND ((AUX.OFR_IMPORTE_CONTRAOFERTA IS NULL AND AUX.OFR_FECHA_CONTRAOFERTA IS NOT NULL) OR (AUX.OFR_IMPORTE_CONTRAOFERTA IS NOT NULL AND AUX.OFR_FECHA_CONTRAOFERTA IS NULL))'),

        --Validaciones para proveedores                                                            
        T_VAL('PVE_001'   ,'1'           ,'Proveedores sin estado "Vigente" / "Baja"'                                                                                                                         ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO IS NULL OR AUX.PVE_COD_ESTADO NOT IN (''''04'''',''''07'''')'),
        T_VAL('PVE_002'   ,'1'           ,'Proveedores sin "Fecha de alta"'                                                                                                                                   ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_FECHA_ALTA IS NULL'),
        T_VAL('PVE_003'   ,'1'           ,'Proveedores en estado "Vigente" sin contacto con usuario o email'                                                                                                  ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX LEFT JOIN REM01.MIG2_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVE_COD_UVEM = AUX.PVE_COD_UVEM WHERE AUX.PVE_COD_ESTADO = ''''04'''' AND (PVC.PVC_COD_USUARIO IS NULL OR PVC.PVC_EMAIL IS NULL)'),
        T_VAL('PVE_004'   ,'0'           ,'Proveedores con un tipo de documento identificativo distinto al NIF'                                                                                               ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_TIPO_DOCUMENTO != ''''15'''''),
        T_VAL('PVE_005'   ,'1'           ,'Proveedores con documento identificativo duplicado y distinto código UVEM (Únicamente para proveedores vigentes y sin contar las oficinas)'                        ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX INNER JOIN ( SELECT UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) PVE_DOCUMENTO_ID FROM (SELECT DISTINCT PVE_COD_UVEM, PVE_DOCUMENTO_ID FROM REM01.MIG2_PVE_PROVEEDORES WHERE PVE_COD_TIPO_PROVEEDOR NOT IN (''''28'''',''''29'''') AND PVE_COD_ESTADO = ''''04'''') AUX GROUP BY UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) HAVING COUNT(1) > 1 ) SQLI ON UPPER(REPLACE(TRANSLATE(AUX.PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) = SQLI.PVE_DOCUMENTO_ID'),
        T_VAL('PVE_006'   ,'1'           ,'Proveedores en estado "Vigente" sin numero de cuenta'                                                                                                              ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO = ''''04'''' AND AUX.PVE_NUM_CUENTA IS NULL'),
        T_VAL('PVE_007'   ,'1'           ,'Proveedores en estado "Vigente" sin titular'                                                                                                                       ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO = ''''04'''' AND AUX.PVE_TITULAR IS NULL'),
        T_VAL('PVE_008'   ,'1'           ,'Proveedores con localidad informada y no tienen informada la provincia'                                                                                            ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_LOCALIDAD IS NOT NULL AND AUX.PVE_COD_PROVINCIA IS NULL'),
        T_VAL('PVE_009'   ,'1'           ,'Proveedores en estado "Baja" sin fecha de baja informada'                                                                                                          ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO = ''''07'''' AND AUX.PVE_FECHA_BAJA IS NULL'),
        T_VAL('PVE_010'   ,'1'           ,'Proveedores sin estado'                                                                                                                                            ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO IS NULL'),
        T_VAL('PVE_011'   ,'1'           ,'Proveedores duplicados con el mismo NIF y misma tipologia (Únicamente para proveedores vigentes)'                                                                  ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX INNER JOIN ( SELECT UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) PVE_DOCUMENTO_ID FROM REM01.MIG2_PVE_PROVEEDORES WHERE PVE_COD_TIPO_PROVEEDOR NOT IN (''''28'''',''''29'''') AND PVE_COD_ESTADO = ''''04'''' GROUP BY UPPER(REPLACE(TRANSLATE(PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')), PVE_COD_TIPO_PROVEEDOR HAVING COUNT(1) > 1) SQLI ON UPPER(REPLACE(TRANSLATE(AUX.PVE_DOCUMENTO_ID, ''''-_.'''', ''''#''''), ''''#'''', '''''''')) = SQLI.PVE_DOCUMENTO_ID'),
        T_VAL('PVE_012'   ,'1'           ,'Proveedores en estado distinto a "Vigente" sin fecha de baja informada'                                                                                            ,'MIG2_PVE_PROVEEDORES'              ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_PVE_PROVEEDORES AUX WHERE AUX.PVE_COD_ESTADO != ''''04'''' AND AUX.PVE_FECHA_BAJA IS NULL'),
        T_VAL('GPV_001'   ,'1'           ,'Gastos que no tengan el tipo de gasto informado'                                                                                                                   ,'MIG2_GPV_GASTOS_PROVEEDORES'       ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES AUX WHERE AUX.GPV_COD_TIPO_GASTO IS NULL'),
        T_VAL('GPV_002'   ,'1'           ,'Gastos que no tengan el subtipo de gasto informado'                                                                                                                ,'MIG2_GPV_GASTOS_PROVEEDORES'       ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES AUX WHERE AUX.GPV_COD_SUBTIPO_GASTO IS NULL'),
        T_VAL('GPV_003'   ,'1'           ,'Gastos sin IVA que no tengan la periodicidad informada'                                                                                                            ,'MIG2_GPV_GASTOS_PROVEEDORES'       ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES AUX JOIN REM01.MIG2_GDE_GASTOS_DET_ECONOMICO T2 ON AUX.GPV_ID = T2.GDE_GPV_ID WHERE AUX.GPV_COD_PERIODICIDAD IS NULL AND T2.GDE_COD_TIPO_IMPUESTO IS NULL'),
        T_VAL('GPV_004'   ,'1'           ,'Gastos que no tengan la fecha de emision informada'                                                                                                                ,'MIG2_GPV_GASTOS_PROVEEDORES'       ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES AUX WHERE AUX.GPV_FECHA_EMISION IS NULL'),
        T_VAL('GPV_005'   ,'1'           ,'Gastos que puedan generar un estado'                                                                                                                               ,'MIG2_GPV_GASTOS_PROVEEDORES'       ,'SELECT DISTINCT #SELECT_STATEMENT# FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES AUX JOIN MIG2_GGE_GASTOS_GESTION T2 ON T2.GGE_GPV_ID = AUX.GPV_ID JOIN MIG2_GDE_GASTOS_DET_ECONOMICO T3 ON T3.GDE_GPV_ID = AUX.GPV_ID JOIN MIG2_GIC_GASTOS_INFO_CONTABI T4 ON T4.GIC_GPV_ID = AUX.GPV_ID WHERE (T2.GGE_COD_EST_AUTORIZ_HAYA,T2.GGE_COD_EST_AUTORIZ_PROP) NOT IN ((''''01'''',''''01''''),(''''02'''',''''01''''),(''''03'''',''''01''''),(''''02'''',''''02''''),(''''02'''',''''03''''),(''''02'''',''''04''''),(''''03'''',''''05''''),(''''03'''',''''06'''')) AND ((T2.GGE_COD_EST_AUTORIZ_HAYA,T2.GGE_COD_EST_AUTORIZ_PROP) NOT IN ((''''03'''',''''07'''')) OR T3.GDE_FECHA_PAGO IS NULL) AND ((T2.GGE_COD_EST_AUTORIZ_HAYA,T2.GGE_COD_EST_AUTORIZ_PROP) NOT IN ((''''03'''',''''07'''')) OR T4.GIC_FECHA_CONTABILIZACION IS NULL) AND T2.GGE_FECHA_ANULACION IS NULL AND T2.GGE_FECHA_RETENCION_PAGO IS NULL'),
        T_VAL('GPV_006'   ,'1'           ,'Gastos cuyo tipo de operacion no sea Pago gasto, Pago gasto inversion o Abono/Factura rectificativa'                                                               ,'MIG2_GPV_GASTOS_PROVEEDORES'       ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GPV_GASTOS_PROVEEDORES AUX WHERE NVL(AUX.GPV_COD_TIPO_OPERACION,''''00'''') NOT IN (''''01'''',''''02'''',''''03'''')'),
        T_VAL('GPT_001'   ,'1'           ,'Gastos activo trabajo, cuya base imponible no sume 100% o sea nula'                                                                                                ,'MIG2_GPV_ACT_TBJ'                  ,'SELECT DISTINCT #SELECT_STATEMENT# FROM (SELECT AUX.GPT_ACT_NUMERO_ACTIVO, SUM(AUX.GPT_BASE_IMPONIBLE) BASE FROM MIG2_GPV_ACT_TBJ AUX GROUP BY AUX.GPT_ACT_NUMERO_ACTIVO) T2 JOIN MIG2_GPV_ACT_TBJ AUX ON AUX.GPT_ACT_NUMERO_ACTIVO = T2.GPT_ACT_NUMERO_ACTIVO WHERE T2.BASE <> 100 UNION SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GPV_ACT_TBJ AUX WHERE AUX.GPT_BASE_IMPONIBLE IS NULL'),
        T_VAL('GDE_001'   ,'1'           ,'Gastos detalle económico, el principal está informado sin tener IVA o viceversa'                                                                                   ,'MIG2_GDE_GASTOS_DET_ECONOMICO'     ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GDE_GASTOS_DET_ECONOMICO AUX WHERE NVL(GDE_COD_TIPO_IMPUESTO,''''00'''') = ''''01'''' AND GDE_PRINCIPAL_SUJETO IS NULL UNION SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GDE_GASTOS_DET_ECONOMICO AUX WHERE GDE_COD_TIPO_IMPUESTO IS NULL AND GDE_PRINCIPAL_SUJETO IS NOT NULL'),
        T_VAL('GDE_002'   ,'1'           ,'Gastos detalle económico, el impuesto indirecto por renuncia exención sólo puede tener valor en caso de que el impuesto indirecto exento sea SÍ'                   ,'MIG2_GDE_GASTOS_DET_ECONOMICO'     ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GDE_GASTOS_DET_ECONOMICO AUX WHERE NVL(AUX.GDE_IND_IMP_INDIRECTO_EXENTO,1)=1 AND AUX.GDE_IND_IMP_INDIR_RENUN_EXENC IS NOT NULL'),
        T_VAL('GDE_003'   ,'1'           ,'Gastos detalle económico, el indicador de inclusión de pago provisión está informado pero la fecha y/o el importe de dicho pago no lo están'                       ,'MIG2_GDE_GASTOS_DET_ECONOMICO'     ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GDE_GASTOS_DET_ECONOMICO AUX WHERE AUX.GDE_INCLUIR_PAGO_PROVISION IS NOT NULL AND (AUX.GDE_FECHA_PAGO IS NULL OR AUX.GDE_IMPORTE_PAGADO IS NULL)'),
        T_VAL('GDE_004'   ,'1'           ,'Gastos detalle económico, la cuenta de abono debe ser distinta a la del emisor del gasto'                                                                          ,'MIG2_GDE_GASTOS_DET_ECONOMICO'     ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GDE_GASTOS_DET_ECONOMICO AUX JOIN MIG2_GPV_GASTOS_PROVEEDORES GPV ON AUX.GDE_GPV_ID = GPV.GPV_ID JOIN MIG2_PVE_PROVEEDORES PVE ON GPV.GPV_COD_PVE_UVEM_EMISOR = PVE.PVE_COD_UVEM WHERE AUX.GDE_ABONO_CUENTA = 1 AND AUX.GDE_IBAN = PVE.PVE_NUM_CUENTA AND ((GPV.GPV_COD_TIPO_GASTO = ''''01'''' AND PVE.PVE_COD_TIPO_PROVEEDOR IN (''''13'''', ''''15'''')) OR (GPV.GPV_COD_TIPO_GASTO = ''''02'''' AND PVE.PVE_COD_TIPO_PROVEEDOR IN (''''13'''', ''''16'''')) OR (GPV.GPV_COD_TIPO_GASTO = ''''03'''' AND PVE.PVE_COD_TIPO_PROVEEDOR IN (''''13'''', ''''17'''')) OR (GPV.GPV_COD_TIPO_GASTO = ''''04'''' AND PVE.PVE_COD_TIPO_PROVEEDOR IN (''''13'''',''''16'''',''''17'''')))'),
        T_VAL('GGE_001'   ,'1'           ,'Gastos de gestión autorizados por el propietario sin fecha de autorización informada'                                                                              ,'MIG2_GGE_GASTOS_GESTION'           ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GGE_GASTOS_GESTION AUX WHERE GGE_FECHA_EST_AUTORIZ_PROP IS NULL AND GGE_COD_EST_AUTORIZ_PROP IS NOT NULL'),
        T_VAL('GPR_001'   ,'1'           ,'Gastos proveedores provisión sin número de provisión de fondos informado cuando el gasto es sin IVA'                                                               ,'MIG2_GPR_PROVISION_GASTOS'         ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GPR_PROVISION_GASTOS AUX JOIN MIG2_GPV_GASTOS_PROVEEDORES GPV ON AUX.GPR_NUMERO_PROVISION_FONDOS = GPV.GPV_NUMERO_PROVISION_FONDOS JOIN MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GPV.GPV_ID = GDE.GDE_GPV_ID WHERE GDE.GDE_COD_TIPO_IMPUESTO IS NULL AND AUX.GPR_NUMERO_PROVISION_FONDOS IS NULL'),
        T_VAL('GPR_002'   ,'1'           ,'Gastos proveedores provisión sin fecha de envío cuando existe fecha de respuesta o con fecha de envío más antigua que la fecha de alta'                            ,'MIG2_GPR_PROVISION_GASTOS'         ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GPR_PROVISION_GASTOS AUX WHERE (AUX.GPR_FECHA_ALTA IS NOT NULL AND AUX.GPR_FECHA_ENVIO < AUX.GPR_FECHA_ALTA) OR (AUX.GPR_FECHA_RESPUESTA IS NOT NULL AND AUX.GPR_FECHA_ENVIO IS NULL)'),
        T_VAL('GPR_003'   ,'1'           ,'Gastos proveedores provisión con fecha de respuesta anterior a fecha de envío'                                                                                     ,'MIG2_GPR_PROVISION_GASTOS'         ,'SELECT DISTINCT #SELECT_STATEMENT# FROM MIG2_GPR_PROVISION_GASTOS AUX WHERE AUX.GPR_FECHA_RESPUESTA IS NOT NULL AND AUX.GPR_FECHA_RESPUESTA < AUX.GPR_FECHA_ENVIO')
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
