--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6326
--## PRODUCTO=SI
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_SQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Recorriendo activos para cambiar la topología de tipo y subtipo de título ');
     
     	-- Busca los activos/gestores
    	V_SQL := ' MERGE INTO REM01.ACT_ACTIVO ACT
		   USING(
			  
				SELECT ACT_NUM_ACTIVO,
				       STA.DD_STA_ID,
				       STA.DD_TTA_ID
				FROM REM01.AUX_REMVIP_6326 AUX				
				LEFT JOIN REM01.DD_STA_SUBTIPO_TITULO_ACTIVO STA
					ON UPPER( STA.DD_STA_DESCRIPCION ) = AUX.DD_STA_DESCRIPCION


		   ) AUX
		   ON ( ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO	)
		   WHEN MATCHED THEN UPDATE	
		   SET ACT.DD_TTA_ID = AUX.DD_TTA_ID,
		       ACT.DD_STA_ID = AUX.DD_STA_ID,
		       ACT.USUARIOMODIFICAR = ''REMVIP-6326'',
		       ACT.FECHAMODIFICAR = SYSDATE			
		 ' ;
	EXECUTE IMMEDIATE V_SQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' activo');

-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Modifica la fecha de título ');
     
     	-- Busca los activos/gestores
    	V_SQL := ' MERGE INTO REM01.ACT_ADN_ADJNOJUDICIAL ADJ
		   USING(
			  
				SELECT DISTINCT ACT_ID,
				       TO_DATE( ADN_FECHA_TITULO, ''DD/MM/YYYY'' ) AS ADN_FECHA_TITULO
				FROM REM01.AUX_REMVIP_6326 AUX				
				INNER JOIN REM01.ACT_ACTIVO ACT
					ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
				WHERE ACT.BORRADO = 0


		   ) AUX
		   ON ( ADJ.ACT_ID = AUX.ACT_ID )
		   WHEN MATCHED THEN
		   UPDATE		
		   SET ADJ.ADN_FECHA_TITULO = AUX.ADN_FECHA_TITULO,
		       ADJ.USUARIOMODIFICAR = ''REMVIP-6326'',
		       ADJ.FECHAMODIFICAR = SYSDATE			
		   WHEN NOT MATCHED THEN 
		   INSERT ( ADN_ID, ACT_ID, ADN_FECHA_TITULO, VERSION, BORRADO, FECHACREAR, USUARIOCREAR )
		   VALUES (
			    REM01.S_ACT_ADN_ADJNOJUDICIAL.NEXTVAL,
			    AUX.ACT_ID,
			    AUX.ADN_FECHA_TITULO,
			    0,
			    0,
			    SYSDATE,
			    ''REMVIP-6326''
			  )	
		 ' ;
	EXECUTE IMMEDIATE V_SQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado/reado '||SQL%ROWCOUNT||' registros en ACT_ADN_ADJNOJUDICIAL ');

-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza el % de participación de los propietarios ');
     
     	-- Busca los activos/gestores
    	V_SQL := ' MERGE INTO REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC
		   USING(
			  
				SELECT DISTINCT ACT_ID
				FROM REM01.AUX_REMVIP_6326 AUX				
				INNER JOIN REM01.ACT_ACTIVO ACT
					ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
				WHERE ACT.BORRADO = 0


		   ) AUX
		   ON ( PAC.ACT_ID = AUX.ACT_ID )
		   WHEN MATCHED THEN
		   UPDATE		
		   SET PAC.PAC_PORC_PROPIEDAD = 100,
		       PAC.USUARIOMODIFICAR = ''REMVIP-6326'',
		       PAC.FECHAMODIFICAR = SYSDATE			
		   WHERE ( PAC.PAC_PORC_PROPIEDAD <> 100 OR PAC.PAC_PORC_PROPIEDAD IS NULL )
		 ' ;
	EXECUTE IMMEDIATE V_SQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado/reado '||SQL%ROWCOUNT||' registros en ACT_PAC_PROPIETARIO_ACTIVO ');

-----------------------------------------------------------------------------------------------------------------

	COMMIT;

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
