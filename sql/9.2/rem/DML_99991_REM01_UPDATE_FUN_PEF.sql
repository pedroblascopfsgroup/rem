--/*
--##########################################
--## AUTOR=Sergio Giménez
--## FECHA_CREACION=20190618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.0
--## INCIDENCIA_LINK=HREOS-6703
--## PRODUCTO=NO
--##
--## Finalidad: Script que updatea la tabla FUN_FUNCIONES para evitar funciones de recovery
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'FUN_FUNCIONES'; -- Configuracion FUN_FUNCIONES
    V_TABLA2 VARCHAR2(25 CHAR):= 'FUN_PEF'; -- Configuracion FUN_FUNCIONES
    V_MSQL VARCHAR2(4000 CHAR);

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_USUARIO VARCHAR2(20) := 'HREOS-6703';

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.'||V_TABLA||'... Empezando a actualizar datos en la tabla.');

    V_MSQL :='UPDATE '||V_ESQUEMA_M||'.'||V_TABLA||' FUNCIONES
      			SET FUNCIONES.BORRADO=1
      			, FUNCIONES.USUARIOBORRAR='''||V_USUARIO||'''
      			, FUNCIONES.FECHABORRAR=SYSDATE
      			WHERE FUNCIONES.FUN_ID IN (
                    SELECT FUN.FUN_ID
                    FROM '||V_ESQUEMA_M||'.'||V_TABLA||' FUN
                    FULL OUTER JOIN '||V_ESQUEMA||'.'||V_TABLA2||' FUNPEF ON FUN.FUN_ID = FUNPEF.FUN_ID
                    WHERE FUNPEF.FUN_ID IS NULL
                )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - FUN_FUNCIONES Actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
