--/*
--##########################################
--## AUTOR=Alvaro Valero
--## FECHA_CREACION=20220726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18370
--## PRODUCTO=NO
--## Finalidad: vista para portales
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_HISTORICO_REAGENDACIONES...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_GRID_HISTORICO_REAGENDACIONES 

	AS
		SELECT
				hre.hre_id,
				hre.hre_fecha_reagendacion_ingreso,
				fia.fia_fecha_agendacion_ingreso,
				fia.fia_importe,
				fia.fia_iban_devolucion,
				fia.fia_fecha_ingreso,
				ofr.ofr_num_oferta,
				cva.cva_cuenta_virtual,
				eco.eco_id
		FROM
				'|| V_ESQUEMA ||'.hre_historico_reagendaciones     hre
				JOIN '|| V_ESQUEMA ||'.fia_fianzas                      fia ON hre.fia_id = fia.fia_id
																AND fia.borrado = 0
				JOIN '|| V_ESQUEMA ||'.ofr_ofertas                      ofr ON ofr.ofr_id = fia.ofr_id
																AND ofr.borrado = 0
				JOIN '|| V_ESQUEMA ||'.cva_cuentas_virtuales_alquiler   cva ON fia.cva_id = cva.cva_id
																									AND cva.borrado = 0
				JOIN '|| V_ESQUEMA ||'.eco_expediente_comercial         eco ON eco.ofr_id = ofr.ofr_id
		WHERE hre.borrado = 0';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_HISTORICO_REAGENDACIONES...Creada OK');

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
