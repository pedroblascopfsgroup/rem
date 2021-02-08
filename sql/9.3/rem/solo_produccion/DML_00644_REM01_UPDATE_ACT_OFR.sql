--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8808
--## PRODUCTO=NO
--##
--## Finalidad: OFERTA MAL CREADA
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para consulta que valida la existencia de una tabla.
  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_OFR';  -- Tabla a modificar
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8808'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_ID = 603391 AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO] RELACION ACTIVOS-OFERTA ERRÓNEA');

        V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_ID = 603391';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] RECTIFICACION RELACION ACTIVOS-OFERTA');

        DBMS_OUTPUT.PUT_LINE('[INFO] Insercion en '||V_TABLA||'');

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ACT_ID, OFR_ID, ACT_OFR_IMPORTE, VERSION, OFR_ACT_PORCEN_PARTICIPACION)
            VALUES (389891, 603391, ''83900'', 0, ''88,60'')';
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ACT_ID, OFR_ID, ACT_OFR_IMPORTE, VERSION, OFR_ACT_PORCEN_PARTICIPACION)
            VALUES (389897, 603391, ''10800'', 0, ''11,40'')';
        EXECUTE IMMEDIATE V_MSQL;

    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE OFERTA');

    END IF;
    
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