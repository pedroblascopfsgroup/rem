--/*
--##########################################
--## AUTOR=Carlos Pons
--## FECHA_CREACION=20170816
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Actualiza la alerta - Proveedor de baja
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
-- p_gpv_id, 		id del gasto a comprobar (si viene a null, los comprobará todos)
-- p_pve_id,    id del proveedor (para comprobar si está de baja)
-- ------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_AVISO_PROV_DE_BAJA (
   p_gpv_id       	IN #ESQUEMA#.GPV_GASTOS_PROVEEDOR.GPV_ID%TYPE ,
   p_pve_id         IN #ESQUEMA#.ACT_PVE_PROVEEDOR.PVE_ID%TYPE
)
AS

	-- Declaración de variables
	-- Usuario para INSERTS y UPDATES
  V_USUARIO  VARCHAR2(100 CHAR) := 'SP_AVISO_PROV_DE_BAJA';

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

    IF (p_pve_id IS NULL) THEN 
        DBMS_OUTPUT.PUT_LINE('[INFO] SE REQUIERE EL IDENTIFICADOR DEL PROVEEDOR');
        RETURN;
    ELSE
        -- Si se pasa un ID_PROVEEDOR por parametro lo buscamos para asgurarnos de que se encuentre
        V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR WHERE PVE_ID = ' || p_pve_id;

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] PROVEEDOR CON ID ' || p_pve_id || ' NO ENCONTRADO');
            RETURN;
        END IF;
    END IF;

    -- Según HREOS-2663
    DBMS_OUTPUT.PUT_LINE('[INFO] UPDATE / INSERT avisos que cumplen estas dos condiciones:');
    DBMS_OUTPUT.PUT_LINE('[INFO] 1> El emisor (= proveedor) del gasto está dado de baja');
    DBMS_OUTPUT.PUT_LINE('[INFO] 2> La fecha de baja del proveedor es anterior a la fecha de emisión/devengo del gasto');


    EXECUTE IMMEDIATE
        'MERGE INTO ' || V_ESQUEMA || '.AVG_AVISOS_GASTOS avisos 
            USING (SELECT gpv.* 
                   FROM   ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR gpv 
                          INNER JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR pve 
                                  ON pve.PVE_ID = gpv.PVE_ID_EMISOR AND
                                  pve.PVE_FECHA_BAJA IS NOT NULL AND
                                  gpv.GPV_FECHA_EMISION IS NOT NULL AND
                                  pve.PVE_FECHA_BAJA < gpv.GPV_FECHA_EMISION
                                  '|| V_SQL_ADITIONAL_WHERE ||' ) gasto ON (avisos.gpv_id = gasto.GPV_ID) 
        WHEN MATCHED THEN 
          UPDATE SET AVG_PROVEEDOR_BAJA = 1, 
                     fechamodificar = SYSDATE, 
                     usuariomodificar = ''' || V_USUARIO || '''
        WHEN NOT MATCHED THEN 
          INSERT (avg_id, 
                  gpv_id, 
                  AVG_PROVEEDOR_BAJA, 
                  usuariocrear, 
                  fechacrear) 
          VALUES (' || V_ESQUEMA || '.S_AVG_AVISOS_GASTOS.NEXTVAL, 
                  gasto.GPV_ID, 
                  1, 
                  ''' || V_USUARIO || ''', 
                  SYSDATE) ';

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT');
    COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END SP_AVISO_PROV_DE_BAJA;
/
EXIT;
