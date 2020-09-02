--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=REMVIP-7935
--## PRODUCTO=NO
--## Finalidad: Vista que devuelve las tareas paralizadas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Juan Bautista Alfonso - - REMVIP-7935 - Modificado fecha posesion para que cargue de la vista V_FECHA_POSESION_ACTIVO
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_TAREAS_PARALIZADAS_ADMISION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_TAREAS_PARALIZADAS_ADMISION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_TAREAS_PARALIZADAS_ADMISION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_TAREAS_PARALIZADAS_ADMISION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_TAREAS_PARALIZADAS_ADMISION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_TAREAS_PARALIZADAS_ADMISION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_TAREAS_PARALIZADAS_ADMISION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_TAREAS_PARALIZADAS_ADMISION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_TAREAS_PARALIZADAS_ADMISION...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_TAREAS_PARALIZADAS_ADMISION 
	AS
		SELECT
			TAR.TAR_ID,
			TEX.TEX_ID,
			TAC.ACT_ID
		FROM ' || V_ESQUEMA || '.ACT_SPS_SIT_POSESORIA POS
		INNER JOIN ' || V_ESQUEMA || '.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID = POS.ACT_ID
		INNER JOIN ' || V_ESQUEMA || '.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID and tar.borrado = 0
		INNER JOIN ' || V_ESQUEMA || '.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
		INNER JOIN ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
		INNER JOIN ' || V_ESQUEMA || '.V_FECHA_POSESION_ACTIVO FPA ON FPA.ACT_ID = POS.ACT_ID
		WHERE TAP.TAP_CODIGO IN (''T001_CheckingDocumentacionAdmision'', ''T001_CheckingDocumentacionGestion'')
		AND TAR.TAR_FECHA_FIN IS NULL
      	AND TAR.TAR_TAREA_FINALIZADA = 0
      	AND TEX.TEX_DETENIDA = 1
      	AND FPA.FECHA_POSESION IS NOT NULL
        ';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_TAREAS_PARALIZADAS_ADMISION...Creada OK');
  
  EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;   
          
END;
/

EXIT;