--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200806
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7934
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
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-7934';
   V_SQL VARCHAR2(4000 CHAR);	
   V_PAR VARCHAR( 1024 CHAR );
   V_RET VARCHAR( 1024 CHAR );  
  
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');

-----------------------------------------------------------------------------------------------------------------      

   V_PAR := '11961826,
11979553,
11975377,
11975899,
11979537,
11905767,
11905788,
11905797,
11905810,
11905818,
11905838,
11905875,
11905909,
11905779,
11905791,
11905800,
11905801,
11905821,
11905844,
11905850,
11905862,
11905899,
11909010,
11950841,
11962916,
12025664,
12051053,
11905559,
11905578,
11905614,
11905620,
11905678,
11905705,
11905712,
11905761,
11905763,
11905775,
11905780,
11905842,
11905865,
11905870,
11905918,
11908626,
11909016,
12020947,
12020948,
12042210,
12051319,
12112327,
12112326';	

   REM01.SP_EXT_REENVIO_GASTO ( V_PAR , V_USUARIOMODIFICAR, V_RET );

-----------------------------------------------------------------------------------------------------------------

   DBMS_OUTPUT.PUT_LINE( V_RET );
   DBMS_OUTPUT.PUT_LINE(' [INFO] Reenviado gastos ');
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
