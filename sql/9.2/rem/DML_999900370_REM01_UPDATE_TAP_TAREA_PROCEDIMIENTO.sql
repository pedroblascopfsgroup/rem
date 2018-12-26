--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20181126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2597
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2597'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TAP_CODIGO VARCHAR2(40 CHAR);
    TAP_SCRIPT_DECISION VARCHAR2(4000 CHAR);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('T013_DefinicionOferta', 'checkFormalizacion() ? (checkDeDerechoTanteo() == false ? (valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''] != DDSiNo.SI ? (checkAtribuciones() ? (checkReserva() == false ? (checkDerechoTanteo() ? ''''ConFormalizacionSinTanteoConAtribucionSinReservaConTanteo'''' : ''''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'''') : ''''ConFormalizacionSinTanteoConAtribucionConReserva'''') : ''''ConFormalizacionSinTanteoSinAtribucion'''') : ''''ConFormalizacionSinTanteoSinAtribucion'''') : ''''ConFormalizacionConTanteo'''') : ''''SinFormalizacion'''''),
		T_JBV('T013_ResolucionComite','valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_APRUEBA ? (checkReserva() ? ''''ApruebaConReserva'''' : ( checkDerechoTanteo() ? ''''ApruebaSinReservaConTanteo'''' : ''''ApruebaSinReservaSinTanteo'''')) : (valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Rechaza'''' : ''''Contraoferta'''')'),
		T_JBV('T013_RespuestaOfertante','valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_ACEPTA || valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_CONTRAOFERTA ? (checkBankia() ? ''''AceptaBankia'''' : (checkReserva() ? ''''AceptaConReserva'''' : ( checkDerechoTanteo() ? ''''AceptaSinReservaConTanteo'''' : ''''AceptaSinReservaSinTanteo''''))) : ''''Rechaza''''')
	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA TAP_SCRIPT_DECISION');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TAP_CODIGO := TRIM(V_TMP_JBV(1));
  	
  	TAP_SCRIPT_DECISION := TRIM(V_TMP_JBV(2));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TAP_CODIGO||'''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
				   SET TAP_SCRIPT_DECISION = '''||TAP_SCRIPT_DECISION||''',
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE
				   WHERE TAP_CODIGO = '''||TAP_CODIGO||'''';
                   
        EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||TAP_CODIGO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');
 
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

