--/*
--##########################################
--## AUTOR=BRUNO ANGLÉS
--## FECHA_CREACION=20170718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2454
--## PRODUCTO=NO
--## Finalidad: Updatear los valoes del DD
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Vble. número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);
    V_ITEM_LINK VARCHAR2(50 CHAR):= 'HREOS-2454';
    V_TABLE_NAME VARCHAR2(30 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP';

    CUENTA NUMBER;
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO '|| V_ESQUEMA ||'.'||V_TABLE_NAME||'...');
  
  V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLE_NAME||' SET DD_SDE_DESCRIPCION=''Documento identificativo del cliente DNI'', DD_SDE_DESCRIPCION_LARGA=''Documento identificativo del cliente DNI'', DD_SDE_MATRICULA_GD=''OP-12-DOCI-01'', BORRADO=0, USUARIOMODIFICAR='''||V_ITEM_LINK||''', FECHAMODIFICAR=SYSDATE WHERE DD_SDE_CODIGO=''01''';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLE_NAME||' SET DD_SDE_DESCRIPCION=''Documento identificativo del cliente NIF'', DD_SDE_DESCRIPCION_LARGA=''Documento identificativo del cliente NIF'', DD_SDE_MATRICULA_GD=''OP-12-DOCI-07'', BORRADO=0, USUARIOMODIFICAR='''||V_ITEM_LINK||''', FECHAMODIFICAR=SYSDATE WHERE DD_SDE_CODIGO=''03''';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLE_NAME||' SET DD_SDE_DESCRIPCION=''Contrato alquiler'', DD_SDE_DESCRIPCION_LARGA=''Contrato alquiler'', DD_SDE_MATRICULA_GD=''OP-07-CNCV-04'', BORRADO=0, USUARIOMODIFICAR='''||V_ITEM_LINK||''', FECHAMODIFICAR=SYSDATE WHERE DD_SDE_CODIGO=''09''';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLE_NAME||' SET DD_SDE_DESCRIPCION=''Informe jurídico'', DD_SDE_DESCRIPCION_LARGA=''Informe jurídico'', DD_SDE_MATRICULA_GD=''OP-07-ESIN-AS'', BORRADO=0, USUARIOMODIFICAR='''||V_ITEM_LINK||''', FECHAMODIFICAR=SYSDATE WHERE DD_SDE_CODIGO=''10''';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLE_NAME||' SET DD_SDE_DESCRIPCION=''Solicitud de visita por la Administración'', DD_SDE_DESCRIPCION_LARGA=''Solicitud de visita por la Administración'', DD_SDE_MATRICULA_GD=''OP-10-CERJ-89'', BORRADO=0, USUARIOMODIFICAR='''||V_ITEM_LINK||''', FECHAMODIFICAR=SYSDATE WHERE DD_SDE_CODIGO=''14''';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  
  V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLE_NAME||' SET DD_SDE_DESCRIPCION=''Autorización venta VPO'', DD_SDE_DESCRIPCION_LARGA=''Autorización venta VPO'', DD_SDE_MATRICULA_GD=''OP-07-ACUE-07'', BORRADO=0, USUARIOMODIFICAR='''||V_ITEM_LINK||''', FECHAMODIFICAR=SYSDATE WHERE DD_SDE_CODIGO=''21''';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLE_NAME||' SET BORRADO=1, USUARIOMODIFICAR='''||V_ITEM_LINK||''', FECHAMODIFICAR=SYSDATE WHERE DD_SDE_CODIGO IN (''25'', ''26'', ''29'', ''30'', ''32'', ''33'')';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO '|| V_ESQUEMA ||'.'||V_TABLE_NAME||': OK');
  
EXCEPTION
     WHEN OTHERS THEN
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
