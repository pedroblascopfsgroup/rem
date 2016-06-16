--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-18
--## PRODUCTO=SI
--##
--## Finalidad: DML Carga MIG_CCO_CONTABILIDAD_COBROS
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquemas  
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN  

V_MSQL := 
'CREATE TABLE '||V_ESQUEMA||'.mig_cco_contabilidad_cobros (
  contrato             VARCHAR2(50 CHAR)   NULL,
  id_cobro             NUMBER(16,0)        NULL,
  id_expediente        NUMBER(16,0)        NULL,
  cierre               NUMBER(16,2)        NULL,
  nominal              NUMBER(16,2)        NULL,
  intereses            NUMBER(16,2)        NULL,
  demoras              NUMBER(16,2)        NULL,
  gto_abogado          NUMBER(16,2)        NULL,
  gto_procurador       NUMBER(16,2)        NULL,
  gto_otros            NUMBER(16,2)        NULL,
  oper_tramite         NUMBER(16,2)        NULL,
  pase_fallido         NUMBER(16,2)        NULL,
  quita_nominal        NUMBER(16,2)        NULL,
  quita_intereses      NUMBER(16,2)        NULL,
  quita_demoras        NUMBER(16,2)        NULL,
  num_mandamiento      VARCHAR2(50 CHAR)   NULL,
  concepto_mandamiento VARCHAR2(50 CHAR)   NULL,
  num_cheque           VARCHAR2(50 CHAR)   NULL,
  num_enlace           VARCHAR2(50 CHAR)   NULL,
  observaciones        VARCHAR2(4000 CHAR) NULL,
  tipo_entrega         NUMBER(3,0)         NULL,
  empleado             VARCHAR2(50 CHAR)   NULL,
  fecha_cobro          DATE                NULL,
  fecha_valor          DATE                NULL,
  id_proceso           NUMBER(16,0)        NULL,
  quita_gto_abogado    NUMBER(16,2)        NULL,
  quita_gto_procurador NUMBER(16,2)        NULL,
  quita_gto_otros      NUMBER(16,2)        NULL,
  quita_oper_tramite   NUMBER(16,2)        NULL,
  enviado              VARCHAR2(1 CHAR)    NULL,
  procede_ot           VARCHAR2(5 CHAR)    NULL,
  iva                  NUMBER(16,2)        NULL,
  quita_iva            NUMBER(16,2)        NULL,
  concepto_entrega     NUMBER(3,0)         NULL
)';

  --Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_NUM_TABLAS FROM USER_TABLES WHERE TABLE_NAME = 'MIG_CCO_CONTABILIDAD_COBROS';
  
  IF V_NUM_TABLAS = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Tabla mig_cco_contabilidad_cobros CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.mig_cco_contabilidad_cobros' );
     DBMS_OUTPUT.PUT_LINE('Tabla mig_cco_contabilidad_cobros BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Tabla mig_cco_contabilidad_cobros CREADA');     
  END IF;   

commit;

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