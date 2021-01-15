--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20201122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11224
--## PRODUCTO=NO
--## Finalidad: Vista para sacar las entidades de una línea de detalle
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
-- 0.1
DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    ERR_NUM NUMBER; -- N?mero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_ELEMENTOS_LINEA_DETALLE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ELEMENTOS_LINEA_DETALLE...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_ELEMENTOS_LINEA_DETALLE';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ELEMENTOS_LINEA_DETALLE... borrada OK'); 
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_ELEMENTOS_LINEA_DETALLE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_ELEMENTOS_LINEA_DETALLE...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_ELEMENTOS_LINEA_DETALLE';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_ELEMENTOS_LINEA_DETALLE... borrada OK');
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_ELEMENTOS_LINEA_DETALLE...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_ELEMENTOS_LINEA_DETALLE ("GLD_ENT_ID", "GLD_ID", "TIPOENTIDAD_COD", "TIPOENTIDAD_DESC", "ENTIDAD", "GLD_PARTICIPACION_GASTO", "GLD_REFERENCIA_CATASTRAL", "ACTIVO", "DIRECCION", "TIPOACTIVO",  "IMPORTE_PROPORCIONAL_TOTAL", "GPV_ID", "DESCRIPCION_LINEA", "GLD_IMPORTE_TOTAL", "BBVA_LINEA_FACTURA", "IMPORTE_SUJETO_TOTAL", "IMPORTE_PROPORCIONAL_SUJETO") AS 
  SELECT
			GLDENT.GLD_ENT_ID,
            GLDENT.GLD_ID,                            
            ENT.DD_ENT_CODIGO AS TIPOENTIDAD_COD ,
            ENT.DD_ENT_DESCRIPCION AS TIPOENTIDAD_DESC,
            CASE
              WHEN ( ACT.ACT_NUM_ACTIVO IS NOT NULL ) THEN
                  TO_CHAR(ACT.ACT_NUM_ACTIVO)
              WHEN ( AGS.AGS_ID IS NOT NULL ) THEN
                  AGS.AGS_ACTIVO_GENERICO
              ELSE
                  TO_CHAR(GLDENT.ENT_ID)
          	END  ENTIDAD,
            GLDENT.GLD_PARTICIPACION_GASTO,          
            GLDENT.GLD_REFERENCIA_CATASTRAL,
            ACT.ACT_ID AS ACTIVO,
            LOC.BIE_LOC_DIRECCION AS DIRECCION,
            SAC.DD_SAC_DESCRIPCION AS TIPOACTIVO,
            ((GLD.GLD_IMPORTE_TOTAL * GLDENT.GLD_PARTICIPACION_GASTO)/100) AS IMPORTE_PROPORCIONAL_TOTAL,
            GLD.GPV_ID,
            (STG.DD_STG_DESCRIPCION || '' '' || NVL(TIT.DD_TIT_DESCRIPCION, '' - '') || '' '' || NVL2(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, TO_CHAR(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO) || '' %'', '' - '')) 
                DESCRIPCION_LINEA,
            GLD.GLD_IMPORTE_TOTAL,
			BBVA.BBVA_LINEA_FACTURA,
			((NVL(gld.gld_principal_sujeto, 0)) + (NVL(gld.GLD_PRINCIPAL_NO_SUJETO, 0)))  AS IMPORTE_SUJETO_TOTAL,
			((((NVL(gld.gld_principal_sujeto, 0)) + (NVL(gld.GLD_PRINCIPAL_NO_SUJETO, 0))) * GLDENT.GLD_PARTICIPACION_GASTO)/100) AS IMPORTE_PROPORCIONAL_SUJETO


		FROM ' || V_ESQUEMA || '.GLD_ENT GLDENT
        JOIN ' || V_ESQUEMA || '.gld_gastos_linea_detalle GLD ON GLDENT.GLD_ID = GLD.gld_id 
        JOIN ' || V_ESQUEMA || '.dd_ent_entidad_gasto ENT ON GLDENT.DD_ENT_ID = ENT.DD_ENT_ID
        LEFT JOIN ' || V_ESQUEMA || '.dd_tit_tipos_impuesto TIT ON GLD.DD_TIT_ID = TIT.DD_TIT_ID
        JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto STG ON GLD.DD_STG_ID = STG.DD_STG_ID
        LEFT JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON GLDENT.ENT_ID = ACT.ACT_ID AND ENT.DD_ENT_CODIGO = ''ACT''
        LEFT JOIN ' || V_ESQUEMA || '.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
        LEFT JOIN ' || V_ESQUEMA || '.BIE_LOCALIZACION LOC ON ACT.BIE_ID = LOC.BIE_ID and LOC.BORRADO = 0
        LEFT JOIN ' || V_ESQUEMA || '.ACT_BBVA_ACTIVOS BBVA ON BBVA.ACT_ID = ACT.ACT_ID AND BBVA.BORRADO = 0
 		LEFT JOIN REM01.ACT_AGS_ACTIVO_GENERICO_STG AGS ON AGS.AGS_ID = GLDENT.ENT_ID  AND AGS.BORRADO = 0 AND ENT.DD_ENT_CODIGO = ''GEN''
		WHERE GLDENT.BORRADO = 0 AND GLD.BORRADO = 0 ';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_ELEMENTOS_LINEA_DETALLE...Creada OK');
  
  EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
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
