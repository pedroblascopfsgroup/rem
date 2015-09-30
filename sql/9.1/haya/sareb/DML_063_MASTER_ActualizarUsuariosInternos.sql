--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.3.5-hy-rc03
--## INCIDENCIA_LINK=HR-1008
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar usuarios internos
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
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
    VAR_CURR_TABLE VARCHAR2(50 CHAR);
    V_CAMPOCODIGO VARCHAR2(50 CHAR);
    V_NUMEROCAMPOCODIGO NUMBER(2);
    V_NUM_TABLAS NUMBER(16);
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);
    
    
    
BEGIN
	   
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES USUARIOS--------------- */
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS' ||
			  ' SET USU_EXTERNO = 0 ' ||
			  ' WHERE USU_GRUPO = 1 AND USU_USERNAME NOT IN (''DLETR'',''PROCU'',''GESTORIA'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Grupos usuarios internos actualizados.');
   

    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
 
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