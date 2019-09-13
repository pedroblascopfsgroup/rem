--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20190912
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7668
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Creación de la vista Ivan Rubio 20190725
--##        0.2 Versión - Modificada la vista para que la referencia catastral la saque de la tabla ACT_CAT_CATASTRO.
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- Configuracion Esquema master
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN
	--V0.2
  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_LIST_OFERTAS_CES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP  VIEW '|| V_ESQUEMA ||'.VI_LIST_OFERTAS_CES...');
    EXECUTE IMMEDIATE 'DROP  VIEW ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES';  
    DBMS_OUTPUT.PUT_LINE('DROP  VIEW '|| V_ESQUEMA ||'.VI_LIST_OFERTAS_CES... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_LIST_OFERTAS_CES...');
  V_MSQL := 'CREATE VIEW ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES 
	AS
		SELECT DISTINCT
		OFR.OFR_ID
		,OFR.OFR_NUM_OFERTA
		,ACT.ACT_NUM_ACTIVO
		,ACT.ID_CES
		,ACT.ID_SANTANDER
		,OFR.OFR_FECHA_ALTA
		,OFR.OFR_IMPORTE
		,OFR.OFR_IMPORTE_CONTRAOFERTA
		,POS.POS_FECHA_POSICIONAMIENTO
		,BDR.BIE_DREG_NUM_FINCA
		,CAT.CAT_REF_CATASTRAL
		,BLO.BIE_LOC_DIRECCION
		,LOC.DD_LOC_DESCRIPCION
		,PRV.DD_PRV_DESCRIPCION
		,CCA.DD_CCA_DESCRIPCION
		,AVA.VAL_IMPORTE
		,(SELECT COUNT(OFR_ID) FROM ACT_OFR WHERE ACT_ID = ACT.ACT_ID) AS N_OFERTAS
		,(SELECT COUNT(VIS_ID) FROM VIS_VISITAS WHERE ACT_ID = ACT.ACT_ID) AS N_VISITAS
		,LISTAGG(COM.COM_NOMBRE||'',''||COM.COM_APELLIDOS||'',''||COM.COM_DOCUMENTO, '';'' on overflow truncate) 
			WITHIN GROUP (ORDER BY COM.COM_NOMBRE) OVER (PARTITION BY OFR.OFR_ID) AS COMPRADORES
		FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR
		JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		JOIN '|| V_ESQUEMA ||'.CEX_COMPRADOR_EXPEDIENTE CEX ON ECO.ECO_ID = CEX.ECO_ID
		JOIN '|| V_ESQUEMA ||'.COM_COMPRADOR COM ON CEX.COM_ID = COM.COM_ID 
		LEFT JOIN '|| V_ESQUEMA ||'.POS_POSICIONAMIENTO POS ON POS.ECO_ID = ECO.ECO_ID
		JOIN '|| V_ESQUEMA ||'.ACT_OFR AOF ON AOF.OFR_ID = OFR.OFR_ID
		JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON AOF.ACT_ID = ACT.ACT_ID
		JOIN '|| V_ESQUEMA ||'.act_cat_catastro cat ON cat.act_id = act.act_id
		LEFT JOIN '|| V_ESQUEMA ||'.VIS_VISITAS VIS ON VIS.ACT_ID = ACT.ACT_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES AVA ON AVA.ACT_ID = ACT.ACT_ID 
		JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = AVA.DD_TPC_ID
		JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_ID = ACT.BIE_ID
		JOIN '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BDR.DD_LOC_ID
		JOIN '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID
		LEFT JOIN '|| V_ESQUEMA_M ||'.DD_CCA_COMUNIDAD CCA ON CCA.DD_CCA_ID = PRV.DD_CCA_ID
		JOIN BIE_LOCALIZACION BLO ON BLO.BIE_ID = ACT.BIE_ID
		WHERE ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''31'')
		AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'') 
		AND ACT.DD_SCR_ID = (SELECT DD_SCR_ID FROM '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'')
		AND TPC.DD_TPC_CODIGO = ''02''';
        
  EXECUTE IMMEDIATE	V_MSQL;
    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_LIST_OFERTAS_CES...Creada OK');
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES IS ''VISTA PARA RECOGER LAS OFERTAS CES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.OFR_ID IS ''ID de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.OFR_NUM_OFERTA IS ''Número de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.ACT_NUM_ACTIVO IS ''Número del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.ID_CES IS ''ID SERVICER ACT_ACTIVO'''; 
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.ID_SANTANDER IS ''ID_INMUEBLE_BS ACT_ACTIVO'''; 
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.OFR_FECHA_ALTA IS ''Fecha creación de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.OFR_IMPORTE IS ''Importe de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.OFR_IMPORTE_CONTRAOFERTA IS ''Importe contraoferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.POS_FECHA_POSICIONAMIENTO IS ''Fecha de posicionamiento prevista''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.BIE_DREG_NUM_FINCA IS ''Finca registral''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.CAT_REF_CATASTRAL IS ''Referencia catastral''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.BIE_LOC_DIRECCION IS ''Dirección del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.DD_LOC_DESCRIPCION IS ''Localidad del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.DD_PRV_DESCRIPCION IS ''Provincia del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.DD_CCA_DESCRIPCION IS ''Comunidad Autónoma del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.VAL_IMPORTE IS ''Importe de venta del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.N_OFERTAS IS ''Número total de ofertas del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.N_VISITAS IS ''Número total de visitas del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_LIST_OFERTAS_CES.COMPRADORES IS ''Lista de compradores del expediente''';

  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_LIST_OFERTAS_CES...Creada OK');
  EXCEPTION
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
