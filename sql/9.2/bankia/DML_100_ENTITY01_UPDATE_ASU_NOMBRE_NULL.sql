--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERÁ
--## FECHA_CREACION=20160708
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-706
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza ASU_ASUNTOS.ASU_NOMBRE Y PCO_PRC_PROCEDIMIENTOS.PCO_PRC_NOM_EXP_JUD cuando tiene valor NULL.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    CURSOR CUR IS 
    select tmp_asu.asu_id, substr(tmp_asu.ASU_ID_EXTERNO || ' | ' || tmp_asu.nom_persona,1,50) nuevo_nombre from
	(
	  select distinct asu.asu_id, ASU.ASU_ID_EXTERNO , tmp_per.nom_persona, TMP_DEUDA.cnt_id, TMP_DEUDA.deuda, ROW_NUMBER () OVER (PARTITION BY asu.asu_id ORDER BY TMP_DEUDA.deuda DESC) num_fila
			from #ESQUEMA#.cnt_contratos cnt
			inner join #ESQUEMA#.cex_contratos_expediente cex on cex.cnt_id=cnt.cnt_id
			inner join #ESQUEMA#.prc_cex pc on pc.cex_id=cex.cex_id
			inner join #ESQUEMA#.prc_procedimientos prc on prc.prc_id=pc.prc_id
			inner join #ESQUEMA#.asu_asuntos asu on asu.asu_id=prc.asu_id
			inner join ( SELECT CNT_ID,(MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA + MOV_INT_REMUNERATORIOS + MOV_INT_MORATORIOS + MOV_GASTOS + MOV_COMISIONES + MOV_IMPUESTOS) DEUDA 
					  FROM (SELECT mov.CNT_ID ,ROW_NUMBER () OVER (PARTITION BY mov.cnt_id ORDER BY mov.mov_fecha_extraccion DESC) rn , MOV.MOV_POS_VIVA_NO_VENCIDA,MOV.MOV_POS_VIVA_VENCIDA ,MOV.MOV_INT_REMUNERATORIOS ,MOV.MOV_INT_MORATORIOS , MOV.MOV_GASTOS ,MOV.MOV_COMISIONES ,MOV.MOV_IMPUESTOS 
							  FROM #ESQUEMA#.MOV_MOVIMIENTOS mov) tmp_mov 
					  WHERE rn = 1) TMP_DEUDA 
				  on tmp_deuda.cnt_id=cnt.cnt_id
			inner join ( SELECT /*+ MATERIALIZE */ (PER_DOC_ID || ' ' || PER_NOMBRE || ' ' || PER_APELLIDO1 || ' ' || PER_APELLIDO2) NOM_PERSONA, CNT_ID
					  FROM  (SELECT PER.PER_DOC_ID, PER.PER_NOMBRE, PER.PER_APELLIDO1, PER.PER_APELLIDO2, ROW_NUMBER() OVER (PARTITION BY CPE.CNT_ID ORDER BY CPE.CPE_ORDEN ASC) RN_MIN_ORDEN, CPE.CNT_ID 
							  FROM #ESQUEMA#.CPE_CONTRATOS_PERSONAS CPE 
							  INNER JOIN #ESQUEMA#.DD_TIN_TIPO_INTERVENCION TIN ON CPE.DD_TIN_ID = TIN.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1 
							  INNER JOIN #ESQUEMA#.PER_PERSONAS PER ON CPE.PER_ID = PER.PER_ID) 
					  WHERE RN_MIN_ORDEN = 1) tmp_per 
				  on tmp_per.cnt_id=cnt.cnt_id                
			where asu.asu_nombre is null or asu.asu_nombre like '%null%'
			ORDER BY asu.asu_id, TMP_DEUDA.cnt_id, TMP_DEUDA.deuda desc
		) tmp_asu
		where num_fila=1;
	
	R_ASUNTO CUR%ROWTYPE;
	
	CURSOR CUR_PRC_PER IS
	select tmp_asu.asu_id, substr(tmp_asu.ASU_ID_EXTERNO || ' | ' || tmp_asu.nom_persona,1,50) nuevo_nombre from
	(
		select distinct asu.asu_id, asu.asu_id_externo, (per.PER_DOC_ID||' '||per.PER_NOMBRE||' '||per.PER_APELLIDO1||' '||per.PER_APELLIDO2) NOM_PERSONA, ROW_NUMBER () OVER (PARTITION BY asu.asu_id ORDER BY per.PER_ID DESC) num_fila
			from  #ESQUEMA#.asu_asuntos asu		
			inner join  #ESQUEMA#.prc_procedimientos prc on asu.asu_id=prc.asu_id
			inner join  #ESQUEMA#.prc_per pp on pp.PRC_ID = prc.PRC_ID
			inner join  #ESQUEMA#.per_personas per on per.PER_ID = pp.PER_ID                
		where asu.asu_nombre is null or asu.asu_nombre like '%null%'
		ORDER BY asu.asu_id desc
    ) tmp_asu
	where num_fila=1; 
	
	R_ASUNTO_PRC_PER CUR_PRC_PER%ROWTYPE;
    
BEGIN		
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... UPDATEANDO ASU_ASUNTOS.ASU_NOMBRE Y PCO_PRC_PROCEDIMIENTOS.PCO_PRC_NOM_EXP_JUD WHERE IS NULL');
	
	--PARA ASU_ASUNTOS QUE SÍ TIENEN CONTRATOS CON PERSONAS ASOCIADAS.
	DBMS_OUTPUT.PUT_LINE('[CURSOR] ASUNTOS CON CONTRATOS CON PERSONAS ASOCIADAS');
	
	OPEN CUR;
	
	LOOP
	FETCH CUR INTO R_ASUNTO;
	EXIT WHEN CUR%NOTFOUND;
	
		DBMS_OUTPUT.PUT_LINE('[UPDATE] '||V_ESQUEMA||'... asu_id:'||R_ASUNTO.asu_id||' asu_nombre:'||R_ASUNTO.nuevo_nombre);
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ASU_ASUNTOS
			SET ASU_NOMBRE='''||R_ASUNTO.nuevo_nombre||''', USUARIOMODIFICAR =''RECOV-706'', FECHAMODIFICAR = sysdate
			WHERE ASU_ID ='||R_ASUNTO.asu_id; 
		
		--DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
	
	END LOOP;
	
	CLOSE CUR;
	
	DBMS_OUTPUT.PUT_LINE('[FIN CURSOR] ASUNTOS CON CONTRATOS CON PERSONAS ASOCIADAS');
	
	--PARA ASU_ASUNTOS QUE NO TIENEN CONTRATOS CON PERSONAS ASOCIADAS COGE EL NOMBRE DE LA PERSONA DE LOS DEMANDADOS DEL PROCEDIMIENTO (DE PRC_PER) EN LUGAR DE IR A TRAVÉS DEL CONTRATO.
	DBMS_OUTPUT.PUT_LINE('[CURSOR] ASUNTOS SIN CONTRATOS CON PERSONAS ASOCIADAS');
	
	OPEN CUR_PRC_PER;
	
	LOOP
	FETCH CUR_PRC_PER INTO R_ASUNTO_PRC_PER;
	EXIT WHEN CUR_PRC_PER%NOTFOUND;
	
		DBMS_OUTPUT.PUT_LINE('[UPDATE] '||V_ESQUEMA||'... asu_id:'||R_ASUNTO_PRC_PER.asu_id||' asu_nombre:'||R_ASUNTO_PRC_PER.nuevo_nombre);
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ASU_ASUNTOS
			SET ASU_NOMBRE='''||R_ASUNTO_PRC_PER.nuevo_nombre||''', USUARIOMODIFICAR =''RECOV-706'', FECHAMODIFICAR = sysdate
			WHERE ASU_ID ='||R_ASUNTO_PRC_PER.asu_id; 
		
		--DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
	
	END LOOP;
	
	CLOSE CUR_PRC_PER;
	
	DBMS_OUTPUT.PUT_LINE('[FIN CURSOR] ASUNTOS SIN CONTRATOS CON PERSONAS ASOCIADAS');

    -- UPDATEO PCO_PRC_PROCEDIMIENTOS.PCO_PRC_NOM_EXP_JUD CON ASU_ASUNTOS.ASU_NOMBRE.
    
    DBMS_OUTPUT.PUT_LINE('[UPDATE] PCO_PRC_PROCEDIMIENTOS.PCO_PRC_NOM_EXP_JUD CON ASU_ASUNTOS.ASU_NOMBRE');
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
			SET PCO.PCO_PRC_NOM_EXP_JUD = (SELECT ASU.ASU_NOMBRE ||''-Preparación de expediente judicial'' 
												FROM '||V_ESQUEMA||'.ASU_ASUNTOS ASU 
												INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON (PRC.ASU_ID = ASU.ASU_ID)
												WHERE PCO.PRC_ID = PRC.PRC_ID AND ASU.ASU_NOMBRE NOT LIKE ''%null%'' AND ASU.ASU_NOMBRE IS NOT NULL),
			USUARIOMODIFICAR = ''RECOV-706'', FECHAMODIFICAR = sysdate
			WHERE PCO.PCO_PRC_NOM_EXP_JUD LIKE ''%null%'' OR PCO.PCO_PRC_NOM_EXP_JUD IS NULL OR INSTR(PCO.PCO_PRC_NOM_EXP_JUD,''-'',1,1) = 1'; 
		
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
    
    -- UPDATEO PCO_PRC_PROCEDIMIENTOS.PCO_PRC_NOM_EXP_JUD CON EXP_EXPEDIENTES.EXP_DESCRIPCION.
    
    DBMS_OUTPUT.PUT_LINE('[UPDATE] PCO_PRC_PROCEDIMIENTOS.PCO_PRC_NOM_EXP_JUD CON EXP_EXPEDIENTES.EXP_DESCRIPCION');
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
			SET PCO.PCO_PRC_NOM_EXP_JUD = (SELECT EXP.EXP_DESCRIPCION ||''-Preparación de expediente judicial''
											  FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
											  INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON (PRC.ASU_ID = ASU.ASU_ID)
											  INNER JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON (ASU.EXP_ID = EXP.EXP_ID)
											  WHERE PCO.PRC_ID = PRC.PRC_ID AND EXP.EXP_DESCRIPCION NOT LIKE ''%null%'' AND EXP.EXP_DESCRIPCION IS NOT NULL),
			USUARIOMODIFICAR = ''RECOV-706'', FECHAMODIFICAR = sysdate
			WHERE PCO.PCO_PRC_NOM_EXP_JUD LIKE ''%null%'' OR PCO.PCO_PRC_NOM_EXP_JUD IS NULL OR INSTR(PCO.PCO_PRC_NOM_EXP_JUD,''-'',1,1) = 1'; 
		
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
		
	COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... UPDATEADO ASU_ASUNTOS.ASU_NOMBRE Y PCO_PRC_PROCEDIMIENTOS.PCO_PRC_NOM_EXP_JUD');
    
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
