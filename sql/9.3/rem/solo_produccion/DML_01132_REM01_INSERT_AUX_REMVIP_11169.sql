--#########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20220221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11185
--## PRODUCTO=NO
--## 
--## Finalidad: Inserta en la tabla AUX_REMVIP_11169 los activos de jaguar en los que se va a lanzar el recalculo visibilidad comercial.
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
  V_USER VARCHAR2(50 CHAR):= 'REMVIP-11185';

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AUX_REMVIP_11169... Se trunca la tabla y se vuelve a insertar.');
	EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_REMVIP_11169';
	      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la insercion de los activos jaguar que se van a recalcular');

      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN AUX_REMVIP_11169');

      
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_REMVIP_11169 (ACTIVO)
					SELECT UNIQUE ACT.ACT_NUM_ACTIVO
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID AND PAC.BORRADO =0
					JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID=ACT.ACT_ID AND APU.BORRADO =0
					JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID =ACT.DD_SCR_ID
					JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0  
					LEFT JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0
					LEFT JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0
					WHERE PAC.PAC_CHECK_GESTION_COMERCIAL=0 AND SCR.DD_SCR_CODIGO=''70''
					AND ( (TCO.DD_TCO_CODIGO = ''01'' AND EPV.DD_EPV_CODIGO = ''03'')  OR (EPA.DD_EPA_CODIGO = ''03'' AND  TCO.DD_TCO_CODIGO = ''03'') 
					OR ((EPA.DD_EPA_CODIGO = ''03'' AND EPV.DD_EPV_CODIGO = ''03'') AND  TCO.DD_TCO_CODIGO = ''02''))';
		    
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]  '||SQL%ROWCOUNT||' ACTIVOS DE JAGUAR INSERTADOS');  

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
