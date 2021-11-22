--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - AUTOR=Vicnete Martinez Cifre
--##		0.2 Cambio en estado de conservación
--##		0.3 GUILLEM REY - traducir descripciones diccionario
--##		0.4 Carles Molins - campo idSantander
--##        0.5 Se añade un LEFT JOIN al cruce con la DD_SAC - Daniel Algaba - 20211018 - HREOS-15634
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    
    seq_count number(3); 						-- Vble. para validar la existencia de las Secuencias.
    table_count number(3); 						-- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); 					-- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); 				-- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; 							-- N?mero de errores
    err_msg VARCHAR2(2048); 					-- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 	-- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_REPORT_AN...');
  V_MSQL := 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.V_REPORT_AN
	AS
		WITH NUM_OFERTAS AS
        (
            SELECT COUNT(1) AS NUM_OFERTAS_ACT, AOFR2.ACT_ID
            FROM '||V_ESQUEMA||'.ACT_OFR AOFR2
            GROUP BY AOFR2.ACT_ID
        ),
        NUM_VISITAS AS (
            SELECT COUNT(1) AS NUM_VISITAS_ACT, VIS.ACT_ID
            FROM '||V_ESQUEMA||'.VIS_VISITAS VIS
            GROUP BY VIS.ACT_ID
        )
        SELECT ACT.ACT_ID||OFR.OFR_ID AS ID_VISTA, SYSDATE AS FECHA_EMISION, OFR.OFR_NUM_OFERTA, ACT.ACT_NUM_ACTIVO, ACT.ACT_NUM_ACTIVO_SAN, SAC.DD_SAC_DESCRIPCION_TRADUCIDA, LOC.BIE_LOC_DIRECCION, DDLOC.DD_LOC_DESCRIPCION
        , PRV.DD_PRV_DESCRIPCION, REG.BIE_DREG_SUPERFICIE_CONSTRUIDA, VPV.VAL_IMPORTE, AOFR.ACT_OFR_IMPORTE,
        CASE WHEN EPV.DD_EPV_CODIGO = ''03'' THEN ''Yes''
             WHEN EPA.DD_EPA_CODIGO = ''03'' THEN ''Yes''
             ELSE ''No''
             END AS PUBLICADO
        , PVE.PVE_NOMBRE_COMERCIAL, ICO.ICO_ANO_CONSTRUCCION, ALO.LOC_LATITUD, ALO.LOC_LONGITUD, 
        CASE WHEN SPS.SPS_OCUPADO = 1 THEN ''Yes''
             ELSE ''No''
        END AS OCUPADO,
        CASE WHEN REG.DD_EON_ID IS NOT NULL THEN ''Yes''
             ELSE ''No''
        END AS SEGUNDA_MANO
        , ECV.DD_ECV_DESCRIPCION_TRADUCIDA, AUX1.NUM_OFERTAS_ACT, NVL(AUX2.NUM_VISITAS_ACT, 0) AS NUM_VISITAS_ACT, EAL.DD_EAL_DESCRIPCION, TAL.DD_TAL_DESCRIPCION
        FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
        JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON OFR.OFR_ID = AOFR.OFR_ID
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AOFR.ACT_ID = ACT.ACT_ID
        JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON ACT.DD_TPA_ID = TPA.DD_TPA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
        JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION LOC ON ACT.BIE_ID = LOC.BIE_ID
        JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD DDLOC ON LOC.DD_LOC_ID = DDLOC.DD_LOC_ID
        JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID = PRV.DD_PRV_ID
        JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES REG ON ACT.BIE_ID = REG.BIE_ID
        LEFT JOIN '||V_ESQUEMA||'.V_PRECIOS_VIGENTES VPV ON ACT.ACT_ID = VPV.ACT_ID AND VPV.DD_TPC_CODIGO = ''02'' AND VPV.VAL_FECHA_FIN IS NULL
        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
        JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON APU.DD_EPV_ID = EPV.DD_EPV_ID
        JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID
        JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON OFR.PVE_ID_PRESCRIPTOR = PVE.PVE_ID
        JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID
        JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION ALO ON ACT.ACT_ID = ALO.ACT_ID
        JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID = SPS.ACT_ID
        JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON ACT.ACT_ID = REG.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION ECV ON ICO.DD_ECV_ID = ECV.DD_ECV_ID
        LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER EAL ON PTA.DD_EAL_ID = EAL.DD_EAL_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER TAL ON ACT.DD_TAL_ID = TAL.DD_TAL_ID
        JOIN NUM_OFERTAS AUX1 ON ACT.ACT_ID = AUX1.ACT_ID
        LEFT JOIN NUM_VISITAS AUX2 ON ACT.ACT_ID = AUX2.ACT_ID';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_REPORT_AN...Creada OK');
  
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
