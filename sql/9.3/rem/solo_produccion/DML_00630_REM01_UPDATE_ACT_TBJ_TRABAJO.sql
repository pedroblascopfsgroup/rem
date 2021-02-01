--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210121
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8696
--## PRODUCTO=NO
--##
--## Finalidad: PONER NULL EN FECHAHORA CONCRETA DE TRABAJOS QUE CAUSABA ERRORES EN CORREOS A PROVEEDORES
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';  -- Tabla a modificar
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8696'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en '||V_TABLA||'');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                TBJ_FECHA_HORA_CONCRETA = NULL,
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE
                WHERE TBJ_FECHA_HORA_CONCRETA LIKE ''01/01/70%''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] FECHAHORA CONCRETA MODIFICADA CORRECTAMENTE EN '||sql%rowcount ||' REGISTROS');
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] ');
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT