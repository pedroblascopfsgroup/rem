--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20181113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2512
--## PRODUCTO=SI
--##
--## Finalidad: Insertar configuracion para mapeo gestor documental
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA_E VARCHAR2(2400 CHAR) := 'MGD_MAPEO_GESTOR_DOC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_P VARCHAR2(2400 CHAR) := 'MGP_MAPEO_GESTOR_DOC_PRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
   V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'REMVIP-2512';
    
    
    
BEGIN
    --Insercion de registros para Zeus y Galeon en la tabla de expedientes comerciales
    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar datos en '||V_TEXT_TABLA_E);
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_E||' 
      WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''13'')
      AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''41'')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS = 0 THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_E||' (MGD_ID, DD_CRA_ID, DD_SCR_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR)
          VALUES (S_MGD_MAPEO_GESTOR_DOC.NEXTVAL, (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''13''), 
          (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''41''), ''Gescobro'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';

        EXECUTE IMMEDIATE V_MSQL;
      
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_E||' 
      WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''15'')
      AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''40'')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS = 0 THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_E||' (MGD_ID, DD_CRA_ID, DD_SCR_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR)
          VALUES (S_MGD_MAPEO_GESTOR_DOC.NEXTVAL, (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''15''), 
          (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''40''), ''LCM Partners'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';

        EXECUTE IMMEDIATE V_MSQL;
      
    END IF;

    --Insercion de registros para Zeus y Galeon en la tabla de gastos
    DBMS_OUTPUT.PUT_LINE('[FIN] Insertado correctamente en '||V_TEXT_TABLA_E);

    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar datos en '||V_TEXT_TABLA_P);
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_P||'
      WHERE PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''R9602817J'')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS > 0 THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_P||' (MGP_ID, PRO_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR)
          VALUES (S_MGP_MAPEO_GESTOR_DOC_PRO.NEXTVAL, (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''R9602817J''), 
          ''Gescobro'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';

        EXECUTE IMMEDIATE V_MSQL;
      
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_P||'
      WHERE PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''B87872156'')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS > 0 THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_P||' (MGP_ID, PRO_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR)
          VALUES (S_MGP_MAPEO_GESTOR_DOC_PRO.NEXTVAL, (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''B87872156''), 
          ''LCM Partners'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';

        EXECUTE IMMEDIATE V_MSQL;
      
    END IF;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Insertado correctamente'||V_TEXT_TABLA_P);
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;