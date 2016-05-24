--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=HR-2198
--## PRODUCTO=SI
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
  CURSOR CRS_TAREAS_DOCG
  IS
    SELECT TAR.TAR_ID,
      TAR.PRC_ID
    FROM
      (SELECT PRC_ID,
        TAR_TAREA
      FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES
      WHERE TAR_TAREA = 'Registrar resultado para documento (Gestoría)'
      AND BORRADO     = 0
      GROUP BY PRC_ID,
        TAR_TAREA
      HAVING COUNT(*) > 1
      ) t,
    #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES TAR
  WHERE t.PRC_ID  = tar.PRC_ID
  AND t.tar_tarea = tar.tar_tarea
  ORDER BY TAR.PRC_ID,
    TAR.FECHACREAR;
  CURSOR CRS_TAREAS_DOC
  IS
    SELECT TAR.TAR_ID,
      TAR.PRC_ID
    FROM
      (SELECT PRC_ID,
        TAR_TAREA
      FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES
      WHERE TAR_TAREA = 'Registrar resultado para documento'
      AND BORRADO     = 0
      GROUP BY PRC_ID,
        TAR_TAREA
      HAVING COUNT(*) > 1
      ) t,
    #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES TAR
  WHERE t.PRC_ID  = tar.PRC_ID
  AND t.tar_tarea = tar.tar_tarea
  ORDER BY TAR.PRC_ID,
    TAR.FECHACREAR;
  idx NUMBER := 0;
  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
  FOR REG_TAREA_DOC IN CRS_TAREAS_DOC
  LOOP
    IF idx = REG_TAREA_DOC.PRC_ID THEN
      DELETE
      FROM #ESQUEMA#.TER_TAREA_EXTERNA_RECUPERACION
      WHERE TEX_ID IN
        (SELECT TEX_ID FROM #ESQUEMA#.TEX_TAREA_EXTERNA WHERE TAR_ID = REG_TAREA_DOC.TAR_ID
        );
      DELETE FROM #ESQUEMA#.TEX_TAREA_EXTERNA WHERE TAR_ID = REG_TAREA_DOC.TAR_ID;
      DELETE FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = REG_TAREA_DOC.TAR_ID;
      COMMIT;
    ELSE
      idx := REG_TAREA_DOC.PRC_ID;
    END IF;
  END LOOP;
  idx:= 0;
  FOR REG_TAREA_DOCG IN CRS_TAREAS_DOCG
  LOOP
    IF idx = REG_TAREA_DOCG.PRC_ID THEN
      DELETE
      FROM #ESQUEMA#.TER_TAREA_EXTERNA_RECUPERACION
      WHERE TEX_ID IN
        (SELECT TEX_ID FROM #ESQUEMA#.TEX_TAREA_EXTERNA WHERE TAR_ID = REG_TAREA_DOCG.TAR_ID
        );
      DELETE FROM #ESQUEMA#.TEX_TAREA_EXTERNA WHERE TAR_ID = REG_TAREA_DOCG.TAR_ID;
      DELETE FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = REG_TAREA_DOCG.TAR_ID;
      COMMIT;
    ELSE
      idx := REG_TAREA_DOCG.PRC_ID;
    END IF;
  END LOOP;
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
  	