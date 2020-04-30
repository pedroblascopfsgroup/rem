--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200424
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7065
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. ACT_EDI_EDIFICIO.EDI_ENTORNO_COMUNICACION Carga masiva
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar ACT_EDI_EDIFICIO > Entorno comunicacion desde AUX_EDI_ENTORNO_COMUNICACION_REMVIP_7065.');

	execute immediate 'MERGE INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO T1 USING (
	    SELECT DISTINCT
	    EDI.EDI_ID, AUX.ENTORNO_COMUNICACION EDI_ENTORNO_COMUNICACION
	    FROM '||V_ESQUEMA||'.AUX_EDI_ENTORNO_COMUNICACION_REMVIP_7065 AUX
	    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO 
	    INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID 
	    INNER JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID
	) T2
	ON (T1.EDI_ID = T2.EDI_ID)
	WHEN MATCHED THEN UPDATE SET
	T1.EDI_ENTORNO_COMUNICACION = T2.EDI_ENTORNO_COMUNICACION,
	T1.USUARIOMODIFICAR = ''REMVIP-7065'',
	T1.FECHAMODIFICAR = SYSDATE';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_EDI_EDIFICIO. Deberian ser 1.551 ');  

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
