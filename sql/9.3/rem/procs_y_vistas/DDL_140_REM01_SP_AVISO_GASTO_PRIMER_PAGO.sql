--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170811
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

CREATE OR REPLACE PROCEDURE SP_UPDATE_AVG_PRIMER_PAGO (
   p_gpv_id       	IN #ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE
)
AS

	-- Declaración de variables

	-- Subtipos de gasto a los que se refiere es procedure
	-- 01	IBI urbana
	-- 02	IBI rústica
	v_stg_codigo_ibi_urbana 	VARCHAR2(10 CHAR) := '01';
	v_stg_codigo_ibi_rustica 	VARCHAR2(10 CHAR) := '02';

	-- Usuario para INSERTS y UPDATES
	V_USUARIO  VARCHAR2(100 CHAR) := 'SP_UPDATE_AVG_PRIMER_PAGO';

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  

    V_SQL_ADITIONAL_WHERE VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    IF (p_gpv_id IS NULL) THEN 
        V_SQL_ADITIONAL_WHERE:='';
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

    -- HREOS-2653
    -- Motivo: Primer pago:
        -- Si el gasto es del tipo impuesto, subtipo IBI
        -- No hay ningún gasto de este mismo tipo para el activo asociado al gasto

    DBMS_OUTPUT.PUT_LINE('[INFO] UPDATE / INSERT avisos que cumplen la condicion (avg_primer_pago = 1)');

    EXECUTE IMMEDIATE
        'MERGE INTO ' || V_ESQUEMA || '.AVG_AVISOS_GASTOS avisos 
            USING (SELECT gpv.* 
                   FROM   ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR gpv 
                          INNER JOIN ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO stg 
                                  ON stg.dd_stg_id = gpv.dd_stg_id 
                          INNER JOIN ' || V_ESQUEMA || '.GPV_ACT act 
                                  ON gpv.gpv_id = act.gpv_id 
                          INNER JOIN (SELECT ACT.act_id 
                                      FROM   ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR gpv 
                                             INNER JOIN ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO stg 
                                                     ON stg.dd_stg_id = gpv.dd_stg_id 
                                             INNER JOIN ' || V_ESQUEMA || '.GPV_ACT act 
                                                     ON gpv.gpv_id = act.gpv_id 
                                      WHERE  stg.dd_stg_codigo IN ( ' || v_stg_codigo_ibi_urbana || ', ' || v_stg_codigo_ibi_rustica || ' ) 
                                             AND gpv.borrado = 0 
                                      GROUP  BY ACT.act_id 
                                      HAVING COUNT(gpv.gpv_id) = 1) groupActivos 
                                  ON groupActivos.act_id = act.act_id 
                   WHERE  stg.dd_stg_codigo IN ( ' || v_stg_codigo_ibi_urbana || ', ' || v_stg_codigo_ibi_rustica || ' ) '
                            || V_SQL_ADITIONAL_WHERE ||
            ' ) gasto ON (avisos.gpv_id = gasto.GPV_ID) 
        WHEN MATCHED THEN 
          UPDATE SET avg_primer_pago = 1, 
                     fechamodificar = SYSDATE, 
                     usuariomodificar = ''' || V_USUARIO || '''
        WHEN NOT MATCHED THEN 
          INSERT (avg_id, 
                  gpv_id, 
                  avg_primer_pago, 
                  usuariocrear, 
                  fechacrear) 
          VALUES (' || V_ESQUEMA || '.S_AVG_AVISOS_GASTOS.NEXTVAL, 
                  gasto.GPV_ID, 
                  1, 
                  ''' || V_USUARIO || ''', 
                  SYSDATE) ';

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT avisos que cumplen la condicion (avg_primer_pago = 1)');

    DBMS_OUTPUT.PUT_LINE('[INFO] UPDATE / INSERT avisos que NO cumplen la condicion (avg_primer_pago = 0)');

    EXECUTE IMMEDIATE
      'MERGE INTO ' || V_ESQUEMA || '.AVG_AVISOS_GASTOS avisos 
          USING (SELECT gpv.* 
                 FROM   ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR gpv 
                        INNER JOIN ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO stg 
                                ON stg.dd_stg_id = gpv.dd_stg_id 
                        INNER JOIN ' || V_ESQUEMA || '.GPV_ACT act 
                                ON gpv.gpv_id = act.gpv_id 
                        INNER JOIN (SELECT ACT.act_id 
                                    FROM   ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR gpv 
                                           INNER JOIN ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO stg 
                                                   ON stg.dd_stg_id = gpv.dd_stg_id 
                                           INNER JOIN ' || V_ESQUEMA || '.GPV_ACT act 
                                                   ON gpv.gpv_id = act.gpv_id 
                                    WHERE  stg.dd_stg_codigo IN ( ' || v_stg_codigo_ibi_urbana || ', ' || v_stg_codigo_ibi_rustica || ' ) 
                                           AND gpv.borrado = 0 
                                    GROUP  BY ACT.act_id 
                                    HAVING COUNT(gpv.gpv_id) > 1) groupActivos 
                                ON groupActivos.act_id = act.act_id 
                 WHERE  stg.dd_stg_codigo IN ( ' || v_stg_codigo_ibi_urbana || ', ' || v_stg_codigo_ibi_rustica || ' ) '
                          || V_SQL_ADITIONAL_WHERE ||
          ' ) gasto ON (avisos.gpv_id = gasto.GPV_ID) 
      WHEN MATCHED THEN 
        UPDATE SET avg_primer_pago = 0, 
                   fechamodificar = SYSDATE, 
                   usuariomodificar = ''' || V_USUARIO || '''
      WHEN NOT MATCHED THEN 
        INSERT (avg_id, 
                gpv_id, 
                avg_primer_pago, 
                usuariocrear, 
                fechacrear) 
        VALUES (' || V_ESQUEMA || '.S_AVG_AVISOS_GASTOS.NEXTVAL, 
                gasto.GPV_ID, 
                0, 
                ''' || V_USUARIO || ''', 
                SYSDATE) ';

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT avisos que NO cumplen la condicion (avg_primer_pago = 0)');

    COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END SP_UPDATE_AVG_PRIMER_PAGO;
/
EXIT;
