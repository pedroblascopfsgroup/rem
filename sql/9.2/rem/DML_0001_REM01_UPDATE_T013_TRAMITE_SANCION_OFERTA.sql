--/*
--##########################################
--## AUTOR= Daniel Algaba
--## FECHA_CREACION=20190220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5518
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar script validacion en tramite sancion oferta de venta comercial.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial HREOS-5377
-- ##		0.2 HREOS-5518 - Corregimos las tareas de reserva para dejar a nulo la decision
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
BEGIN
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET TAP_SCRIPT_DECISION = ''checkFormalizacion() ? valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''] != DDSiNo.SI ? checkAtribuciones() ? checkReserva() == false ? ''''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'''' : ''''ConFormalizacionSinTanteoConAtribucionConReserva'''' : ''''ConFormalizacionSinTanteoSinAtribucion''''  : ''''ConFormalizacionSinTanteoSinAtribucion'''' : ''''SinFormalizacion''''''
                    , USUARIOMODIFICAR = ''HREOS-5377''
                    , FECHAMODIFICAR = SYSDATE
                    WHERE TAP_CODIGO = ''T013_DefinicionOferta''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_DefinicionOferta.......');
		    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		END IF;
		  
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_ResolucionComite'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    SET TAP_SCRIPT_DECISION =''valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva() ? ''''ApruebaConReserva'''' : ''''ApruebaSinReservaSinTanteo'''' : valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Rechaza'''' : ''''Contraoferta''''''
                    , USUARIOMODIFICAR = ''HREOS-5377''
                    , FECHAMODIFICAR = SYSDATE
                    WHERE TAP_CODIGO = ''T013_ResolucionComite''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_ResolucionComite.......');
		    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		END IF;
		   
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_RespuestaOfertante'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
   					 SET TAP_SCRIPT_DECISION = ''valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_ACEPTA || valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_CONTRAOFERTA ? checkBankia() ? ''''AceptaBankia'''' :  checkReserva() ? ''''AceptaConReserva'''' : ''''AceptaSinReservaSinTanteo'''' : ''''Rechaza''''''              		
                    , USUARIOMODIFICAR = ''HREOS-5377''
                    , FECHAMODIFICAR = SYSDATE
                    WHERE TAP_CODIGO = ''T013_RespuestaOfertante''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_RespuestaOfertante.......');
		    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		END IF;
		   
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_InformeJuridico'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
   					 SET TAP_SCRIPT_DECISION = ''checkReserva() == false  ? ''''SinReservaSinTanteo'''' : ''''ConReserva''''''              		
                    , USUARIOMODIFICAR = ''HREOS-5377''
                    , FECHAMODIFICAR = SYSDATE
                    WHERE TAP_CODIGO = ''T013_InformeJuridico''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_InformeJuridico.......');
		    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		    
		END IF;
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_InstruccionesReserva'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
					SET TAP_SCRIPT_DECISION = null
                    WHERE TAP_CODIGO = ''T013_InstruccionesReserva''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_InstruccionesReserva	.......');
		    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		    
		END IF;
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
					SET TAP_SCRIPT_DECISION = null
                    WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_ObtencionContratoReserva.......');
		    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		    
		END IF;
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_ResolucionTanteo'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
					SET BORRADO = 1           		
                    , USUARIOBORRAR = ''HREOS-5377''
                    , FECHABORRAR = SYSDATE
                    WHERE TAP_CODIGO = ''T013_ResolucionTanteo''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_ResolucionTanteo.......');
		    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		    
		END IF;
		
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