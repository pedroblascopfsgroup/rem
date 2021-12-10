--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16632
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(25 CHAR):= 'HREOS-16632';

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS GEE_GESTOR_ENTIDAD ');

    V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR 
              (PVE_ID
              , DD_TPR_ID
              , PVE_NOMBRE
              , PVE_NOMBRE_COMERCIAL
              , DD_TDI_ID
              , PVE_DOCIDENTIF
              , PVE_EMAIL
              , PVE_PAGINA_WEB
              , PVE_FRANQUICIA
              , PVE_IVA_CAJA
              , VERSION
              , USUARIOCREAR
              , FECHACREAR
              , BORRADO
              , DD_TPC_ID
              , DD_TPE_ID
              , PVE_FECHA_ALTA
              , PVE_LOCALIZADA
              , DD_EPR_ID
              , PVE_HOMOLOGADO
              , PVE_TOP
              , PVE_RETENER
              , PVE_COD_REM
              , PVE_COD_API_PROVEEDOR
              , PVE_AUTORIZACION_WEB)
          SELECT
              '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.NEXTVAL PVE_ID
              , (SELECT TPR.DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = ''28'') DD_TPR_ID
              , ''Caixa - Oficina '' || LPAD(COD_CAIXABANK, 4, ''0'') PVE_NOMBRE
              , ''Caixa - Oficina '' || LPAD(COD_CAIXABANK, 4, ''0'') PVE_NOMBRE_COMERCIAL
              , (SELECT TDI.DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI WHERE TDI.DD_TDI_CODIGO = ''15'') DD_TDI_ID
              , ''A08663619'' PVE_DOCIDENTIF
              , ''oficina_'' || LPAD(COD_CAIXABANK, 4, ''0'') || ''@dummycaixa.com'' PVE_EMAIL
              , 0 PVE_PAGINA_WEB
              , 0 PVE_FRANQUICIA
              , 0 PVE_IVA_CAJA
              , 0 VERSION
              , '''||V_USU||''' USUARIOCREAR
              , SYSDATE FECHACREAR
              , 0 BORRADO
              , (SELECT TPC.DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPOS_COLABORADOR TPC WHERE TPC.DD_TPC_CODIGO = ''02'') DD_TPC_ID
              , (SELECT TPE.DD_TPE_ID FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA TPE WHERE TPE.DD_TPE_CODIGO = ''2'') DD_TPE_ID
              , SYSDATE PVE_FECHA_ALTA
              , 1 PVE_LOCALIZADA
              , (SELECT DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR WHERE DD_EPR_CODIGO = ''04'') DD_EPR_ID
              , 1 PVE_HOMOLOGADO
              , 0 PVE_TOP
              , 0 PVE_RETENER
              , '||V_ESQUEMA||'.S_PVE_COD_REM.NEXTVAL PVE_COD_REM
              , LPAD(COD_CAIXABANK, 4, ''0'') PVE_COD_API_PROVEEDOR
              , 0 PVE_AUTORIZACION_WEB
              FROM (SELECT MIN_A - 1 + LEVEL COD_CAIXABANK
              FROM (SELECT 
              MIN(0) MIN_A
              , MAX(9999) MAX_A
              FROM DUAL)
              CONNECT BY LEVEL <= MAX_A - MIN_A + 1)';
	EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_PVE_PROVEEDOR PARA NUEVAS OFICINAS CAIXA');

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
