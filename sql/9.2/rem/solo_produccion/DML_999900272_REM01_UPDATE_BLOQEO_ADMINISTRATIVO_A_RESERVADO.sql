--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20180619
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1091
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar la reserva indicada del expediente indicado al estado indicado y, ademas, borrarle la fecha de firma
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
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
    V_USUARIOMODIFICAR VARCHAR2(50 CHAR):= 'REMVIP-988';
        
BEGIN
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET
      DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''06''),
      USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
      FECHAMODIFICAR = SYSDATE
      WHERE ECO_ID IN (
      SELECT ECO.ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
      JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID
      JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON ECO.TBJ_ID = TBJ.TBJ_ID
      JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID
      JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
      JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR on TAR.TAR_ID = TAC.TAR_ID
      LEFT JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON ECO.ECO_ID = RES.ECO_ID
      JOIN '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE ON RES.DD_ERE_ID = ERE.DD_ERE_ID
      WHERE EEC.DD_EEC_CODIGO = ''05'' AND TAR.TAR_DESCRIPCION = ''Resolución tanteo'' AND TAR.TAR_FECHA_FIN IS NOT NULL
      AND ERE.DD_ERE_CODIGO = ''02'')';
    EXECUTE IMMEDIATE V_SQL;
		
    DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros');

    COMMIT;
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