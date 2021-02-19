--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8982
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAR PROVEEDOR CONTACTO DE LOS PROVEEDORES SIN CONTACTO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8982'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO T1 USING (
					SELECT 0 AS PVC_ID,PVE.PVE_ID, PVE.DD_PRV_ID, PVE.DD_TDI_ID, PVE.PVE_DOCIDENTIF, PVE.PVE_NOMBRE, PVE.PVE_CP, PVE.PVE_DIRECCION,PVE.PVE_TELF1, PVE.PVE_TELF2, PVE.PVE_FAX, PVE.PVE_EMAIL
					FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE NOT EXISTS (SELECT PVC_ID FROM ACT_PVC_PROVEEDOR_CONTACTO PVC WHERE PVE.PVE_ID = PVC.PVE_ID AND BORRADO = 0) AND BORRADO = 0
				) T2
				ON (T1.PVC_ID = T2.PVC_ID)
				WHEN NOT MATCHED THEN INSERT (PVC_ID,PVE_ID,DD_PRV_ID,DD_TDI_ID,PVC_DOCIDENTIF,PVC_NOMBRE,PVC_CP,PVC_DIRECCION,PVC_TELF1,PVC_TELF2,PVC_FAX,PVC_EMAIL,USUARIOCREAR,FECHACREAR,PVC_PRINCIPAL) VALUES (
				'||V_ESQUEMA||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL, T2.PVE_ID, T2.DD_PRV_ID, T2.DD_TDI_ID, T2.PVE_DOCIDENTIF, T2.PVE_NOMBRE, T2.PVE_CP, T2.PVE_DIRECCION,T2.PVE_TELF1, 
				T2.PVE_TELF2, T2.PVE_FAX, T2.PVE_EMAIL, ''REMVIP-8982'', SYSDATE, 1)';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] CREADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_PVC_PROVEEDOR_CONTACTO');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
	EXCEPTION
	
	    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		ROLLBACK;
		RAISE;
END;
/
EXIT;