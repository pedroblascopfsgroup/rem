--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16085
--## PRODUCTO=NO
--## Finalidad: vista para sacar rechazos de un gasto
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Añadir nuevo campo TIPO_IMPORTE - [HREOS-14219] - Javier Esbri
--##        0.3 Añadir UNION - [HREOS-16085] - Alejandra García
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_MOT_RECHAZO_GASTO_CX' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_MOT_RECHAZO_GASTO_CX...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_GRID_MOT_RECHAZO_GASTO_CX';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_MOT_RECHAZO_GASTO_CX... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_MOT_RECHAZO_GASTO_CX' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_MOT_RECHAZO_GASTO_CX...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_GRID_MOT_RECHAZO_GASTO_CX';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_MOT_RECHAZO_GASTO_CX... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_MOT_RECHAZO_GASTO_CX...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_GRID_MOT_RECHAZO_GASTO_CX 
	AS
    SELECT 
    RGS.RGS_ID AS RGS_ID, 
    GPV.GPV_ID AS GASTO_ID, 
    gpv.gpv_num_gasto_haya AS GPV_NUM_GASTO, 
    LES.DD_LES_CODIGO AS LES_CODIGO, 
    LES.DD_RETORNO_SAPBC AS LES_RETORNO,
    LES.DD_TEXT_MENSAJE_SAP AS LES_DESCRIPCION,
    GLD.GLD_ID AS NUM_LINEA,
    ACT.ACT_ID AS ACT_ID,
    act.ACT_NUM_ACTIVO AS NUM_ACTIVO,
    RGS.MENSAJE_ERROR AS MENSAJE_ERROR,
    RGS.FECHA_PROCESADO AS FECHA_PROCESADO,
    RGS.TIPO_IMPORTE AS TIPO_IMPORTE

    FROM 
        '||V_ESQUEMA||'.ACT_RGS_RECHAZOS_GASTOS_SAPBC RGS
        JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = RGS.GPV_ID AND GPV.BORRADO = 0
        LEFT JOIN  '||V_ESQUEMA||'.dd_les_listado_errores_sap LES ON LES.DD_LES_ID = RGS.DD_LES_ID AND LES.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID = RGS.GLD_ID AND GLD.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = RGS.ACT_ID AND ACT.BORRADO = 0
        WHERE RGS.BORRADO = 0
        
  UNION
  
    SELECT 
    RGS.RGS_ID AS RGS_ID, 
    GPV.GPV_ID AS GASTO_ID, 
    gpv.gpv_num_gasto_haya AS GPV_NUM_GASTO, 
    LES.DD_LES_CODIGO AS LES_CODIGO, 
    LES.DD_RETORNO_CAIXA AS LES_RETORNO,
    LES.DD_TEXT_MENSAJE_CAIXA AS LES_DESCRIPCION,
    GLD.GLD_ID AS NUM_LINEA,
    ACT.ACT_ID AS ACT_ID,
    act.ACT_NUM_ACTIVO AS NUM_ACTIVO,
    RGS.MENSAJE_ERROR AS MENSAJE_ERROR,
    RGS.FECHA_PROCESADO AS FECHA_PROCESADO,
    RGS.TIPO_IMPORTE AS TIPO_IMPORTE

    FROM 
        '||V_ESQUEMA||'.ACT_RGS_RECHAZOS_GASTOS_CAIXA RGS
        JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = RGS.GPV_ID AND GPV.BORRADO = 0
        LEFT JOIN  '||V_ESQUEMA||'.dd_les_listado_errores_CAIXA LES ON LES.DD_LES_ID = RGS.DD_LES_ID AND LES.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID = RGS.GLD_ID AND GLD.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = RGS.ACT_ID AND ACT.BORRADO = 0
        WHERE RGS.BORRADO = 0';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_MOT_RECHAZO_GASTO_CX...Creada OK');
  
  EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;