--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220509
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11613
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica datos interlocutores
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-11613'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

--CLC
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL T1
                USING (
SELECT DISTINCT clc.clc_id,clc.clc_id_persona_haya_caixa,clc.clc_documento,
CLC.DD_TPE_ID,
CASE WHEN CLC.DD_TPE_ID = 1
THEN AUX.NOMBRE
WHEN CLC.DD_TPE_ID = 2
THEN CLC.CLC_NOMBRE
END AS NOMBRE,

CASE WHEN CLC.DD_TPE_ID = 1
THEN AUX.APELLIDOS
WHEN CLC.DD_TPE_ID = 2
THEN clc.clc_apellidos
END AS APELLIDO,

CASE WHEN CLC.DD_TPE_ID = 1
THEN CLC.CLC_RAZON_SOCIAL
WHEN CLC.DD_TPE_ID = 2
THEN AUX.NOMBRE_JURIDICA
END AS RAZON_SOCIAL,

TO_DATE(aux.fecha_nacimiento,''DD/MM/YYYY'') AS FECHA_NACIMIENTO_AUXILIAR, 
clc.clc_fecha_nacimiento,
pai.dd_pai_id
FROM '||V_ESQUEMA||'.AUX_REMVIP_11613 AUX
JOIN '||V_ESQUEMA||'.AUX_REMVIP_11613_2 AUX2 ON AUX2.ID_CLIENTE_HAYA=AUX.ID_CLIENTE_HAYA
JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC ON clc.clc_id_persona_haya_caixa = AUX.ID_CLIENTE_HAYA AND CLC.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_PAI_PAISES PAI ON pai.dd_pai_cod_iso=aux.pais_orig AND PAI.BORRADO = 0
WHERE ((clc.clc_fecha_nacimiento IS NULL AND AUX.FECHA_NACIMIENTO IS NOT NULL) OR TRUNC(clc.clc_fecha_nacimiento)!=TRUNC(TO_DATE(aux.fecha_nacimiento,''DD/MM/YYYY'')))
OR (clc.dd_tpe_id = 1 AND (CLC.CLC_NOMBRE IS NULL OR UPPER(CLC.CLC_NOMBRE)!=UPPER(aux.nombre)))
OR (CLC.DD_TPE_ID = 1 AND (clc.clc_apellidos IS NULL OR UPPER(CLC.CLC_APELLIDOS)!=UPPER(aux.apellidos)))
OR (CLC.DD_TPE_ID = 2 AND (clc.clc_razon_social IS NULL OR UPPER(clc.clc_razon_social)!=UPPER(aux.nombre_juridica)))
OR (clc.dd_pai_id IS NULL OR CLC.DD_PAI_ID!=pai.dd_pai_id)

                ) T2
                ON (T1.CLC_ID = T2.CLC_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.DD_PAI_ID = T2.DD_PAI_ID,
                    T1.CLC_NOMBRE = T2.NOMBRE,
                    T1.CLC_APELLIDOS = T2.APELLIDO,
                    T1.CLC_RAZON_SOCIAL = T2.RAZON_SOCIAL,
                    T1.CLC_FECHA_NACIMIENTO = T2.FECHA_NACIMIENTO_AUXILIAR,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USU||'''	 		
    ';
		
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS EN CLC_CLIENTE_COMERCIAL '|| SQL%ROWCOUNT ||'  ');

    --COM_COMPRADOR

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.COM_COMPRADOR T1
                USING (
SELECT DISTINCT COM.COM_ID,COM.COM_ID_PERSONA_HAYA_CAIXA,com.com_documento,
COM.DD_TPE_ID,

TO_DATE(aux.fecha_nacimiento,''DD/MM/YYYY'') AS FECHA_NAC_AUX, 
COM.COM_FECHA_NACIMIENTO,
pai.dd_pai_id
FROM '||V_ESQUEMA||'.AUX_REMVIP_11613 AUX
JOIN '||V_ESQUEMA||'.AUX_REMVIP_11613_2 AUX2 ON AUX2.ID_CLIENTE_HAYA=AUX.ID_CLIENTE_HAYA
JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID_PERSONA_HAYA_CAIXA = AUX.ID_CLIENTE_HAYA AND COM.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_PAI_PAISES PAI ON pai.dd_pai_cod_iso=aux.pais_orig AND PAI.BORRADO = 0

                ) T2
                ON (T1.COM_ID = T2.COM_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.COM_FECHA_NACIMIENTO = T2.FECHA_NAC_AUX,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USU||'''	 		
    ';
		
	EXECUTE IMMEDIATE V_MSQL; 

DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS EN COM_COMPRADOR '|| SQL%ROWCOUNT ||'  ');

--IOC
V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.IOC_INTERLOCUTOR_PBC_CAIXA T1
                USING (
SELECT DISTINCT IOC.IOC_ID,IOC.IOC_ID_PERSONA_HAYA_CAIXA,IOC.IOC_DOC_IDENTIFICATIVO,
aux.tpic,
IOC.IOC_PERSONA_FISICA,
ioc.ioc_nombre,

ioc.ioc_apellidos,
aux.nombre AS AUX_NOMBRE,
aux.apellidos AS AUX_APELLIDOS,
TO_DATE(aux.fecha_nacimiento,''DD/MM/YYYY'') AS FECHA_NAC_AUX, 
IOC.IAP_FECHA_NACIMIENTO,
IOC.DD_PAI_ID AS PAIS_IOC,
pai.dd_pai_id
FROM '||V_ESQUEMA||'.AUX_REMVIP_11613 AUX
JOIN '||V_ESQUEMA||'.AUX_REMVIP_11613_2 AUX2 ON AUX2.ID_CLIENTE_HAYA=AUX.ID_CLIENTE_HAYA
JOIN '||V_ESQUEMA||'.ioc_interlocutor_pbc_caixa IOC ON IOC.IOC_ID_PERSONA_HAYA_CAIXA = AUX.ID_CLIENTE_HAYA AND IOC.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_PAI_PAISES PAI ON pai.dd_pai_cod_iso=aux.pais_orig AND PAI.BORRADO = 0
WHERE ((IOC.IAP_FECHA_NACIMIENTO IS NULL AND AUX.FECHA_NACIMIENTO IS NOT NULL) OR (TRUNC(IOC.IAP_FECHA_NACIMIENTO)!=TRUNC(TO_DATE(aux.fecha_nacimiento,''DD/MM/YYYY''))))
OR (IOC.IOC_PERSONA_FISICA = 1 AND (ioc.ioc_nombre IS NULL OR UPPER(IOC.ioc_nombre)!=UPPER(aux.nombre)))
OR (IOC.IOC_PERSONA_FISICA = 1 AND (ioc.ioc_apellidos IS NULL OR UPPER(IOC.ioc_apellidos)!=UPPER(aux.apellidos)))
OR (IOC.IOC_PERSONA_FISICA = 0 AND (ioc.ioc_nombre IS NULL OR UPPER(ioc.ioc_nombre)!=UPPER(aux.nombre_juridica)))
OR (IOC.DD_PAI_ID IS NULL OR IOC.DD_PAI_ID!=pai.dd_pai_id)

                ) T2
                ON (T1.IOC_ID = T2.IOC_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.IOC_NOMBRE = T2.AUX_NOMBRE,
                    T1.IOC_APELLIDOS = T2.AUX_APELLIDOS,
                    T1.DD_PAI_ID = T2.DD_PAI_ID,
                    T1.IAP_FECHA_NACIMIENTO = T2.FECHA_NAC_AUX,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USU||'''	 		
    ';
		
	EXECUTE IMMEDIATE V_MSQL; 

DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS EN IOC_INTERLOCUTOR_PBC_CAIXA '|| SQL%ROWCOUNT ||'  ');

--IAP
V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.iap_info_adc_persona T1
                USING (
SELECT DISTINCT IAP.IAP_ID,

IAP.DD_PAI_ID,
pai.dd_pai_id AS PAI_NAC_AUX
FROM '||V_ESQUEMA||'.AUX_REMVIP_11613 AUX
JOIN '||V_ESQUEMA||'.AUX_REMVIP_11613_2 AUX2 ON AUX2.ID_CLIENTE_HAYA=AUX.ID_CLIENTE_HAYA
JOIN '||V_ESQUEMA||'.iap_info_adc_persona IAP ON IAP.IAP_ID_PERSONA_HAYA_CAIXA = AUX.ID_CLIENTE_HAYA AND IAP.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_PAI_PAISES PAI ON pai.dd_pai_cod_iso=aux.nacionalidad AND PAI.BORRADO = 0
WHERE (IAP.DD_PAI_ID IS NULL AND PAI.DD_PAI_ID IS NOT NULL OR (IAP.DD_PAI_ID IS NOT NULL AND IAP.DD_PAI_ID!=PAI.DD_PAI_ID ))
                ) T2
                ON (T1.IAP_ID = T2.IAP_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.DD_PAI_ID = T2.PAI_NAC_AUX,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USU||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS EN IAP_INFO_ADC_PERSONA '|| SQL%ROWCOUNT ||'  ');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT