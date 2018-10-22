--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2236
--## PRODUCTO=NO
--##
--## Finalidad: FUSION CCM TO LIBERBANK
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
DBMS_OUTPUT.put_line('[FUSION CCM TO LIBERBANK] MODIFICAR AUX');


DBMS_OUTPUT.put_line('[1] BORRAMOS LO QUE ESTÉ CONTABILIZADO');


V_SQL := 'DELETE '||V_ESQUEMA||'.AUX_FUSION_CMM_LIBER WHERE GPV_NUM_GASTO_HAYA IN (
            SELECT GPV.GPV_NUM_GASTO_HAYA FROM AUX_FUSION_CMM_LIBER AUX
            JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV on GPV.GPV_NUM_GASTO_HAYA = AUX.GPV_NUM_GASTO_HAYA
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
            WHERE GIC.GIC_FECHA_CONTABILIZACION IS NOT NULL AND
            PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''BANCO DE CASTILLA LA MANCHA, S.A.''))';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han BORRADO '||SQL%ROWCOUNT||' registros en la tabla AUX_FUSION_CMM_LIBER');




DBMS_OUTPUT.put_line('[2] INSERTAMOS LO QUE ESTE EN ESTADO PENDIENTE O INCOMPLETO ');


V_SQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_FUSION_CMM_LIBER (GPV_NUM_GASTO_HAYA) 
            SELECT GPV_NUM_GASTO_HAYA FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
            WHERE GPV.DD_EGA_ID IN (1,12) AND 
            PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''BANCO DE CASTILLA LA MANCHA, S.A.'')';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla ACT_PAC_PROPIETARIO_ACTIVO');



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

