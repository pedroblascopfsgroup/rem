
--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20201119
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-00000
--## PRODUCTO=NO
--## 
--## Finalidad: Migración modelo antiguo a nuevo en administración.
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  V_TABLA VARCHAR2(30 CHAR); -- Vble. nombre tabla auxiliar.
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
    T_COL('INSERT_GLD_ENT', 'GLD_ENT'),
    T_COL('INSERT_GLD_TBJ', 'GLD_TBJ')
  );  
  V_TMP_COL T_COL;

 
BEGIN
    	
    -----------------------
    ---     CAMPOS      ---
    -----------------------

    DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        IF 'INSERT_GLD_ENT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [INSERT_GLD_ENT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''GPV_ACT''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                V_TABLA := NULL;

                IF V_NUM_TABLAS = 1 THEN
                    V_TABLA := 'GPV_ACT';
                ELSE
                    V_TABLA := 'GPV_ACT_BACKUP';
                END IF;

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GLD_ENT (GLD_ENT_ID, GLD_ID, DD_ENT_ID, ENT_ID, GLD_PARTICIPACION_GASTO, GLD_REFERENCIA_CATASTRAL, USUARIOCREAR, FECHACREAR)
                            SELECT '||V_ESQUEMA||'.S_GLD_ENT.NEXTVAL GLD_ENT, GLD_ID, DD_ENT_ID, ACT_ID, GPV_PARTICIPACION_GASTO, GPV_REFERENCIA_CATASTRAL, ''HREOS-10574'', CURRENT_TIMESTAMP(6)
                            FROM 
                            (
                                SELECT GLD.GLD_ID, DD_ENT.DD_ENT_ID, GPV_ACT.ACT_ID, GLD.BORRADO, GPV_ACT.GPV_PARTICIPACION_GASTO
                                    , GPV_ACT.GPV_REFERENCIA_CATASTRAL
                                    , ROW_NUMBER() OVER(PARTITION BY GLD.GLD_ID, GPV_ACT.ACT_ID ORDER BY GPV_ACT.GPV_REFERENCIA_CATASTRAL NULLS LAST) RN
                                FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV_ACT
                                JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV_ACT.GPV_ID 
                                    AND GLD.BORRADO = 0
                                JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO DD_ENT ON DD_ENT.DD_ENT_CODIGO = ''ACT''
                                LEFT JOIN '||V_ESQUEMA||'.GLD_ENT ON GLD_ENT.GLD_ID = GLD.GLD_ID AND GLD_ENT.ENT_ID = GPV_ACT.ACT_ID
                                WHERE GLD_ENT.GLD_ENT_ID IS NULL
                            )
                            WHERE RN = 1';
                EXECUTE IMMEDIATE V_MSQL;
            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_ENT informada con '||SQL%ROWCOUNT||' registros.');
            END IF;
        END IF;

        IF 'INSERT_GLD_TBJ' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [INSERT_GLD_TBJ]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''GPV_TBJ''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                V_TABLA := NULL;

                IF V_NUM_TABLAS = 1 THEN
                    V_TABLA := 'GPV_TBJ';
                ELSE
                    V_TABLA := 'GPV_TBJ_BACKUP';
                END IF;

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GLD_TBJ (GLD_TBJ_ID, GLD_ID, TBJ_ID, DD_TEG_ID, USUARIOCREAR, FECHACREAR)
                    SELECT '||V_ESQUEMA||'.S_GLD_TBJ.NEXTVAL GLD_TBJ_ID, GLD_ID, TBJ_ID, DD_TEG_ID, ''HREOS-10574'', CURRENT_TIMESTAMP(6)
                    FROM (
                        SELECT GLD.GLD_ID, GPV_TBJ.TBJ_ID, ROW_NUMBER() OVER(PARTITION BY GPV_TBJ.TBJ_ID ORDER BY GPV_TBJ.FECHACREAR) RN
                            , CASE WHEN PVE.PVE_ID IS NULL 
                                THEN DD_TEG_.DD_TEG_ID
                                ELSE DD_TEG.DD_TEG_ID
                                END DD_TEG_ID
                        FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV_TBJ
                        JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GPV_TBJ.GPV_ID AND GPV.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV_TBJ.GPV_ID AND GLD.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.DD_TEG_TIPO_EMISOR_GLD DD_TEG ON DD_TEG.DD_TEG_CODIGO = ''HAY''
                        JOIN '||V_ESQUEMA||'.DD_TEG_TIPO_EMISOR_GLD DD_TEG_ ON DD_TEG_.DD_TEG_CODIGO = ''OTR''
                        LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR AND PVE.BORRADO = 0
                            AND PVE.PVE_DOCIDENTIF IN (''A86744349'',''B86744349'')
                        WHERE GPV_TBJ.BORRADO = 0
                            AND NOT EXISTS (
                                SELECT 1
                                FROM '||V_ESQUEMA||'.GLD_TBJ GTB
                                WHERE GTB.BORRADO = 0
                                    AND GTB.TBJ_ID = GPV_TBJ.TBJ_ID
                                    AND GTB.DD_TEG_ID = CASE WHEN PVE.PVE_ID IS NULL THEN DD_TEG_.DD_TEG_ID ELSE DD_TEG.DD_TEG_ID END
                            )
                    )
                    WHERE RN = 1';
                EXECUTE IMMEDIATE V_MSQL;
            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_TBJ informada con '||SQL%ROWCOUNT||' registros.');
	            END IF;
        END IF;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
    
    COMMIT;  
    
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

EXIT;
