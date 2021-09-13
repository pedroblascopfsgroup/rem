--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210908
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10418
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-10418';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR COLUMNAS DD_EEC_VENTA Y DD_EEC_ALQUILER PARA REGISTRO DE DICCIONARIO');

    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''43'' AND DD_EEC_VENTA IS NULL AND DD_EEC_ALQUILER IS NULL';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN            

        V_SQL := ' UPDATE '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL SET 
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE, 
                    DD_EEC_VENTA = 1,
                    DD_EEC_ALQUILER = 0
                    WHERE DD_EEC_CODIGO = ''43''';	

        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADO REGISTRO PDTE RESPUESTA OFERTANTE COMITÉ CORRECTAMENTE'); 

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: NO ES NECESARIO ACTUALIZAR EL REGISTRO PDTE RESPUESTA OFERTANTE COMITÉ');
                
    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT