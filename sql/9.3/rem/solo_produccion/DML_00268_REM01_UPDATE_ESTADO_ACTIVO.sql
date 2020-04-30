--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200422
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7105
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación alquileres
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge ACT_ACTIVO.DD_EAC_ID. Carga masiva.');

    
    execute immediate '
	MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING(
	SELECT ACT.ACT_ID FROM ACT_ACTIVO ACT
	JOIN '||V_ESQUEMA||'.AUX_REMVIP_7105 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO 
	WHERE ACT.USUARIOCREAR = ''MIG_DIVARIAN'') AUX ON (ACT.ACT_ID = AUX.ACT_ID)
	WHEN MATCHED THEN UPDATE SET
	ACT.DD_EAC_ID = (SELECT DD_EAC_ID FROM DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''04''),
	ACT.USUARIOMODIFICAR = ''REMVIP-7105'',
	ACT.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. (Deberian de ser 12.180)');


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
