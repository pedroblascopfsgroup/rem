--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2681
--## PRODUCTO=NO
--##
--## Finalidad: Script para insertar primer historico en la tabla ACT_AHP_HIST_PUBLICACION con misma fecha_ini y fecha_fin para VENTAS
--## VERSIONES:
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_ESQUEMA   VARCHAR2(50 CHAR) := 'REM01';
    V_MSQL      VARCHAR2(32000 CHAR);
    SOURCE_DATA VARCHAR2(3 CHAR) := 'ACT';
    DATA_SOURCE VARCHAR2(32000 CHAR);

BEGIN   

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('  INSERT PRIMERA HISTORICA EN ACT_AHP_HIST_PUBLICACION PARA VENTA');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION 
		    (AHP_ID
		    , ACT_ID
		    , DD_TPU_V_ID
		    , DD_EPV_ID
		    , DD_EPA_ID
		    , DD_TCO_ID
		    , DD_MTO_V_ID
		    , AHP_CHECK_PUBLICAR_V
		    , AHP_CHECK_OCULTAR_V
		    , AHP_CHECK_OCULTAR_PRECIO_V
		    , AHP_CHECK_PUB_SIN_PRECIO_V
		    , AHP_FECHA_INI_VENTA
		    , AHP_FECHA_FIN_VENTA
		    , USUARIOCREAR
		    , FECHACREAR) 
		SELECT '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL,
		ACT.ACT_ID,
		NULL,
		(SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA PUB  WHERE PUB.DD_EPV_CODIGO = ''03''),
		NULL,
		(SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO  WHERE TCO.DD_TCO_CODIGO = ''01''),
		NULL,
		1,
		0,
		0,
		0,
		TO_DATE(AUX.FECHA_INI, ''DD/MM/YYYY''),
		TO_DATE(AUX.FECHA_INI, ''DD/MM/YYYY''),
		''REMVIP_2681'',
		SYSDATE 
		FROM '||V_ESQUEMA||'.AUX_REMVIP_2681_3 AUX
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_ACTIVO
		WHERE AUX.TIPO_PUBLICACION = ''VENTA''';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(' REGISTROS INSERTADOS: '||SQL%ROWCOUNT);
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
            
    COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(SQLERRM);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          
END;
/
EXIT
