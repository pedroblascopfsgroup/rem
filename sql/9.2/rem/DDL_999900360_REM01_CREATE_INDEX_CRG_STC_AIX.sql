--/*
--##########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20181022
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=HREOS-4565
--## PRODUCTO=NO
--## Finalidad: DDL
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL         VARCHAR2(4000 CHAR);
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA_IDX  VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquema idx
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM        NUMBER; -- Numero de errores
    ERR_MSG        VARCHAR2(2048); -- Mensaje de error
    V_ENTIDAD_ID   NUMBER(16);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] IDX_CRG_CARGAS_ACT_ID...Comprobaciones previas');
    v_sql := null;
    v_num_tablas := 0;
    v_sql := 'Select count(1)
                From (SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
                        FROM ALL_IND_COLUMNS
                       WHERE UPPER(table_name) = ''ACT_CRG_CARGAS'' AND index_owner = '''||v_esquema||'''
                       GROUP BY index_name) sqli
               Where sqli.columnas = ''ACT_ID,BORRADO''
            ';
    DBMS_OUTPUT.PUT_LINE(v_sql);
    execute immediate v_sql into v_num_tablas;

    If v_num_tablas > 0
     Then DBMS_OUTPUT.PUT_LINE('[FIN] IDX_CRG_CARGAS_ACT_ID...  Atributos ya indexados');
     Else v_sql := null;
          v_num_tablas := 0;
          v_sql := 'Select count(*) From user_indexes Where index_name = ''IDX_CRG_CARGAS_ACT_ID''';
          execute immediate v_sql into v_num_tablas;

          If v_num_tablas > 0
           Then DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.IDX_CRG_CARGAS_ACT_ID... Ya existe indice con este nombre');
           Else v_sql := null;
                v_num_tablas := 0;
                v_sql := 'Select count(1) From ALL_TABLES Where table_name = ''ACT_CRG_CARGAS'' And owner = '''||v_esquema||'''';
                execute immediate v_sql into v_num_tablas;
                If v_num_tablas > 0
                 Then v_sql := null;
                      v_sql := 'Create Index IDX_CRG_CARGAS_ACT_ID On '||v_esquema||'.ACT_CRG_CARGAS (ACT_ID, BORRADO) Tablespace '||v_esquema_idx;
                      execute immediate v_sql;
                      DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.IDX_CRG_CARGAS_ACT_ID...  indice creado');
                      v_sql := null;
                      v_sql := 'Analyze Table '||v_esquema||'.ACT_CRG_CARGAS estimate statistics sample 20 percent';
                      execute immediate v_sql;
                      DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.ACT_CRG_CARGAS...  estadisticas actualizadas');
                 Else DBMS_OUTPUT.PUT_LINE('[FIN] IDX_CRG_CARGAS_ACT_ID...  La tabla no existe');
                End If;
          End If;
    End If;
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] IDX_STC_COD...Comprobaciones previas');
    v_sql := null;
    v_num_tablas := 0;
    v_sql := 'Select count(1)
                From (SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
                        FROM ALL_IND_COLUMNS
                       WHERE UPPER(table_name) = ''DD_STC_SUBTIPO_CARGA'' AND index_owner = '''||v_esquema||'''
                       GROUP BY index_name) sqli
               Where sqli.columnas = ''DD_STC_CODIGO''
            ';
    DBMS_OUTPUT.PUT_LINE(v_sql);
    execute immediate v_sql into v_num_tablas;

    If v_num_tablas > 0
     Then DBMS_OUTPUT.PUT_LINE('[FIN] IDX_STC_COD...  Atributos ya indexados');
     Else v_sql := null;
          v_num_tablas := 0;
          v_sql := 'Select count(*) From user_indexes Where index_name = ''IDX_STC_COD''';
          execute immediate v_sql into v_num_tablas;

          If v_num_tablas > 0
           Then DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.IDX_STC_COD... Ya existe indice con este nombre');
           Else v_sql := null;
                v_num_tablas := 0;
                v_sql := 'Select count(1) From ALL_TABLES Where table_name = ''DD_STC_SUBTIPO_CARGA'' And owner = '''||v_esquema||'''';
                execute immediate v_sql into v_num_tablas;
                If v_num_tablas > 0
                 Then v_sql := null;
                      v_sql := 'Create Index IDX_STC_COD On '||v_esquema||'.DD_STC_SUBTIPO_CARGA (DD_STC_CODIGO) Tablespace '||v_esquema_idx;
                      execute immediate v_sql;
                      DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.IDX_STC_COD...  indice creado');
                      v_sql := null;
                      v_sql := 'Analyze Table '||v_esquema||'.DD_STC_SUBTIPO_CARGA estimate statistics sample 20 percent';
                      execute immediate v_sql;
                      DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.DD_STC_SUBTIPO_CARGA...  estadisticas actualizadas');
                 Else DBMS_OUTPUT.PUT_LINE('[FIN] IDX_STC_COD...  La tabla no existe');
                End If;
          End If;
    End If;
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] IDX_AIC_COD_ID...Comprobaciones previas');
    v_sql := null;
    v_num_tablas := 0;
    v_sql := 'Select count(1)
                From (SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
                        FROM ALL_IND_COLUMNS
                       WHERE UPPER(table_name) = ''DD_AIC_ACCION_INF_COMERCIAL'' AND index_owner = '''||v_esquema||'''
                       GROUP BY index_name) sqli
               Where sqli.columnas = ''DD_AIC_CODIGO,DD_AIC_ID''
            ';
    DBMS_OUTPUT.PUT_LINE(v_sql);
    execute immediate v_sql into v_num_tablas;

    If v_num_tablas > 0
     Then DBMS_OUTPUT.PUT_LINE('[FIN] IDX_AIC_COD_ID...  Atributos ya indexados');
     Else v_sql := null;
          v_num_tablas := 0;
          v_sql := 'Select count(*) From user_indexes Where index_name = ''IDX_AIC_COD_ID''';
          execute immediate v_sql into v_num_tablas;

          If v_num_tablas > 0
           Then DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.IDX_AIC_COD_ID... Ya existe indice con este nombre');
           Else v_sql := null;
                v_num_tablas := 0;
                v_sql := 'Select count(1) From ALL_TABLES Where table_name = ''DD_AIC_ACCION_INF_COMERCIAL'' And owner = '''||v_esquema||'''';
                execute immediate v_sql into v_num_tablas;
                If v_num_tablas > 0
                 Then v_sql := null;
                      v_sql := 'Create Index IDX_AIC_COD_ID On '||v_esquema||'.DD_AIC_ACCION_INF_COMERCIAL (DD_AIC_CODIGO,DD_AIC_ID) Tablespace '||v_esquema_idx;
                      execute immediate v_sql;
                      DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.IDX_AIC_COD_ID...  indice creado');
                      v_sql := null;
                      v_sql := 'Analyze Table '||v_esquema||'.DD_AIC_ACCION_INF_COMERCIAL estimate statistics sample 20 percent';
                      execute immediate v_sql;
                      DBMS_OUTPUT.PUT_LINE('[FIN] '||v_esquema||'.DD_AIC_ACCION_INF_COMERCIAL...  estadisticas actualizadas');
                 Else DBMS_OUTPUT.PUT_LINE('[FIN] IDX_AIC_COD_ID...  La tabla no existe');
                End If;
          End If;
    End If;

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
