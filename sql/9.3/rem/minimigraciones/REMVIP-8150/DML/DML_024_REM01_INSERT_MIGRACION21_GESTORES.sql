--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200930
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8150
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
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-8150';
   V_COUNT NUMBER(16):= 0;
   HORA_INI TIMESTAMP;
   HORA_FIN TIMESTAMP;
   PL_OUTPUT VARCHAR2(32000 CHAR);
   P_ACT_ID NUMBER;
   v_n INTERVAL DAY TO SECOND ;
    
   
   CURSOR ASIGNAR_GESTORES IS 
       SELECT ACT_ID 
       FROM REM01.ACT_ACTIVO
       WHERE ACT_NUM_ACTIVO IN (
		7387069,
		7387070,
		7387071,
		7387072
       );

   FILA ASIGNAR_GESTORES%ROWTYPE;
  
BEGIN
   HORA_INI := SYSTIMESTAMP;
   DBMS_OUTPUT.put_line('[INICIO] Ejecutando asignacion gestores ...........'||HORA_INI||' ');

     
   OPEN ASIGNAR_GESTORES;
   
   V_COUNT := 0;
   
   LOOP
       FETCH ASIGNAR_GESTORES INTO FILA;
       EXIT WHEN ASIGNAR_GESTORES%NOTFOUND;
       
       REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('REMVIP-8150', PL_OUTPUT, FILA.ACT_ID, NULL, '02' );

       DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 
	
       PL_OUTPUT := '';

       REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('REMVIP-8150', PL_OUTPUT, FILA.ACT_ID, NULL, '01' );

       DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 
	
       PL_OUTPUT := '';
           
       V_COUNT := V_COUNT + 1;
   END LOOP;
    
   DBMS_OUTPUT.PUT_LINE(' [INFO] Se han asignado gestores a  '||V_COUNT||' activos ');
   CLOSE ASIGNAR_GESTORES;

   HORA_FIN := SYSTIMESTAMP;
   v_n := HORA_FIN - HORA_INI;
   DBMS_OUTPUT.PUT_LINE('[FIN] Duración la ejecución................'||EXTRACT( SECOND FROM v_n)||' segundos ');
    
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
