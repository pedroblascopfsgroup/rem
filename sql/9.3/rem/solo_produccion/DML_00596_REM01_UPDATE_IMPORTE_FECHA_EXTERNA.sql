--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8592
--## PRODUCTO=NO
--##
--## Finalidad:  
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-8592';
    
    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('6875934'),
        T_TIPO_DATA('6874959')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la anulación de venta');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

            V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
                        SET ACT_VENTA_EXTERNA_FECHA = NULL
                            ,ACT_VENTA_EXTERNA_IMPORTE = NULL
                            ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE ACT_NUM_ACTIVO =  '||V_TMP_TIPO_DATA(1)||' ';
            EXECUTE IMMEDIATE V_SQL;

        V_COUNT:=V_COUNT+1;    	

        DBMS_OUTPUT.PUT_LINE('[FIN] El activo '||V_TMP_TIPO_DATA(1)||' se ha actualizado correctamente');

    END LOOP;

	COMMIT;

	
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;
END;
/
EXIT;

