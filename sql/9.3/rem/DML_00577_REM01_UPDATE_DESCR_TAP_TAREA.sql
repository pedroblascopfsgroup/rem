--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210330
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9148
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
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-9148';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_TOTAL NUMBER(16):=0;   
    V_TABLA VARCHAR2(50 CHAR):='TAP_TAREA_PROCEDIMIENTO';
    V_CAIXA VARCHAR2(50 CHAR):='CaixaBank';
    V_BANKIA VARCHAR2(50 CHAR):='Bankia';


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- TAP_CODIGO
                T_TIPO_DATA('T004_AutorizacionBankia'),
                T_TIPO_DATA('T003_AutorizacionBankia'),
                T_TIPO_DATA('T002_AutorizacionBankia'),
                T_TIPO_DATA('T013_RespuestaBankiaDevolucion'),
                T_TIPO_DATA('T013_RespuestaBankiaAnulacionDevolucion')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;



BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR TAP_TAREAS_PROCEDIMIENTO BANKIA');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);


        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' TAP            
                WHERE TAP.TAP_CODIGO='''||V_TMP_TIPO_DATA(1)||''' AND TAP.TAP_DESCRIPCION LIKE ''%Bankia%'' ';

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN            

            V_SQL := ' UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                        USUARIOMODIFICAR = ''' || V_USUARIO || ''',
                        FECHAMODIFICAR = SYSDATE, 
                        TAP_DESCRIPCION = (SELECT REPLACE(TAP.TAP_DESCRIPCION,''Bankia'',''CaixaBank'') FROM '||V_ESQUEMA||'.'||V_TABLA||' TAP
                                                    WHERE TAP.TAP_CODIGO='''||V_TMP_TIPO_DATA(1)||''')                    
                        WHERE TAP_CODIGO='''||V_TMP_TIPO_DATA(1)||''' ';	

            EXECUTE IMMEDIATE V_SQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Modificada TAP_TAREA_PROCEDIMIENTO bankia por caixabank codigo='''||V_TMP_TIPO_DATA(1)||''' ');            

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO] No existe tarea con el codigo indicado ('''||V_TMP_TIPO_DATA(1)||''') o el codigo proporcionado no tiene de descripcion Bankia');
                    
        END IF;


    END LOOP;

    

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