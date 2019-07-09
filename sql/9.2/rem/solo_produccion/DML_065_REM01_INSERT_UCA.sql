--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4752
--## PRODUCTO=NO
--##
--## Finalidad: Subcarterizar usuarios para Apple
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-4752';

 BEGIN

   	  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.uca_usuario_cartera (
					select 
						'||V_ESQUEMA||'.S_uca_usuario_cartera.NEXTVAL
					,   usu_id
					,   (select dd_cra_id from '||V_ESQUEMA||'.dd_cra_cartera where dd_cra_codigo = ''07'')
					,   (select dd_scr_id from '||V_ESQUEMA||'.dd_scr_subcartera where dd_scr_codigo = ''138'') 
					from REMMASTER.usu_usuarios 
					where usu_username in (''ogf.gherrero'',''ogf.isardinero'',''46859715K''
											,''3943365C'',''ogf.oruiz'',''ogf.sdelgado'')
					)';
					
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' registros ');

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
