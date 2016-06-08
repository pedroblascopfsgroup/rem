--/*
--##########################################
--## AUTOR=JAIME SÁNCHEZ-CUENCA
--## FECHA_CREACION=20160608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= PRODUCTO-1851
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar a la fecha de la implantación la Fecha de Avaluo de los Asuntos que la tiene a null.
--##                   
--##       
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO VARCHAR(50) := 'PRODUCTO-1851';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION FECHA AVALUO');

    --** TEV_VALOR
    ----------------
    v_sql := 'MERGE INTO '||v_esquema||'.TEV_TAREA_EXTERNA_VALOR TEV2 USING(
			SELECT DISTINCT TEV.TEV_ID, TO_DATE(''2016-04-16'',''YYYY-MM-DD'') TEV_FECHA
			FROM '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR,
				'||v_esquema||'.TEX_TAREA_EXTERNA TEX,
				'||v_esquema||'.TEV_TAREA_EXTERNA_VALOR TEV,
				'||v_esquema||'.ASU_ASUNTOS ASU
			WHERE TAR.TAR_TAREA = ''Obtención avalúo''
			AND TAR.TAR_ID = TEX.TAR_ID
			AND TEX.TEX_ID = TEV.TEX_ID
			AND TEV.TEV_NOMBRE = ''fecha''
			AND TEV.TEV_VALOR IS NULL
			AND TAR.ASU_ID = ASU.ASU_ID
			AND EXISTS(SELECT 1
				   FROM '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR2
				   WHERE TAR2.ASU_ID = ASU.ASU_ID
				   AND TAR2.TAR_TAREA = ''Estudiar conformidad o alegación''
				   and tar2.tar_fecha_fin is null)
			    )AUX
 	      ON (TEV2.TEV_ID = AUX.TEV_ID)
	      WHEN MATCHED THEN UPDATE SET TEV2.TEV_VALOR = AUX.TEV_FECHA,
					   TEV2.USUARIOMODIFICAR = '''||USUARIO||''',
					   TEV2.FECHAMODIFICAR = SYSDATE';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.TEV_TAREA_EXTERNA_VALOR ACTUALIZADA. '||SQL%ROWCOUNT||' Filas');
    Commit;


DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZACION FECHA AVALUO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;
