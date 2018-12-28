--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20181227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5043
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

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER(16); -- Vble. para validar la existencia de vista.
    
BEGIN
	
--V_EXP_PREBLOQUEO_GENCAT v0.1

  SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_EXP_PREBLOQUEO_GENCAT' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA > 0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_EXP_PREBLOQUEO_GENCAT...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_EXP_PREBLOQUEO_GENCAT';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_EXP_PREBLOQUEO_GENCAT... borrada OK');
  END IF;

  SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_EXP_PREBLOQUEO_GENCAT' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA > 0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_EXP_PREBLOQUEO_GENCAT...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_EXP_PREBLOQUEO_GENCAT';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_EXP_PREBLOQUEO_GENCAT... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_EXP_PREBLOQUEO_GENCAT...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_EXP_PREBLOQUEO_GENCAT
      AS
       SELECT cmg.ACT_ID, cmg.CMG_ID, cmg.CMG_FECHA_COMUNICACION, cmg.CMG_FECHA_SANCION,
        ecg.DD_ECG_CODIGO,san.DD_SAN_CODIGO,ofg.OFR_ID
        ,ofg.OFG_IMPORTE, tpe.DD_TPE_CODIGO, sip.DD_SIP_CODIGO, cmg.CMG_FECHA_ANULACION
        from '|| V_ESQUEMA ||'.ACT_CMG_COMUNICACION_GENCAT cmg
        left join '|| V_ESQUEMA ||'.DD_ECG_ESTADO_COM_GENCAT ecg ON cmg.DD_ecg_id =ecg.DD_ECG_ID
        left join '|| V_ESQUEMA ||'.DD_SAN_SANCION san ON cmg.DD_SAN_ID = san.DD_SAN_ID
        join '|| V_ESQUEMA ||'.ACT_OFG_OFERTA_GENCAT ofg on cmg.CMG_ID = ofg.CMG_ID
        join '|| V_ESQUEMA ||'.DD_TPE_TIPO_PERSONA tpe on tpe.dd_tpe_id = ofg.DD_TPE_ID and ofg.DD_TPE_ID is not null
        left join '|| V_ESQUEMA ||'.DD_SIP_SITUACION_POSESORIA sip on sip.DD_SIP_ID = ofg.dd_sip_id
        order by cmg.CMG_FECHA_COMUNICACION desc';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_EXP_PREBLOQUEO_GENCAT...Creada OK');
  
END;
/

EXIT;