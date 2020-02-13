--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9237
--## PRODUCTO=NO
--## Finalidad: vista para portales de activos
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
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PORTALES_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PORTALES_ACTIVO...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_PORTALES_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PORTALES_ACTIVO... borrada OK'); 
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PORTALES_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PORTALES_ACTIVO...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_PORTALES_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PORTALES_ACTIVO... borrada OK');
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PORTALES_ACTIVO...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_PORTALES_ACTIVO 
	AS
  SELECT
    ACT.ACT_ID
    , NULL AS AGR_ID
    , CASE
        WHEN
            SIN_TOMA_POSESION_INICIAL = 0
            AND OCUPADO_CONTITULO = 0
            AND PENDIENTE_INSCRIPCION  = 0
            AND PROINDIVISO  = 0
            AND TAPIADO  = 0
            AND OBRANUEVA_SINDECLARAR = 0
            AND OBRANUEVA_ENCONSTRUCCION = 0
            AND DIVHORIZONTAL_NOINSCRITA = 0
            AND RUINA = 0
            AND VANDALIZADO = 0
            AND COMBO_OTRO = 0
            AND SIN_INFORME_APROBADO = 0
            AND SIN_INFORME_APROBADO_REM = 0
            AND CON_CARGAS = 0
            AND SIN_ACCESO = 0
            AND OCUPADO_SINTITULO = 0
            AND ESTADO_PORTAL_EXTERNO = 0
            THEN (SELECT POR.DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL POR WHERE POR.DD_POR_CODIGO = ''01'')
        WHEN
            SIN_TOMA_POSESION_INICIAL = 0
            AND PROINDIVISO  = 0
            AND TAPIADO  = 0
            AND OBRANUEVA_SINDECLARAR = 0
            AND OBRANUEVA_ENCONSTRUCCION = 0
            AND DIVHORIZONTAL_NOINSCRITA = 0
            AND RUINA = 0
            AND VANDALIZADO = 0
            AND COMBO_OTRO = 0
            AND SIN_INFORME_APROBADO = 0
            AND SIN_INFORME_APROBADO_REM = 0
            AND SIN_ACCESO = 0
            AND ESTADO_PORTAL_EXTERNO = 0
            AND (COND.PENDIENTE_INSCRIPCION = 0 OR CNP.CNP_PENDIENTE_INSCRIPCION = 1 AND COND.PENDIENTE_INSCRIPCION = 1)
            AND (COND.CON_CARGAS = 0 OR CNP.CNP_CON_CARGAS = 1 AND COND.CON_CARGAS = 1)
            AND (COND.OCUPADO_SINTITULO = 0 OR CNP.CNP_OCUPADO_SIN_TITULO = 1 AND COND.OCUPADO_SINTITULO = 1)
            AND (COND.OCUPADO_CONTITULO = 0 OR CNP.CNP_OCUPADO_CON_TITULO = 1 AND COND.OCUPADO_CONTITULO = 1)
            THEN (SELECT POR.DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL POR WHERE POR.DD_POR_CODIGO = ''01'')
        ELSE (SELECT POR.DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL POR WHERE POR.DD_POR_CODIGO = ''02'')
    END DD_POR_ID
    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
    INNER JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0
    INNER JOIN '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD COND ON COND.ACT_ID = ACT.ACT_ID AND COND.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.ACT_CNP_CONFIG_PORTAL CNP ON ACT.DD_CRA_ID = CNP.DD_CRA_ID AND CNP.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
    WHERE
    ACT.BORRADO = 0
    AND EPV.DD_EPV_CODIGO IN (''03'',''04'')
    AND NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX 
                    JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AUX.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
                    JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                    LEFT JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0
                    WHERE DD_TAG_CODIGO = ''02'' AND AUX.ACT_ID = ACT.ACT_ID)';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PORTALES_ACTIVO...Creada OK');
  
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
