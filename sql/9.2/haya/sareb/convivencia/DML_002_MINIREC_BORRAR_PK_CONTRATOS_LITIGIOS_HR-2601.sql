--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=20160607
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2601
--## PRODUCTO=NO
--## Finalidad:  Borrar la clave primaria de la tabla  
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema Master
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
      
      V_MSQL := 'SELECT COUNT(1) FROM  ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''PK_MR_CNT_PROC_VIVOS''AND OWNER = '''||V_ESQUEMA_MINIREC||'''';
      DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
          V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_MINIREC || '.MINIRECOVERY_CNT_PROC_VIVOS DROP CONSTRAINT PK_MR_CNT_PROC_VIVOS';
          DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Borrado realizado correctamente');   
      ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] Este registro ya no existe');
      END IF;
      
      V_MSQL := 'SELECT COUNT(1) FROM  all_indexes WHERE UPPER(INDEX_NAME) = ''PK_MR_CNT_PROC_VIVOS''AND UPPER(owner)= '''||V_ESQUEMA_MINIREC||'''';
      DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
      EXECUTE IMMEDIATE V_MSQL into V_NUM_TABLAS;
      
		IF V_NUM_TABLAS = 1 THEN
    V_MSQL := 'drop index ' || V_ESQUEMA_MINIREC || '.PK_MR_CNT_PROC_VIVOS';
              DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
      
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_MR_CNT_PROC_VIVOS modificado: indice borrado');
		END IF;	

 EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
