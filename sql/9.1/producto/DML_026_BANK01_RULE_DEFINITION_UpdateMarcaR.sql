--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20150623
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.13
--## INCIDENCIA_LINK=BCFI-668
--## PRODUCTO=SI
--## Finalidad: DML
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM        NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID   NUMBER(16);

BEGIN

    --** Marca Refinanciación
    v_num_tablas:=0;
    v_msql:='Select count(1)
               From '||v_esquema||'.dd_rule_definition Where rd_title like ''Marca Refinanciacion''';
    Execute Immediate v_msql into v_num_tablas;

    If V_NUM_TABLAS = 1
     Then
       DBMS_OUTPUT.put_line('[INFO] Actualizamos varible ''Marca Refinanciación''');

       v_msql:='UPDATE '||v_esquema||'.dd_rule_definition
                   SET rd_title = ''Marca R''
                 WHERE rd_title like ''Marca Refinanciacion''
               ';
       Execute Immediate v_msql;
       DBMS_OUTPUT.put_line('[INFO] Varible ''Marca Refinanciación'' actualizada a ''Marca R''. '||SQL%ROWCOUNT||' Filas actualizadas.');

    Elsif V_NUM_TABLAS > 0
     Then
       DBMS_OUTPUT.put_line('[ERROR] Se intenta actualizar más de una fila. 0 Filas actualizadas.');

    Else
       DBMS_OUTPUT.put_line('[INFO] Varible ''Marca Refinanciación no existe. 0 Filas actualizadas.''');

    End If;

     --** Confirmamos
     Commit;


EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;
END;
/
EXIT;
