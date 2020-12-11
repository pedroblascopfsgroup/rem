--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8290
--## PRODUCTO=NO
--## 
--## Finalidad:
--##                    
--## INSTRUCCIONES:  REPOSICIONAR TRABAJOS
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 char);
    
    V_USUARIO VARCHAR(50 CHAR):= 'REMVIP-8290';

BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

	#ESQUEMA#.REPOSICIONAMIENTO_TRABAJO(''||V_USUARIO||'', 
	TRIM('902457100001,
		902792700001,
		910903100001,
		910903100002,
		915218100001,
		915341900001,
		915341900002,
		915382900001,
		915955100001,
		915955100002,
		915955500001,
		915955500002,
		915955600001,
		915955600002,
		915955800001,
		915955800002,
		915955900001,
		915955900002,
		916190400001,
		916190400002,
		916474100001,
		916474600001,
		916474700001,
		916476900001,
		916481100001,
		916481300001,
		916481600001,
		916481700001,
		916481800001,
		916482300001,
		916482500001,
		916482600001,
		916558200001,
		916598300001,
		916598300002,
		916667900001,
		916668400001'), 
		
		'T006_ValidacionInforme');
        
    #ESQUEMA#.ALTA_BPM_INSTANCES(''||V_USUARIO||'', PL_OUTPUT);
    
	COMMIT;

 	DBMS_OUTPUT.put_line('[OK]');

 	DBMS_OUTPUT.put_line('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
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