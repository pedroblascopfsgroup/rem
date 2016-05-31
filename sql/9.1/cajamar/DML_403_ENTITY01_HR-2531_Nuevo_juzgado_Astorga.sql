--/*
--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=201600511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=HR-2531
--## PRODUCTO=NO
--## Finalidad: DML inserta juzgado Astorga
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
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema este caso haya01
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master este caso hayamaster
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    v_plaza VARCHAR2(25 CHAR);
BEGIN
  DBMS_OUTPUT.PUT_LINE('[INICIO HR-2531] Inserta juzgado Astorga '); 
  
  v_plaza := '1435';
  
  -- Plaza - 1435
  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.dd_pla_plazas WHERE dd_pla_codigo = '''||v_plaza||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
  -- Plaza
  IF V_NUM_TABLAS > 0 THEN    
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.dd_pla_plazas');
  ELSE
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.dd_pla_plazas ' ||
        ' (dd_pla_id, dd_pla_codigo, dd_pla_descripcion, dd_pla_descripcion_larga, version, usuariocrear, fechacrear, borrado, dtype) VALUES' ||
        ' ('|| V_ESQUEMA|| '.s_dd_pla_plazas.nextval, '''||v_plaza||''', ''ASTORGA'', ''ASTORGA'', 0, ''HR-2531'', SYSDATE, 0, ''LINTipoPlaza'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;  
  END IF;
  
  -- Juzgado 1 - 31847
  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.dd_juz_juzgados_plaza WHERE dd_juz_codigo = ''31847'' ';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  -- Juzgado 1 
  IF V_NUM_TABLAS > 0 THEN    
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.dd_juz_juzgados_plaza');
  ELSE
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.dd_juz_juzgados_plaza ' ||
        ' (dd_juz_id, dd_juz_codigo, dd_juz_descripcion, dd_juz_descripcion_larga, dd_pla_id, version, usuariocrear, fechacrear, borrado, dtype) VALUES' ||
        ' ('|| V_ESQUEMA|| '.s_dd_juz_juzgados_plaza.nextval, ''31847'', ''JUZGADO DE 1º INSTANCIA DE ASTORGA Nº-001'', ''JUZGADO DE 1º INSTANCIA DE ASTORGA Nº-001'','||
        ' (SELECT dd_pla_id FROM '||V_ESQUEMA||'.dd_pla_plazas WHERE dd_pla_codigo = '''||v_plaza||'''),' ||
        ' 0, ''HR-2531'', SYSDATE, 0, ''EXTTipoJuzgado'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
  END IF;
  
  -- Juzgado 2 - 31848
  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.dd_juz_juzgados_plaza WHERE dd_juz_codigo = ''31848'' ';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  -- Juzgado 1
  IF V_NUM_TABLAS > 0 THEN    
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.dd_juz_juzgados_plaza');
  ELSE
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.dd_juz_juzgados_plaza ' ||
        ' (dd_juz_id, dd_juz_codigo, dd_juz_descripcion, dd_juz_descripcion_larga, dd_pla_id, version, usuariocrear, fechacrear, borrado, dtype) VALUES' ||
        ' ('|| V_ESQUEMA|| '.s_dd_juz_juzgados_plaza.nextval, ''31848'', ''JUZGADO DE 1º INSTANCIA DE ASTORGA Nº-002'', ''JUZGADO DE 1º INSTANCIA DE ASTORGA Nº-002'','||
        ' (SELECT dd_pla_id FROM '||V_ESQUEMA||'.dd_pla_plazas WHERE dd_pla_codigo = '''||v_plaza||'''),' ||
        ' 0, ''HR-2531'', SYSDATE, 0, ''EXTTipoJuzgado'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
  END IF;
 
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN HR-2531] Inserta juzgado Astorga '); 

  EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------inserta juzgado Astorga-----------');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------inserta juzgado Astorga-----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/
EXIT;