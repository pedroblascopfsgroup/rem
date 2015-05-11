--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DML para rellenar los datos de los diccionarios relacionados con SUB_SUBASTA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en DD_DFI_DECISION_FINALIZAR
    TYPE T_TIPO_DFI IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_DFI IS TABLE OF T_TIPO_DFI;
    V_TIPO_DFI T_ARRAY_DFI := T_ARRAY_DFI(
    T_TIPO_DFI(1, 'CA', 'Amistosa', 'Tipo de Actuación Amistosa', 0, 'DD', 0),
   T_TIPO_DFI(2, 'TR', 'Trámites', 'Tipo de Actuación Trámites', 0, 'DD', 0),
   T_TIPO_DFI(21, '03', 'Otros trámites', 'Otros trámites', 0, 'DD', 0),
   T_TIPO_DFI(22, '04', 'Contratos bloqueados', 'Contratos bloqueados', 0, 'DD', 0),
   T_TIPO_DFI(3, 'CO', 'Concursal', 'Tipo de Actuación Concursal', 0, 'DD', 0),
   T_TIPO_DFI(4, 'PE', 'Penal', 'Tipo de Actuación Penal', 0, 'DD', 1),
   T_TIPO_DFI(5, 'AD', 'Adjudicados', 'Tipo de Actuación Adjudicados', 0, 'DD', 1),
   T_TIPO_DFI(6, 'EJ', 'Ejecutivo y cambiario', 'Tipo de Actuación Ejecutivo', 0, 'DD', 0),
   T_TIPO_DFI(7, 'DE', 'Declarativo y monitorio', 'Tipo de Actuación Declarativo', 0, 'DD',  0),
   T_TIPO_DFI(8, 'AP', 'Apremio', 'Tipo de Actuación Apremio', 0, 'DD', 0),
   T_TIPO_DFI(101, 'DEL', 'Borrado logico', 'Borrado logico', 0, 'DD', 1),
   T_TIPO_DFI(23, 'REC', 'Recobro', 'Tipo de Actuación Recobro', 0, 'chema', 0),
   T_TIPO_DFI(301, 'GI', 'Gestión Interna', 'Gestión Interna', 0, 'DD', 0),
   T_TIPO_DFI(201, 'EX', 'Extrajudicial', 'Extrajudicial', 0, 'Oscar', 0)
    ); 
    V_TMP_TIPO_DFI T_TIPO_DFI;
    
    
    BEGIN	
    -- LOOP Insertando valores en DD_DFI_DECISION_FINALIZAR
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_DFI.FIRST .. V_TIPO_DFI.LAST
      LOOP
      
        V_TMP_TIPO_DFI := V_TIPO_DFI(I);
        
        V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = '''||TRIM(V_TMP_TIPO_DFI(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TAC_TIPO_ACTUACION... Ya existe la ACTUACION '''|| TRIM(V_TMP_TIPO_DFI(1))||'''');
        ELSE
             
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION (
                      DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                      SELECT '|| V_TMP_TIPO_DFI(1) || ','''||V_TMP_TIPO_DFI(2)||''','''||TRIM(V_TMP_TIPO_DFI(3))||''','''||TRIM(V_TMP_TIPO_DFI(4))||''',' ||
                      TRIM(V_TMP_TIPO_DFI(5))||','''||TRIM(V_TMP_TIPO_DFI(6))||''',SYSDATE,'||TRIM(V_TMP_TIPO_DFI(7))||' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_DFI(2)||''','''||TRIM(V_TMP_TIPO_DFI(3))||'''');
              
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          
        END IF;
        
      END LOOP;
       
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION... Datos del diccionario insertado');
      

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