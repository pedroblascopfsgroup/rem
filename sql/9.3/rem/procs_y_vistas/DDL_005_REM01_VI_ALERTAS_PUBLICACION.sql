--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200422
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6440
--## PRODUCTO=NO
--## Finalidad: vista para alertas de publicacion y fases de activos
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
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA VARCHAR2(30 CHAR) := 'V_ALERTAS_PUBLICACION';


    CUENTA NUMBER;

    V_ESQUEMA_1 VARCHAR2(20 CHAR) := ''|| V_ESQUEMA ||'';
    V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
    V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
    V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
    V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ALERTAS_PUBLICACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ALERTAS_PUBLICACION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_ALERTAS_PUBLICACION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ALERTAS_PUBLICACION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ALERTAS_PUBLICACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ALERTAS_PUBLICACION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ALERTAS_PUBLICACION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ALERTAS_PUBLICACION... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ALERTAS_PUBLICACION...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_ALERTAS_PUBLICACION 
	AS 
	SELECT ACT.ACT_NUM_ACTIVO AS NUM_ACTIVO, 
	ACT.ACT_ID AS ID_ACTIVO,
	UPPER(CRA.DD_CRA_DESCRIPCION) AS CARTERA, 
	UPPER(SCR.DD_SCR_DESCRIPCION) AS SUBCARTERA ,
	FSP.DD_FSP_DESCRIPCION AS FASE_PUBLICACION,
	TTA.DD_TTA_DESCRIPCION AS TIPO_TITULO,
   	NVL2 (TIT.ACT_ID, 0, 1) AS ALERTA_INSCRIPCION,
	NVL2 (VCG.CON_CARGAS, VCG.CON_CARGAS, 0) AS ALERTA_CARGAS,                   
	CASE WHEN (ACT.DD_CRA_ID = 21) 
             THEN (CASE WHEN SIJ.DD_SIJ_INDICA_POSESION = 1 THEN 0 ELSE 1 END) 
             ELSE (CASE WHEN SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL THEN 0 ELSE 1 END)           
    	END AS ALERTA_POSESION,     
	CASE WHEN TAL.DD_TAL_CODIGO IN (''02'',''03'',''04'') THEN 1 ELSE 0 END AS ALERTA_TIPO_ALQUILER,                
	CASE WHEN (SPS.SPS_OCUPADO = 1 AND TPA.DD_TPA_CODIGO = ''01'' OR UA.ACT_ID IS NOT NULL) THEN 1 ELSE 0 END AS ALERTA_ALQUILER,   
	CASE WHEN (SPS.SPS_OCUPADO = 1 AND (TPA.DD_TPA_CODIGO = ''02'' OR TPA.DD_TPA_CODIGO = ''03'')) THEN 1 ELSE 0 END AS ALERTA_OKUPADO 
	FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT 
	INNER JOIN '|| V_ESQUEMA ||'.ACT_HFP_HIST_FASES_PUB HFP ON ACT.ACT_ID = HFP.ACT_ID AND HFP.HFP_FECHA_FIN IS NULL AND HFP.BORRADO = 0
	INNER JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
	INNER JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON ACT.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
	INNER JOIN '|| V_ESQUEMA ||'.DD_FSP_FASE_PUBLICACION FSP ON HFP.DD_FSP_ID = FSP.DD_FSP_ID  AND FSP.BORRADO = 0
	INNER JOIN '|| V_ESQUEMA ||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON ACT.DD_TTA_ID = TTA.DD_TTA_ID AND TTA.BORRADO = 0
	LEFT JOIN '|| V_ESQUEMA ||'.DD_TAL_TIPO_ALQUILER TAL ON ACT.DD_TAL_ID = TAL.DD_TAL_ID AND TAL.BORRADO = 0 
    	INNER JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID AND SCM.BORRADO = 0 AND SCM.DD_SCM_CODIGO <> ''05''
    	INNER JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID AND PAC.BORRADO = 0 AND PAC.PAC_INCLUIDO = 1
    	INNER JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
    	LEFT JOIN '|| V_ESQUEMA ||'.DD_SIJ_SITUACION_JURIDICA SIJ ON SPS.DD_SIJ_ID = SIJ.DD_SIJ_ID
	LEFT JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT TPA ON TPA.DD_TPA_ID = SPS.DD_TPA_ID
 	LEFT JOIN '|| V_ESQUEMA ||'.VI_ACTIVOS_CON_CARGAS VCG ON VCG.ACT_ID = ACT.ACT_ID 
    	LEFT JOIN 
         (SELECT AGA.ACT_ID
          FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
          WHERE AGA.AGA_PRINCIPAL = 1 AND EXISTS
	  (
	   SELECT AGA2.AGR_ID FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA2
	   INNER JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = AGA2.ACT_ID
	   INNER JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGA2.AGR_ID = AGR.AGR_ID
	   INNER JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG1 ON TAG1.DD_TAG_ID = AGR.DD_TAG_ID
	   WHERE TAG1.DD_TAG_CODIGO = ''16'' AND SPS.DD_TPA_ID = 1 AND AGA.AGA_ID = AGA2.AGA_ID
	  )) UA ON UA.ACT_ID = ACT.ACT_ID
    	LEFT JOIN
          (SELECT ACT_TIT.ACT_ID
       	   FROM '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL ACT_REG
           LEFT JOIN '|| V_ESQUEMA ||'.ACT_ABA_ACTIVO_BANCARIO ABA ON ABA.ACT_ID = ACT_REG.ACT_ID
           JOIN '|| V_ESQUEMA ||'.ACT_TIT_TITULO ACT_TIT ON ACT_TIT.ACT_ID = ACT_REG.ACT_ID
           JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_DREG_ID = ACT_REG.BIE_DREG_ID
           WHERE ABA.DD_CLA_ID = 1 OR ACT_TIT.TIT_FECHA_INSC_REG IS NOT NULL) TIT ON TIT.ACT_ID = ACT.ACT_ID
	WHERE ACT.BORRADO = 0';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ALERTAS_PUBLICACION...Creada OK');

	IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

	END IF;

	IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

	END IF;

	IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

	END IF;
  
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
