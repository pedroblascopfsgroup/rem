--/*
--##########################################
--## AUTOR=Lara Pablo Flores
--## FECHA_CREACION=20220429
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17600
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Bloqueo API
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

 
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_HISTORICO_BLOQUEO_APIS...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_HISTORICO_BLOQUEO_APIS 
		AS
			SELECT 
			bha.BHA_ID AS ID,
		    bha.PVE_ID, 
		   	tpb.DD_TPB_DESCRIPCION, 
			NVL2(tco.DD_TCO_DESCRIPCION ,tco.DD_TCO_DESCRIPCION, 
				NVL2(cra.DD_CRA_DESCRIPCION, cra.DD_CRA_DESCRIPCION, 
					NVL2(esp.DD_ESP_DESCRIPCION, esp.DD_ESP_DESCRIPCION, prv.DD_PRV_DESCRIPCION))) AS BLOQUEOS,		
			bha.BHA_MOTIVO_BLOQUEO,
			bha.BHA_MOTIVO_DESBLOQUEO,
			bha.FECHACREAR AS FECHA_BLOQUEO,
			bha.USUARIOCREAR AS USUARIO_BLOQUEO,
			bha.FECHAMODIFICAR AS FECHA_DESBLOQUEO,
			bha.USUARIOMODIFICAR AS USUARIO_DESBLOQUEO
		FROM BHA_HIST_BLOQUEO_APIS bha
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TPB_TIPO_BLOQUEO tpb on tpb.DD_TPB_ID = bha.DD_TPB_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION tco on tco.DD_TCO_ID = bha.BHA_BLOQUEO_LN
		LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA cra on cra.DD_CRA_ID = bha.BHA_BLOQUEO_CARTERA
		LEFT JOIN '|| V_ESQUEMA ||'.DD_ESP_ESPECIALIDAD esp on esp.DD_ESP_ID = bha.BHA_BLOQUEO_ESPECIALIDAD
		LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_PRV_PROVINCIA PRV on PRV.DD_PRV_ID = bha.BHA_BLOQUEO_PRV
		where bha.borrado = 0 ORDER BY bha.FECHACREAR DESC'
  ;


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_HISTORICO_BLOQUEO_APIS...Creada OK');

  COMMIT;

  EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;   
  
END;
/

EXIT;
