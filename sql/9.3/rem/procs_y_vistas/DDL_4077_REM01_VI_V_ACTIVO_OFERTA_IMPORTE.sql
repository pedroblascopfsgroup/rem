--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20210609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1849
--## PRODUCTO=NO
--## Finalidad: DDL
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 REMVIP-9909 - Carlos Santos Vílchez
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

    CUENTA NUMBER;

BEGIN

-- Modificación de la vista V_ACTIVO_OFERTA_IMPORTE de Fase1.

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVO_OFERTA_IMPORTE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVO_OFERTA_IMPORTE...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_ACTIVO_OFERTA_IMPORTE';
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVO_OFERTA_IMPORTE... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVO_OFERTA_IMPORTE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVO_OFERTA_IMPORTE...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ACTIVO_OFERTA_IMPORTE';
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVO_OFERTA_IMPORTE... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVO_OFERTA_IMPORTE...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVO_OFERTA_IMPORTE
      AS
      SELECT ACT.ACT_ID,
      AFR.OFR_ID, 
      AFR.ACT_OFR_IMPORTE, 
      AFR.OFR_ACT_PORCEN_PARTICIPACION, 
      ACT.ACT_NUM_ACTIVO,
      AFR.ACT_ID||AFR.OFR_ID AS ID_VISTA
      FROM '|| V_ESQUEMA ||'.ACT_OFR AFR
      JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON AFR.ACT_ID = ACT.ACT_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVO_OFERTA_IMPORTE...Creada OK');

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
