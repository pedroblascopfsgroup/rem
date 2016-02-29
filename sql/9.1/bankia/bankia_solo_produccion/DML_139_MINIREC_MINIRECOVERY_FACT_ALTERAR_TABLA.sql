--##########################################
--## AUTOR=Luis Antonio Prato Paredes
--## FECHA_CREACION=20160229
--## ARTEFACTO=[online|batch]
--## VERSION_ARTEFACTO=X.X.X_rcXX
--## INCIDENCIA_LINK=PROJECTKEY-ISSUENUMBER
--## PRODUCTO=[SI|NO]
--## 
--## Finalidad:Inyectar registros en bi_factu (BKREC-1742)  
--## INSTRUCCIONES:  inyectar los registros que en su momento no se pudieron cargar por culpa de un error
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#''; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(32767 CHAR);
    

    -- Otras variables

 BEGIN

    -- CUERPO DEL SCRIPT
    -- PARA LA CREACIÓN DE OBJETOS USAR LA CONSULTA DE EXISTENCIA PREVIA
    -- USAR M_SQL para construir SQL a ejecutar
    -- USAR EXECUTE IMMEDIATE para ejecutar M_SQL
  
                                                                    
V_MSQL := 'alter table ' ||V_ESQUEMA|| '.MINIRECOVERY_FACT ADD CPA_ID NUMBER(16,0)';
 Execute IMMEDIATE V_MSQL;

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