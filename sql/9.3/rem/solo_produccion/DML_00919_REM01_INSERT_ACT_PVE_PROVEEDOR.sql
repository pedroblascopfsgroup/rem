--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210622
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9996
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  INSERTAR PROVEEDOR
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9996'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PVE_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar
    V_PVE_ID NUMBER(16);

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN '||V_TABLA||' ');            

    --Comprobar si ya existe
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_DOCIDENTIF = ''B97538672''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
    
    IF V_NUM_TABLAS = 0 THEN  

        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
        (PVE_ID
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
        ,PVE_EMAIL
        ,PVE_FECHA_ALTA
        ,DD_EPR_ID
        ,USUARIOCREAR
        ,FECHACREAR
        ,PVE_COD_REM) VALUES (
        '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.NEXTVAL,
        (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''04''),
        ''EDIMAR URBANA, SL'',
        ''EDIMAR URBANA, SL'',
        (SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''02''),
        ''B97538672'',
        (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = ''46''),
        (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = ''46131''),
        46701,
        ''Avenida de Beniopa, 22 - BJ'',
        ''639115806'',
        ''edimar.urbana@gmail.com'',
        TO_DATE(''22/06/2021'', ''DD/MM/YYYY''),
        (SELECT DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR WHERE DD_EPR_CODIGO = ''04''),
        '''||V_USUARIO||''',
        SYSDATE,
        '||V_ESQUEMA||'.S_PVE_COD_REM.NEXTVAL)';
        EXECUTE IMMEDIATE V_MSQL;

        --Se obtiene la secuencia creada en el insert anterior
        V_MSQL:= 'SELECT '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.CURRVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_PVE_ID;
    
        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO 
        (PVC_ID
        ,PVE_ID
        ,DD_PRV_ID       
        ,DD_TDI_ID
        ,PVC_DOCIDENTIF
        ,PVC_NOMBRE
        ,PVC_APELLID01
        ,PVC_CP
        ,PVC_TELF1
        ,PVC_EMAIL
        ,USUARIOCREAR
        ,FECHACREAR
        ,PVC_PRINCIPAL
        ,PVC_FECHA_ALTA) VALUES (
        '||V_ESQUEMA||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL,
        '||V_PVE_ID||',
        (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = ''46''),
        (SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''02''),
        ''B97538672'',
        ''SANTIAGO'',
        ''ARES'',
        46701,
        ''639115806'',
        ''edimar.urbana@gmail.com'',
        '''||V_USUARIO||''',
        SYSDATE,
        1,
        TO_DATE(''22/06/2021'', ''DD/MM/YYYY''))';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: PROVEEDOR INSERTADO');

    ELSE                

        DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL PROVEEDOR CON DOCIDENTIF: ''B97538672''');

    END IF;

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