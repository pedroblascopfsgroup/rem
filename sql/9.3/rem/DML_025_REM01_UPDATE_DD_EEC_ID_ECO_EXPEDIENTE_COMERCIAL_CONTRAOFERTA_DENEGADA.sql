--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190426
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK= HREOS-6251
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica el estado del expediente a "Contraoferta denegada" para aquellos expedientes anulados
--##			cuya tarea "Respuesta Ofertante" el cliente haya marcado como "Rechazada".
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	--Comprobamos el dato a insertar
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''29''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	--Si existe el código lo updateamos
	IF V_NUM_TABLAS > 0 THEN				
	  
		  DBMS_OUTPUT.PUT_LINE('	[INFO]  Existe el código 29 en el diccionario DD_EEC_EST_EXP_COMERCIAL. Procedemos a updatear los expedientes comerciales.');
		  
		  V_MSQL :=    'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1
						USING (
							SELECT DISTINCT ECO_ID 
							FROM (
								SELECT ACT.ACT_NUM_ACTIVO                                                       AS ACTIVO,
									   CRA.DD_CRA_DESCRIPCION                                                   AS CARTERA,
									   OFR.OFR_NUM_OFERTA                                                       AS OFERTA,
									   ECO.ECO_NUM_EXPEDIENTE                                                   AS EXPEDIENTE,
									   EOF.DD_EOF_DESCRIPCION                                                   AS ESTADO_OFERTA,
									   EEC.DD_EEC_DESCRIPCION                                                   AS ESTADO_EXPEDIENTE, 
									   TRA.TRA_ID                                                               AS TRAMITE,
									   TPO.DD_TPO_DESCRIPCION                                                   AS PROCEDIMIENTO,
									   TAP.TAP_CODIGO                                                           AS TAREA_COD,
									   TAR.TAR_DESCRIPCION                                                      AS TAREA,
									   TEV.TEV_NOMBRE                                                           AS CAMPO,
									   TEV.TEV_VALOR                                                            AS CAMPO_VALOR,
									   ROF.DD_ROF_DESCRIPCION                                                   AS CAMPO_VALOR_DD,
									   ECO.ECO_ID
								FROM '||V_ESQUEMA||'.ACT_ACTIVO                 ACT
								JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA             CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
								JOIN '||V_ESQUEMA||'.ACT_OFR                    AOF ON AOF.ACT_ID = ACT.ACT_ID
								JOIN '||V_ESQUEMA||'.OFR_OFERTAS                OFR ON OFR.OFR_ID = AOF.OFR_ID
								JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL   ECO ON ECO.OFR_ID = OFR.OFR_ID
								JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA      EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
								JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL   EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
								JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO            TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID
								JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE            TRA ON TRA.TBJ_ID = TBJ.TBJ_ID
								JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS         TAC ON TAC.TRA_ID = TRA.TRA_ID
								JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES  TAR ON TAR.TAR_ID = TAC.TAR_ID
								JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA          TEX ON TEX.TAR_ID = TAR.TAR_ID
								JOIN '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR    TEV ON TEV.TEX_ID = TEX.TEX_ID
								JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO    TAP ON TAP.TAP_ID = TEX.TAP_ID
								JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO  TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
								JOIN '||V_ESQUEMA||'.DD_ROF_RESPUESTA_OFERTANTE ROF ON ROF.DD_ROF_CODIGO = TEV.TEV_VALOR
								WHERE CRA.DD_CRA_CODIGO IN (''12'')                                            
								  AND TAP.TAP_CODIGO IN (''T013_RespuestaOfertante'')                            
								  AND TEV.TEV_NOMBRE = ''comboRespuesta''                                    
								  AND ROF.DD_ROF_CODIGO = ''02''                                                 
								  AND ACT.BORRADO = 0
								  AND OFR.BORRADO = 0
								  AND ECO.BORRADO = 0
							)
						) T2
						ON (T1.ECO_ID = T2.ECO_ID)
						WHEN MATCHED THEN UPDATE SET 
							T1.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN (''29'')),
							T1.USUARIOMODIFICAR = ''HREOS-6251'',
							T1.FECHAMODIFICAR = SYSDATE
		  ';
		  EXECUTE IMMEDIATE V_MSQL;
		  DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizad el estado de expediente (DD_EEC_ID) de '||SQL%ROWCOUNT||' expedientes comerciales correctamente.');
	  
   --Si no existe, no hacemos nada   
   ELSE
   
		  DBMS_OUTPUT.PUT_LINE('	[INFO] No existe el código 29 en el diccionario DD_EEC_EST_EXP_COMERCIAL. No hacemos nada.');
	
   END IF;
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]');
   

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
