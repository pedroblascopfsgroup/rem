--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210324
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9283
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
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-9283';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_TOTAL NUMBER(16):=0;

    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- TBJ_NUM_TRABAJO
                T_TIPO_DATA('916643700001'),
                T_TIPO_DATA('916950106435'),
                T_TIPO_DATA('916964302032'),
                T_TIPO_DATA('916964302131'),
                T_TIPO_DATA('916964319959'),
                T_TIPO_DATA('916964306039'),
                T_TIPO_DATA('916694200001'),
                T_TIPO_DATA('916964334578'),
                T_TIPO_DATA('916964314904'),
                T_TIPO_DATA('916964327277'),
                T_TIPO_DATA('916964319278'),
                T_TIPO_DATA('916964333524'),
                T_TIPO_DATA('916964325348'),
                T_TIPO_DATA('916964363802'),
                T_TIPO_DATA('916964343527'),
                T_TIPO_DATA('916964360270'),
                T_TIPO_DATA('916964366182'),
                T_TIPO_DATA('916964350143'),
                T_TIPO_DATA('916964352488'),
                T_TIPO_DATA('916964352325'),
                T_TIPO_DATA('916964357389'),
                T_TIPO_DATA('916964357382'),
                T_TIPO_DATA('916964360256'),
                T_TIPO_DATA('916468900001'),
                T_TIPO_DATA('916964372454'),
                T_TIPO_DATA('916964374745')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PROVEEDOR TRABAJO');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||''' AND DD_IRE_ID IS NULL AND BORRADO=0' INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

            V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET 
                        USUARIOMODIFICAR = ''' || V_USUARIO || ''',
                        FECHAMODIFICAR   = SYSDATE, 
                        DD_IRE_ID = (SELECT DD_IRE_ID FROM '||V_ESQUEMA||'.DD_IRE_IDENTIFICADOR_REAM WHERE DD_IRE_CODIGO=01)
                        WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||''' ';	

            EXECUTE IMMEDIATE V_SQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Modificado trabajo: '''||V_TMP_TIPO_DATA(1)||''' correctamente');
            V_COUNT := V_COUNT + 1;

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO] El trabajo no existe o no tiene a nulo el area peticionaria ');
                    
        END IF;

    END LOOP;
	
    
     DBMS_OUTPUT.PUT_LINE('[INFO]  Modificados '||V_COUNT||' trabajos correctamente de '||V_COUNT_TOTAL||'');  

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