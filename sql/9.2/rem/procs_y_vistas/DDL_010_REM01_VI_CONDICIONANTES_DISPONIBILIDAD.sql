--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20170612
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1591
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial ANAHUAC DE VICENTE
--## 		0.2 JOSEVI: Nuevas condiciones: Varios propietarios activo o 1 propietario con menos de 100%.
--##             Calculo de condicionado/no condicionado desde la vista
--##		0.3 HREOS-1954 - Inclusión condicionantes SIN_INFORME_APROBADO y CON_CARGAS
--##		0.4 HREOS-2142 - Corregir PENDIENTE_INSCRIPCION que estaba al reves
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
    err_num NUMBER; -- Vble. número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_COND_DISPONIBILIDAD' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_COND_DISPONIBILIDAD';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_COND_DISPONIBILIDAD
	AS
  SELECT 
    ACT_ID,
    SIN_TOMA_POSESION_INICIAL,
    OCUPADO_CONTITULO,
    PENDIENTE_INSCRIPCION,
    PROINDIVISO,
    TAPIADO,
    OBRANUEVA_SINDECLARAR,
    OBRANUEVA_ENCONSTRUCCION,
    DIVHORIZONTAL_NOINSCRITA,
    RUINA,
    OTRO,
    SIN_INFORME_APROBADO,
    REVISION,
    PROCEDIMIENTO_JUDICIAL,
    CON_CARGAS,
    OCUPADO_SINTITULO,
    ESTADO_PORTAL_EXTERNO,
    DECODE(EST_DISP_COM_CODIGO,''01'', 1, 0) AS ES_CONDICIONADO,
    EST_DISP_COM_CODIGO,
    BORRADO
  FROM (
  		SELECT ACT.ACT_ID,
             NVL2(SPS4.SPS_ID,1,0) AS SIN_TOMA_POSESION_INICIAL,
  		       NVL2(SPS3.SPS_ID,1,0) AS OCUPADO_CONTITULO,
  	         NVL2(TIT.ACT_ID,0,1) AS PENDIENTE_INSCRIPCION,
             NVL2(NPA.ACT_ID,1,0) AS PROINDIVISO,
             NVL2(SPS1.SPS_ID,1,0) AS TAPIADO,
             NVL2(EON.DD_EON_ID,1,0) AS OBRANUEVA_SINDECLARAR,
             NVL2(EAC2.DD_EAC_ID,1,0) AS OBRANUEVA_ENCONSTRUCCION,
             NVL2(REG2.REG_ID,1,0) AS DIVHORIZONTAL_NOINSCRITA,
  		     NVL2(EAC1.DD_EAC_ID,1,0) AS RUINA,     
  		     SPS5.SPS_OTRO AS OTRO,
  		     DECODE(VEI.DD_AIC_CODIGO ,''02'' ,0 , 1) AS SIN_INFORME_APROBADO,
             0 AS REVISION, --NO EXISTE EN REM
             0 AS PROCEDIMIENTO_JUDICIAL, --NO EXISTE EN REM
  		     NVL2(VCG.CON_CARGAS, VCG.CON_CARGAS, 0) AS CON_CARGAS,
  		     NVL2(SPS2.SPS_ID,1,0) AS OCUPADO_SINTITULO,
  		     NVL2(SPS6.SPS_ID,1,0) AS ESTADO_PORTAL_EXTERNO,
             CASE
                  WHEN (NVL2(SPS4.SPS_ID,1,0) = 1 OR NVL2(EAC1.DD_EAC_ID,1,0) = 1 OR NVL2(TIT.ACT_ID,0,1) = 1 
                        OR NVL2(EON.DD_EON_ID,1,0) = 1 OR NVL2(NPA.ACT_ID,1,0) = 1 OR NVL2(EAC2.DD_EAC_ID,1,0) = 1 
                        OR NVL2(SPS3.SPS_ID,1,0) = 1 OR NVL2(SPS1.SPS_ID,1,0) = 1 OR NVL2(SPS2.SPS_ID,1,0) = 1
                        OR NVL2(REG2.REG_ID,1,0) = 1 OR NVL2(SPS5.SPS_OTRO,1,0) = 1)
                    THEN ''01''
	                  ELSE ''02''
             END AS EST_DISP_COM_CODIGO,
  		     0 AS BORRADO
  		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
  		LEFT JOIN '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO EAC1 ON EAC1.DD_EAC_ID = ACT.DD_EAC_ID AND EAC1.DD_EAC_CODIGO = ''05'' -- RUINA
  		LEFT JOIN '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO EAC2 ON EAC2.DD_EAC_ID = ACT.DD_EAC_ID AND EAC2.DD_EAC_CODIGO = ''02'' -- OBRA NUEVA EN CONSTRUCCIÓN
  		LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS1 ON SPS1.ACT_ID = ACT.ACT_ID AND SPS1.SPS_ACC_TAPIADO = 1 -- TAPIADO
  		LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS2 ON SPS2.ACT_ID = ACT.ACT_ID AND SPS2.SPS_OCUPADO = 1 AND SPS2.SPS_CON_TITULO = 0 -- OCUPADO SIN TITULO
  		LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS3 ON SPS3.ACT_ID = ACT.ACT_ID AND SPS3.SPS_OCUPADO = 1 AND SPS3.SPS_CON_TITULO = 1 -- OCUPADO CON TITULO
  		LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS4 ON SPS4.ACT_ID = ACT.ACT_ID AND SPS4.SPS_FECHA_TOMA_POSESION IS NULL -- SIN TOMA POSESION INICIAL
  		LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS5 ON SPS5.ACT_ID = ACT.ACT_ID -- OTROS MOTIVOS
  		LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS6 ON SPS6.ACT_ID = ACT.ACT_ID AND SPS6.SPS_ESTADO_PORTAL_EXTERNO = 1 -- ESTADO PUBLICACION PORTALES EXTERNOS
  		LEFT JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID = ACT.ACT_ID AND TIT.TIT_FECHA_INSC_REG IS NOT NULL -- PENDIENTE DE INSCRIPCIÓN
  		LEFT JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG1 ON REG1.ACT_ID = ACT.ACT_ID
  		LEFT JOIN '||V_ESQUEMA||'.DD_EON_ESTADO_OBRA_NUEVA EON ON EON.DD_EON_ID = REG1.DD_EON_ID AND EON.DD_EON_CODIGO IN (''02'',''04'',''05'') -- OBRA NUEVA SIN DECLARAR
  		LEFT JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG2 ON REG2.ACT_ID = ACT.ACT_ID AND REG2.REG_DIV_HOR_INSCRITO = 0 -- DIVISIÓN HORIZONTAL NO INSCRITA
  		LEFT JOIN '||V_ESQUEMA||'.V_NUM_PROPIETARIOSACTIVO NPA ON NPA.ACT_ID = ACT.ACT_ID --PROINDIVISO (VARIOS PROPIETARIOS O 1 PROPIETARIO CON %PROP < 100)
		LEFT JOIN '||V_ESQUEMA||'.VI_ACTIVOS_CON_CARGAS VCG ON VCG.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID 
		LEFT JOIN '||V_ESQUEMA||'.VI_ESTADO_ACTUAL_INFMED VEI ON VEI.ICO_ID = ICO.ICO_ID  --SIN_INFORME_APROBADO
    where act.borrado = 0

    )';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...Creada OK');
  
END;
/

EXIT;
