--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20210218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13125
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

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_GESTIONADOS_REAM...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_ACTIVOS_GESTIONADOS_REAM 

	AS
		SELECT a.ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO a 
			WHERE 
			EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_ACTIVO act
			        JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO APRO on act.act_id = apro.act_id and apro.borrado = 0
			        join '|| V_ESQUEMA ||'.act_pro_propietario pro on apro.pro_id = pro.pro_id  and pro.borrado = 0
			        JOIN '|| V_ESQUEMA ||'.cfm_configuracion_ream CFM on act.dd_cra_id = CFM.DD_CRA_ID AND act.dd_scr_id = act.dd_Scr_id and pro.pro_id = cfm.pro_id 
					and act.ACT_PERIMETRO_MACC = cfm.cfm_cartera_mac and cfm.borrado = 0
			        where a.act_id = act.act_id and act.borrado = 0)  
			OR EXISTS  (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_ACTIVO act
			        JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO APRO on act.act_id = apro.act_id  and apro.borrado = 0
			        join '|| V_ESQUEMA ||'.act_pro_propietario pro on apro.pro_id = pro.pro_id and pro.borrado = 0
			        JOIN '|| V_ESQUEMA ||'.cfm_configuracion_ream CFM on act.dd_cra_id = CFM.DD_CRA_ID AND act.dd_scr_id = act.dd_Scr_id and 
					pro.pro_id = cfm.pro_id and cfm.cfm_cartera_mac is null and cfm.borrado = 0
			        where a.act_id = act.act_id and act.borrado = 0)
			OR EXISTS  (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_ACTIVO act
			        JOIN '|| V_ESQUEMA ||'.cfm_configuracion_ream CFM on act.dd_cra_id = CFM.DD_CRA_ID AND act.dd_scr_id = act.dd_Scr_id and cfm.pro_id is null 
					and cfm.cfm_cartera_mac is null and cfm.borrado = 0
			        where a.act_id = act.act_id and act.borrado = 0)
			OR EXISTS  (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_ACTIVO act
			        JOIN '|| V_ESQUEMA ||'.cfm_configuracion_ream CFM on act.dd_cra_id = CFM.DD_CRA_ID AND cfm.dd_scr_id  is null and cfm.pro_id is null 
					and cfm.cfm_cartera_mac is null and cfm.borrado = 0
			        where a.act_id = act.act_id and act.borrado = 0)';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_GESTIONADOS_REAM...Creada OK');

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
