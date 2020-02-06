--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200121
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6227
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6227';
   V_SQL VARCHAR2(4000 CHAR);	
  
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');


	V_SQL := ' 
			UPDATE REM01.ACT_GES_DIST_GESTORES
			SET BORRADO = 1,
			    USUARIOBORRAR = ''REMVIP-6227'',
			    FECHABORRAR = SYSDATE
			WHERE 1 = 1
			AND USUARIOCREAR = ''HREOS-7578''
			AND TRUNC( FECHACREAR ) = TO_DATE( ''13/12/2019'', ''DD/MM/YYYY'' )

	      ';
	
	EXECUTE IMMEDIATE V_SQL;


	DBMS_OUTPUT.PUT_LINE('[INFO] Registros borrados = '||SQL%ROWCOUNT||' ');  

-----------------------------------------------------------------------------------------------------------------

    
   COMMIT;

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
