--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210721
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14647
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
    V_USUARIO VARCHAR(100 CHAR):= 'HREOS-14647';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_TOTAL NUMBER(16):=0;   
    V_TABLA VARCHAR2(50 CHAR):='DD_CRA_CARTERA';
    V_UNICA VARCHAR2(50 CHAR):='Unicaja';
    V_LIBER VARCHAR2(50 CHAR):='Liberbank';
    V_CODIGO_CARTERA VARCHAR2(50 CHAR):='08';
    V_CODIGO_SUBCARTERA VARCHAR2(50 CHAR):='56';


BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR CARTERA Liberbank');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' CRA            
            WHERE CRA.DD_CRA_CODIGO='''||V_CODIGO_CARTERA||''' AND CRA.DD_CRA_DESCRIPCION='''||V_LIBER||''' ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN            

        V_SQL := ' UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                    USUARIOMODIFICAR = ''' || V_USUARIO || ''',
                    FECHAMODIFICAR = SYSDATE, 
                    DD_CRA_DESCRIPCION = '''||V_UNICA||''',
                    DD_CRA_DESCRIPCION_LARGA = '''||V_UNICA||'''
                    WHERE DD_CRA_CODIGO='||V_CODIGO_CARTERA||' ';	

        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Modificada cartera '||V_CODIGO_CARTERA||' - '''||V_LIBER||''' por '''||V_UNICA||''' correctamente'); 



    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] No existe la cartera o la cartera no tiene de descripcion Bankia');
                
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR            
            WHERE SCR.DD_SCR_CODIGO='''||V_CODIGO_SUBCARTERA||''' AND SCR.DD_SCR_DESCRIPCION='''||V_LIBER||''' ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN            

        V_SQL := ' UPDATE '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SET 
                    USUARIOMODIFICAR = ''' || V_USUARIO || ''',
                    FECHAMODIFICAR = SYSDATE, 
                    DD_SCR_DESCRIPCION = '''||V_UNICA||''',
                    DD_SCR_DESCRIPCION_LARGA = '''||V_UNICA||'''
                    WHERE DD_SCR_CODIGO='||V_CODIGO_SUBCARTERA||' ';	

        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Modificada SUBCARTERA '||V_CODIGO_SUBCARTERA||' - '''||V_LIBER||''' por '''||V_UNICA||''' correctamente'); 



    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] No existe la cartera o la cartera no tiene de descripcion Bankia');
                
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