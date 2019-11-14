--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20190619
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6925
--## PRODUCTO=NO
--## Finalidad: Creación de vista para sacar las carteras de los trabajos de un proveedor
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'V_CARTERA_TRABAJOS_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR);     
BEGIN
	DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
	EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE EDITIONABLE VIEW "'||V_ESQUEMA||'"."'||V_TEXT_VISTA||'" ("DD_CRA_ID", "PVE_ID", "ID_VISTA") AS 
							SELECT DISTINCT CRA.DD_CRA_ID, PVE.PVE_ID, CRA.DD_CRA_ID||PVE.PVE_ID AS ID_VISTA FROM '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE 
								JOIN '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVE.PVE_ID = PVC.PVE_ID
								JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON PVC.PVC_ID = TBJ.PVC_ID
								JOIN '|| V_ESQUEMA ||'.ACT_TBJ ATBJ ON TBJ.TBJ_ID = ATBJ.TBJ_ID
								JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ATBJ.ACT_ID = ACT.ACT_ID
								JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
	COMMIT;
EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;
