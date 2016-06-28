--/*
--##########################################
--## AUTOR=RUBEN ROVIRA NIETO
--## FECHA_CREACION=20160623
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=RECOVERY-431
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado logico de procedimientos repetidos sin tareas
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        1.0 version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   

BEGIN

	V_MSQL := 'update '||V_ESQUEMA||'.prc_procedimientos set borrado=1, usuarioborrar=''RECOVERY-431'' where prc_id in (
	SELECT prc.prc_id FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc left join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.prc_id=prc.prc_id where prc.dd_tpo_id=2748 and tar.tar_id is null and prc.asu_id in  
	(SELECT prc.asu_id FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.prc_id=prc.prc_id where prc.dd_tpo_id=2748))';
			 
   EXECUTE IMMEDIATE V_MSQL;
   
   COMMIT;   
                                   
EXCEPTION

WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/

EXIT;

