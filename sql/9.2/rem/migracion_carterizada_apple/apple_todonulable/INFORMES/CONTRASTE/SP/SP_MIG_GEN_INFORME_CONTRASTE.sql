CREATE OR REPLACE PROCEDURE SP_MIG_GEN_INFORME_CONTRASTE ( USUARIO_MIGRACION VARCHAR2 ) AUTHID CURRENT_USER IS

    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    vInterfaz VARCHAR2(50 CHAR);
    vTablaMig VARCHAR2(50 CHAR);
    vTablaModelo VARCHAR2(50 CHAR);
    vRegistrosEntrada NUMBER(16);
    vResultado NUMBER(16);
    vAuditoria NUMBER(1);
    
    CURSOR TABLES_CURSOR IS 
    SELECT DISTINCT INF.INTERFAZ, REL.TABLA_MIG, REL.TABLA_MODELO, REL.TABLA_MODELO_AUDITORIA, INF.REGISTROS_ENTRADA
    FROM REM01.MIG2_INFORME_CONTRASTE INF 
    INNER JOIN REM01.MIG2_RELACION_DAT_MIG_MODELO REL ON REL.FICHERO_DAT = INF.INTERFAZ
    ORDER BY INF.INTERFAZ
    ;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    ------------------------------------------------------------------------------------------------------------------------------------
    --CASO GENÉRICO. Calculamos los registros migrados en FaseB de aquellas tablas que tengas audiatoría (usuariocrear).
    ------------------------------------------------------------------------------------------------------------------------------------
    OPEN TABLES_CURSOR;
    LOOP
        FETCH TABLES_CURSOR INTO vInterfaz, vTablaMig, vTablaModelo, vAuditoria, vRegistrosEntrada;
        EXIT WHEN TABLES_CURSOR%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('  [INFO] Actualizando volumetrias de la interfaz : '||vInterfaz||'...');
      
        V_MSQL := '
          UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE SET 
            REGISTROS_RECHAZADOS = (SELECT '||vRegistrosEntrada||' - (SELECT COUNT(1) FROM '||vTablaMig||') FROM DUAL)
            , REGISTROS_INVALIDOS = (SELECT COUNT(1) FROM '||vTablaMig||' WHERE VALIDACION > 1)
            , REGISTROS_DUPLICADOS = (SELECT COUNT(1) FROM '||vTablaMig||' WHERE VALIDACION = 1)
          WHERE INTERFAZ = '''||vInterfaz||'''
        '
        ;
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
        
        IF vAuditoria = 1 THEN
        
          V_MSQL := '
            UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
            SET REGISTROS_MIGRADOS = (SELECT COUNT(1) FROM '||vTablaModelo||' WHERE USUARIOCREAR = '''||USUARIO_MIGRACION||''')
            WHERE INTERFAZ = '''||vInterfaz||'''
          '
          ;
          --DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          
        END IF;
        
    END LOOP;
    CLOSE TABLES_CURSOR;

	------------------------------------------------------------------------------------------------------------------------------------
    --CASOS ESPECIALES. Calculamos los registros migrados en FaseB de aquellas tablas que:
    --					- No tengan auditoria
	--					- Sean updateados/insertados en varias interfaces de la faseB.
    ------------------------------------------------------------------------------------------------------------------------------------
    V_MSQL := '
            UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
            SET REGISTROS_MIGRADOS = (SELECT COUNT(1) 
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										INNER JOIN '||V_ESQUEMA||'.MIG2_ACT_ACTIVO MIG ON MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
										WHERE ACT.USUARIOMODIFICAR = '''||USUARIO_MIGRACION||'''
										  AND MIG.VALIDACION IN (0,1))
            WHERE INTERFAZ = ''ACTIVOS'' ';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
            UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
            SET REGISTROS_MIGRADOS = (SELECT COUNT(1) 
									  FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
									  INNER JOIN '||V_ESQUEMA||'.MIG2_AGR_AGRUPACIONES MIG ON AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM
									  WHERE USUARIOMODIFICAR = '''||USUARIO_MIGRACION||''')
            WHERE INTERFAZ = ''AGRUPACIONES2'' ';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := '
            UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
            SET REGISTROS_MIGRADOS =   (SELECT COUNT(1) 
										FROM  '||V_ESQUEMA||'.ACT_TBJ_TRABAJO ATR
										WHERE ATR.USUARIOCREAR = '''||USUARIO_MIGRACION||'''
										  AND ATR.FECHACREAR = (SELECT MIN(FECHACREAR)
																  FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO ATR
															INNER JOIN '||V_ESQUEMA||'.MIG_ATR_TRABAJO MIG ON ATR.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO
																 WHERE USUARIOCREAR = '''||USUARIO_MIGRACION||''')
									   )
            WHERE INTERFAZ = ''TRABAJO'' ';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET REGISTROS_MIGRADOS = (SELECT COUNT(1)
            FROM REM01.MIG_AAA_AGRUPACION_ACTIVO TP
            WHERE TP.VALIDACION = 0 AND EXISTS (
                SELECT 1
                FROM REM01.ACT_AGR_AGRUPACION T1
                JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO T3 ON T3.AGR_ID = T1.AGR_ID
                JOIN REM01.ACT_ACTIVO T2 ON T2.ACT_ID = T3.ACT_ID
                WHERE TP.ACT_NUMERO_ACTIVO = T2.ACT_NUM_ACTIVO
                    AND TP.AGR_EXTERNO = T1.AGR_NUM_AGRUP_UVEM
                    AND (T2.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T3.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T1.USUARIOCREAR = '''||USUARIO_MIGRACION||''')))
        WHERE INTERFAZ = ''AGRUPACIONES_ACTIVO'' ';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
	    UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
	    SET REGISTROS_MIGRADOS = (SELECT COUNT(1)
			FROM REM01.ACT_PRP TP
			WHERE EXISTS (
			    SELECT 1
			    FROM REM01.MIG2_ACT_PRP T1
			    JOIN REM01.ACT_ACTIVO T2 ON T2.ACT_NUM_ACTIVO = T1.ACT_PRP_ACT_NUMERO_ACTIVO
			    JOIN REM01.PRP_PROPUESTAS_PRECIOS T3 ON T3.PRP_NUM_PROPUESTA = T1.ACT_PRP_NUM_PROPUESTA
			    WHERE TP.ACT_ID = T2.ACT_ID AND TP.PRP_ID = T3.PRP_ID AND T1.VALIDACION = 0
			        AND (T2.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T3.USUARIOCREAR = '''||USUARIO_MIGRACION||''')))
	    WHERE INTERFAZ = ''ACTIVO_PROPUESTAS'' '
	;
	  --DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET REGISTROS_MIGRADOS = (SELECT COUNT(1)
            FROM REM01.MIG2_CEX_COMPRADOR_EXPEDIENTE TP
            WHERE TP.VALIDACION = 0 AND EXISTS (
                SELECT 1
                FROM REM01.CEX_COMPRADOR_EXPEDIENTE T1
                JOIN REM01.COM_COMPRADOR T2 ON T2.COM_ID = T1.COM_ID
                JOIN REM01.CLC_CLIENTE_COMERCIAL T4 ON T4.CLC_ID = T2.CLC_ID
                JOIN REM01.ECO_EXPEDIENTE_COMERCIAL T3 ON T3.ECO_ID = T1.ECO_ID
                JOIN REM01.OFR_OFERTAS T5 ON T5.OFR_ID = T3.OFR_ID
                WHERE TP.CEX_COD_OFERTA = T5.OFR_NUM_OFERTA 
                  AND (T2.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T3.USUARIOCREAR = '''||USUARIO_MIGRACION||''')))
        WHERE INTERFAZ = ''COMPRADOR_EXPEDIENTE'' ';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET REGISTROS_MIGRADOS = (  SELECT
									(SELECT COUNT(1)
									FROM REM01.MIG2_GPV_ACT_TBJ TP
									WHERE TP.VALIDACION = 0 
									AND 
									EXISTS (
											SELECT 1
											FROM REM01.GPV_ACT              T1
											JOIN REM01.GPV_GASTOS_PROVEEDOR T2 ON T2.GPV_ID = T1.GPV_ID
											JOIN REM01.ACT_ACTIVO           T3 ON T3.ACT_ID = T1.ACT_ID
											WHERE TP.GPT_ACT_NUMERO_ACTIVO = T3.ACT_NUM_ACTIVO
											  AND (T2.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T3.USUARIOCREAR = '''||USUARIO_MIGRACION||''')
									))
									+
									(SELECT COUNT(1)
									FROM REM01.MIG2_GPV_ACT_TBJ TP
									WHERE TP.VALIDACION = 0 
									AND 
									EXISTS (
											SELECT 1
											FROM REM01.GPV_TBJ              T1
											JOIN REM01.GPV_GASTOS_PROVEEDOR T2 ON T2.GPV_ID = T1.GPV_ID
											JOIN REM01.ACT_TBJ_TRABAJO      T3 ON T3.TBJ_ID = T1.TBJ_ID
											WHERE TP.GPT_TBJ_NUM_TRABAJO = T3.TBJ_NUM_TRABAJO
											  AND (T2.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T3.USUARIOCREAR = '''||USUARIO_MIGRACION||''')
									)) 
									AS CUENTA FROM DUAL )
        WHERE INTERFAZ = ''GASTOS_PROVEEDORES_ACT_TBJ'' ';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET REGISTROS_MIGRADOS = (SELECT COUNT(1)
					FROM REM01.MIG2_GEA_GESTORES_ACTIVOS TP
					WHERE TP.VALIDACION = 0 AND EXISTS (
						SELECT 1
						FROM REM01.GAC_GESTOR_ADD_ACTIVO   GAC
						JOIN REM01.GEE_GESTOR_ENTIDAD      GEE
						  ON GAC.GEE_ID = GEE.GEE_ID
						JOIN REM01.ACT_ACTIVO              ACT
						  ON GAC.ACT_ID = ACT.ACT_ID
						WHERE GEE.USUARIOCREAR = '''||USUARIO_MIGRACION||'''
						  AND TP.GEA_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO))
        WHERE INTERFAZ = ''GESTORES_ACTIVO'' ';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET REGISTROS_MIGRADOS = (SELECT COUNT(1)
            FROM REM01.MIG2_GEO_GESTORES_OFERTAS TP
            WHERE TP.VALIDACION = 0 AND EXISTS (
                SELECT 1
                FROM REM01.GCO_GESTOR_ADD_ECO T1
                JOIN REM01.ECO_EXPEDIENTE_COMERCIAL T2 ON T1.ECO_ID = T2.ECO_ID
                JOIN REM01.OFR_OFERTAS T3 ON T3.OFR_ID = T2.OFR_ID
                WHERE TP.GEE_ID = T1.GEE_ID AND TP.GEO_COD_OFERTA = T3.OFR_NUM_OFERTA
                    AND (T2.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T3.USUARIOCREAR = '''||USUARIO_MIGRACION||''')))
        WHERE INTERFAZ = ''GESTORES_OFERTAS'' ';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET REGISTROS_MIGRADOS = (SELECT COUNT(1)
            FROM REM01.MIG2_OFA_OFERTAS_ACTIVO TP
            WHERE TP.VALIDACION = 0 AND EXISTS (
                SELECT 1
                FROM REM01.ACT_OFR T1
                JOIN REM01.ACT_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
                JOIN REM01.OFR_OFERTAS T3 ON T3.OFR_ID = T1.OFR_ID
                WHERE TP.OFA_ACT_NUMERO_ACTIVO = T2.ACT_NUM_ACTIVO AND TP.OFA_COD_OFERTA = T3.OFR_NUM_OFERTA
                    AND (T2.USUARIOCREAR = '''||USUARIO_MIGRACION||''' OR T3.USUARIOCREAR = '''||USUARIO_MIGRACION||''')))
        WHERE INTERFAZ = ''OFERTAS_ACTIVO'' ';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET REGISTROS_MIGRADOS = (SELECT COUNT(1)
            FROM REM01.MIG2_USU_USUARIOS TP
            JOIN REMMASTER.USU_USUARIOS T1 ON T1.USU_USERNAME = TP.USU_USERNAME AND T1.BORRADO = 0
            WHERE TP.VALIDACION = 0)
        WHERE INTERFAZ = ''USUARIOS'' ';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    COMMIT;
    
        
    ------------------------------------------------------------------------------------------------------------------------------------
    --PARTE FINAL. Calculamos:
    --			   - Las interfaces que nos han venido vacías por migracion
    --			   - El porcentaje de registros migrados en relacion a los registros de entrada.
    --			   - Si algun campo es nulo lo convertimos a 0.
    ------------------------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE (INTERFAZ, REGISTROS_ENTRADA, REGISTROS_RECHAZADOS, REGISTROS_INVALIDOS, REGISTROS_DUPLICADOS, REGISTROS_MIGRADOS, PORCENTAJE)
        SELECT ''[ INTERFAZ NO RECIBIDA / VACIA ] - '' || REL.FICHERO_DAT , 0, 0, 0, 0, 0, 0
        FROM '||V_ESQUEMA||'.MIG2_RELACION_DAT_MIG_MODELO REL
        LEFT JOIN '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE INF ON INF.INTERFAZ = REL.FICHERO_DAT
        WHERE INF.INTERFAZ IS NULL
    ';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    
    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
        SET PORCENTAJE = ROUND((NVL(REGISTROS_MIGRADOS,0)/DECODE(REGISTROS_ENTRADA,NULL,1, 0, 1, REGISTROS_ENTRADA))*100, 2)
    ';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    EXECUTE IMMEDIATE '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE
		SET REGISTROS_ENTRADA = NVL(REGISTROS_ENTRADA, 0),
		REGISTROS_RECHAZADOS = NVL(REGISTROS_RECHAZADOS, 0),
		REGISTROS_INVALIDOS = NVL(REGISTROS_INVALIDOS, 0),
		REGISTROS_DUPLICADOS = NVL(REGISTROS_DUPLICADOS, 0),
		REGISTROS_MIGRADOS = NVL(REGISTROS_MIGRADOS, 0),
		PORCENTAJE = NVL(PORCENTAJE, 0)
    ';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    
    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE MIG2
        SET PORCENTAJE = 100
        WHERE MIG2.PORCENTAJE > 100
    ';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);

    ROLLBACK;
    RAISE;          

END;

/

EXIT
