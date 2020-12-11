--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8429
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    -- Ejecutar
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    -- Esquemas 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_8429';
    -- ID
    V_ID_EXPEDIENTE NUMBER(16); -- Vble. para el id del activo
    V_OFERTA_1 NUMBER(16) := 6006968;
    V_OFERTA_2 NUMBER(16) := 6007041;
    -- Tablas
    V_TABLA_GASTOS VARCHAR2(50 CHAR):= 'GEX_GASTOS_EXPEDIENTE';
    V_TABLA_EXPEDIENTE VARCHAR2(50 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    V_TABLA_OFERTAS VARCHAR2(50 CHAR):= 'OFR_OFERTAS';
    

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR COMISIONES DE LAS OFERTAS 6006968 Y 6007041');

    -----------------------------------------------------------------------------------------------------------

    -- Obtenemos el id de expediente
    V_MSQL := 'SELECT ECO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_EXPEDIENTE||' ECO 
                INNER JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
                WHERE OFR.OFR_NUM_OFERTA = '||V_OFERTA_1||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_EXPEDIENTE;	

    -- Actualizamos la comisión del expediente
    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_GASTOS||' SET
        DD_ACC_ID = (SELECT DD_ACC_ID FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS WHERE DD_ACC_CODIGO = ''05''),
        GEX_IMPORTE_CALCULO = 200000,
        GEX_IMPORTE_FINAL = 8000,
        GEX_PAGADOR = 0,
        VERSION = 1,
        USUARIOMODIFICAR = '''||V_USUARIO||''',
        FECHAMODIFICAR = SYSDATE,
        GEX_APROBADO = 0,
        DD_TPH_ID = NULL,
        GEX_IMPORTE_ORIGINAL = NULL
        WHERE ECO_ID = '||V_ID_EXPEDIENTE||' AND BORRADO = 0';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMISIÓN DE OFERTA '||V_OFERTA_1||' ACTUALIZADA');

    -----------------------------------------------------------------------------------------------------------

    -- Obtenemos el id de expediente
    V_MSQL := 'SELECT ECO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_EXPEDIENTE||' ECO 
                INNER JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
                WHERE OFR.OFR_NUM_OFERTA = '||V_OFERTA_2||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_EXPEDIENTE;	

    -- Actualizamos la comisión del expediente
    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_GASTOS||' SET
        DD_ACC_ID = (SELECT DD_ACC_ID FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS WHERE DD_ACC_CODIGO = ''05''),
        GEX_IMPORTE_CALCULO = 103400,
        GEX_IMPORTE_FINAL = 4136,
        GEX_PAGADOR = 0,
        VERSION = 1,
        USUARIOMODIFICAR = '''|| V_USUARIO ||''',
        FECHAMODIFICAR = SYSDATE,
        GEX_APROBADO = 0,
        DD_TPH_ID = NULL,
        GEX_IMPORTE_ORIGINAL = NULL
        WHERE ECO_ID = '||V_ID_EXPEDIENTE||' AND BORRADO = 0';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMISIÓN DE OFERTA '||V_OFERTA_2||' ACTUALIZADA');

    -----------------------------------------------------------------------------------------------------------

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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