--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20171128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3312
--## PRODUCTO=SI
--##
--## Finalidad: UPDATEAR DOS ACTIVOS PARA PONERLOS A VENDIDOS Y PONERLES FECHA DE VENTA, PARA QUE NO SE SIGAN MOSTRANDO COMO DISPONIBLES PARA LA VENTA CON RESERVA
--## INSTRUCCIONES: 
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		
		V_SQL := 'SELECT COUNT(1)
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
		JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
		WHERE '||V_ESQUEMA||'.AGR.AGR_NUM_AGRUP_REM = 8876638 AND '||V_ESQUEMA||'.ACT.ACT_VENTA_EXTERNA_FECHA IS NULL AND
		'||V_ESQUEMA||'.ACT.DD_SCM_ID != (SELECT DD_SCM_ID FROM DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'')';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
			V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT SET '||V_ESQUEMA||'.ACT.ACT_VENTA_EXTERNA_FECHA = SYSDATE,
			'||V_ESQUEMA||'.ACT.DD_SCM_ID = (SELECT SCM.DD_SCM_ID FROM DD_SCM_SITUACION_COMERCIAL SCM WHERE SCM.DD_SCM_CODIGO = ''05''),
			'||V_ESQUEMA||'.ACT.USUARIOMODIFICAR = ''HREOS-3312'',
			'||V_ESQUEMA||'.ACT.FECHAMODIFICAR = SYSDATE
			 WHERE 
			'||V_ESQUEMA||'.ACT.ACT_ID IN
			(
				SELECT '||V_ESQUEMA||'.ACT.ACT_ID
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
				JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
				WHERE '||V_ESQUEMA||'.AGR.AGR_NUM_AGRUP_REM = 8876638
			)';
			
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[SUCCESS] Actualización de la tabla '||V_TEXT_TABLA||' completada. Actualizados '||SQL%ROWCOUNT||' registros.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No se cumplen las condiciones en '||V_TEXT_TABLA||'. ¿Se ejecutó previamente este script?');
		END IF;
		
    COMMIT;
   

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