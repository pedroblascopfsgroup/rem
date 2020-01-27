--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20191028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8222
--## PRODUCTO=NO
--## Finalidad: DML para rellenar la tabla BACKUP_ACT_DCA_DATOS_CONTRATO_ALQ
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BACKUP_ACT_DCA_DATOS_CONTRATO_ALQ'
    INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[Rellenar la tabla BACKUP_ACT_DCA_DATOS_CONTRATO_ALQ]');
		V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.BACKUP_ACT_DCA_DATOS_CONTRATO_ALQ (
								DCA_ID,
								DCA_FECHA_CREACION,
								DCA_NOM_PRINEX,
								ACT_ID,
								DCA_UHEDIT,
								DCA_ID_CONTRATO,
								DCA_EST_CONTRATO,
								DCA_FECHA_FIRMA,
								DCA_FECHA_FIN_CONTRATO,
								DCA_CUOTA,
								DCA_NOMBRE_CLIENTE,
								DCA_DEUDA_PENDIENTE,
								DCA_RECIBOS_PENDIENTES,
								DCA_F_ULTIMO_PAGADO,
								DCA_F_ULTIMO_ADEUDADO,
								VERSION,
								USUARIOCREAR,
								FECHACREAR,
								USUARIOMODIFICAR,
								FECHAMODIFICAR,
								USUARIOBORRAR,
								FECHABORRAR,
								BORRADO,
								ID_AAII,
								ID_PRINEX,
								DCA_ID_CONTRATO_ANTIGUO) SELECT 
								DCA_ID,
								DCA_FECHA_CREACION,
								DCA_NOM_PRINEX,
								ACT_ID,
								DCA_UHEDIT,
								DCA_ID_CONTRATO,
								DCA_EST_CONTRATO,
								DCA_FECHA_FIRMA,
								DCA_FECHA_FIN_CONTRATO,
								DCA_CUOTA,
								DCA_NOMBRE_CLIENTE,
								DCA_DEUDA_PENDIENTE,
								DCA_RECIBOS_PENDIENTES,
								DCA_F_ULTIMO_PAGADO,
								DCA_F_ULTIMO_ADEUDADO,
								VERSION,
								USUARIOCREAR,
								FECHACREAR,
								USUARIOMODIFICAR,
								FECHAMODIFICAR,
								USUARIOBORRAR,
								FECHABORRAR,
								BORRADO,
								ID_AAII,
								ID_PRINEX,
								DCA_ID_CONTRATO_ANTIGUO FROM '||V_ESQUEMA||'.ACT_DCA_DATOS_CONTRATO_ALQ';

		EXECUTE IMMEDIATE V_SQL;
		
    END IF;
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
