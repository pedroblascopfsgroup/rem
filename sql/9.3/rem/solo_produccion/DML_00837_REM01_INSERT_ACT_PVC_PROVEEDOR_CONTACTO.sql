--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210505
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9603
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  INSERTAR PROVEEDORES CONTACTOS
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
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PVC_PROVEEDOR_CONTACTO'; --Vble. auxiliar para almacenar la tabla a insertar
    
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    V_PVE_ID NUMBER(16);
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion

 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --PVE_DOCIDENTIF
        T_TIPO_DATA('A28520278'),
        T_TIPO_DATA('A48027056'),
        T_TIPO_DATA('A48283964'),
        T_TIPO_DATA('A54496005'),
        T_TIPO_DATA('A80628597'),
        T_TIPO_DATA('B02504694'),
        T_TIPO_DATA('B04522454'),
        T_TIPO_DATA('B04880670'),
        T_TIPO_DATA('B10229623'),
        T_TIPO_DATA('B12640637'),
        T_TIPO_DATA('B25613282'),
        T_TIPO_DATA('B29353026'),
        T_TIPO_DATA('B33878786'),
        T_TIPO_DATA('B39539606'),
        T_TIPO_DATA('B39666052'),
        T_TIPO_DATA('B46635991'),
        T_TIPO_DATA('B61540969'),
        T_TIPO_DATA('B62001110'),
        T_TIPO_DATA('B63311898'),
        T_TIPO_DATA('B63572267'),
        T_TIPO_DATA('B63715809'),
        T_TIPO_DATA('B63918445'),
        T_TIPO_DATA('B73658312'),
        T_TIPO_DATA('B81480352'),
        T_TIPO_DATA('B82741851'),
        T_TIPO_DATA('B85757300'),
        T_TIPO_DATA('B85830602'),
        T_TIPO_DATA('B86408374'),
        T_TIPO_DATA('B86884848'),
        T_TIPO_DATA('B87009734'),
        T_TIPO_DATA('B87621256'),
        T_TIPO_DATA('B98020001'),
        T_TIPO_DATA('B98803612'),
        T_TIPO_DATA('U12663605'),
        T_TIPO_DATA('06541573M'),
        T_TIPO_DATA('22527396T'),
        T_TIPO_DATA('27244328T'),
        T_TIPO_DATA('28948676W'),
        T_TIPO_DATA('74919472P'),
        T_TIPO_DATA('13889238K'),
        T_TIPO_DATA('27480036G'),
        T_TIPO_DATA('B06547053'),
        T_TIPO_DATA('B86420619'),
        T_TIPO_DATA('B86575172'),
        T_TIPO_DATA('B91588426'),
        T_TIPO_DATA('B92741743'),
        T_TIPO_DATA('B96333331'),
        T_TIPO_DATA('B96591763'),
        T_TIPO_DATA('B97449532'),
        T_TIPO_DATA('E81343519'),
        T_TIPO_DATA('J14824007'),
        T_TIPO_DATA('P0400600C')
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

            V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            PVC_ID,
            PVE_ID,
            PVC_NOMBRE,
            USUARIOCREAR,
            FECHACREAR,
            PVC_FECHA_ALTA
            ) VALUES (
            '||V_ESQUEMA||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL,
            '||V_PVE_ID||',
            ''Contacto DUMMY'',
            '''||V_USUARIO||''',
            SYSDATE,
            TO_DATE(SYSDATE, ''dd/MM/yyyy'')
            )';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: PROVEEDOR CONTACTO PARA EL PROVEEDOR '''||V_PVE_ID||''' INSERTADO');

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