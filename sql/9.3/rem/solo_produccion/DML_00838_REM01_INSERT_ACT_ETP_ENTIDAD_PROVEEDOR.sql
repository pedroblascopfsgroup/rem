--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210505
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9603
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  INSERTAR CARTERAS EN PROVEEDORES
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9603'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ETP_ENTIDAD_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar
    
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    V_PVE_ID NUMBER(16);
    V_CRA_ID NUMBER(16);
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion

 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --PVE_DOCIDENTIF
        T_TIPO_DATA('A28520278', '07'),
        T_TIPO_DATA('A48027056', '03'),
        T_TIPO_DATA('A48283964', '03'),
        T_TIPO_DATA('A54496005', '01'),
        T_TIPO_DATA('A80628597', '03'),
        T_TIPO_DATA('A80628597', '01'),
        T_TIPO_DATA('A80628597', '08'),
        T_TIPO_DATA('A80628597', '07'),
        T_TIPO_DATA('A80628597', '02'),
        T_TIPO_DATA('A80628597', '16'),
        T_TIPO_DATA('B02504694', '08'),
        T_TIPO_DATA('B04522454', '02'),
        T_TIPO_DATA('B04522454', '03'),
        T_TIPO_DATA('B04522454', '01'),
        T_TIPO_DATA('B04522454', '08'),
        T_TIPO_DATA('B04522454', '07'),
        T_TIPO_DATA('B04522454', '16'),
        T_TIPO_DATA('B04880670', '02'),
        T_TIPO_DATA('B04880670', '03'),
        T_TIPO_DATA('B04880670', '01'),
        T_TIPO_DATA('B04880670', '08'),
        T_TIPO_DATA('B04880670', '07'),
        T_TIPO_DATA('B04880670', '16'),
        T_TIPO_DATA('B10229623', '08'),
        T_TIPO_DATA('B12640637', '02'),
        T_TIPO_DATA('B12640637', '03'),
        T_TIPO_DATA('B12640637', '01'),
        T_TIPO_DATA('B12640637', '08'),
        T_TIPO_DATA('B12640637', '07'),
        T_TIPO_DATA('B12640637', '16'),
        T_TIPO_DATA('B25613282', '07'),
        T_TIPO_DATA('B29353026', '01'),
        T_TIPO_DATA('B33878786', '08'),
        T_TIPO_DATA('B39539606', '08'),
        T_TIPO_DATA('B39666052', '02'),
        T_TIPO_DATA('B39666052', '03'),
        T_TIPO_DATA('B39666052', '01'),
        T_TIPO_DATA('B39666052', '08'),
        T_TIPO_DATA('B39666052', '07'),
        T_TIPO_DATA('B39666052', '16'),
        T_TIPO_DATA('B46635991', '03'),
        T_TIPO_DATA('B61540969', '07'),
        T_TIPO_DATA('B62001110', '02'),
        T_TIPO_DATA('B62001110', '03'),
        T_TIPO_DATA('B62001110', '01'),
        T_TIPO_DATA('B62001110', '08'),
        T_TIPO_DATA('B62001110', '07'),
        T_TIPO_DATA('B62001110', '16'),
        T_TIPO_DATA('B63311898', '07'),
        T_TIPO_DATA('B63572267', '02'),
        T_TIPO_DATA('B63572267', '03'),
        T_TIPO_DATA('B63572267', '01'),
        T_TIPO_DATA('B63572267', '08'),
        T_TIPO_DATA('B63572267', '07'),
        T_TIPO_DATA('B63572267', '16'),
        T_TIPO_DATA('B63715809', '02'),
        T_TIPO_DATA('B63715809', '03'),
        T_TIPO_DATA('B63715809', '01'),
        T_TIPO_DATA('B63715809', '08'),
        T_TIPO_DATA('B63715809', '07'),
        T_TIPO_DATA('B63715809', '16'),
        T_TIPO_DATA('B63918445', '07'),
        T_TIPO_DATA('B73658312', '02'),
        T_TIPO_DATA('B73658312', '03'),
        T_TIPO_DATA('B73658312', '01'),
        T_TIPO_DATA('B73658312', '08'),
        T_TIPO_DATA('B73658312', '07'),
        T_TIPO_DATA('B73658312', '16'),
        T_TIPO_DATA('B81480352', '02'),
        T_TIPO_DATA('B81480352', '03'),
        T_TIPO_DATA('B81480352', '01'),
        T_TIPO_DATA('B81480352', '08'),
        T_TIPO_DATA('B81480352', '07'),
        T_TIPO_DATA('B81480352', '16'),
        T_TIPO_DATA('B82741851', '08'),
        T_TIPO_DATA('B85757300', '07'),
        T_TIPO_DATA('B85830602', '02'),
        T_TIPO_DATA('B85830602', '03'),
        T_TIPO_DATA('B85830602', '01'),
        T_TIPO_DATA('B85830602', '08'),
        T_TIPO_DATA('B85830602', '07'),
        T_TIPO_DATA('B85830602', '16'),
        T_TIPO_DATA('B86408374', '02'),
        T_TIPO_DATA('B86408374', '03'),
        T_TIPO_DATA('B86408374', '01'),
        T_TIPO_DATA('B86408374', '08'),
        T_TIPO_DATA('B86408374', '07'),
        T_TIPO_DATA('B86408374', '16'),
        T_TIPO_DATA('B86884848', '08'),
        T_TIPO_DATA('B87009734', '07'),
        T_TIPO_DATA('B87621256', '08'),
        T_TIPO_DATA('B98020001', '02'),
        T_TIPO_DATA('B98020001', '03'),
        T_TIPO_DATA('B98020001', '01'),
        T_TIPO_DATA('B98020001', '08'),
        T_TIPO_DATA('B98020001', '07'),
        T_TIPO_DATA('B98020001', '16'),
        T_TIPO_DATA('B98803612', '03'),
        T_TIPO_DATA('U12663605', '01'),
        T_TIPO_DATA('06541573M', '02'),
        T_TIPO_DATA('06541573M', '03'),
        T_TIPO_DATA('06541573M', '01'),
        T_TIPO_DATA('06541573M', '08'),
        T_TIPO_DATA('06541573M', '07'),
        T_TIPO_DATA('06541573M', '16'),
        T_TIPO_DATA('22527396T', '07'),
        T_TIPO_DATA('27244328T', '01'),
        T_TIPO_DATA('28948676W', '08'),
        T_TIPO_DATA('74919472P', '02'),
        T_TIPO_DATA('74919472P', '03'),
        T_TIPO_DATA('74919472P', '01'),
        T_TIPO_DATA('74919472P', '08'),
        T_TIPO_DATA('74919472P', '07'),
        T_TIPO_DATA('74919472P', '16'),
        T_TIPO_DATA('13889238K', '02'),
        T_TIPO_DATA('13889238K', '03'),
        T_TIPO_DATA('13889238K', '01'),
        T_TIPO_DATA('13889238K', '08'),
        T_TIPO_DATA('13889238K', '07'),
        T_TIPO_DATA('13889238K', '16'),
        T_TIPO_DATA('27480036G', '02'),
        T_TIPO_DATA('27480036G', '03'),
        T_TIPO_DATA('27480036G', '01'),
        T_TIPO_DATA('27480036G', '08'),
        T_TIPO_DATA('27480036G', '07'),
        T_TIPO_DATA('27480036G', '16'),
        T_TIPO_DATA('B06547053', '08'),
        T_TIPO_DATA('B86420619', '02'),
        T_TIPO_DATA('B86420619', '03'),
        T_TIPO_DATA('B86420619', '01'),
        T_TIPO_DATA('B86420619', '08'),
        T_TIPO_DATA('B86420619', '07'),
        T_TIPO_DATA('B86420619', '16'),
        T_TIPO_DATA('B86575172', '07'),
        T_TIPO_DATA('B91588426', '07'),
        T_TIPO_DATA('B92741743', '02'),
        T_TIPO_DATA('B96333331', '07'),
        T_TIPO_DATA('B96333331', '16'),
        T_TIPO_DATA('B96591763', '03'),
        T_TIPO_DATA('B97449532', '03'),
        T_TIPO_DATA('E81343519', '03'),
        T_TIPO_DATA('J14824007', '02'),
        T_TIPO_DATA('J14824007', '03'),
        T_TIPO_DATA('J14824007', '01'),
        T_TIPO_DATA('J14824007', '08'),
        T_TIPO_DATA('J14824007', '07'),
        T_TIPO_DATA('J14824007', '16'),
        T_TIPO_DATA('P0400600C', '01')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN '||V_TABLA||' ');            

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);        
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF='''||V_TMP_TIPO_DATA(1)||''' AND USUARIOCREAR = ''REMVIP-9603''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
        
        IF V_NUM_TABLAS = 1 THEN

            V_MSQL :='SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF='''||V_TMP_TIPO_DATA(1)||''' AND USUARIOCREAR = ''REMVIP-9603''';
            EXECUTE IMMEDIATE V_MSQL INTO V_PVE_ID;       

            V_MSQL :='SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO ='''||V_TMP_TIPO_DATA(2)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_CRA_ID;         

            V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            ETP_ID,
            DD_CRA_ID,
            PVE_ID,
            USUARIOCREAR,
            FECHACREAR
            ) VALUES (
            '||V_ESQUEMA||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL,
            '||V_CRA_ID||',
            '||V_PVE_ID||',
            '''||V_USUARIO||''',
            SYSDATE
            )';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: CARTERA PARA EL PROVEEDOR '''||V_PVE_ID||''' INSERTADA');

        ELSE                
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL PROVEEDOR');

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