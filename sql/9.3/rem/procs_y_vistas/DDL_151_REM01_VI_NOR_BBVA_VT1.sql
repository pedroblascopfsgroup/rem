--/*
--##########################################
--## AUTOR=Joaquin Arnal
--## FECHA_CREACION=20200913
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10975
--## PRODUCTO=NO
--## Finalidad: Vista para filtrar por los activos BBVA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 HREOS-11680 - JAD - reformulamos la vista VI_NOR_BBVA_VT1
--##        0.3 HREOS-11680 - JAD - quitamos el num_linia es vacio que esta mal
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_NOR_BBVA_VT1' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_NOR_BBVA_VT1...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_NOR_BBVA_VT1';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_NOR_BBVA_VT1... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_NOR_BBVA_VT1' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_NOR_BBVA_VT1...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_NOR_BBVA_VT1';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_NOR_BBVA_VT1... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_NOR_BBVA_VT1...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_NOR_BBVA_VT1 
	AS
    SELECT DISTINCT
        ACT.ACT_ID AS ACT_ID
        , COALESCE(BBVA.BBVA_CEXPER,''NULL'') AS CEXPER_MORA
        , CASE
            WHEN PRO.PRO_TITULIZADO IS NOT NULL
            THEN ''0182''
            ELSE LPAD(PRO.PRO_CODIGO_ENTIDAD,4,''0'')
        END AS SOCIEDAD
        , COALESCE(BBVA.BBVA_LINEA_FACTURA,0) AS NUMERO_ACTIVO_SAP
        , ''0000'' AS SUBNUMERO_ACTIVO_SAP
        , COALESCE(SUBSTR(ACT.ACT_NUM_ACTIVO_DIVARIAN, 1, 6),''NULL'') AS NUM_INTERNO
        , COALESCE(BBVA.BBVA_CLASE,''NULL'') AS CLASE
        , CASE
            WHEN PRO.PRO_TITULIZADO IS NOT NULL
            THEN TIB.TIB_CODIGO_SGITAS
            ELSE COALESCE(TIB.TIB_CODIGO_ACOGE,''NULL'')
        END AS TIPO_INMUEBLE
        , COALESCE(SUBSTR(BIEL.BIE_LOC_NOMBRE_VIA, 1, 50),''NULL'') AS CALLE_INMUEBLE
        , COALESCE(SUBSTR(BIEL.BIE_LOC_NUMERO_DOMICILIO, 1, 4),''NULL'') AS NUMERO_INMUEBLE
        , ''NULL'' AS CALLE_INMUEBLE_2
        , ''NULL'' AS NUMERO_INMUEBLE_2
        , COALESCE(UPPER(SUBSTR(LOC2.DD_LOC_DESCRIPCION, 1, 30)),''NULL'') AS LOCALIDAD
        , COALESCE(UPPER(BIEL.BIE_LOC_PROVINCIA),''NULL'') AS PROVINCIA
        , COALESCE(UPPER(BIEL.BIE_LOC_COD_POST),''NULL'') AS CODIGO_POSTAL
        ,''011'' AS PAIS
        ,CASE
            WHEN TIT.TIT_FECHA_INSC_REG IS NOT NULL AND ETI.DD_ETI_CODIGO = ''02'' AND ECa.DD_ECa_codigo = ''05'' AND VISTA.FECHA_POSESION IS NOT NULL
            THEN ''S''
            ELSE ''N''
        END AS DEP_JURIDICAMENTE
        , COALESCE(TO_CHAR(AJD.AJD_FECHA_ADJUDICACION,''DD.MM.YYYY''),''NULL'') AS FECHA_DEP_JURIDICA
        , COALESCE(SUBSTR(AJD.AJD_NUM_AUTO, 1, 7),''NULL'') AS NUM_AUTOS
        , ''NULL'' AS CALLE_JUZGADO
        , ''NULL'' AS NUMERO_JUZGADO
        , COALESCE(SUBSTR(ENT.BIE_DREG_NUM_FINCA, 1, 14),''NULL'') AS NUM_FINCA_REGISTRAL
        , ''NULL'' AS CATASTRO
        , COALESCE(CAT.CAT_REF_CATASTRAL,''NULL'') AS REFERENCIA_CATASTRAL
        , COALESCE(CAT.CAT_SUPERFICIE_CONSTRUIDA,0) AS SUPERFICIE
        , ''NULL'' AS OFICINA_VENDEDORA
        , coalesce(eco_gex.sum_gex,0) AS COMISION_EXTERNA
        , COALESCE(OFR.OFR_IMPORTE,0) AS PRECIO_VENTA
        , ''NULL'' AS NOMBRE_CLIENTE
        , ''NULL'' AS APELLIDO_1
        , ''NULL'' AS APELLIDO_2
        ,CASE
            WHEN TPE.DD_TPE_DESCRIPCION = ''FISICA'' 
                THEN ''F''
                ELSE ''J''
        END AS TIPO_IDENTIFICADOR
        , COALESCE(SUBSTR(COM.COM_DOCUMENTO, 1, 9),''NULL'') AS NIF_COMPRADOR
        , COALESCE(SUBSTR(COM.COM_DIRECCION, 1, 50),''NULL'') AS CALLE_COMPRADOR
        , ''NULL'' AS NUMERO_COMPRADOR
        , COALESCE(COM.COM_CODIGO_POSTAL,''NULL'') AS CP_COMPRADOR
        , COALESCE(SUBSTR(LOC2.DD_LOC_DESCRIPCION, 1, 30),''NULL'') AS LOCALIDAD_COMPRADOR
        , COALESCE(PRV2.DD_PRV_CODIGO,''NULL'') AS PROVINCIA_COMPRADOR
        , CASE
            WHEN LOC2.DD_LOC_ID IS NOT NULL
            THEN ''011''
            ELSE ''null''
        END AS PAIS_COMPRADOR
        ,CASE
            WHEN ACT.ACT_VENTA_EXTERNA_FECHA IS NOT NULL THEN TO_CHAR(ACT.ACT_VENTA_EXTERNA_FECHA,''DD.MM.YYYY'')
            ELSE COALESCE(TO_CHAR(ECO.ECO_FECHA_VENTA,''DD.MM.YYYY''),''NULL'')
        END AS FECHA_VENTA
        ,CASE
            WHEN ACT.ACT_VENTA_PLANO = 1 
            THEN ''CP''
            ELSE ''EP''
        END AS TIPO_CONTRATO
        ,''NULL'' AS RESTO_FINCAS
        ,COALESCE(PAC.PAC_PORC_PROPIEDAD,0) AS PROINDIVISO
        ,COALESCE(NULL,''NULL'') AS POLIVALENTE
        ,COALESCE(PRO.PRO_TITULIZADO,''NULL'') AS COD_EMPRESA_TITULIZADORA
        ,CASE
            WHEN PRO.PRO_TITULIZADO IS NOT NULL
            THEN PRO.PRO_DOCIDENTIF
            ELSE ''NULL''
        END AS NIF_EMPRESA_TITULIZADORA
        ,COALESCE(BBVA.BBVA_UIC,''NULL'') AS IUC
        ,COALESCE(REG.REG_IDUFIR,''NULL'') AS IDUFIR
        ,''NULL'' AS REST_IDUFIR
        ,CASE
            WHEN OAN.DD_OAN_CODIGO = ''08'' 
            THEN ''03''
            ELSE ''NULL''
        END AS PROCEDENCIA_LEASING
        ,CASE
            WHEN VI_BBVA_SIT_COMER.SITUACION_COMERCIAL_BBVA is not null
                THEN VI_BBVA_SIT_COMER.SITUACION_COMERCIAL_BBVA
            WHEN SCM.DD_SCM_CODIGO = ''02''
                THEN ''Libre en venta''
            WHEN SCM.DD_SCM_CODIGO = ''10''
                THEN ''Alquilado''
            ELSE ''NULL''
        END AS SIT_COMERCIAL
        ,CASE
            WHEN VAL.ACT_ID is not null
            THEN VAL.VAL_IMPORTE
            ELSE 0
        END AS PRECIO_TARIFA
        ,CASE
            WHEN VAL.ACT_ID is not null
            THEN TO_CHAR(VAL.VAL_FECHA_INICIO,''DD.MM.YYYY'')
            ELSE ''NULL''
        END AS FECHA_INICIO_TARIFA
        ,COALESCE(BBVA.bbva_cod_promocion,''NULL'') AS PROMOCION
        ,CASE
            WHEN EAC.DD_EAC_CODIGO in (''02'',''06'') 
            THEN ''EN CURSO''
            ELSE ''TERMINADO''
        END AS OBRA
        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
        LEFT JOIN '||V_ESQUEMA||'.VI_BBVA_SIT_COMER ON VI_BBVA_SIT_COMER.ACT_ID = ACT.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO EAC ON EAC.DD_EAC_ID = ACT.DD_EAC_ID
        JOIN '||V_ESQUEMA||'.ACT_BBVA_ACTIVOS BBVA ON BBVA.ACT_ID = ACT.ACT_ID
        JOIN '||V_ESQUEMA||'.BIE_BIEN BIEN ON BIEN.BIE_ID = ACT.BIE_ID
        JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIEL ON BIEN.BIE_ID = BIEL.BIE_ID
        JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC2 ON LOC2.DD_LOC_ID = BIEL.DD_LOC_ID
        LEFT JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID = ACT.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD ENT ON ENT.BIE_ID = BIEN.BIE_ID
        JOIN '||V_ESQUEMA||'.ACT_CAT_CATASTRO CAT ON CAT.ACT_ID = ACT.ACT_ID
        LEFT JOIN
        (
                SELECT 
                    estado_ofertas.ACT_ID, estado_ofertas.OFR_ID, estado_ofertas.DD_EOF_CODIGO, estado_ofertas.FECHACREAR, estado_ofertas.OFR_FECHA_ALTA
                FROM (
                    SELECT DISTINCT ACT2.act_id, EOF.DD_EOF_CODIGO, OFR.OFR_ID, OFR.FECHACREAR, OFR.OFR_FECHA_ALTA,
                        ROW_NUMBER() OVER (PARTITION BY ACT2.act_id ORDER BY OFR.OFR_FECHA_ALTA DESC) AS RN
                    FROM '||V_ESQUEMA||'.act_activo ACT2
                        JOIN '||V_ESQUEMA||'.ACT_OFR ACOF ON ACOF.ACT_ID = ACT2.ACT_ID
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACOF.OFR_ID AND OFR.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO = ''01''
                    union
                    SELECT DISTINCT ACT2.act_id, EOF.DD_EOF_CODIGO, OFR.OFR_ID, OFR.FECHACREAR, OFR.OFR_FECHA_ALTA,
                        ROW_NUMBER() OVER (PARTITION BY ACT2.act_id ORDER BY OFR.OFR_FECHA_ALTA DESC) AS RN
                    FROM '||V_ESQUEMA||'.act_activo ACT2
                        JOIN '||V_ESQUEMA||'.ACT_OFR ACOF ON ACOF.ACT_ID = ACT2.ACT_ID
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACOF.OFR_ID AND OFR.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO != ''01''
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.ACT_OFR ACOF2 
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR2 ON OFR2.OFR_ID = ACOF2.OFR_ID AND OFR2.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF2 ON EOF2.DD_EOF_ID = OFR2.DD_EOF_ID AND EOF2.DD_EOF_CODIGO = ''01''
                        WHERE ACOF2.ACT_ID = ACT2.ACT_ID
                    )
                ) estado_ofertas 
                WHERE estado_ofertas.RN = 1
        ) last_oferta ON last_oferta.ACT_ID = ACT.ACT_ID 
        left join '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = last_oferta.OFR_ID
        left JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID 
        left join (
            select gex.eco_id, sum(gex.gex_importe_final) sum_gex from '||V_ESQUEMA||'.gex_gastos_expediente gex where gex.gex_aprobado = 1 and gex.borrado = 0
            group by gex.eco_id
        ) eco_gex on eco_gex.eco_id = ECO.eco_id 
        left JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CCEX ON CCEX.ECO_ID = ECO.ECO_ID AND CCEX.CEX_TITULAR_CONTRATACION = 1
        left JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID = CCEX.COM_ID
        left JOIN '||V_ESQUEMA||'.DD_TPE_TIPO_PERSONA TPE ON TPE.DD_TPE_ID = COM.DD_TPE_ID
        left JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV2 ON PRV2.DD_PRV_ID = COM.DD_PRV_ID
        left JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC2 ON LOC2.DD_LOC_ID = COM.DD_LOC_ID
        JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
        JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
        LEFT JOIN '||V_ESQUEMA||'.TIB_TIPOLOGIA_INMUEBLE_BBVA TIB ON TIB.DD_TPA_ID = TPA.DD_TPA_ID AND TIB.DD_SAC_ID = SAC.DD_SAC_ID
        JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID
        JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
        JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON ACT.ACT_ID = TIT.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI ON TIT.DD_ETI_ID = ETI.DD_ETI_ID
        JOIN '||V_ESQUEMA||'.dd_eca_estado_carga_activos eca ON act.DD_ECa_ID = eca.DD_ECa_ID
        JOIN '||V_ESQUEMA||'.V_FECHA_POSESION_ACTIVO VISTA ON VISTA.ACT_ID = ACT.ACT_ID
        JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
        JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = PAC.PRO_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_OAN_ORIGEN_ANTERIOR OAN ON OAN.DD_OAN_ID = ACT.DD_OAN_ID
        LEFT JOIN 
        (
            select 
                VAL2.act_id, VAL2.VAL_IMPORTE, VAL2.VAL_FECHA_INICIO, VAL2.VAL_FECHA_FIN,
                ROW_NUMBER() OVER (PARTITION BY VAL2.act_id ORDER BY VAL2.VAL_FECHA_INICIO DESC) AS RW
            from '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL2 
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL2.DD_TPC_ID and TPC.DD_TPC_CODIGO = ''02''
            WHERE (VAL2.VAL_FECHA_FIN > sysdate OR VAL2.VAL_FECHA_FIN is null)
        )
         VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.RW = 1
    ';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_NOR_BBVA_VT1...Creada OK');
  
  EXCEPTION
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
