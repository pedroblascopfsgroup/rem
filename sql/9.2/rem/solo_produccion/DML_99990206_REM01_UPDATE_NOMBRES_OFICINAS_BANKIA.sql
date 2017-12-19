--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20171219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3419
--## PRODUCTO=NO
--##
--## Finalidad: Actualización del nombre de proveedores de Bankia
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.    
        
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	EXECUTE IMMEDIATE 'MERGE INTO ACT_PVE_PROVEEDOR T1 
	USING (
	    WITH T1 AS(
		SELECT PVE.PVE_ID, PVE.PVE_NOMBRE, PVE.PVE_NOMBRE_COMERCIAL FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR DD ON DD.DD_TPR_ID = PVE.DD_TPR_ID AND DD.DD_TPR_CODIGO = ''28''
		WHERE PVE.PVE_NOMBRE_COMERCIAL LIKE ''OFICINA%'' AND PVE.PVE_NOMBRE LIKE ''BANKIA%''
	      ) SELECT INITCAP(CONCAT(''Bankia - '' , T1.PVE_NOMBRE_COMERCIAL)) AS NOMBRE_FINAL, T1.PVE_NOMBRE, T1.PVE_NOMBRE_COMERCIAL, T1.PVE_ID FROM T1
	) T2 ON (T1.PVE_ID = T2.PVE_ID)
	WHEN MATCHED THEN UPDATE SET
	    T1.PVE_NOMBRE = T2.NOMBRE_FINAL,
	    T1.PVE_NOMBRE_COMERCIAL = T2.NOMBRE_FINAL,
	    T1.USUARIOMODIFICAR = ''HREOS-3445'',
	    T1.FECHAMODIFICAR = SYSDATE
	    
	'
	;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_PVE_PROVEEDOR ACTUALIZADA CORRECTAMENTE, '||SQL%ROWCOUNT||' registros actualizados.');
   

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
