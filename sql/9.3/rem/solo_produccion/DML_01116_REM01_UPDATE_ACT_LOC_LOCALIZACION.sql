--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11060
--## PRODUCTO=NO
--## 
--## Finalidad: CREAR PRESUPUESTOS 2022 EN ACT_LOC_LOCALIZACION
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

  V_ESQUEMA VARCHAR2(30 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USER VARCHAR2(50 CHAR):= 'REMVIP-11060';

BEGIN

	--Comprobamos SI ESTA EL EJERCICIO 2021

        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	        --Si existe CONTINUAMOS
        	IF V_NUM_TABLAS > 0 THEN
      
		      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la actualización de Planta');
		      
		      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION ACT_LOC
						USING(
							SELECT ACT.ACT_ID 
							FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							WHERE ACT.ACT_NUM_ACTIVO_CAIXA IN (89028050,89028056,
							89028249,89028243,89028114,89028149,89028079,89028306,
							89028308,89028309,89028330)
						) AUX
						ON (ACT_LOC.ACT_ID = AUX.ACT_ID)
						WHEN MATCHED THEN
							UPDATE SET 
							ACT_LOC.USUARIOMODIFICAR = '''||V_USER||'''
							, ACT_LOC.FECHAMODIFICAR = SYSDATE
							, ACT_LOC.DD_PLN_ID = (SELECT DD_PLN_ID FROM '||V_ESQUEMA||'.DD_PLN_PLANTA_EDIFICIO WHERE DD_PLN_CODIGO = ''900'')';
				    
		      EXECUTE IMMEDIATE V_SQL;
		      
		      DBMS_OUTPUT.PUT_LINE('[INFO]  '||SQL%ROWCOUNT||' ACTUALIZADOS');  

		ELSE
          		DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA TABLA '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION');
				
        END IF;    

      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;
