--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170816
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

-- Parámetros de entrada --------------------------------------------------------------------------------------------------
-- p_gasto_id, 		id del gasto a actualizar (si viene a null, los actualizará todos)
-- ------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_UPDATE_AVG_DIF_IMPORTE (
   p_gpv_id       	IN #ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE
)
AS

	-- Declaración de variables

	-- Usuario para INSERTS y UPDATES
	V_USUARIO  VARCHAR2(100 CHAR) := 'SP_UPDATE_AVG_DIF_IMPORTE';

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  

    V_SQL_ADITIONAL_WHERE VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    IF (p_gpv_id IS NULL) THEN 
        V_SQL_ADITIONAL_WHERE:='';
        DBMS_OUTPUT.PUT_LINE('[INFO] EL ID DEL GASTO NO PUEDE SER NULO');
        RETURN;
    ELSE

        -- Si se pasa un gasto por parametro lo buscamos para asgurarnos de que se encuentre
        V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR WHERE gpv_id = ' || p_gpv_id;

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] GASTO CON ID ' || p_gpv_id || ' NO ENCONTRADO');
            RETURN;
        END IF;

        V_SQL_ADITIONAL_WHERE:=' AND gpv.gpv_id = ' || p_gpv_id;
    END IF;

    --HREOS-2665
    --Motivo: Importe diferente:
        --Si el gasto es del tipo cuota de comunidad
        --Existe un gasto anterior del mismo tipo para el activo asociado al gasto
        --El importe del gasto es diferente al del gasto anterior del mismo tipo


        -- Jorge Martin consulta de ayuda para identificar todos los gastosy tipos de un activo

        -- SELECT gpv.gpv_id, 
        --        gde.gde_importe_total, 
        --        gpv.gpv_fecha_emision, 
        --        stg.dd_stg_codigo, 
        --        stg.dd_stg_descripcion 
        -- FROM   REM01.gpv_gastos_proveedor gpv 
        --        INNER JOIN REM01.gpv_act act 
        --                ON gpv.gpv_id = act.gpv_id 
        --        INNER JOIN REM01.dd_stg_subtipos_gasto stg 
        --                ON stg.dd_stg_id = gpv.dd_stg_id 
        --        INNER JOIN REM01.dd_tga_tipos_gasto tga 
        --                ON tga.dd_tga_id = gpv.dd_tga_id 
        --        INNER JOIN REM01.gde_gastos_detalle_economico gde 
        --                ON gde.gpv_id = gpv.gpv_id 
        -- WHERE  tga.dd_tga_codigo = '05' 
        --        AND act.act_id = '72463'  -- id del activo para visualizar los gastos
        -- ORDER  BY gpv.gpv_fecha_emision;


    DBMS_OUTPUT.PUT_LINE('[INFO] UPDATE / INSERT avisos que cumplen la condicion (AVG_DIF_IMPORTE = 1)');

    EXECUTE IMMEDIATE
        'MERGE INTO ' || V_ESQUEMA || '.AVG_AVISOS_GASTOS avisos 
            USING (SELECT gpv.*
                    FROM   ' || V_ESQUEMA || '.gpv_gastos_proveedor gpv 
                           INNER JOIN ' || V_ESQUEMA || '.gpv_act act 
                                   ON gpv.gpv_id = act.gpv_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_tga_tipos_gasto tga 
                                   ON tga.dd_tga_id = gpv.dd_tga_id 
                           INNER JOIN ' || V_ESQUEMA || '.gde_gastos_detalle_economico gde 
                                   ON gde.gpv_id = gpv.gpv_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto stg 
                                   ON stg.dd_stg_id = gpv.dd_stg_id 
                    WHERE  tga.dd_tga_codigo = ''05'' 
                           AND stg.dd_stg_codigo = ''26''
                            ' || V_SQL_ADITIONAL_WHERE || '
                           AND EXISTS (SELECT gpv2.gpv_id 
                                       FROM   ' || V_ESQUEMA || '.gpv_gastos_proveedor gpv2 
                                              INNER JOIN ' || V_ESQUEMA || '.gpv_act act2 
                                                      ON gpv2.gpv_id = act2.gpv_id 
                                              INNER JOIN ' || V_ESQUEMA || '.dd_tga_tipos_gasto tga2 
                                                      ON tga2.dd_tga_id = gpv2.dd_tga_id 
                                              INNER JOIN ' || V_ESQUEMA || '.gde_gastos_detalle_economico gde2 
                                                      ON gde2.gpv_id = gpv2.gpv_id 
                                              INNER JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto stg2 
                                                      ON stg2.dd_stg_id = gpv2.dd_stg_id 
                                       WHERE  tga2.dd_tga_codigo = ''05'' 
                                              AND stg2.dd_stg_codigo = ''26'' 
                                              AND gpv2.gpv_fecha_emision < gpv.gpv_fecha_emision 
                                              AND gpv2.gpv_id != gpv.gpv_id 
                                              AND act2.act_id = act.act_id 
                                              AND gde2.gde_importe_total != gde.gde_importe_total) 
               ) gasto ON (avisos.gpv_id = gasto.GPV_ID) 
        WHEN MATCHED THEN 
          UPDATE SET AVG_DIF_IMPORTE = 1, 
                     fechamodificar = SYSDATE, 
                     usuariomodificar = ''' || V_USUARIO || '''
        WHEN NOT MATCHED THEN 
          INSERT (avg_id, 
                  gpv_id, 
                  AVG_DIF_IMPORTE, 
                  usuariocrear, 
                  fechacrear) 
          VALUES (' || V_ESQUEMA || '.S_AVG_AVISOS_GASTOS.NEXTVAL, 
                  gasto.GPV_ID, 
                  1, 
                  ''' || V_USUARIO || ''', 
                  SYSDATE) ';

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT avisos que cumplen la condicion (AVG_DIF_IMPORTE = 1)');

    DBMS_OUTPUT.PUT_LINE('[INFO] UPDATE / INSERT avisos que NO cumplen la condicion (AVG_DIF_IMPORTE = 0)');

    EXECUTE IMMEDIATE
        'MERGE INTO ' || V_ESQUEMA || '.AVG_AVISOS_GASTOS avisos 
            USING (SELECT gpv.*
                    FROM   ' || V_ESQUEMA || '.gpv_gastos_proveedor gpv 
                           INNER JOIN ' || V_ESQUEMA || '.gpv_act act 
                                   ON gpv.gpv_id = act.gpv_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_tga_tipos_gasto tga 
                                   ON tga.dd_tga_id = gpv.dd_tga_id 
                           INNER JOIN ' || V_ESQUEMA || '.gde_gastos_detalle_economico gde 
                                   ON gde.gpv_id = gpv.gpv_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto stg 
                                   ON stg.dd_stg_id = gpv.dd_stg_id 
                    WHERE  tga.dd_tga_codigo = ''05'' 
                           AND stg.dd_stg_codigo = ''26''
                            ' || V_SQL_ADITIONAL_WHERE || '
                           AND NOT EXISTS (SELECT gpv2.gpv_id 
                                       FROM   ' || V_ESQUEMA || '.gpv_gastos_proveedor gpv2 
                                              INNER JOIN ' || V_ESQUEMA || '.gpv_act act2 
                                                      ON gpv2.gpv_id = act2.gpv_id 
                                              INNER JOIN ' || V_ESQUEMA || '.dd_tga_tipos_gasto tga2 
                                                      ON tga2.dd_tga_id = gpv2.dd_tga_id 
                                              INNER JOIN ' || V_ESQUEMA || '.gde_gastos_detalle_economico gde2 
                                                      ON gde2.gpv_id = gpv2.gpv_id 
                                              INNER JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto stg2 
                                                      ON stg2.dd_stg_id = gpv2.dd_stg_id 
                                       WHERE  tga2.dd_tga_codigo = ''05'' 
                                              AND stg2.dd_stg_codigo = ''26'' 
                                              AND gpv2.gpv_fecha_emision < gpv.gpv_fecha_emision 
                                              AND gpv2.gpv_id != gpv.gpv_id 
                                              AND act2.act_id = act.act_id 
                                              AND gde2.gde_importe_total != gde.gde_importe_total) 
               ) gasto ON (avisos.gpv_id = gasto.GPV_ID) 
        WHEN MATCHED THEN 
          UPDATE SET AVG_DIF_IMPORTE = 0, 
                     fechamodificar = SYSDATE, 
                     usuariomodificar = ''' || V_USUARIO || '''
        WHEN NOT MATCHED THEN 
          INSERT (avg_id, 
                  gpv_id, 
                  AVG_DIF_IMPORTE, 
                  usuariocrear, 
                  fechacrear) 
          VALUES (' || V_ESQUEMA || '.S_AVG_AVISOS_GASTOS.NEXTVAL, 
                  gasto.GPV_ID, 
                  0, 
                  ''' || V_USUARIO || ''', 
                  SYSDATE) ';

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT avisos que NO cumplen la condicion (AVG_DIF_IMPORTE = 0)');

    COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END SP_UPDATE_AVG_DIF_IMPORTE;
/
EXIT;
