--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3705
--## PRODUCTO=NO
--##
--## Finalidad:	Insertar en la tabla ACT_PAC_PERIMETRO_ACTIVO para los activos de la ACT_ACTIVO que no tengan registro
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
				USING (
				    SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				    LEFT JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
				    WHERE PAC.ACT_ID IS NULL AND ACT_NUM_ACTIVO > 0
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN NOT MATCHED THEN INSERT VALUES (
				  '||V_ESQUEMA||'.S_ACT_PAC_PERIMETRO_ACTIVO.NEXTVAL,
				  T2.ACT_ID,
				  1,
				  1,
				  NULL,
				  NULL,
				  1,
				  NULL,
				  NULL,
				  1,
				  NULL,
				  NULL,
				  1,
				  NULL,
				  NULL,
				  1,
				  NULL,
				  NULL,
				  0,
				  ''REMVIP-3705'',
				  SYSDATE,
				  NULL,
				  NULL,
				  NULL,
				  NULL,
				  0,
				  NULL,
				  1,
				  NULL,
				  NULL
				)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('	[INFO]	'||SQL%ROWCOUNT||' filas actualizadas');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');   

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