--/*
--##########################################
--## AUTOR=NOMBRE APELLIDOS
--## FECHA_CREACION=YYYYMMDD
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=X.X.X_rcXX
--## INCIDENCIA_LINK=HR-2532
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

    -- Otras variables
    V_NUM_TABLAS NUMBER(16);
    V_TABLA VARCHAR2(1024 CHAR);
    
 BEGIN
      DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
      DBMS_OUTPUT.PUT_LINE(' ');
      V_TABLA :='DD_PCO_BFR_RESULTADO';
      
      
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''103''';
      --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
          V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''103''';
          --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Borrado realizado correctamente');   
      ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] Este registro ya no existe');
      END IF;

      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''104''';
      --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
          V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''104''';
          --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Borrado realizado correctamente');   
      ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] Este registro ya no existe');
      END IF;
      
      
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''139''';
      --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
          V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''139''';
          --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Borrado realizado correctamente');   
      ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] Este registro ya no existe');
      END IF;
      
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''3''';
      DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_PCO_BFR_NOTIFICADO=1 WHERE DD_PCO_BFR_CODIGO=''3''';
          DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Registro 3 marcado como NOTIFICADO correctamente');   
      ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] El registro 3 no existe');
      END IF;
      
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''5''';
      --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_PCO_BFR_NOTIFICADO=1 WHERE DD_PCO_BFR_CODIGO=''5''';
          --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Registro 5 marcado como NOTIFICADO correctamente');   
      ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] El registro 5 no existe');
      END IF;
      
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PCO_BFR_CODIGO=''6''';
      --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_PCO_BFR_NOTIFICADO=1 WHERE DD_PCO_BFR_CODIGO=''6''';
          --DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Registro 6 marcado como NOTIFICADO correctamente');   
      ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] El registro 6 no existe');
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
