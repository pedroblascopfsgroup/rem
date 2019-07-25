--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190725
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4915
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
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4915';
   V_PAR VARCHAR( 1024 CHAR );
   V_RET VARCHAR( 1024 CHAR );  	
  
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');
       

   V_PAR := '10464584,10464586,10464612,10464613,10464630,10464636,10464671,10464674,10464708';	
   REM01.SP_EXT_REENVIO_GASTO ( V_PAR , V_USUARIOMODIFICAR, V_RET );

   DBMS_OUTPUT.PUT_LINE( V_RET );
   DBMS_OUTPUT.PUT_LINE(' [INFO] Reenviado gastos ');


   REM01.SP_EXT_MODIFICACION_ESTADOS ( V_PAR , 
					V_USUARIOMODIFICAR, 
					'01',
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
   DBMS_OUTPUT.PUT_LINE(' [INFO] Cambiado estado de gastos a "Pendiente de autorizar');
 

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
