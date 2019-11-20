--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190909
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5206
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5206';
   V_PAR VARCHAR( 1024 CHAR );
   V_RET VARCHAR( 1024 CHAR );  	
  
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');
       

   V_PAR := '9704265,
10106784,
9704266,
10106785,
10162943,
10106290,
10106786,
9704267,
10106787,
10162944,
9704268,
10106788,
10162920,
10162945,
10106789,
10010677,
10010678,
10106790,
10162946,
10106791,
10162947,
10106792,
10059596,
10059597,
10059839,
10106793,
10162948,
10162562,
10162887,
10162888,
10162949,
10162976,
10162977,
10162978,
10162979,
10162983
';	


   REM01.SP_EXT_MODIFICACION_ESTADOS ( V_PAR , 
					V_USUARIOMODIFICAR, 
					'05',
					1,
					null,
					0,
					null,
					0,
					sysdate,
					0,
					sysdate,
					0,
					null,
					0,
					sysdate,
					0,
					null,
					0,
					0,
					0,
					0,
					0,
					V_RET );

   DBMS_OUTPUT.PUT_LINE( V_RET );
   DBMS_OUTPUT.PUT_LINE(' [INFO] Cambiado estado de gastos a "Pagados');
 

   DBMS_OUTPUT.PUT_LINE('[FIN] ');
    
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
