--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181030
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2361
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR TABLA DD_TPN_TIPO_INMUEBLE DESDE TABLA AUXILIAR
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2361';

BEGIN

--BUSCA Y ACTUALIZA DD_TPN_TIPO_INMUEBLE

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');
		
		V_SQL := '  MERGE INTO REM01.DD_TPN_TIPO_INMUEBLE T1 
			    USING (
			    SELECT AUX.DD_TPN_CODIGO, AUX.DD_TPN_DESCRIPCION, AUX.DD_TPN_DESCRIPCION_LARGA 
			    FROM REM01.AUX_VRO_DD_TPN_TIPO_INMUEBLE AUX 
			    LEFT JOIN REM01.DD_TPN_TIPO_INMUEBLE TPN ON AUX.DD_TPN_CODIGO = TPN.DD_TPN_CODIGO 
			    WHERE TPN.DD_TPN_CODIGO IS NULL 
			    )
			    T2 
			    ON (T1.DD_TPN_CODIGO = T2.DD_TPN_CODIGO)
				  WHEN NOT MATCHED THEN INSERT (DD_TPN_ID, 
							        DD_TPN_CODIGO,
							        DD_TPN_DESCRIPCION, 
								DD_TPN_DESCRIPCION_LARGA, 
								VERSION, 
								USUARIOCREAR, 
								FECHACREAR, 
								USUARIOMODIFICAR, 
								FECHAMODIFICAR, 
								USUARIOBORRAR, 
								FECHABORRAR, 
								BORRADO)
				VALUES (REM01.S_DD_TPN_TIPO_INMUEBLE.NEXTVAL,
					T2.DD_TPN_CODIGO, 
					T2.DD_TPN_DESCRIPCION, 
					T2.DD_TPN_DESCRIPCION_LARGA, 
					0, 
					''REMVIP_2361'', 
					SYSDATE, 
					NULL,
					NULL, 
					NULL, 
					NULL,
					0)';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla DD_TPN_TIPO_INMUEBLE.');
		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
