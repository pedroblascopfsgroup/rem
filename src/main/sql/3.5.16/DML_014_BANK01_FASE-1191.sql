--/*
--##########################################
--## Author: Óscar
--## Finalidad: DML
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ada_adjuntos_asuntos
   SET usuariomodificar = ''FASE-1191'',
       fechamodificar = SYSDATE,
       dd_tfa_id = (SELECT dd_tfa_id
                      FROM '||V_ESQUEMA||'.dd_tfa_fichero_adjunto
                     WHERE dd_tfa_codigo = ''ADC'')
 WHERE dd_tfa_id = (SELECT dd_tfa_id
                      FROM '||V_ESQUEMA||'.dd_tfa_fichero_adjunto
                     WHERE dd_tfa_codigo = ''ADCO'')';

EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.adp_adjuntos_personas
   SET usuariomodificar = ''FASE-1191'',
       fechamodificar = SYSDATE,
       dd_tfa_id = (SELECT dd_tfa_id
                      FROM '||V_ESQUEMA||'.dd_tfa_fichero_adjunto
                     WHERE dd_tfa_codigo = ''ADC'')
 WHERE dd_tfa_id = (SELECT dd_tfa_id
                      FROM '||V_ESQUEMA||'.dd_tfa_fichero_adjunto
                     WHERE dd_tfa_codigo = ''ADCO'')';
                     
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.adc_adjuntos_contratos
   SET usuariomodificar = ''FASE-1191'',
       fechamodificar = SYSDATE,
       dd_tfa_id = (SELECT dd_tfa_id
                      FROM '||V_ESQUEMA||'.dd_tfa_fichero_adjunto
                     WHERE dd_tfa_codigo = ''ADC'')
 WHERE dd_tfa_id = (SELECT dd_tfa_id
                      FROM '||V_ESQUEMA||'.dd_tfa_fichero_adjunto
                     WHERE dd_tfa_codigo = ''ADCO'')';


DBMS_OUTPUT.PUT_LINE('[INICIO] Nuevo documento'); 
        V_SQL := ' select count(1)
    from '||V_ESQUEMA||'.adj_adjuntos adj
    left join '||V_ESQUEMA||'.ada_adjuntos_asuntos ada on adj.adj_id = ada.adj_id
    left join '||V_ESQUEMA||'.adc_adjuntos_contratos adc on adj.adj_id = adc.adj_id
    left join '||V_ESQUEMA||'.adp_adjuntos_personas adp on adj.adj_id = adp.adj_id
    where ada.DD_TFA_ID  = (select dd_tfa_id from '||V_ESQUEMA||'.dd_tfa_fichero_adjunto where dd_tfa_codigo = ''ADCO'')  or adc.dd_tfa_id = (select dd_tfa_id from '||V_ESQUEMA||'.dd_tfa_fichero_adjunto where dd_tfa_codigo = ''ADCO'') or adp.dd_tfa_id = (select dd_tfa_id from '||V_ESQUEMA||'.dd_tfa_fichero_adjunto where dd_tfa_codigo = ''ADCO'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
IF V_NUM_TABLAS > 0 THEN            
  DBMS_OUTPUT.put_line('[INFO] Existen ficheros de tipo ADCO');
ELSE        
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET BORRADO = 1, USUARIOBORRAR = ''FASE-1191'', fechaborrar = sysdate where dd_tfa_codigo = ''ADCO''';
END IF ;  






COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

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

