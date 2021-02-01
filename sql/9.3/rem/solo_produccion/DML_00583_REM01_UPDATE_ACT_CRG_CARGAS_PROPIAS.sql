--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8545
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualización de CRG_CARGAS_PROPIAS a SI (1)
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8545'; --Vble. auxiliar para almacenar el usuario

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		T_TIPO_DATA('6031785'),
            T_TIPO_DATA('6034673'),
            T_TIPO_DATA('6034679'),
            T_TIPO_DATA('6034681'),
            T_TIPO_DATA('6035098'),
            T_TIPO_DATA('6036332'),
            T_TIPO_DATA('6036335'),
            T_TIPO_DATA('6036339'),
            T_TIPO_DATA('6037457'),
            T_TIPO_DATA('6042669'),
            T_TIPO_DATA('6076553'),
            T_TIPO_DATA('6077775'),
            T_TIPO_DATA('6028922'),
            T_TIPO_DATA('6031954'),
            T_TIPO_DATA('6034676'),
            T_TIPO_DATA('6080549'),
            T_TIPO_DATA('6034680'),
            T_TIPO_DATA('6035099'),
            T_TIPO_DATA('6036334'),
            T_TIPO_DATA('6036337'),
            T_TIPO_DATA('6036340'),
            T_TIPO_DATA('6036543'),
            T_TIPO_DATA('6036547'),
            T_TIPO_DATA('6038229'),
            T_TIPO_DATA('6042666'),
            T_TIPO_DATA('6077182'),
            T_TIPO_DATA('6028919'),
            T_TIPO_DATA('6028921'),
            T_TIPO_DATA('6079342'),
            T_TIPO_DATA('6082078'),
            T_TIPO_DATA('6798912'),
            T_TIPO_DATA('6034674'),
            T_TIPO_DATA('6036261'),
            T_TIPO_DATA('6135271'),
            T_TIPO_DATA('6042668'),
            T_TIPO_DATA('6042670'),
            T_TIPO_DATA('6077714'),
            T_TIPO_DATA('6028920'),
            T_TIPO_DATA('6028923'),
            T_TIPO_DATA('6035100'),
            T_TIPO_DATA('6036341'),
            T_TIPO_DATA('6080456'),
            T_TIPO_DATA('6082076'),
            T_TIPO_DATA('6815762'),
            T_TIPO_DATA('6791844'),
            T_TIPO_DATA('6042870'),
            T_TIPO_DATA('6042905'),
            T_TIPO_DATA('6028590'),
            T_TIPO_DATA('6029472'),
            T_TIPO_DATA('6031783'),
            T_TIPO_DATA('6034678'),
            T_TIPO_DATA('6036333'),
            T_TIPO_DATA('6036336'),
            T_TIPO_DATA('6036338'),
            T_TIPO_DATA('6036725'),
            T_TIPO_DATA('6040563'),
            T_TIPO_DATA('6042665'),
            T_TIPO_DATA('6042667'),
            T_TIPO_DATA('6042671'),
            T_TIPO_DATA('6042902'),
            T_TIPO_DATA('6043637'),
            T_TIPO_DATA('6078130'),
            T_TIPO_DATA('6078738'),
            T_TIPO_DATA('6082077'),
            T_TIPO_DATA('6133691'),
            T_TIPO_DATA('6134888'),
            T_TIPO_DATA('6135113'),
            T_TIPO_DATA('6354700'),
            T_TIPO_DATA('6780897'),
            T_TIPO_DATA('7017670'),
            T_TIPO_DATA('6076641'),
            T_TIPO_DATA('6077777'),
            T_TIPO_DATA('6077779'),
            T_TIPO_DATA('6078323'),
            T_TIPO_DATA('6078509'),
            T_TIPO_DATA('6081586'),
            T_TIPO_DATA('6082308'),
            T_TIPO_DATA('6082580'),
            T_TIPO_DATA('6134583'),
            T_TIPO_DATA('6135659'),
            T_TIPO_DATA('6789284'),
            T_TIPO_DATA('6791842'),
            T_TIPO_DATA('6815756'),
            T_TIPO_DATA('6844352'),
            T_TIPO_DATA('6889776'),
            T_TIPO_DATA('6028924'),
            T_TIPO_DATA('6029000'),
            T_TIPO_DATA('6029814'),
            T_TIPO_DATA('6031590'),
            T_TIPO_DATA('6034675'),
            T_TIPO_DATA('6034677'),
            T_TIPO_DATA('6036149'),
            T_TIPO_DATA('6077778'),
            T_TIPO_DATA('6082075'),
            T_TIPO_DATA('6083984'),
            T_TIPO_DATA('6346161'),
            T_TIPO_DATA('6798783'),
            T_TIPO_DATA('6844339'),
            T_TIPO_DATA('7032010')); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR CRG_CARGAS_PROPIAS DE ACT_CRG_CARGAS A SI (1)');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0 ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

            IF V_COUNT != 0 THEN

                V_MSQL :=   'UPDATE '||V_ESQUEMA||'.ACT_CRG_CARGAS SET 
                            CRG_CARGAS_PROPIAS = 1,
                            USUARIOMODIFICAR = '''||V_USUARIO||''', 
                            FECHAMODIFICAR = SYSDATE
                            WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0)';

                EXECUTE IMMEDIATE V_MSQL;

            ELSE 

                DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '||V_TMP_TIPO_DATA(1)||' NO EXISTE O SE HA BORRADO'); 

            END IF;

                DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '||V_TMP_TIPO_DATA(1)||' HA SIDO ACTUALIZADO'); 

        END LOOP;
    
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
EXIT