--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180716
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-1023
--## PRODUCTO=NO
--##
--## Finalidad: Inserción de mapeo en ETG_EQV
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1023'; -- Vble. para indicar el trabajo que solicita la acción.
    V_TPR_COD VARCHAR2(50 CHAR); -- Vble. para tratar el tipo de proveedor.
    V_TPR_INS VARCHAR2(50 CHAR);
    TYPE T_ACCION IS TABLE OF VARCHAR2(500 CHAR);
    TYPE A_ACCION IS TABLE OF T_ACCION;
    V_ACCION A_ACCION := A_ACCION(
    		   --ETG_COD,COD_TGA,COD_STG,TIPO_PROVEEDOR,DESC_TIPO_GASTO                     ,COGRUG_POS,COTACA_POS,COSBAC_POS,DESC_TIPO_GASTO_NEG,COGRUG_NEG,COTACA_NEG,COSBAC_NEG
    	T_ACCION('82'   ,'17'   ,'88'   ,NULL          ,'PUBLICIDAD ACTIVOS ADJUDICADOS'    ,'3'       ,'48'      ,'7'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
    	T_ACCION('101'	,'07'	,'31'	,'1'		   ,'COMUNIDADES EUC'			        ,'3'	   ,'44'      ,'5'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
		T_ACCION('102'	,'07'	,'31'	,'21'          ,'COMUNIDADES EUC'			        ,'3'	   ,'44'      ,'5'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
		T_ACCION('103'	,'07'	,'31'	,'41'		   ,'COMUNIDADES EUC'			        ,'3'	   ,'44'      ,'5'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
		T_ACCION('100'	,'07'	,'31'	,'22'          ,'COMUNIDADES EUC'			        ,'3'	   ,'44'      ,'5'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
		T_ACCION('104'	,'07'	,'30'	,'1'           ,'EJEC. PROPIEDAD: OBRAS Y MANTENIM.','3'	   ,'44'      ,'2'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
		T_ACCION('105'	,'07'	,'30'	,'21'          ,'EJEC. PROPIEDAD: OBRAS Y MANTENIM.','3'	   ,'44'      ,'2'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
		T_ACCION('106'	,'07'	,'30'	,'41'          ,'EJEC. PROPIEDAD: OBRAS Y MANTENIM.','3'	   ,'44'      ,'2'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    ),
		T_ACCION('107'	,'07'	,'30'	,'22'          ,'EJEC. PROPIEDAD: OBRAS Y MANTENIM.','3'	   ,'44'      ,'2'       ,NULL               ,'NULL'    ,'NULL'    ,'NULL'    )
    );
    V_TMP_ACCION T_ACCION;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_ACCION.FIRST .. V_ACCION.LAST
    LOOP
        V_TMP_ACCION := V_ACCION(I);

	    IF V_TMP_ACCION(4) IS NULL THEN
	    	V_TPR_COD := 'IS NULL';
            V_TPR_INS := 'NULL';
	    ELSE
	    	V_TPR_COD := '= ' || V_TMP_ACCION(4);
            V_TPR_INS := V_TMP_ACCION(4);
	    END IF;
	    
	    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
	        USING (
	            SELECT TGA.DD_TGA_ID, STG.DD_STG_ID, ETG.DD_ETG_ID
	            FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG 
	            JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID AND TGA.DD_TGA_CODIGO = '''||V_TMP_ACCION(2)||''' AND STG.DD_STG_CODIGO = '''||V_TMP_ACCION(3)||'''
	            LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA||' ETG ON STG.DD_STG_ID = ETG.DD_STG_ID AND TGA.DD_TGA_ID = ETG.DD_TGA_ID
	            	AND ETG.DD_TPR_ID '||V_TPR_COD||' AND ETG.DD_ETG_CODIGO = '''||V_TMP_ACCION(1)||'''
	            ) T2
	        ON (T1.DD_ETG_ID = T2.DD_ETG_ID)
	        WHEN MATCHED THEN UPDATE SET
	            T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
	            , T1.DD_ETG_DESCRIPCION_POS = '''||V_TMP_ACCION(5)||''', T1.DD_ETG_DESCRIPCION_LARGA_POS = '''||V_TMP_ACCION(5)||'''
	            , T1.COGRUG_POS = '||V_TMP_ACCION(6)||', T1.COTACA_POS = '||V_TMP_ACCION(7)||', T1.COSBAC_POS = '||V_TMP_ACCION(8)||'
	            , T1.DD_ETG_DESCRIPCION_NEG = '''||V_TMP_ACCION(9)||''', T1.DD_ETG_DESCRIPCION_LARGA_NEG = '''||V_TMP_ACCION(9)||'''
	            , T1.COGRUG_NEG = '||V_TMP_ACCION(10)||', T1.COTACA_NEG = '||V_TMP_ACCION(11)||', T1.COSBAC_NEG = '||V_TMP_ACCION(12)||'
	        WHEN NOT MATCHED THEN INSERT (T1.DD_ETG_ID, T1.DD_TGA_ID, T1.DD_STG_ID, T1.DD_ETG_CODIGO, T1.DD_ETG_DESCRIPCION_POS
	        	, T1.DD_ETG_DESCRIPCION_LARGA_POS, T1.COGRUG_POS, T1.COTACA_POS, T1.COSBAC_POS, T1.DD_ETG_DESCRIPCION_NEG
	        	, T1.DD_ETG_DESCRIPCION_LARGA_NEG, T1.COGRUG_NEG, T1.COTACA_NEG, T1.COSBAC_NEG, T1.USUARIOCREAR, T1.FECHACREAR
	        	, T1.DD_TPR_ID)
	        VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, T2.DD_TGA_ID, T2.DD_STG_ID, '''||V_TMP_ACCION(1)||''', '''||V_TMP_ACCION(5)||'''
	        	, '''||V_TMP_ACCION(5)||''', '||V_TMP_ACCION(6)||', '||V_TMP_ACCION(7)||', '||V_TMP_ACCION(8)||', '''||V_TMP_ACCION(9)||'''
                , '''||V_TMP_ACCION(9)||''', '||V_TMP_ACCION(10)||', '||V_TMP_ACCION(11)||', '||V_TMP_ACCION(12)||', '''||V_USUARIO||''', SYSDATE
                , '||V_TPR_INS||')';
	    --DBMS_OUTPUT.PUT_LINE(V_SQL);
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('  [INFO] Fusionada/s '||NVL(SQL%ROWCOUNT,0)||' fila en tabla de mapeo '||V_TABLA||' con código '||V_TMP_ACCION(1)||'.');

	END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    COMMIT;

 
EXCEPTION
    WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE(ERR_MSG);
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        ROLLBACK;
        RAISE;   
END;
/
EXIT;