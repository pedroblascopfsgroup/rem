--/*
--##########################################
--## AUTOR=Salvador G
--## FECHA_CREACION=20160404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK=CMREC-2888
--## PRODUCTO=NO
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_ID VARCHAR2(4000 CHAR); -- Vble. para consulta del id.
    V_SQL_NEXT_ID VARCHAR2(4000 CHAR); -- Vble. para consulta del id.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TFA_ID NUMBER(16); -- Vble. para almacenar el id de DD_TFA_FICHERO_ADJUNTO.
    V_NEXT_ID NUMBER(16); -- Vble. para almacenar el siguiente id de MTT_MAP_ADJRECOVERY_ADJCM.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('ARETJ', '00360'),
      T_FUNCION('EDH', '00358'),
      T_FUNCION('ENES', '00384')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        -- INSERTANDO EN DD_TFA_FICHERO_ADJUNTO

        IF V_NUM_TABLAS > 0 THEN   
        
            V_SQL_ID := 'SELECT DD_TFA_ID FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        	EXECUTE IMMEDIATE V_SQL_ID INTO V_TFA_ID;
        	
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM WHERE DD_TFA_ID = '''||V_TFA_ID||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        	
        	IF V_NUM_TABLAS = 0 THEN
        	
        			V_SQL_NEXT_ID := 'SELECT NVL(MAX(MTT_ID)+1, 1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM';
        			EXECUTE IMMEDIATE V_SQL_NEXT_ID INTO V_NEXT_ID;
        	  
        	  		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.MTT_MAP_ADJRECOVERY_ADJCM (' ||
              		'MTT_ID, DD_TFA_ID, TFA_CODIGO_EXTERNO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
              		'VALUES ('||V_NEXT_ID||','||V_TFA_ID||','''||TRIM(V_TMP_FUNCION(2))||''', 0, ''DML'',SYSDATE,0)';
              
          	   		EXECUTE IMMEDIATE V_MSQL;
          	   		DBMS_OUTPUT.PUT_LINE('INSERTADO: en MTT_MAP_ADJRECOVERY_ADJCM datos: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
          
	       	ELSE    
					DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... Existe el registro '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
	        END IF;        
        	 
         ELSE    
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TFA_FICHERO_ADJUNTO... No existe el registro con el DD_TFA_CODIGO '''|| TRIM(V_TMP_FUNCION(1))||'''');
        END IF;
      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
