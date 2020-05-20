--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200430
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7155
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. Estados de ofertas gencat Divarian
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	PL_OUTPUT VARCHAR2(32000 CHAR);

	V_COUNT NUMBER(25);
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar las tablas act_cmg_comunicacion_gencat y ofr_ofertas en funcion a AUX_NO_EJERCE_REMVIP_7155.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Activos sobre los que se ha comunicado pero no se ha sancionado aun.');

	--Las ofertas (Activos) sobre los que se ha comunicado pero no hay respuesta (256):
	--A éstos, le metemos, estado de comunicación COMUNICADO y estado de sanción NULO
	--Además, borramos las ofertas gencat, y congelamos las ofertas "normales"
	execute immediate 'MERGE INTO act_cmg_comunicacion_gencat T1 USING (
	    SELECT 
	    distinct ofr.ofr_id, ACT.ACT_ID
	    FROM ACT_ACTIVO ACT 
	    INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	    INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	    INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
	    where ofr.ofr_id not in (
	        SELECT 
	        distinct ofr.ofr_id
	        FROM AUX_NO_EJERCE_REMVIP_7155 AUX
	        INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
	        INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	        INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	        INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA--OFERTASGENCAT
	    )
	) T2
	ON (T1.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN UPDATE SET
	T1.DD_SAN_ID = NULL,
	T1.DD_ECG_ID = (SELECT DD_ECG_ID FROM dd_ecg_estado_com_gencat WHERE DD_ECG_CODIGO = ''COMUNICADO''),
	T1.USUARIOMODIFICAR = ''REMVIP-7155'',
	T1.FECHAMODIFICAR = SYSDATE 
	';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en act_cmg_comunicacion_gencat. Deberian ser 256.');  

	COMMIT;

	execute immediate 'MERGE INTO ofr_ofertas T1 USING (
	    SELECT 
	    distinct ofr.ofr_id, ACT.ACT_ID
	    FROM ACT_ACTIVO ACT 
	    INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	    INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	    INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
	    where ofr.ofr_id not in (
	        SELECT 
	        distinct ofr.ofr_id
	        FROM AUX_NO_EJERCE_REMVIP_7155 AUX
	        INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
	        INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	        INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	        INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA--OFERTASGENCAT
	    )
	) T2
	ON (T1.ofr_id = T2.ofr_id)
	WHEN MATCHED THEN UPDATE SET
	T1.BORRADO = 1,
	T1.USUARIOBORRAR = ''REMVIP-7155'',
	T1.FECHABORRAR = SYSDATE 
	';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ofr_ofertas (Se borran las ofertas gencat). Deberian ser 256.');  

	COMMIT;

	execute immediate 'MERGE INTO ofr_ofertas T1 USING (
	    SELECT 
	    distinct ofr.ofr_id, ACT.ACT_ID
	    FROM ACT_ACTIVO ACT 
	    INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	    INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	    INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
	    where ofr.ofr_id not in (
	        SELECT 
	        distinct ofr.ofr_id
	        FROM AUX_NO_EJERCE_REMVIP_7155 AUX
	        INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
	        INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	        INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	        INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFR_ANT = OFR.OFR_NUM_OFERTA--OFERTASBUENAS
	    )
	) T2
	ON (T1.ofr_id = T2.ofr_id)
	WHEN MATCHED THEN UPDATE SET
	T1.dd_eof_id = (SELECT dd_eof_id FROM dd_eof_estados_oferta WHERE dd_eof_codigo = ''03''),--congelada
	T1.USUARIOMODIFICAR = ''REMVIP-7155'',
	T1.FECHAMODIFICAR = SYSDATE 
	';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ofr_ofertas (Se congelan las ofertas NO gencat). Deberian ser 256.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Activos sobre los que se ha sancionado y NO EJERCEN.');


	--Las ofertas (Activos) sobre los que se han dicho que NO ejercen (90):
	--A éstos, le metemos, estado de comunicación SANCIONADO y estado de sanción NO EJERCE
	--Además, borramos las ofertas gencat. (Las ofertas normales las dejamos estar)
	execute immediate 'MERGE INTO act_cmg_comunicacion_gencat T1 USING (
	    SELECT 
	    distinct ofr.ofr_id, ACT.ACT_ID
	    FROM AUX_NO_EJERCE_REMVIP_7155 AUX
	    INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
	    INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	    INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	    INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA--OFERTASGENCAT
	) T2
	ON (T1.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN UPDATE SET
	T1.DD_SAN_ID = (SELECT DD_SAN_ID FROM dd_san_sancion WHERE DD_SAN_CODIGO = ''NO_EJERCE''),
	T1.DD_ECG_ID = (SELECT DD_ECG_ID FROM dd_ecg_estado_com_gencat WHERE DD_ECG_CODIGO = ''SANCIONADO''),
	T1.USUARIOMODIFICAR = ''REMVIP-7155'',
	T1.FECHAMODIFICAR = SYSDATE 
	';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en act_cmg_comunicacion_gencat. Deberian ser 90.');  

	COMMIT;

	execute immediate 'MERGE INTO ofr_ofertas T1 USING (
	    SELECT 
	    distinct ofr.ofr_id, ACT.ACT_ID
	    FROM AUX_NO_EJERCE_REMVIP_7155 AUX
	    INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
	    INNER JOIN ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
	    INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
	    INNER JOIN MIG_OFG_OFERTAS_GENCAT OFG ON OFG.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA--OFERTASGENCAT
	) T2
	ON (T1.ofr_id = T2.ofr_id)
	WHEN MATCHED THEN UPDATE SET
	T1.BORRADO = 1,
	T1.USUARIOBORRAR = 'REMVIP-7155',
	T1.FECHABORRAR = SYSDATE 
	';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ofr_ofertas (Se borran las ofertas gencat). Deberian ser 90.');  

	COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
