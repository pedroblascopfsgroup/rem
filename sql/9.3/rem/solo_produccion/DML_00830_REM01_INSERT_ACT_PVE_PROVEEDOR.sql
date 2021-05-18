--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210503
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9603
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  INSERTAR PROVEEDORES
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
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PVE_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar
    
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    V_TIPO NUMBER(16);
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion

 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --PVE_DOCIDENTIF DD_TPR_ID
        T_TIPO_DATA('A28520278','05'),
        T_TIPO_DATA('A48027056','05'),
        T_TIPO_DATA('A48283964','05'),
        T_TIPO_DATA('A54496005','05'),
        T_TIPO_DATA('A80628597','05'),
        T_TIPO_DATA('B02504694','05'),
        T_TIPO_DATA('B04522454','05'),
        T_TIPO_DATA('B04880670','05'),
        T_TIPO_DATA('B10229623','05'),
        T_TIPO_DATA('B12640637','05'),
        T_TIPO_DATA('B25613282','05'),
        T_TIPO_DATA('B29353026','05'),
        T_TIPO_DATA('B33878786','05'),
        T_TIPO_DATA('B39539606','05'),
        T_TIPO_DATA('B39666052','05'),
        T_TIPO_DATA('B46635991','05'),
        T_TIPO_DATA('B61540969','05'),
        T_TIPO_DATA('B62001110','05'),
        T_TIPO_DATA('B63311898','05'),
        T_TIPO_DATA('B63572267','05'),
        T_TIPO_DATA('B63715809','05'),
        T_TIPO_DATA('B63918445','05'),
        T_TIPO_DATA('B73658312','05'),
        T_TIPO_DATA('B81480352','05'),
        T_TIPO_DATA('B82741851','05'),
        T_TIPO_DATA('B85757300','05'),
        T_TIPO_DATA('B85830602','05'),
        T_TIPO_DATA('B86408374','05'),
        T_TIPO_DATA('B86884848','05'),
        T_TIPO_DATA('B87009734','05'),
        T_TIPO_DATA('B87621256','05'),
        T_TIPO_DATA('B98020001','05'),
        T_TIPO_DATA('B98803612','05'),
        T_TIPO_DATA('U12663605','05'),
        T_TIPO_DATA('06541573M','05'),
        T_TIPO_DATA('22527396T','05'),
        T_TIPO_DATA('27244328T','05'),
        T_TIPO_DATA('28948676W','05'),
        T_TIPO_DATA('74919472P','05'),
        T_TIPO_DATA('13889238K','36'),
        T_TIPO_DATA('27480036G','19'),
        T_TIPO_DATA('B06547053','02'),
        T_TIPO_DATA('B86420619','36'),
        T_TIPO_DATA('B86575172','19'),
        T_TIPO_DATA('B91588426','42'),
        T_TIPO_DATA('B92741743','19'),
        T_TIPO_DATA('B96333331','27'),
        T_TIPO_DATA('B96591763','27'),
        T_TIPO_DATA('B97449532','04'),
        T_TIPO_DATA('E81343519','19'),
        T_TIPO_DATA('J14824007','04'),
        T_TIPO_DATA('P0400600C','13')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN '||V_TABLA||' ');            

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        --Comprobar si ya existe
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_DOCIDENTIF='''||V_TMP_TIPO_DATA(1)||''' AND DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''43'')';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
        
        IF V_NUM_TABLAS = 0 THEN

            V_MSQL :='SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_TIPO;         

            V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
            (PVE_ID
           ,PVE_COD_UVEM
           ,DD_TPR_ID
           ,PVE_NOMBRE
           ,PVE_NOMBRE_COMERCIAL
           ,DD_TDI_ID
           ,PVE_DOCIDENTIF
           ,DD_PRV_ID
           ,DD_LOC_ID
           ,PVE_CP
           ,PVE_DIRECCION
           ,PVE_TELF1
           ,PVE_TELF2
           ,PVE_EMAIL
           ,PVE_PAGINA_WEB
           ,PVE_FRANQUICIA
           ,PVE_IVA_CAJA
           ,PVE_NUM_CUENTA
           ,DD_TPC_ID
           ,DD_TPE_ID
           ,PVE_NIF
           ,PVE_FECHA_ALTA
           ,PVE_LOCALIZADA
           ,DD_EPR_ID
           ,PVE_AMBITO
           ,PVE_OBSERVACIONES
           ,PVE_HOMOLOGADO
           ,DD_CPR_ID
           ,PVE_TOP
           ,PVE_TITULAR_CUENTA
           ,PVE_RETENER
           ,DD_MRE_ID
           ,PVE_FECHA_RETENCION
           ,PVE_COD_API_PROVEEDOR
           ,PVE_AUTORIZACION_WEB
           ,PVE_COD_PRINEX
           ,PVE_ENVIADO
           ,PVE_COD_ORIGEN
           ,PVE_ID_PERSONA_HAYA
           ,USUARIOCREAR
           ,FECHACREAR
           ,PVE_COD_REM
           ,PVE_WEBCOM_ID)
            SELECT '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.NEXTVAL,
            PVE.PVE_COD_UVEM,
            (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''43''),
            PVE.PVE_NOMBRE,
            PVE.PVE_NOMBRE_COMERCIAL,
            PVE.DD_TDI_ID,
            '''||V_TMP_TIPO_DATA(1)||''',
            PVE.DD_PRV_ID,
            PVE.DD_LOC_ID,
            PVE.PVE_CP,
            PVE.PVE_DIRECCION,
            PVE.PVE_TELF1,
            PVE.PVE_TELF2,
            PVE.PVE_EMAIL,
            PVE.PVE_PAGINA_WEB,
            PVE.PVE_FRANQUICIA,
            PVE.PVE_IVA_CAJA,
            PVE.PVE_NUM_CUENTA,
            PVE.DD_TPC_ID,
            PVE.DD_TPE_ID,
            PVE.PVE_NIF,
            PVE.PVE_FECHA_ALTA,
            PVE.PVE_LOCALIZADA,
            PVE.DD_EPR_ID,
            PVE.PVE_AMBITO,
            PVE.PVE_OBSERVACIONES,
            PVE.PVE_HOMOLOGADO,
            PVE.DD_CPR_ID,
            PVE.PVE_TOP,
            PVE.PVE_TITULAR_CUENTA,
            PVE.PVE_RETENER,
            PVE.DD_MRE_ID,
            PVE.PVE_FECHA_RETENCION,
            PVE.PVE_COD_API_PROVEEDOR,
            PVE.PVE_AUTORIZACION_WEB,
            PVE.PVE_COD_PRINEX,
            PVE.PVE_ENVIADO,
            PVE.PVE_COD_ORIGEN,
            PVE.PVE_ID_PERSONA_HAYA,
            '''||V_USUARIO||''',
            SYSDATE,
            PVE.PVE_COD_REM,
            PVE.PVE_WEBCOM_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA||' PVE WHERE PVE.PVE_DOCIDENTIF = '''||V_TMP_TIPO_DATA(1)||''' AND PVE.DD_TPR_ID = '||V_TIPO||'
            ';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: PROVEEDOR CON DOCIDENTIF '''||V_TMP_TIPO_DATA(1)||''' INSERTADO');

        ELSE                
            DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL PROVEEDOR CON DOCIDENTIF: '''||V_TMP_TIPO_DATA(1)||''' Y TIPO PROVEEDOR SUELOS DND');

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