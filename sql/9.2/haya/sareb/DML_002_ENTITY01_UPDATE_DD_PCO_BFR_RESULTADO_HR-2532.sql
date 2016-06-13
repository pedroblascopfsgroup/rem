--/*
--##########################################
--## AUTOR=Miguel Ángel sánchez Sánchez
--## FECHA_CREACION=20160603
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2532
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar registro del diccionario DD_PCO_BFR_RESULTADO a su estado anterior
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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

    -- Otras variables
    V_NUM_TABLAS NUMBER(16);
    V_TABLA VARCHAR2(1024 CHAR);
    
 BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
DBMS_OUTPUT.PUT_LINE(' ');
V_TABLA :='DD_PCO_BFR_RESULTADO';

V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
--DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_PCO_BFR_NOTIFICADO=0 WHERE DD_PCO_BFR_CODIGO=''168''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_TABLA||' ya no existe');
END IF;

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
