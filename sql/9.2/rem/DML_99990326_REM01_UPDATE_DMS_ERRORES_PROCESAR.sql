--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20180314
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-
--## PRODUCTO=NO
--##
--## Finalidad: Inicializar la columna DMS_ERRORES_PROCESAR de los documentos ya creados
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-';

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO]');

   V_MSQL := 'UPDATE '||V_ESQUEMA||'.DMS_DOCUMENTOS_MASIVO
   		SET DMS_ERRORES_PROCESAR = ''0'', 
		USUARIOMODIFICAR= ''REMVIP-'',
		FECHAMODIFICAR= SYSDATE
		WHERE DMS_ERRORES_PROCESAR is null';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas de la tabla de DMS_DOCUMENTOS_MASIVO');

   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.PUT_LINE(ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT;