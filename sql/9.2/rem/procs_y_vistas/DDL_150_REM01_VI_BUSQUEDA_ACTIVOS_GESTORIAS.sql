--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20191031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8188
--## PRODUCTO=NO
--## Finalidad: vista para filtrar por activos por gestorías
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_GESTORIAS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_GESTORIAS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_GESTORIAS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_GESTORIAS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_GESTORIAS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_GESTORIAS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_GESTORIAS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_GESTORIAS... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_GESTORIAS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_GESTORIAS 
	AS
    SELECT 
        ACT.ACT_ID,
        CAG.DD_IGE_ID
    FROM
        '||V_ESQUEMA||'.ACT_ACTIVO ACT
        INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
        INNER JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID AND USU.BORRADO = 0
        INNER JOIN '||V_ESQUEMA_MASTER||'.GRU_GRUPOS_USUARIOS GRU ON GRU.USU_ID_USUARIO = USU.USU_ID AND GRU.BORRADO =  0
        INNER JOIN '||V_ESQUEMA||'.CAG_CONFIG_ACCESO_GESTORIAS CAG ON GRU.USU_ID_GRUPO = CAG.CAG_USU_GRUPO AND CAG.BORRADO = 0
    WHERE ACT.BORRADO = 0
    GROUP BY
        ACT.ACT_ID,
        CAG.DD_IGE_ID';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_GESTORIAS...Creada OK');
  
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
