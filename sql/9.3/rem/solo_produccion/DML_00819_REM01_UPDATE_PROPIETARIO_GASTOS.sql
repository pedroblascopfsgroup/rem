--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210421
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9444
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  ACTUALIZAR PROPIETARIOS GASTOS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9444'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='GPV_GASTOS_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar    
    V_TABLA_PROPIETARIOS VARCHAR2(100 CHAR) :='ACT_PRO_PROPIETARIO';
    
    V_DOCIDENTIF VARCHAR2(100 CHAR) :='V84856319'; --DOCIDENTIF del propietario a actualizar
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion

    V_CPP_BASE VARCHAR2(100 CHAR):='749103';


 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --GPV_NUM_GASTO_HAYA
        T_TIPO_DATA('13808823'),
        T_TIPO_DATA('13808824'),
        T_TIPO_DATA('13808819'),
        T_TIPO_DATA('13808816'),
        T_TIPO_DATA('13808815'),
        T_TIPO_DATA('13808812'),
        T_TIPO_DATA('13808822'),
        T_TIPO_DATA('13808808'),
        T_TIPO_DATA('13808810'),
        T_TIPO_DATA('13808814'),
        T_TIPO_DATA('13808818'),
        T_TIPO_DATA('13808820'),
        T_TIPO_DATA('13808809'),
        T_TIPO_DATA('13808811'),
        T_TIPO_DATA('13808813'),
        T_TIPO_DATA('13808817'),
        T_TIPO_DATA('13808821')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||' ');            


    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIOS||' WHERE PRO_DOCIDENTIF='''||V_DOCIDENTIF||''' ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN              

        V_SQL:='SELECT PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIOS||' WHERE PRO_DOCIDENTIF='''||V_DOCIDENTIF||''' AND BORRADO=0';
         EXECUTE IMMEDIATE V_SQL INTO V_ID;

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
            --Comprobar si el gasto ya existe
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
            
            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PROPIETARIO DEL GASTO GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');
                    
                
                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                        PRO_ID = '||V_ID||' ,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE 
                        WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';

                EXECUTE IMMEDIATE V_MSQL;


                IF sql%rowcount > 0 THEN 
                    DBMS_OUTPUT.PUT_LINE('[INFO]: Modificado el GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||'''  Con propietario: '''||V_DOCIDENTIF||''' ');
                    DBMS_OUTPUT.PUT_LINE('[INFO]:                                                                                           ');
                    V_COUNT:=V_COUNT+1;
                END IF;


                V_MSQL :='UPDATE '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE SET
                            GLD_CPP_BASE = '''||V_CPP_BASE||''',
                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                            FECHAMODIFICAR = SYSDATE
                            WHERE GLD_ID= (SELECT GLD_ID FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD
                                            JOIN '||V_ESQUEMA||'.'||V_TABLA||' GPV ON GPV.GPV_ID=GLD.GPV_ID
                                            WHERE GLD.BORRADO=0 AND GPV.BORRADO=0 AND GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''')';
                EXECUTE IMMEDIATE V_MSQL;

            ELSE                
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO CON GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');

            END IF;

        END LOOP;

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE PROPIETARIO CON EL DOCIDENTIF INDICADO:  '''||V_DOCIDENTIF||''' ');
    END IF;

         DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADOS CORRECTAMENTE '''||V_COUNT||''' DE '''||V_COUNT_TOTAL||''' ');

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