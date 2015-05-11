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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

--INC 87
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoADC() ? null : ''''Es necesario adjuntar el documento auto de declaración del concurso.'''''' where tap_codigo = ''P412_RegistrarPublicacionBOE'' and tap_script_validacion is null';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoECC() ? null : ''''Es necesario adjuntar el documento escrito de comunicación de créditos.'''''' where tap_codigo = ''P412_RegistrarInsinuacionCreditos''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoIPAC() ? null : ''''Es necesario adjuntar el documento informe provisional del AC.'''''' where tap_codigo = ''P412_RegistrarInformeAdmonConcursal''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoTDAC() ? null : ''''Es necesario adjuntar el documento textos definitivos del AC.'''''' where tap_codigo = ''P412_RegistrarResolucionFaseComun''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion_jbpm = ''valores[''''P408_realizarValoracionConcurso''''][''''comboConvenioPresentado''''] == DDSiNo.SI ? (comprobarExisteDocumentoPC() ? null : ''''Es necesario adjuntar el documento propuestas de convenio.'''') : ''''null'''''' where tap_codigo = ''P408_realizarValoracionConcurso''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoPI() ? null : ''''Es necesario adjuntar el documento planes de liquidación.'''''' where tap_codigo = ''P31_InformeLiquidacion''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P406_RegistrarResHomologacionJudicial''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P22_RegistrarResolucion''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P25_RegistrarResolucion''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo in (''P96_registrarResolucionAllanamiento'',''P96_registrarResolucionOposicion'')';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P28_registrarResolucion''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P30_RegResolucionConvenio''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P31_registrarResolucion''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P34_registrarResolucion''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P62_registrarResolucion''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoASDJM() ? null : ''''Es necesario adjuntar el documento auto o sentencia dictada por el juzgado de lo mercantil.'''''' where tap_codigo = ''P94_RegistrarResolucion''';

DBMS_OUTPUT.PUT_LINE('[INICIO] Nuevo documento'); 
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''APS''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) values   (s_dd_tfa_fichero_adjunto.nextval, ''APS'', ''Aprobación propuesta de subasta'', ''Aprobación propuesta de subasta'', 0, ''DML'', SYSDATE, 0, 8)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
    
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoDSCC() ? null : ''''Es necesario adjuntar el documento demanda sellada + certificación de cargas (cuando se obtenga)'''')'' where tap_codigo = ''P01_DemandaCertificacionCargas''';

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
