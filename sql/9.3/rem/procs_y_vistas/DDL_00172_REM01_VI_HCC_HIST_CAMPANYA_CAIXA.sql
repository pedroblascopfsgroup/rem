--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15082
--## PRODUCTO=NO
--## Finalidad: DDL          
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Cambio lógica merge, tener en cuenta el tiempo de cosecha - [HREOS-14674] - Alejandra García
--##        0.2 Cambio lógica merge - [HREOS-15082] - Alejandra García
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
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_HCC_HIST_CAMPANYA_CAIXA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_HCC_HIST_CAMPANYA_CAIXA...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_HCC_HIST_CAMPANYA_CAIXA';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_HCC_HIST_CAMPANYA_CAIXA... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_HCC_HIST_CAMPANYA_CAIXA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_HCC_HIST_CAMPANYA_CAIXA...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_HCC_HIST_CAMPANYA_CAIXA';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_HCC_HIST_CAMPANYA_CAIXA... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_HCC_HIST_CAMPANYA_CAIXA...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_HCC_HIST_CAMPANYA_CAIXA (
                           ACT_ID
                          ,ID_CAMPANYA_VENTA
                          ,ID_CAMPANYA_ALQUILER
                      )AS
                      WITH FECHA_FIN_MINIMA AS(
                          SELECT
                               ACT_ID 
                              ,TIPOLOGIA
                              ,MIN(FECHA_FIN_FASE + TIEMPO_COSECHA) FECHA_FIN_COSECHA
                          FROM '|| V_ESQUEMA ||'.HCC_HIST_CAMPANYA_CAIXA
                          WHERE SYSDATE BETWEEN FECHA_INICIO_FASE AND FECHA_FIN_FASE + TIEMPO_COSECHA
                          AND BORRADO=0
                          GROUP BY ACT_ID, TIPOLOGIA
                      ),CAMPANYAS AS (
                          SELECT DISTINCT
                               MINIM.ACT_ID
                              ,HCC.ID_CAMPANYA
                              ,HCC.TIPOLOGIA
                              ,HCC.HCC_ID
                          FROM FECHA_FIN_MINIMA MINIM
                          JOIN '|| V_ESQUEMA ||'.HCC_HIST_CAMPANYA_CAIXA HCC ON MINIM.ACT_ID=HCC.ACT_ID AND HCC.FECHA_FIN_FASE + HCC.TIEMPO_COSECHA = MINIM.FECHA_FIN_COSECHA
                          WHERE  HCC.BORRADO=0
                      )
                      SELECT DISTINCT
                          MINIM.ACT_ID AS ACT_ID
                          ,CAMP1.ID_CAMPANYA AS ID_CAMPANYA_VENTA
                          ,CAMP2.ID_CAMPANYA AS ID_CAMPANYA_ALQUILER
                      FROM FECHA_FIN_MINIMA MINIM
                      JOIN '|| V_ESQUEMA ||'.HCC_HIST_CAMPANYA_CAIXA HCC ON MINIM.ACT_ID=HCC.ACT_ID
                      LEFT JOIN CAMPANYAS CAMP1 ON CAMP1.ACT_ID=HCC.ACT_ID AND UPPER(CAMP1.TIPOLOGIA)=''VENTA''
                      LEFT JOIN CAMPANYAS CAMP2 ON CAMP2.ACT_ID=HCC.ACT_ID AND UPPER(CAMP2.TIPOLOGIA)=''ALQUILER''
                      WHERE HCC.BORRADO=0
                      ';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_HCC_HIST_CAMPANYA_CAIXA...Creada OK');

  COMMIT;
  

  EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;