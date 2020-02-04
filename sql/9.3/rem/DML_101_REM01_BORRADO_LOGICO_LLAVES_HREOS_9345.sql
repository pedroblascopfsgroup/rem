--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9345
--## PRODUCTO=NO
--##
--## Finalidad: Borrado lógico de las tablas: ACT_LLV_LLAVE y ACT_MLV_MOVIMIENTO_LLAVE
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'HREOS-9345';

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    --  Lista de tablas para borrado lógico cuyos registros no están borrados ya
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        T_FUNCION('ACT_LLV_LLAVE'),
        T_FUNCION('ACT_MLV_MOVIMIENTO_LLAVE')
    ); 
    V_TMP_FUNCION T_FUNCION;

    
BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando borrado lógico de las tablas:');
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
        DBMS_OUTPUT.PUT_LINE(V_TMP_FUNCION(1));
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TMP_FUNCION(1)||' SET BORRADO = 1, USUARIOBORRAR ='''||V_ITEM||''', FECHABORRAR = SYSDATE WHERE BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.put_line('[FIN] Realizado borrado lógico en '||V_ESQUEMA||'.'||V_TMP_FUNCION(1)||' de '||SQL%ROWCOUNT||' registros.');
	END LOOP;
    
    COMMIT;
    
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
