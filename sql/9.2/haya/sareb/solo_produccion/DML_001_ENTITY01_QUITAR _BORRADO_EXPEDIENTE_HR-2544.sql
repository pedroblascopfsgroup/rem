--/*
--##########################################
--## AUTOR=Miguel Ángel Sánchez(Valencia)
--## FECHA_CREACION=20160512
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-2544
--## PRODUCTO=NO
--## 
--## Finalidad: Quitar el borrado logico del expediente 1000000000005959
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables

 BEGIN


  V_MSQL := '
  update '||V_ESQUEMA||'.EXP_EXPEDIENTES exp
set borrado=0, 
dd_tpx_id=(select tpx.DD_TPX_ID from '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE tpx where tpx.DD_TPX_CODIGO = ''GESDEU'')
where exp_id= 1000000000005959';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

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
