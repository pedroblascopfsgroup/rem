--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200421
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7073
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación tarifas
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge ACT_TCT_TRABAJO_CFGTARIFA.TCT_PRECIO_UNITARIO. Carga masiva.');

    
    execute immediate '
	MERGE INTO '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA TCT USING(
	SELECT TCT.TCT_ID, CFT.CFT_PRECIO_UNITARIO 
	FROM '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA TCT
	JOIN '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT ON CFT.CFT_ID = TCT.CFT_ID
	WHERE TCT.USUARIOCREAR = ''MIG_DIVARIAN'' AND TCT.TCT_PRECIO_UNITARIO = 0
	) AUX ON (AUX.TCT_ID = TCT.TCT_ID)
	WHEN MATCHED THEN UPDATE SET
	TCT.TCT_PRECIO_UNITARIO = AUX.CFT_PRECIO_UNITARIO,
	VERSION = 0,
	USUARIOMODIFICAR = ''REMVIP-7073'',
	FECHAMODIFICAR = SYSDATE
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
