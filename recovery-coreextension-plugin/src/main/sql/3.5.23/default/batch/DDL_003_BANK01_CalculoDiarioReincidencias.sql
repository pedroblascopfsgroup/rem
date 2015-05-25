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

CREATE OR REPLACE PROCEDURE CALCULO_DIARIO_REINCID_CNT(FECHA_PROCESO IN VARCHAR2) IS

  V_ESQUEMA VARCHAR(30) := '#ESQUEMA#';

  V_COUNT NUMBER(3);
  V_SIGUIENTE_DIA NUMBER(10,0) := 0;

  TYPE CUR_TYP IS REF CURSOR;
  CURSOR_SQL CUR_TYP;
  V_SQL VARCHAR2(4000);

  V_OK BOOLEAN := TRUE;

BEGIN

  -- EXTRACCIÓN DE LOS DÍAS PROCESADOS
  DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO DIARIO DE EXTRACCIÓN DE DATOS DE REINCIDENCIAS DE CONTRATOS --- FECHA_PROCESO: ' || FECHA_PROCESO);

  -- comprobar si existe FECHA_PROCESO en dpr_fecha_extraccion
  V_SQL := 'select count(1) from ' || V_ESQUEMA || '.dpr_fecha_extraccion ' ||
  	'where dpr_fecha_extraccion=to_date(''' || FECHA_PROCESO || ''',''dd/mm/yyyy'')';

  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

  -- SI existe fecha proceso, terminar 
  IF V_COUNT > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[ERROR] FECHA YA PROCESADA --- FECHA_PROCESO: ' || FECHA_PROCESO);
  	V_OK := FALSE;
  END IF;

  IF V_OK THEN
    -- NO EXISTE FECHA_PROCESO, OBTENER NUEVO CREAR REGISTRO Y CONTINUAR
    V_SQL := 'select max(dpr_num_dia) + 1 from ' || V_ESQUEMA || '.dpr_fecha_extraccion';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_SIGUIENTE_DIA;
    DBMS_OUTPUT.PUT_LINE('NUEVO NÚMERO DE DÍA: ' || V_SIGUIENTE_DIA);
    
    V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.dpr_fecha_extraccion (DPR_NUM_DIA, DPR_FECHA_EXTRACCION)' ||
      ' VALUES (' || V_SIGUIENTE_DIA || ', to_date(''' || FECHA_PROCESO || ''',''dd/mm/yyyy''))';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;
    
    -- UPDATE QUE INCREMENTA EL CONTADOR DE REINCIDENCIAS PARA LOS SCRIPTS QUE YA EXISTÍAN
    DBMS_OUTPUT.PUT_LINE('UPDATE QUE INCREMENTA EL CONTADOR DE REINCIDENCIAS PARA LOS SCRIPTS QUE YA EXISTÍAN');
    V_SQL := 'UPDATE ' || V_ESQUEMA || '.ACN_ANTECED_CONTRATOS ' ||
      ' SET ACN_NUM_REINCIDEN=ACN_NUM_REINCIDEN+1 ' ||
      ' WHERE CNT_ID IN ' ||
      ' (select cnt_id from ' || V_ESQUEMA || '.mov_movimientos ' ||
      '  where mov_fecha_extraccion=to_date(''' || FECHA_PROCESO || ''',''dd/mm/yyyy'') and ' ||
      '  mov_deuda_irregular>0 and ' ||
      '  cnt_id not IN ' ||
      '  (select cnt_id from bank01.TMP_CNT_IRREGULAR_FECHA t where t.dpr_num_dia=' || (V_SIGUIENTE_DIA-1) ||')' ||
      '  AND cnt_id IN ' ||
      '  (select cnt_id from bank01.TMP_CNT_IRREGULAR_FECHA t))';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;

    -- INSERT CUANDO NO HABÍA REGISTROS PREVIOS DEL DÍA FECHA_PROCESO EN ACN_ANTECED_CONTRATO
    DBMS_OUTPUT.PUT_LINE('INSERT CUANDO NO HABÍA REGISTROS PREVIOS DEL DÍA FECHA_PROCESO EN ACN_ANTECED_CONTRATO');
    V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.ACN_ANTECED_CONTRATOS ' ||
      '(CNT_ID, ACN_NUM_REINCIDEN, USUARIOCREAR, FECHACREAR)  ' ||
      'SELECT cnt_id,1,''DIARIO'',SYSDATE from ' || V_ESQUEMA || '.mov_movimientos ' ||
      'where mov_fecha_extraccion=to_date(''' || FECHA_PROCESO || ''',''dd/mm/yyyy'') and ' ||
      '    mov_deuda_irregular>0 and ' ||
      '    cnt_id not IN  ' ||
      '    (select cnt_id from bank01.TMP_CNT_IRREGULAR_FECHA t)';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;

    -- INSERTAR EN TMP_CNT_IRREGULAR_FECHA los registros de MOV_MOVIMIENTOS con MOV_FECHA_EXTRACCION=FECHA_PROCESO y MOV_DEUDA_IRREGULAR>0
    DBMS_OUTPUT.PUT_LINE('INSERTAR EN TMP_CNT_IRREGULAR_FECHA los registros de MOV_MOVIMIENTOS con MOV_FECHA_EXTRACCION=FECHA_PROCESO y MOV_DEUDA_IRREGULAR>0');
    V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.TMP_CNT_IRREGULAR_FECHA (CNT_ID, DPR_NUM_DIA) ' ||
      'SELECT M.CNT_ID, ' || V_SIGUIENTE_DIA || ' ' ||
      'FROM BANK01.MOV_MOVIMIENTOS M  ' ||
      'WHERE M.MOV_DEUDA_IRREGULAR>0 AND  ' ||
      'M.MOV_FECHA_EXTRACCION=to_date(''' || FECHA_PROCESO || ''',''dd/mm/yyyy'') ' ||
      'ORDER BY M.CNT_ID';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] PROCESO DIARIO DE EXTRACCIÓN DE DATOS DE REINCIDENCIAS DE CONTRATOS');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FINAL ERRONEO] PROCESO DIARIO DE EXTRACCIÓN DE DATOS DE REINCIDENCIAS DE CONTRATOS');
  END IF;

  EXCEPTION
       WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN: '||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            
            ROLLBACK;
            RAISE;

END;

EXIT