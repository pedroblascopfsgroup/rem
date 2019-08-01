--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190801
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-4949
--## PRODUCTO=NO
--##
--## Finalidad: insertar proveedor ELECNOR a trabajos sin proveedor de sareb
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-4949';
	V_NUM NUMBER;
BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'MERGE INTO ACT_TBJ_TRABAJO T1
		USING (
		    SELECT TBJ.TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
		    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ AT ON AT.TBJ_ID = TBJ.TBJ_ID
		    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AT.ACT_ID
		    INNER JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID AND DD_STR_CODIGO IN (''18'',''19'',''20'',''21'',''22'',''23'',''24'')
		    INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND DD_CRA_CODIGO = ''02''
		    WHERE TBJ.PVC_ID IS NULL
		) T2
		ON (T1.TBJ_ID = T2.TBJ_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.PVC_ID = (SELECT PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO WHERE PVC_DOCIDENTIF = ''A48027056''),
		    T1.USUARIOMODIFICAR = '''||V_ITEM||''',
		    T1.FECHAMODIFICAR = SYSDATE';
	    
	EXECUTE IMMEDIATE V_MSQL;
	
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CONFIG WHERE ID = ''proveedor.elecnor''' INTO V_NUM;
	
	IF V_NUM < 1 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CONFIG(ID,VALOR) VALUES(''proveedor.elecnor'',''A48027056'')';
		EXECUTE IMMEDIATE V_MSQL;
	ELSE 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.CONFIG SET VALOR = ''A48027056'' WHERE ID = ''proveedor.elecnor''';
		EXECUTE IMMEDIATE V_MSQL;
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
EXIT;