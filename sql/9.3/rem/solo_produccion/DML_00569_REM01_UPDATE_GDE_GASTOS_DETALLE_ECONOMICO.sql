--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201209
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8469
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  ACTUALIZAR CHECK EXENTO
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8469'; --Vble. auxiliar para almacenar el usuario
    V_TABLA_GASTOS_PROV VARCHAR2(100 CHAR) :='GPV_GASTOS_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar 
    V_TABLA_GASTOS_DETALLE VARCHAR2(100 CHAR) :='GDE_GASTOS_DETALLE_ECONOMICO'; --Vble. auxiliar para almacenar la tabla a insertar    

    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion


 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('12474383'),
        T_TIPO_DATA('12474265'),
        T_TIPO_DATA('12464720'),
        T_TIPO_DATA('12464705'),
        T_TIPO_DATA('12464692'),
        T_TIPO_DATA('12464605'),
        T_TIPO_DATA('12431574'),
        T_TIPO_DATA('12428623'),
        T_TIPO_DATA('12348282'),
        T_TIPO_DATA('12336353'),
        T_TIPO_DATA('12336352'),
        T_TIPO_DATA('12336351'),
        T_TIPO_DATA('12330025'),
        T_TIPO_DATA('12329984'),
        T_TIPO_DATA('12311786'),
        T_TIPO_DATA('12283805'),
        T_TIPO_DATA('12274653'),
        T_TIPO_DATA('12274651'),
        T_TIPO_DATA('12274648'),
        T_TIPO_DATA('12274645'),
        T_TIPO_DATA('12271979'),
        T_TIPO_DATA('12271973'),
        T_TIPO_DATA('12271970'),
        T_TIPO_DATA('12271968'),
        T_TIPO_DATA('12271967'),
        T_TIPO_DATA('12271965'),
        T_TIPO_DATA('12271963'),
        T_TIPO_DATA('12271962'),
        T_TIPO_DATA('12271959'),
        T_TIPO_DATA('12271958'),
        T_TIPO_DATA('12271954'),
        T_TIPO_DATA('12271953'),
        T_TIPO_DATA('12271952'),
        T_TIPO_DATA('12271933'),
        T_TIPO_DATA('12271931'),
        T_TIPO_DATA('12271928'),
        T_TIPO_DATA('12271922'),
        T_TIPO_DATA('12271900'),
        T_TIPO_DATA('12271898'),
        T_TIPO_DATA('12271888'),
        T_TIPO_DATA('12256832'),
        T_TIPO_DATA('12256831'),
        T_TIPO_DATA('12256829'),
        T_TIPO_DATA('12256823'),
        T_TIPO_DATA('12256821'),
        T_TIPO_DATA('12256820'),
        T_TIPO_DATA('12256817'),
        T_TIPO_DATA('12244681'),
        T_TIPO_DATA('12240656'),
        T_TIPO_DATA('12204444'),
        T_TIPO_DATA('12148246'),
        T_TIPO_DATA('12134445'),
        T_TIPO_DATA('12129225'),
        T_TIPO_DATA('12072298'),
        T_TIPO_DATA('12045248'),
        T_TIPO_DATA('12039614'),
        T_TIPO_DATA('12033733'),
        T_TIPO_DATA('12029870'),
        T_TIPO_DATA('11984611'),
        T_TIPO_DATA('11984610'),
        T_TIPO_DATA('11984609'),
        T_TIPO_DATA('11984605'),
        T_TIPO_DATA('11984602'),
        T_TIPO_DATA('11984599'),
        T_TIPO_DATA('11984597'),
        T_TIPO_DATA('11984592'),
        T_TIPO_DATA('11984591'),
        T_TIPO_DATA('11984589'),
        T_TIPO_DATA('11984586'),
        T_TIPO_DATA('11984581'),
        T_TIPO_DATA('11984575'),
        T_TIPO_DATA('11980576'),
        T_TIPO_DATA('11295483')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA_GASTOS_DETALLE||' ');            

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        --Comprobar si el gasto existe
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GASTOS_PROV||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
        
        IF V_NUM_TABLAS > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS EL CHECK EXENTO DEL GASTO GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');
            
            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_GASTOS_DETALLE||' SET 
                    GDE_IMP_IND_EXENTO = 1,
                    USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    FECHAMODIFICAR = SYSDATE 
                    WHERE GPV_ID = (SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA_GASTOS_PROV||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''') ';

            EXECUTE IMMEDIATE V_MSQL;

        ELSE                
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO CON GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');

        END IF;

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