--/*
--##########################################
--## AUTOR=Miguel Ángel Sánchez Sánchez
--## FECHA_CREACION=20160711
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-699
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir las nuevas columnas del aprovisionamiento de PCR
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    V_TABLA VARCHAR2(1024 CHAR);
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    -- Otras variables

 BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

V_TABLA :='CNV_AUX_ALTA_PRC';
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INFO] Verificando si existe la tabla: '||V_TABLA);
V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
DBMS_OUTPUT.PUT_LINE(V_MSQL);
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 1 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla existe. Verificando si existen las columnas nuevas.');
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS 
    WHERE (COLUMN_NAME=''FECHA_PROCESO_2'' AND TABLE_NAME=''CNV_AUX_ALTA_PRC'') 
    OR (COLUMN_NAME=''CODIGO_PROPIETARIO'' AND TABLE_NAME=''CNV_AUX_ALTA_PRC'')
    OR (COLUMN_NAME=''TIPO_PRODUCTO'' AND TABLE_NAME=''CNV_AUX_ALTA_PRC'')
    OR (COLUMN_NAME=''NUMERO_CONTRATO'' AND TABLE_NAME=''CNV_AUX_ALTA_PRC'')
    OR (COLUMN_NAME=''NUMERO_ESPEC'' AND TABLE_NAME=''CNV_AUX_ALTA_PRC'')
    OR (COLUMN_NAME=''CODIGO_PERSONA'' AND TABLE_NAME=''CNV_AUX_ALTA_PRC'')
    OR (COLUMN_NAME=''NUMERO_CLIENTE_NUSE'' AND TABLE_NAME=''CNV_AUX_ALTA_PRC'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Las columnas no existen. Creando columnas nuevas.'); 
        V_MSQL := '
        ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_ALTA_PRC
        ADD(
        FECHA_PROCESO_2 DATE,
        CODIGO_PROPIETARIO NUMBER(5),
        TIPO_PRODUCTO VARCHAR2(5),
        NUMERO_CONTRATO NUMBER(17),
        NUMERO_ESPEC NUMBER(15),
        CODIGO_PERSONA NUMBER(16),
        NUMERO_CLIENTE_NUSE NUMBER(17) 
        )';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL ;
        
        DBMS_OUTPUT.PUT_LINE('    [INFO] Las columnas han sido creadas correctamente.'); 
    ELSE
        DBMS_OUTPUT.PUT_LINE('    [INFO] Las columnas ya existen.');
    END IF;

ELSE
    DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla '||V_TABLA||' ya existe');
END IF;
DBMS_OUTPUT.PUT_LINE('[FIN]');
 EXCEPTION

    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);

    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;
