--/*
--#########################################
--## AUTOR=Ivan Rubio Frechina
--## FECHA_CREACION=20200313
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8135
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
  V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-7995';

 
BEGIN

	#ESQUEMA#.tramite_a_ultima_version('T017');  
   
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