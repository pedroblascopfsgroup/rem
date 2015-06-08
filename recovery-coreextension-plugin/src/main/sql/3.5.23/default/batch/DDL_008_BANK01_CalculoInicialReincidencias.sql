--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150519
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.0.1-rc07-bk
--## INCIDENCIA_LINK=BKFTRES-30
--## PRODUCTO=SI
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET SERVEROUTPUT ON; 

CREATE OR REPLACE PROCEDURE CALCULO_INICIAL_REINCID_CNT IS

  V_ESQUEMA VARCHAR(30) := '#ESQUEMA#';
  V_SQL VARCHAR2(4000);

  V_CNT_ID_ANTERIOR NUMBER(16,0) := 0;
  V_DIA_ANTERIOR NUMBER(10,0) := 0;

  V_NUM_REINCID NUMBER(10,0) := 0;

  V_SQL_CURSOR VARCHAR2(4000);
  TYPE CUR_TYP IS REF CURSOR;
  CONTRATOS CUR_TYP;
  TYPE CNT_TYP IS RECORD (DPR_NUM_DIA NUMBER(10,0),CNT_ID NUMBER(16,0));
  CNT CNT_TYP;

  V_FECHA_INICIO VARCHAR2(30) := '01/01/2015';

BEGIN

  -- EXTRACCIÓN DE LOS DÍAS PROCESADOS
  DBMS_OUTPUT.PUT_LINE('[INICIO] EXTRACCIÓN DE LOS DÍAS PROCESADOS');
  V_SQL := 'DELETE FROM ' || V_ESQUEMA || '.DPR_FECHA_EXTRACCION';
  EXECUTE IMMEDIATE V_SQL;
  V_SQL := 'INSERT INTO BANK01.DPR_FECHA_EXTRACCION ' || 
    'SELECT ROWNUM, AUX.* FROM ' ||
    '(SELECT DISTINCT MOV_FECHA_EXTRACCION FROM BANK01.H_MOV_MOVIMIENTOS ' ||
    ' WHERE MOV_FECHA_EXTRACCION>=to_date(''' || V_FECHA_INICIO || ''',''dd/mm/yyyy'') ' ||
    ' ORDER BY mov_fecha_extraccion) AUX';
  EXECUTE IMMEDIATE V_SQL;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] EXTRACCIÓN DE LOS DÍAS PROCESADOS');

  -- CUMPLIMENTACIÓN DE LA TABLA TEMPORAL CON CNT_IS Y NÚMERO DE DÍA
  DBMS_OUTPUT.PUT_LINE('[INICIO] CUMPLIMENTACIÓN DE LA TABLA TEMPORAL CON CNT_IS Y NÚMERO DE DÍA');
  V_SQL := 'DELETE FROM ' || V_ESQUEMA || '.TMP_CNT_IRREGULAR_FECHA';
  EXECUTE IMMEDIATE V_SQL;
  V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.TMP_CNT_IRREGULAR_FECHA (CNT_ID, DPR_NUM_DIA)' ||
    ' SELECT HM.CNT_ID, DPR.DPR_NUM_DIA FROM ' || V_ESQUEMA || '.H_MOV_MOVIMIENTOS HM ' ||
    ' INNER JOIN ' || V_ESQUEMA || '.DPR_FECHA_EXTRACCION DPR ' || 
    ' ON DPR.DPR_FECHA_EXTRACCION=HM.MOV_FECHA_EXTRACCION ' ||
    ' WHERE HM.MOV_DEUDA_IRREGULAR>0 ' ||
    ' ORDER BY HM.CNT_ID, DPR.DPR_NUM_DIA';
  EXECUTE IMMEDIATE V_SQL;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] CUMPLIMENTACIÓN DE LA TABLA TEMPORAL CON CNT_IS Y NÚMERO DE DÍA');


  DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO CARGA REINCIDENCIAS DE CONTRATOS');

  V_SQL := 'DELETE FROM ' || V_ESQUEMA || '.ACN_ANTECED_CONTRATOS';
  EXECUTE IMMEDIATE V_SQL;

  V_SQL_CURSOR := 'SELECT DPR_NUM_DIA,CNT_ID FROM ' || V_ESQUEMA || '.TMP_CNT_IRREGULAR_FECHA ORDER BY CNT_ID,DPR_NUM_DIA';
  OPEN CONTRATOS FOR V_SQL_CURSOR;

     LOOP
        FETCH CONTRATOS INTO CNT;
        EXIT WHEN CONTRATOS%NOTFOUND;
        IF CNT.CNT_ID <> V_CNT_ID_ANTERIOR THEN
           IF V_NUM_REINCID > 0 THEN
              V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.ACN_ANTECED_CONTRATOS ' || 
                ' (CNT_ID, ACN_NUM_REINCIDEN, USUARIOCREAR, FECHACREAR) VALUES ' || 
                ' (' || V_CNT_ID_ANTERIOR || ',' || V_NUM_REINCID || ',''IMPORT'', SYSDATE)';
              EXECUTE IMMEDIATE V_SQL;
              --DBMS_OUTPUT.PUT_LINE(V_SQL);
              DBMS_OUTPUT.PUT_LINE('=== CNT_ID: ' || V_CNT_ID_ANTERIOR || ' - V_NUM_REINCID: ' || V_NUM_REINCID);
           END IF;
           V_NUM_REINCID := 1; 
        ELSE
           IF CNT.DPR_NUM_DIA > (V_DIA_ANTERIOR + 1) THEN
              V_NUM_REINCID := V_NUM_REINCID + 1;
           END IF;
        END IF;
        V_CNT_ID_ANTERIOR := CNT.CNT_ID;
        V_DIA_ANTERIOR := CNT.DPR_NUM_DIA;
     END LOOP;

  CLOSE CONTRATOS;

  IF V_NUM_REINCID > 0 THEN
      V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.ACN_ANTECED_CONTRATOS ' || 
        ' (CNT_ID, ACN_NUM_REINCIDEN, USUARIOCREAR, FECHACREAR) VALUES ' || 
        ' (' || V_CNT_ID_ANTERIOR || ',' || V_NUM_REINCID || ',''IMPORT'', SYSDATE)';
      EXECUTE IMMEDIATE V_SQL;
      --DBMS_OUTPUT.PUT_LINE(V_SQL);
      DBMS_OUTPUT.PUT_LINE('=== CNT_ID: ' || V_CNT_ID_ANTERIOR || ' - V_NUM_REINCID: ' || V_NUM_REINCID);
  END IF;

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN] PROCESO CARGA REINCIDENCIAS DE CONTRATOS');

  EXCEPTION
       WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN: '||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            
            ROLLBACK;
            RAISE;

END;
/

EXIT 
