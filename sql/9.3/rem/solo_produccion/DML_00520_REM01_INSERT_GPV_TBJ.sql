--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8332
--## PRODUCTO=NO
--##
--## Finalidad: Añadir trabajos a gasto
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
    V_NUM_TABLAS NUMBER(25);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8332'; -- USUARIO CREAR/MODIFICAR

    V_GASTO NUMBER(25):= 12274498;
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('916964321192'),
        T_TIPO_DATA('9000284897'),
        T_TIPO_DATA('9000230261'),
        T_TIPO_DATA('9000242699'),
        T_TIPO_DATA('9000282435'),
        T_TIPO_DATA('9000248028'),
        T_TIPO_DATA('9000211817'),
        T_TIPO_DATA('9000272009'),
        T_TIPO_DATA('9000265385'),
        T_TIPO_DATA('9000242902'),
        T_TIPO_DATA('9000259351'),
        T_TIPO_DATA('9000279603'),
        T_TIPO_DATA('9000256579'),
        T_TIPO_DATA('9000289979'),
        T_TIPO_DATA('9000267787')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '||V_GASTO||'');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_GASTO||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            DBMS_OUTPUT.PUT_LINE('[INFO]: VINCULAMOS GASTO '||V_GASTO||' - TRABAJO '||V_TMP_TIPO_DATA(1)||'');

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_TBJ (GPV_TBJ_ID, GPV_ID, TBJ_ID, USUARIOCREAR, FECHACREAR)
                            SELECT '||V_ESQUEMA||'.S_GPV_TBJ.NEXTVAL,
                            (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_GASTO||'),
                            (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||'),
                            '''||V_USUARIO||''',SYSDATE FROM DUAL';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '||V_GASTO||' - TRABAJO '||V_TMP_TIPO_DATA(1)||' VINCULADO');

            ELSE 

                DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO '||V_TMP_TIPO_DATA(1)||' NO EXISTE');

            END IF;
            
        END LOOP;

    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '||V_GASTO||' NO EXISTE');

    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: FIN');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT