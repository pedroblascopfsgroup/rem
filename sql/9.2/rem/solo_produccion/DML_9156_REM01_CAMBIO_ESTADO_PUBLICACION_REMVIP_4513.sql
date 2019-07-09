--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190611
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4513
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
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4513';
   V_COUNT NUMBER(16):= 0;
   HORA_INI TIMESTAMP;
   HORA_FIN TIMESTAMP;
   v_n INTERVAL DAY TO SECOND ;
    
   
   CURSOR ESTADO_PUBLI_RECALCULAR IS 
       SELECT ACT_ID 
       FROM REM01.ACT_ACTIVO
       WHERE ACT_NUM_ACTIVO IN (
        6872800, 
	6874732,
	6876810,
	7073072, 
	6868227, 
	7073072
       );

   FILA ESTADO_PUBLI_RECALCULAR%ROWTYPE;
  
BEGIN
   HORA_INI := SYSTIMESTAMP;
   DBMS_OUTPUT.put_line('[INICIO] Ejecutando actualizacion estados publicacion ...........'||HORA_INI||' ');

     
   OPEN ESTADO_PUBLI_RECALCULAR;
   
   V_COUNT := 0;
   
   LOOP
       FETCH ESTADO_PUBLI_RECALCULAR INTO FILA;
       EXIT WHEN ESTADO_PUBLI_RECALCULAR%NOTFOUND;
       
       REM01.SP_CAMBIO_ESTADO_PUBLICACION (FILA.ACT_ID, 1, ''||V_USUARIOMODIFICAR||'');
           
       V_COUNT := V_COUNT + 1;
   END LOOP;
    
   DBMS_OUTPUT.PUT_LINE(' [INFO] Se han RECALCULADO '||V_COUNT||' ESTADOS DE PUBLICACION ');
   CLOSE ESTADO_PUBLI_RECALCULAR;

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
