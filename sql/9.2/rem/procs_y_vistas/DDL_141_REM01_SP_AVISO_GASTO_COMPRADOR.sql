--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170814
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

CREATE OR REPLACE PROCEDURE SP_UPDATE_AVG_COMPRADOR (
   p_gpv_id       	IN #ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE
)
AS

	-- Declaración de variables

	-- Usuario para INSERTS y UPDATES
	V_USUARIO  VARCHAR2(100 CHAR) := 'SP_UPDATE_AVG_COMPRADOR';

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

    -- HREOS-2651
    --Motivo: Corresponde al comprador:
        --Si el activo asociado al gasto está en estado comercial "vendido"
        --La fecha de venta es anterior a la fecha de emisión/devengo del gasto.
        --El tipo de gasto es Complejo Inmobiliario, Comunidad de Propietarios, Impuesto (excepto el subtipo Plusvalía), Junta de Compensación/EUC, Otras entidades en que se integra el activo, Otros tributos, Sanción, Suministro, Tasa.
    
    DBMS_OUTPUT.PUT_LINE('[INFO] UPDATE / INSERT avisos que cumplen la condicion (AVG_COMPRADOR = 1)');

    EXECUTE IMMEDIATE
        'MERGE INTO ' || V_ESQUEMA || '.AVG_AVISOS_GASTOS avisos 
            USING (SELECT DISTINCT gpv.* 
                     FROM   ' || V_ESQUEMA || '.gpv_gastos_proveedor gpv 
                           INNER JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto stg 
                                    ON stg.dd_stg_id = gpv.dd_stg_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_tga_tipos_gasto tga 
                                    ON tga.dd_tga_id = gpv.dd_tga_id 
                           INNER JOIN ' || V_ESQUEMA || '.gpv_act act 
                                    ON gpv.gpv_id = act.gpv_id 
                           INNER JOIN ' || V_ESQUEMA || '.act_activo activo 
                                    ON act.act_id = activo.act_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_scm_situacion_comercial scm 
                                    ON activo.dd_scm_id = scm.dd_scm_id 
                           LEFT JOIN ' || V_ESQUEMA || '.act_ofr act_ofr 
                                    ON act_ofr.act_id = activo.act_id 
                           LEFT JOIN ' || V_ESQUEMA || '.eco_expediente_comercial eco 
                                    ON eco.ofr_id = act_ofr.ofr_id 
                           LEFT JOIN ' || V_ESQUEMA || '.dd_eec_est_exp_comercial EEC 
                                    ON eco.dd_eec_id = EEC.dd_eec_id 
                                        AND EEC.dd_eec_codigo = ''08''
                    WHERE  scm.dd_scm_codigo = ''05'' 
                           AND tga.dd_tga_codigo IN ( ''06'', ''05'', ''01'', ''07'', ''08'', ''03'', ''04'', ''09'', ''02'' ) 
                           AND Nvl2(activo.act_venta_externa_fecha, activo.act_venta_externa_fecha, eco.eco_fecha_venta) < gpv.gpv_fecha_emision 
                           AND NOT stg.dd_stg_codigo IN ( ''03'', ''04'' ) '
                           || V_SQL_ADITIONAL_WHERE ||
              ' ) gasto ON (avisos.gpv_id = gasto.GPV_ID) 
        WHEN MATCHED THEN 
          UPDATE SET AVG_COMPRADOR = 1, 
                     fechamodificar = SYSDATE, 
                     usuariomodificar = ''' || V_USUARIO || '''
        WHEN NOT MATCHED THEN 
          INSERT (avg_id, 
                  gpv_id, 
                  AVG_COMPRADOR, 
                  usuariocrear, 
                  fechacrear) 
          VALUES (' || V_ESQUEMA || '.S_AVG_AVISOS_GASTOS.NEXTVAL, 
                  gasto.GPV_ID, 
                  1, 
                  ''' || V_USUARIO || ''', 
                  SYSDATE) ';

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT avisos que cumplen la condicion (AVG_COMPRADOR = 1)');

    DBMS_OUTPUT.PUT_LINE('[INFO] UPDATE / INSERT avisos que NO cumplen la condicion (AVG_COMPRADOR = 0)');

    EXECUTE IMMEDIATE
        'MERGE INTO ' || V_ESQUEMA || '.AVG_AVISOS_GASTOS avisos 
            USING (SELECT DISTINCT gpv.* 
                     FROM   ' || V_ESQUEMA || '.gpv_gastos_proveedor gpv 
                           INNER JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto stg 
                                    ON stg.dd_stg_id = gpv.dd_stg_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_tga_tipos_gasto tga 
                                    ON tga.dd_tga_id = gpv.dd_tga_id 
                           INNER JOIN ' || V_ESQUEMA || '.gpv_act act 
                                    ON gpv.gpv_id = act.gpv_id 
                           INNER JOIN ' || V_ESQUEMA || '.act_activo activo 
                                    ON act.act_id = activo.act_id 
                           INNER JOIN ' || V_ESQUEMA || '.dd_scm_situacion_comercial scm 
                                    ON activo.dd_scm_id = scm.dd_scm_id 
                           LEFT JOIN ' || V_ESQUEMA || '.act_ofr act_ofr 
                                    ON act_ofr.act_id = activo.act_id 
                           LEFT JOIN ' || V_ESQUEMA || '.eco_expediente_comercial eco 
                                    ON eco.ofr_id = act_ofr.ofr_id 
                           LEFT JOIN ' || V_ESQUEMA || '.dd_eec_est_exp_comercial EEC 
                                    ON eco.dd_eec_id = EEC.dd_eec_id 
                                        AND EEC.dd_eec_codigo = ''08''
                    WHERE scm.dd_scm_codigo != ''05'' 
					OR Nvl2(activo.act_venta_externa_fecha, activo.act_venta_externa_fecha, eco.eco_fecha_venta) > gpv.gpv_fecha_emision
                    OR NOT tga.dd_tga_codigo IN ( ''06'', ''05'', ''01'', ''07'', ''08'', ''03'', ''04'', ''09'', ''02'' ) 
                    OR stg.dd_stg_codigo IN ( ''03'', ''04'' ) '
                       || V_SQL_ADITIONAL_WHERE ||
                  ' ) gasto ON (avisos.gpv_id = gasto.GPV_ID) 
        WHEN MATCHED THEN 
          UPDATE SET AVG_COMPRADOR = 0, 
                     fechamodificar = SYSDATE, 
                     usuariomodificar = ''' || V_USUARIO || '''';

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT avisos que NO cumplen la condicion (AVG_COMPRADOR = 0)');

    COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END SP_UPDATE_AVG_COMPRADOR;
/
EXIT;
