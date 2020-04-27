--/*
--######################################### 
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200424
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9991
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado lógico de adjuntos anteriores al 28 de Enero de 2020
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico de adjuntos anteriores al 28 de Enero de 2020');

    
    execute immediate '
	UPDATE '||V_ESQUEMA||'.ACT_APR_ADJUNTO_PROVEEDOR ACT_APR
	SET 
	ACT_APR.BORRADO = 1
	, ACT_APR.USUARIOBORRAR = ''HREOS-9991''
	, ACT_APR.FECHABORRAR = SYSDATE
	WHERE EXISTS (
		SELECT
		1
		FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		INNER JOIN '||V_ESQUEMA||'.ACT_APR_ADJUNTO_PROVEEDOR APR ON APR.PVE_ID = PVE.PVE_ID
		INNER JOIN '||V_ESQUEMA||'.DD_TDP_TIPO_DOC_PROVEEDOR TDP ON TDP.DD_TDP_ID = APR.DD_TDP_ID
		INNER JOIN '||V_ESQUEMA||'.ADJ_ADJUNTOS ADJ ON ADJ.ADJ_ID = APR.ADJ_ID
		WHERE PVE.BORRADO=0
		AND APR.BORRADO = 0
		AND APR.APR_FECHA_DOCUMENTO < TO_DATE(''28/01/2020'',''dd/mm/yyyy'')
		AND APR.APR_ID = ACT_APR.APR_ID
	)
	
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');


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
