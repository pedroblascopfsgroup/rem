--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150519
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.0.1-rc11-bk
--## INCIDENCIA_LINK=BCFI-627
--## PRODUCTO=NO
--##
--## Finalidad: Modificar el procedimiento PREPROCESADO_COBROS_FACT para que coja como fecha del cobro el campo
--## 			CPA_FECHA_VALOR en lugar del campo CPA_FECHA_MOVIMIENTO ambos de la tabla CPA_COBROS_PAGOS
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
v_schema   VARCHAR(25) := '#ESQUEMA#';
v_schema_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN



DBMS_OUTPUT.PUT_LINE('[START] Alterar procedimiento PREPROCESADO_COBROS_FACT');

EXECUTE IMMEDIATE '
	CREATE OR REPLACE PROCEDURE '||v_schema||'.PREPROCESADO_COBROS_FACT AS
	  V_LAST_BATCH_EXECUTION DATE;
	  V_LAST_DATE_PREPROCESS DATE;
	BEGIN
	  V_LAST_BATCH_EXECUTION := SYSDATE-1;
	
	  SELECT TRUNC(MAX(CCR_FECHA)) INTO V_LAST_DATE_PREPROCESS FROM '||v_schema||'.CCR_CONTROL_COBROS_RECOBRO;
	  IF (V_LAST_DATE_PREPROCESS IS NULL) THEN
	    SELECT SYSDATE-1 INTO V_LAST_DATE_PREPROCESS FROM DUAL;
	  END IF;
	  DBMS_OUTPUT.PUT_LINE(''Ultima fecha preprocesado Cobros: ''||V_LAST_DATE_PREPROCESS);
	
	  V_LAST_DATE_PREPROCESS := V_LAST_DATE_PREPROCESS + 1;
	  WHILE (V_LAST_DATE_PREPROCESS <= V_LAST_BATCH_EXECUTION)
	  LOOP
	    DBMS_OUTPUT.PUT_LINE(''Procesando cobros del dia: ''|| V_LAST_DATE_PREPROCESS);
	
	    INSERT INTO '||v_schema||'.CPR_COBROS_PAGOS_RECOBRO
	      (CPR_ID, CPA_ID, CPA_FECHA, CNT_ID, EXP_ID, RCF_AGE_ID, RCF_SCA_ID, FECHA_INI_IRREGU, FECHA_POS_VENCIDA)
	    WITH DIAS AS (
	      SELECT /*+ MATERIALIZE */ DISTINCT TRUNC(FECHA_HIST) FECHA_HIST FROM '||v_schema||'.H_REC_FICHERO_CONTRATOS WHERE TRUNC(FECHA_HIST) <> TO_DATE(''14/11/2014'',''dd/MM/yyyy''))
	    ,CPA_FECHA_HIST AS (
	      SELECT /*+ MATERIALIZE */ CPA.CPA_ID, MAX(TRUNC(D.FECHA_HIST)) FECHA_REPARTO
	      FROM '||v_schema||'.CPA_COBROS_PAGOS CPA
	        JOIN DIAS D ON TRUNC(CPA.CPA_FECHA_VALOR) >= TRUNC(D.FECHA_HIST)
	      WHERE TRUNC(CPA.CPA_FECHA_EXTRACCION) = TRUNC(V_LAST_DATE_PREPROCESS)
	      GROUP BY CPA.CPA_ID)
      ,VALORES AS (
        SELECT /*+ MATERIALIZE */ DISTINCT	    
	      CPA.CPA_ID,
	      CPA_FECHA_VALOR,
	      CPA.CNT_ID, CRE.EXP_ID, HREC.RCF_AGE_ID, CRE.RCF_SCA_ID,
	      HREC.FECHA_INI_IRREGU, HREC.FECHA_POS_VENCIDA
	    FROM '||v_schema||'.CPA_COBROS_PAGOS CPA
	      INNER JOIN CPA_FECHA_HIST ON CPA.CPA_ID = CPA_FECHA_HIST.CPA_ID
	      INNER JOIN '||v_schema||'.H_REC_FICHERO_CONTRATOS HREC ON CPA.CNT_ID = SUBSTR(HREC.ID_ENVIO,9)
	          AND TRUNC(HREC.FECHA_HIST) =  TRUNC(CPA_FECHA_HIST.FECHA_REPARTO)
	      INNER JOIN '||v_schema||'.CRC_CICLO_RECOBRO_CNT CRC ON CPA.CNT_ID = CRC.CNT_ID
	        AND HREC.ID_ENVIO = CRC.CRC_ID_ENVIO
	        AND TRUNC(CPA.CPA_FECHA_VALOR)  BETWEEN TRUNC(CRC.CRC_FECHA_ALTA) AND (TRUNC(NVL(CRC.CRC_FECHA_BAJA,SYSDATE))-1)
	        AND CRC.BORRADO = 0
	      INNER JOIN '||v_schema||'.CRE_CICLO_RECOBRO_EXP CRE ON CRC.CRE_ID = CRE.CRE_ID
	        AND CRE.RCF_SCA_ID = HREC.RCF_SCA_ID AND CRE.RCF_AGE_ID = HREC.RCF_AGE_ID
	        AND CRE.BORRADO = 0
	    WHERE CPA.BORRADO = 0 AND CPA.CPA_COBRO_FACTURABLE = 1 AND TRUNC(CPA.CPA_FECHA_EXTRACCION) = V_LAST_DATE_PREPROCESS)
      SELECT '||v_schema||'.S_CPR_COBROS_PAGOS_RECOBRO.NEXTVAL CPR_ID, VALORES.*
      FROM VALORES;
	
	    INSERT INTO '||v_schema||'.CCR_CONTROL_COBROS_RECOBRO (CCR_ID, CCR_FECHA)
	    VALUES ('||v_schema||'.S_CCR_CONTROL_COBROS_RECOBRO.NEXTVAL, V_LAST_DATE_PREPROCESS);
	
	    V_LAST_DATE_PREPROCESS:=V_LAST_DATE_PREPROCESS + 1;
	
	    COMMIT;
	  END LOOP;
	EXCEPTION
	  WHEN OTHERS THEN
	    DBMS_OUTPUT.PUT_LINE(''ERROR: ''||TO_CHAR(SQLCODE));
	    DBMS_OUTPUT.PUT_LINE(SQLERRM);
	
	    ROLLBACK;
	    RAISE;
	END PREPROCESADO_COBROS_FACT;
';


DBMS_OUTPUT.PUT_LINE('REPLACE PROCEDURE '|| v_schema ||'.PREPROCESADO_COBROS_FACT ... OK');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT