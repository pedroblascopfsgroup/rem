/*
--######################################################################
--## Author: Carlos P.
--## Finalidad: Corregir BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    /*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';    -- [PARAMETRO] Configuracion Esquemas

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     

    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    
BEGIN	

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando documentos .......');
    
     V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS     
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''ADCO'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''ADC'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
    
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RSAR'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''APS'')';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''PCTER'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''CONV'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RESPAC'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''INRSI'')';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''COAPH'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''LII'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''PCTER'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''PC'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''PCCSC'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''PCC'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''INFLFL'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''PL'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''INFLFL'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''PLIQ'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RSIPAC'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RESPAC'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RSPPAL'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RESFL'')';
	EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
	 V_MSQL := 'update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RSINPA'')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo=''RESHA'')';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  
  --COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando documentos .......');
     
    V_MSQL := 'delete from dd_tfa_fichero_adjunto where dd_tfa_codigo in (''ADC'',''APS'',''CONV'',''INRSI'',''LII'',''PC'',''PCC'',''PL'',''PLIQ'',''RESPAC'',''RESFL'',''RESHA'')';
    			
    DBMS_OUTPUT.PUT_LINE('[INFO] Eliminando documentos .......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Documentos eliminados.');  
    
    			
    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */

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