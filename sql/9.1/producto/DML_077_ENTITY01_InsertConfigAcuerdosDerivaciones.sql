--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20151019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=PRODUCTO-180
--## PRODUCTO=SI
--##
--## Finalidad: Inserta la configuración de las derivaciones por tipo de acuerdo del termino en ACU_CDE_DERIVACIONES
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(8000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_TPA VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TPA.
    V_SQL_TPA_COUNT VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TPA.
    V_SQL_TPO VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TPA.  
    V_SQL_TPO_COUNT VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TPA COUNT.
    V_ID_TPA VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TPA
    V_ID_TPA_COUNT VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TPA
    V_ID_TPO VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TPA
    V_ID_TPO_COUNT VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TPA
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    --Valores en ACU_CDE_DERIVACIONES
    TYPE T_ACU_DERIV IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_STA IS TABLE OF T_ACU_DERIV;
    V_ACU_DERIV T_ARRAY_STA := T_ARRAY_STA(
      T_ACU_DERIV( 'DA_CV', 'HC102', 1, 'Ha finalizado el Término de dación / compraventa del Acuerdo dado de alta en el asunto. Por favor,compruebe si corresponde iniciar el "Trámite de Mandamiento de Cancelación de Cargas"', 0, 'CGG', SYSDATE, 0, NULL, NULL, NULL, NULL )
    );   
    V_TMP_ACU_DERIV T_ACU_DERIV;

BEGIN	

      -- LOOP Insertando valores en ACU_CDE_DERIVACIONES ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES... Empezando a insertar datos en ACU_CDE_DERIVACIONES');
    FOR I IN V_ACU_DERIV.FIRST .. V_ACU_DERIV.LAST
      LOOP
            V_TMP_ACU_DERIV := V_ACU_DERIV(I);
            
            V_SQL_TPO_COUNT := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||V_TMP_ACU_DERIV(2)||'''';
			EXECUTE IMMEDIATE V_SQL_TPO_COUNT INTO V_ID_TPO_COUNT;
			
			V_SQL_TPA_COUNT := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = '''||V_TMP_ACU_DERIV(1)||'''';
			EXECUTE IMMEDIATE V_SQL_TPA_COUNT INTO V_ID_TPA_COUNT;
            
            IF (V_ID_TPO_COUNT > 0) AND (V_ID_TPA_COUNT > 0)  THEN				
          		    --- Obtenemos el DD_TPA_ID
			        V_SQL_TPA := 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = '''||V_TMP_ACU_DERIV(1)||'''';
			        EXECUTE IMMEDIATE V_SQL_TPA INTO V_ID_TPA;
			        
			        --- Obtenemos el DD_TPO_ID
			        V_SQL_TPO := 'SELECT DD_TPO_ID FROM '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||V_TMP_ACU_DERIV(2)||'''';
			        EXECUTE IMMEDIATE V_SQL_TPO INTO V_ID_TPO;
			            
			        --Comprobamos el dato a insertar
			        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES WHERE DD_TPA_ID = '''||V_ID_TPA||'''';
			        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			        
			        IF V_NUM_TABLAS > 0 THEN				
			          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_CDE_DERIVACIONES... Ya existe el ACU_CDE_DERIVACIONES con el DD_TPA_ID = '''|| V_ID_TPA ||'''');
			        ELSE
			        
			          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACU_CDE_DERIVACIONES.NEXTVAL FROM DUAL';
			          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
			          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACU_CDE_DERIVACIONES (' ||
			                      'ACU_CDE_ID, DD_TPA_ID, DD_TPO_ID, ACU_CDE_RESTRICTIVO, ACU_CDE_RESTRICTIVO_TEXTO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR)' ||
			                      'SELECT '|| V_ENTIDAD_ID || ','''||V_ID_TPA||''','''||V_ID_TPO||''','''||V_TMP_ACU_DERIV(3)||''''||
									','''||V_TMP_ACU_DERIV(4)||''','''||V_TMP_ACU_DERIV(5)||''','''||V_TMP_ACU_DERIV(6)||''''||
									','''||V_TMP_ACU_DERIV(7)||''','''||V_TMP_ACU_DERIV(8)||''','''||V_TMP_ACU_DERIV(9)||''''||
									','''||V_TMP_ACU_DERIV(10)||''','''||V_TMP_ACU_DERIV(11)||''','''||V_TMP_ACU_DERIV(12)||''' FROM DUAL';
			              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_ACU_DERIV(2)||'''');
			          EXECUTE IMMEDIATE V_MSQL;
			        END IF;
       		ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_CDE_DERIVACIONES... No existe el DD_TPO_CODIGO = '''|| V_TMP_ACU_DERIV(2) ||'''');
       		END IF;
            
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.STA_SUBTIPO... Datos del subtipo de tarea insertado.');
    
    
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