--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160523
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1353
--## PRODUCTO=SI
--## Finalidad: DML.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

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
    
    V_TGE_ID NUMBER(16); -- Vble. para guardar el id del TGE
    V_ENT_ID NUMBER(16); -- Vble. para guardar el id de la ENTIDAD

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    --Valores en ETG_ENTIDAD_TIPO_GESTOR
    TYPE T_TGE_ENTTGEST IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_STA IS TABLE OF T_TGE_ENTTGEST;
    V_TGE_TIPOGEST T_ARRAY_STA := T_ARRAY_STA(
      T_TGE_ENTTGEST('GAJUR', 'HAYA'),  
      T_TGE_ENTTGEST('SAJUR', 'HAYA')
    );   
    V_TMP_ETG T_TGE_ENTTGEST;
   
    
BEGIN
	 
	-- LOOP Insertando valores en ETG_ENTIDAD_TIPO_GESTOR ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.ETG_ENTIDAD_TIPO_GESTOR... Empezando a insertar datos');
    
    FOR I IN V_TGE_TIPOGEST.FIRST .. V_TGE_TIPOGEST.LAST
      LOOP
         
      	V_TMP_ETG := V_TGE_TIPOGEST(I);
      	
      	  V_SQL := 'SELECT COUNT(DD_TGE_ID) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_ETG(1))||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

          IF V_NUM_TABLAS = 1 THEN
          		
          		V_SQL := 'SELECT COUNT(ID) FROM '||V_ESQUEMA_M||'.ENTIDAD WHERE DESCRIPCION = '''||TRIM(V_TMP_ETG(2))||'''';
          		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          		
          		IF V_NUM_TABLAS = 1 THEN
          		
          				V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_ETG(1))||''''; 
          				EXECUTE IMMEDIATE V_SQL INTO V_TGE_ID;
          		        
          				V_SQL := 'SELECT ID FROM '||V_ESQUEMA_M||'.ENTIDAD WHERE DESCRIPCION = '''||TRIM(V_TMP_ETG(2))||'''';
          				EXECUTE IMMEDIATE V_SQL INTO V_ENT_ID;
          				
          				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.ETG_ENTIDAD_TIPO_GESTOR (DD_TGE_ID, ENTIDAD_ID ) VALUES ('||V_TGE_ID||','||V_ENT_ID||')';
	              
	          			EXECUTE IMMEDIATE V_MSQL;
	          			DBMS_OUTPUT.PUT_LINE('INSERTADO: '''||V_TMP_ETG(1)||''' - '''||V_TMP_ETG(2)||'''');
          				
          		ELSE
          			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.ENTIDAD... No tiene resultados o obtiene mas de uno para el codigo '''|| TRIM(V_TMP_ETG(2)) ||'''');
          		END IF;
          		
          ELSE
	       		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR... No tiene resultados o obtiene mas de uno para el codigo '''|| TRIM(V_TMP_ETG(1)) ||'''');
	      END IF;
          
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR... Datos insertados.');
	
	
	
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
    END 