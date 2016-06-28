--/*
--##########################################
--## AUTOR=_Miguel Angel Sanchez
--## FECHA_CREACION=20160616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-1
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar los registros ERROR y JUSTIFICANTE ESCANEADO en el DD_PCO_BFR_RESULTADO
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
    V_TABLA VARCHAR2(1024 CHAR);
        V_NUM_TABLAS NUMBER(16);
 BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');


V_TABLA :='DD_PCO_BFR_RESULTADO';

DBMS_OUTPUT.PUT_LINE(' ');

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar registro ''ERROR'' en la tabla: '||V_TABLA);
--Comprobar si existe
V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' where DD_PCO_BFR_DESCRIPCION = ''ERROR''';
 --DBMS_OUTPUT.PUT_LINE('******************************************[QUERY] '||V_MSQL);
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
V_MSQL := 'Insert into '||V_ESQUEMA||'.'||V_TABLA||' (DD_PCO_BFR_ID,DD_PCO_BFR_CODIGO,DD_PCO_BFR_DESCRIPCION,DD_PCO_BFR_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_PCO_BFR_NOTIFICADO) 
values (haya01.S_DD_PCO_BFR_RESULTADO.nextval,''999'',''ERROR'',''ERROR'',''0'',''RECOVERY-52'',sysdate,null,null,null,null,''0'',''0'')';
-- DBMS_OUTPUT.PUT_LINE('*******************************************[QUERY] '||V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('    [INFO] El registro ''ERROR'' en la tabla '||V_TABLA||' ha sido creado correctamente');
ELSE
	DBMS_OUTPUT.PUT_LINE('    [INFO] El registro ''ERROR'' en la tabla '||V_TABLA||' ya existe');
END IF;   

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar registro ''JUSTIFICANTE ESCANEADO'' en la tabla: '||V_TABLA);
--Comprobar si existe
V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' where DD_PCO_BFR_DESCRIPCION = ''JUSTIFICANTE ESCANEADO''';
 --DBMS_OUTPUT.PUT_LINE('******************************************[QUERY] '||V_MSQL);
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
V_MSQL := 'Insert into '||V_ESQUEMA||'.'||V_TABLA||' (DD_PCO_BFR_ID,DD_PCO_BFR_CODIGO,DD_PCO_BFR_DESCRIPCION,DD_PCO_BFR_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_PCO_BFR_NOTIFICADO) 
values (haya01.S_DD_PCO_BFR_RESULTADO.nextval,''142'',''JUSTIFICANTE ESCANEADO'',''JUSTIFICANTE ESCANEADO'',''0'',''RECOVERY-1'',sysdate,null,null,null,null,''0'',''0'')';
-- DBMS_OUTPUT.PUT_LINE('*******************************************[QUERY] '||V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('    [INFO] El registro ''JUSTIFICANTE ESCANEADO'' en la tabla '||V_TABLA||' ha sido creado correctamente');
ELSE
	DBMS_OUTPUT.PUT_LINE('    [INFO] El registro ''JUSTIFICANTE ESCANEADO'' en la tabla '||V_TABLA||' ya existe');
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
