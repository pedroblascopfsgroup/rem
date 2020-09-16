 --/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL creación de la vista de filtro de activos para publicar automáticamente.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
    table_count NUMBER(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count NUMBER(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_TEXT_VISTA VARCHAR2(30 CHAR) := 'V_ACT_PUBLI_HEP_CONDICIONES'; -- Vble. auxiliar para almacenar el nombre de la vista.
    V_MSQL VARCHAR2(4000 CHAR);
    CUENTA NUMBER(1); -- Vble. existencia de la vista.
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'MATERIALIZED VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('[INFO] Vista borrada OK');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'..');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
		  SELECT
			HISTORICO.ACT_ID,
      		HISTORICO.HEP_ID,
			(SELECT DD_POR_CODIGO FROM DD_POR_PORTAL WHERE DD_POR_ID = HISTORICO.DD_POR_ID) AS CODIGO_PORTAL,
			DECODE((SELECT COND.RUINA + COND.PENDIENTE_INSCRIPCION + COND.OBRANUEVA_SINDECLARAR + COND.SIN_TOMA_POSESION_INICIAL + COND.PROINDIVISO + 
			COND.OBRANUEVA_ENCONSTRUCCION + COND.OCUPADO_CONTITULO + COND.TAPIADO + COND.ESTADO_PORTAL_EXTERNO + COND.OCUPADO_SINTITULO +
			COND.DIVHORIZONTAL_NOINSCRITA + NVL2(COND.OTRO, 1, 0) FROM REM01.V_COND_DISPONIBILIDAD COND WHERE HISTORICO.ACT_ID = cond.ACT_ID), 0, 0, 1) AS CONDICIONADO
			
		  FROM
		      REM01.ACT_HEP_HIST_EST_PUBLICACION HISTORICO
		
		  WHERE
		      (HISTORICO.DD_EPU_ID NOT IN (''06'') AND HISTORICO.DD_EPU_ID IS NOT NULL) -- Que el estado de publicacion del historico del activo no se encuentre en el estado no publicado o null.
		      AND HEP_ID IN (SELECT MAX(HEP_ID) FROM ACT_HEP_HIST_EST_PUBLICACION GROUP BY ACT_ID) -- Obtener el ID mas alto del historico por cada activo
';

  DBMS_OUTPUT.PUT_LINE('[INFO] Vista creada OK');
  
END;
/

EXIT;