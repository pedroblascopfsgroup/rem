--/*
--##########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20190115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Sacar los datos para montar la excel de bankia
--##           
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    
BEGIN
	
 EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_PROPUESTA_ALQ_BANKIA 
(
    "ECO_ID","NUM_ACTIVO_UVEM","ALQ_CARENCIA","DD_TPA_DESCRIPCION","TXO_TEXTO","ECO_FECHA_ALTA","APU_FECHA_INI_ALQUILER","ALQ_FIANZA_IMPORTE","ALQ_FIANZA_MESES","OFR_IMPORTE","DD_EAL_DESCRIPCION","PRO_NOMBRE",
    "TAS_FECHA_RECEPCION_TASACION","TAS_IMPORTE_TAS_FIN","BIE_LOC_POBLACION","BIE_LOC_DIRECCION","BIE_LOC_COD_POST","DD_PRV_DESCRIPCION","BIE_LOC_ESCALERA","BIE_LOC_PISO","BIE_LOC_PUERTA","BIE_LOC_NUMERO_DOMICILIO",
    "DD_TVI_DESCRIPCION","COM_NOMBRE","COM_APELLIDOS","COM_DOCUMENTOS","DD_CRA_DESCRIPCION"
) AS

SELECT
    
				ECO_ID,
				ACT_NUM_ACTIVO_UVEM,
				ALQ_CARENCIA,
				TXO_TEXTO,
				ECO_FECHA_ALTA,
				APU_FECHA_INI_ALQUILER,
                ALQ_FIANZA_IMPORTE,
				ALQ_FIANZA_MESES,
                OFR_IMPORTE,
				DD_EAL_DESCRIPCION,
				PRO_NOMBRE,  
                TAS_FECHA_RECEPCION_TASACION,
                TAS_IMPORTE_TAS_FIN, 
                DD_TPA_DESCRIPCION,  --TipoActivo--
				BIE_LOC_POBLACION , --Municipio --
                BIE_LOC_DIRECCION,  --Calle --
                BIE_LOC_COD_POST,    --Codigo postal --
                DD_PRV_DESCRIPCION,  --Provincia --
                BIE_LOC_ESCALERA,  --Escalera -- 
                BIE_LOC_PISO,      --Piso-- 
                BIE_LOC_PUERTA,   --Puerta--
                BIE_LOC_NUMERO_DOMICILIO , --Numero--
                DD_TVI_DESCRIPCION,  --Tipo via--
                DD_CRA_DESCRIPCION,
				COM_NOMBRE,
                COM_APELLIDOS, 
				COM_DOCUMENTO
    FROM (
    SELECT
                    ECO.ECO_ID,
                    ACT.ACT_NUM_ACTIVO_UVEM,
                    ALQ.ALQ_CARENCIA,
                    TXO.TXO_TEXTO,
                    ECO.ECO_FECHA_ALTA,
                    APU.APU_FECHA_INI_ALQUILER,
                    ALQ.ALQ_FIANZA_IMPORTE,
                    ALQ.ALQ_FIANZA_MESES,
                    OFR.OFR_IMPORTE,
                    EA.DD_EAL_DESCRIPCION,
                    PRO.PRO_NOMBRE,
                    TPA.DD_TPA_DESCRIPCION,     --TipoActivo--
                    TAS.TAS_FECHA_RECEPCION_TASACION, --LISTA---
                    TAS.TAS_IMPORTE_TAS_FIN,    --LISTA --
                    BIE.BIE_LOC_POBLACION , --Municipio --
                    BIE.BIE_LOC_DIRECCION,  --Calle --
                    BIE.BIE_LOC_COD_POST,    --Codigo postal --
                    APR.DD_PRV_DESCRIPCION,  --Provincia --
                    BIE.BIE_LOC_ESCALERA,  --Escalera -- 
                    BIE.BIE_LOC_PISO,      --Piso-- 
                    BIE.BIE_LOC_PUERTA,   --Puerta--
                    BIE.BIE_LOC_NUMERO_DOMICILIO , --Numero--
                    TVI.DD_TVI_DESCRIPCION,  --Tipo via--
                    CAR.DD_CRA_DESCRIPCION,  --Cartera -- 
                    COM.COM_NOMBRE,
                    COM.COM_APELLIDOS, 
                    COM.COM_DOCUMENTO,
                    ROW_NUMBER() OVER (PARTITION BY TAS.ACT_ID ORDER BY TAS.TAS_FECHA_RECEPCION_TASACION desc)RN
                    
            FROM 
				'|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO
            JOIN 
                '|| V_ESQUEMA ||'.ACT_OFR AOF ON AOF.OFR_ID = ECO.OFR_ID
            JOIN
                '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
            JOIN
                '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AOF.ACT_ID
            JOIN
                '|| V_ESQUEMA ||'.COE_CONDICIONANTES_EXPEDIENTE ALQ ON ALQ.ECO_ID = ECO.ECO_ID
            JOIN
                '|| V_ESQUEMA ||'.TXO_TEXTOS_OFERTA TXO ON TXO.OFR_ID = OFR.OFR_ID
            JOIN 
                '|| V_ESQUEMA ||'.DD_TTX_TIPOS_TEXTO_OFERTA TT ON TT.DD_TTX_ID = TXO.DD_TTX_ID  AND  TT.DD_TTX_CODIGO =''02''
            JOIN
                '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
            JOIN
                '|| V_ESQUEMA ||'. ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID
            JOIN
                '|| V_ESQUEMA ||'.DD_EAL_ESTADO_ALQUILER EA ON EA.DD_EAL_ID = PTA.DD_EAL_ID
            JOIN 
                '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PAC ON ACT_PAC.ACT_ID = ACT.ACT_ID
            JOIN
                '|| V_ESQUEMA ||'. ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PAC.PRO_ID
            JOIN 
                '|| V_ESQUEMA ||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.ECO_ID = ECO.ECO_ID
            JOIN 
                '|| V_ESQUEMA ||'.COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID
            JOIN
                '|| V_ESQUEMA ||'.BIE_BIEN BIEN ON BIEN.BIE_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO_UVEM
            JOIN 
                '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE ON BIE.BIE_ID = BIEN.BIE_ID
            JOIN 
                '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA APR ON APR.DD_PRV_ID =  BIE.DD_PRV_ID
             JOIN
                '|| V_ESQUEMA_M ||'.DD_TVI_TIPO_VIA TVI ON TVI.DD_TVI_ID = BIE.DD_TVI_ID 
            JOIN
                '|| V_ESQUEMA ||'.ACT_TAS_TASACION TAS ON TAS.ACT_ID = ACT.ACT_ID
            JOIN
                '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
            JOIN 
                '|| V_ESQUEMA ||'.DD_CRA_CARTERA CAR ON CAR.DD_CRA_ID = ACT.DD_CRA_ID
           )AUX
       WHERE AUX.RN = 1';
			
		DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PROPUESTA_ALQ_BANKIA...Creada OK');	       

END;


/
EXIT;