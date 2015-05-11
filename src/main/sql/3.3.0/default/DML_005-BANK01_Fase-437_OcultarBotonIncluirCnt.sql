/*
--##########################################
--## Author: Óscar Dorado
--## Adaptado a BP : 
--## Finalidad: Hasta fase 3, ningún usuario debe poder utilizar la función de agregar contratos al procedimiento 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('ROLE_INCLUIR_CONTRATO_PROCEDIMIENTO'), -- Acumulación de contratos
      T_TIPO_TPO('ACEPTAR-ASUNTO') -- Ver pesatña de aceptación del asunto
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    
   

BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... Actualizando referencias');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (select fun_id from '||V_ESQUEMA_MASTER||'.fun_funciones where fun_descripcion = '''|| V_TMP_TIPO_TPO(1) || ''')'; 

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando: ''' || V_TMP_TIPO_TPO(1) ||'''');
            
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'... Referencias actualizadas');
   
    
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