--/*
--##########################################
--## AUTOR=JESSICA MARIA SAMPERE CALATAYUD 
--## FECHA_CREACION=20180112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3.03
--## INCIDENCIA_LINK=RENIVDOS-2558
--## PRODUCTO=NO
--##
--## Finalidad: Corregir usuarios gestorias para que sean de grupo
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET TIMING ON
SET LINESIZE 2000
SET VERIFY OFF
SET TIMING ON
SET FEEDBACK ON


DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	UPD_USU_GRUPO VARCHAR2 (32000) := q'[UPDATE #ESQUEMA_MASTER#.USU_USUARIOS SET USU_GRUPO = 1 
										WHERE USU_APELLIDO1 in( 'Admisión', 'Administración', 'Formalización', 'Cédulas Habitabilidad')
										AND USU_GRUPO = 0]';

BEGIN

	EXECUTE IMMEDIATE UPD_USU_GRUPO;
	DBMS_OUTPUT.PUT_LINE('[OK] Usuarios de grupo actualizados');

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