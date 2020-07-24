--/*
--######################################### 
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10574
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir constraints a tabla de cuentas contables y partidas presupuestarias.
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
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
    T_COL('INSERT_GLD', 'GLD_GASTOS_LINEA_DETALLE'),
    T_COL('INSERT_GLD_ENT', 'GLD_ENT'),
    T_COL('INSERT_GLD_TBJ', 'GLD_TBJ'),
    T_COL('CREATE_GPV_GDE_GIC_BACKUP', 'GPV_GDE_GIC_BACKUP'),
    T_COL('CREATE_REL_BACKUP', 'GPV_ACT', 'GPV_ACT_BACKUP'),
    T_COL('CREATE_REL_BACKUP', 'GPV_TBJ', 'GPV_TBJ_BACKUP'),
    T_COL('CREATE_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_IRPF_BASE', 'NUMBER(16,2)', 'Base IRPF'),
    T_COL('CREATE_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_IRPF_CLAVE', 'VARCHAR(20 CHAR)', 'Clave IRPF'),
    T_COL('CREATE_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_IRPF_SUBCLAVE', 'VARCHAR(20 CHAR)', 'Subclave IRPF'),
    T_COL('CREATE_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_RET_GAR_BASE', 'NUMBER(16,2)', 'Base Retención de garantía'),
    T_COL('CREATE_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_RET_GAR_TIPO_IMPOSITIVO', 'NUMBER(4,2)', 'Tipo Impositivo Retención de garantía'),
    T_COL('CREATE_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_RET_GAR_CUOTA', 'NUMBER(16,2)', 'Cuota de Retención de garantía'),
    T_COL('DROP_CONSTRAINT', 'GPV_GASTOS_PROVEEDOR', 'FK_GPV_DD_STG'),
    T_COL('DROP_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'FK_GDE_DD_TRG_ID'),
    T_COL('DROP_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'FK_DD_TIT'),
    T_COL('DROP_COLUMN', 'GPV_GASTOS_PROVEEDOR', 'DD_STG_ID'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_PRINCIPAL_SUJETO'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_PRINCIPAL_NO_SUJETO'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_RECARGO'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'DD_TRG_ID'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_INTERES_DEMORA'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_COSTAS'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_OTROS_INCREMENTOS'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_PROV_SUPLIDOS'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'DD_TIT_ID'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_IMP_IND_EXENTO'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_IMP_IND_RENUNCIA_EXENCION'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_IMP_IND_TIPO_IMPOSITIVO'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_IMP_IND_CUOTA'),
    T_COL('DROP_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'GDE_EXISTE_RECARGO'),
    T_COL('DROP_COLUMN', 'GIC_GASTOS_INFO_CONTABILIDAD', 'GIC_CUENTA_CONTABLE'),
    T_COL('DROP_COLUMN', 'GIC_GASTOS_INFO_CONTABILIDAD', 'GIC_PTDA_PRESUPUESTARIA'),
    T_COL('DROP_COLUMN', 'GIC_GASTOS_INFO_CONTABILIDAD', 'GIC_CUENTA_CONTABLE_ESP'),
    T_COL('DROP_COLUMN', 'GIC_GASTOS_INFO_CONTABILIDAD', 'GIC_PTDA_PRESUPUESTARIA_ESP'),
    T_COL('DROP TABLE','GPV_TBJ'),
    T_COL('DROP TABLE','GPV_ACT')
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

        IF 'INSERT_GLD' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [INSERT_GLD]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN    
	            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE';
	            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	            IF V_NUM_TABLAS = 0 THEN
	                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE (GLD_ID, GPV_ID, DD_STG_ID, GLD_PRINCIPAL_SUJETO, GLD_PRINCIPAL_NO_SUJETO, GLD_RECARGO
	                            , DD_TRG_ID, GLD_INTERES_DEMORA, GLD_COSTAS, GLD_OTROS_INCREMENTOS, GLD_PROV_SUPLIDOS, DD_TIT_ID, GLD_IMP_IND_EXENTO
	                            , GLD_IMP_IND_RENUNCIA_EXENCION, GLD_IMP_IND_TIPO_IMPOSITIVO, GLD_IMP_IND_CUOTA, GLD_IMPORTE_TOTAL, GLD_CCC_BASE
	                            , GLD_CPP_BASE, GLD_CCC_ESP, GLD_CPP_ESP, USUARIOCREAR, FECHACREAR)
	                            SELECT '||V_ESQUEMA||'.S_GLD_GASTOS_LINEA_DETALLE.NEXTVAL GLD, GPV.GPV_ID, GPV.DD_STG_ID, GDE.GDE_PRINCIPAL_SUJETO
	                            , GDE.GDE_PRINCIPAL_NO_SUJETO, GDE.GDE_RECARGO, GDE.DD_TRG_ID
	                            , GDE.GDE_INTERES_DEMORA, GDE.GDE_COSTAS, GDE.GDE_OTROS_INCREMENTOS, GDE.GDE_PROV_SUPLIDOS, GDE.DD_TIT_ID
	                            , GDE.GDE_IMP_IND_EXENTO, GDE.GDE_IMP_IND_RENUNCIA_EXENCION, GDE.GDE_IMP_IND_TIPO_IMPOSITIVO, GDE.GDE_IMP_IND_CUOTA
	                            , GDE.GDE_IMPORTE_TOTAL, GIC.GIC_CUENTA_CONTABLE, GIC.GIC_PTDA_PRESUPUESTARIA, GIC.GIC_CUENTA_CONTABLE_ESP
	                            , GIC.GIC_PTDA_PRESUPUESTARIA_ESP, ''HREOS-10574'', CURRENT_TIMESTAMP(6)
	                            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
	                            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID AND GDE.BORRADO = 0
	                            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID AND GIC.BORRADO = 0
	                            LEFT JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID AND GLD.BORRADO = 0
	                            WHERE GPV.BORRADO = 0 AND GLD.GLD_ID IS NULL';
	                EXECUTE IMMEDIATE V_MSQL;
	                DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_GASTOS_LINEA_DETALLE informada.');
	            ELSE
	            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_GASTOS_LINEA_DETALLE rellena previamente.');
	            END IF;
            END IF;
        END IF;

        IF 'INSERT_GLD_ENT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [INSERT_GLD_ENT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
            	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GLD_ENT';
	            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	            IF V_NUM_TABLAS = 0 THEN
	                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GLD_ENT (GLD_ENT_ID, GLD_ID, DD_ENT_ID, ENT_ID, GLD_PARTICIPACION_GASTO, GLD_REFERENCIA_CATASTRAL, USUARIOCREAR, FECHACREAR)
	                            SELECT '||V_ESQUEMA||'.S_GLD_ENT.NEXTVAL GLD_ENT, GLD_ID, DD_ENT_ID, ACT_ID, GPV_PARTICIPACION_GASTO, GPV_REFERENCIA_CATASTRAL, ''HREOS-10574'', CURRENT_TIMESTAMP(6)
	                            FROM 
	                            (
	                                SELECT GLD.GLD_ID, DD_ENT.DD_ENT_ID, GPV_ACT.ACT_ID, GLD.BORRADO, GPV_ACT.GPV_PARTICIPACION_GASTO
	                                    , GPV_ACT.GPV_REFERENCIA_CATASTRAL
	                                    , ROW_NUMBER() OVER(PARTITION BY GLD.GLD_ID, GPV_ACT.ACT_ID ORDER BY GPV_ACT.GPV_REFERENCIA_CATASTRAL NULLS LAST) RN
	                                FROM '||V_ESQUEMA||'.GPV_ACT
	                                JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV_ACT.GPV_ID AND GLD.BORRADO = 0
	                                JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO DD_ENT ON DD_ENT.DD_ENT_CODIGO = ''ACT''
	                                LEFT JOIN '||V_ESQUEMA||'.GLD_ENT ON GLD_ENT.GLD_ID = GLD.GLD_ID AND GLD_ENT.ENT_ID = GPV_ACT.ACT_ID
	                                WHERE GLD_ENT.GLD_ENT_ID IS NULL
	                            )
	                            WHERE RN = 1';
	                EXECUTE IMMEDIATE V_MSQL;
	            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_ENT informada.');
	            ELSE
	            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_ENT rellena previamente.');
	            END IF;
            END IF;
        END IF;

        IF 'INSERT_GLD_TBJ' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [INSERT_GLD_TBJ]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
            	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GLD_TBJ';
	            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	            IF V_NUM_TABLAS = 0 THEN
	                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GLD_TBJ (GLD_TBJ_ID, GLD_ID, TBJ_ID, DD_TEG_ID, USUARIOCREAR, FECHACREAR)
	                            SELECT '||V_ESQUEMA||'.S_GLD_TBJ.NEXTVAL GLD_TBJ_ID, GLD_ID, TBJ_ID, DD_TEG_ID, ''HREOS-10574'', CURRENT_TIMESTAMP(6)
	                            FROM (
	                                SELECT GLD.GLD_ID, GPV_TBJ.TBJ_ID, ROW_NUMBER() OVER(PARTITION BY GPV_TBJ.TBJ_ID ORDER BY GPV_TBJ.FECHACREAR) RN
	                                    , CASE WHEN PVE.PVE_ID IS NULL 
	                                        THEN DD_TEG_.DD_TEG_ID
	                                        ELSE DD_TEG.DD_TEG_ID
	                                        END DD_TEG_ID
	                                FROM '||V_ESQUEMA||'.GPV_TBJ
	                                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GPV_TBJ.GPV_ID AND GPV.BORRADO = 0
	                                JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV_TBJ.GPV_ID AND GLD.BORRADO = 0
	                                JOIN '||V_ESQUEMA||'.DD_TEG_TIPO_EMISOR_GLD DD_TEG ON DD_TEG.DD_TEG_CODIGO = ''HAY''
	                                JOIN '||V_ESQUEMA||'.DD_TEG_TIPO_EMISOR_GLD DD_TEG_ ON DD_TEG_.DD_TEG_CODIGO = ''OTR''
	                                LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR AND PVE.BORRADO = 0
	                                    AND PVE.PVE_DOCIDENTIF IN (''A86744349'',''B86744349'')
	                                LEFT JOIN '||V_ESQUEMA||'.GLD_TBJ ON GLD_TBJ.GLD_ID = GLD.GLD_ID AND GLD_TBJ.TBJ_ID = GPV_TBJ.TBJ_ID AND GLD_TBJ.BORRADO = 0
	                                    AND GLD_TBJ.DD_TEG_ID <> CASE WHEN PVE.PVE_ID IS NULL THEN DD_TEG_.DD_TEG_ID ELSE DD_TEG.DD_TEG_ID END
	                                WHERE GPV_TBJ.BORRADO = 0
	                            )
	                            WHERE RN = 1';
	                EXECUTE IMMEDIATE V_MSQL;
	            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_TBJ informada.');
	            ELSE
	            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla GLD_TBJ rellena previamente.');
	            END IF;
            END IF;
        END IF;

        IF 'CREATE_GPV_GDE_GIC_BACKUP' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [CREATE_GPV_GDE_GIC_BACKUP]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN
                V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' AS
                            SELECT CURRENT_TIMESTAMP(6) FECHA_BACKUP, GPV.GPV_ID, GPV.DD_STG_ID, GDE.GDE_PRINCIPAL_SUJETO
                                , GDE.GDE_PRINCIPAL_NO_SUJETO, GDE.GDE_RECARGO, GDE.DD_TRG_ID
                                , GDE.GDE_INTERES_DEMORA, GDE.GDE_COSTAS, GDE.GDE_OTROS_INCREMENTOS, GDE.GDE_PROV_SUPLIDOS, GDE.DD_TIT_ID
                                , GDE.GDE_IMP_IND_EXENTO, GDE.GDE_IMP_IND_RENUNCIA_EXENCION, GDE.GDE_IMP_IND_TIPO_IMPOSITIVO, GDE.GDE_IMP_IND_CUOTA
                                , GDE.GDE_IMPORTE_TOTAL, GIC.GIC_CUENTA_CONTABLE, GIC.GIC_PTDA_PRESUPUESTARIA, GIC.GIC_CUENTA_CONTABLE_ESP
                                , GIC.GIC_PTDA_PRESUPUESTARIA_ESP, GPV.PVE_ID_EMISOR
                            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID AND GDE.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID AND GIC.BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;
            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla '||V_TMP_COL(2)||' creada.');
            ELSE
            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla '||V_TMP_COL(2)||' creada previamente.');
            END IF;
        END IF;

        IF 'CREATE_REL_BACKUP' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [CREATE_'||V_TMP_COL(3)||']');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN
                V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TMP_COL(3)||' AS
                            SELECT CURRENT_TIMESTAMP(6) FECHA_BACKUP, '||V_TMP_COL(2)||'.*
                            FROM '||V_ESQUEMA||'.'||V_TMP_COL(2)||'';
                EXECUTE IMMEDIATE V_MSQL;
            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla '||V_TMP_COL(3)||' creada.');
            ELSE
            	DBMS_OUTPUT.PUT_LINE('	[INFO] Tabla '||V_TMP_COL(3)||' creada previamente.');
            END IF;
        END IF;

        IF 'CREATE_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [CREATE_COLUMN]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                -- Verificar si el campo ya existe
                V_MSQL := 'SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo Columna '||V_TMP_COL(3)||'');
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4)||''; 

                    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TMP_COL(2)||'.'||V_TMP_COL(3)||' IS '''||V_TMP_COL(5)||'''';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna '||V_TMP_COL(3)||' creado.');      
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... ya existe.');
                END IF;    
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TMP_COL(2)||'... No existe.');  
            END IF;
        END IF;

        IF 'DROP_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [DROP_CONSTRAINT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando FK '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' DROP CONSTRAINT '||V_TMP_COL(3)||'';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' no existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... No existe.');
            END IF;    
        END IF;

        IF 'DROP_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                -- Verificar si el campo ya existe
                V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                
                IF V_NUM_TABLAS = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando Columna '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' DROP COLUMN '||V_TMP_COL(3)||'';       
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... No existe.');
                END IF;    
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TMP_COL(2)||'... No existe.');  
            END IF;
        END IF;

        IF 'DROP TABLE' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando Tabla '||V_TMP_COL(2)||'');  
                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' PURGE';       
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TMP_COL(2)||'... No existe.');  
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
