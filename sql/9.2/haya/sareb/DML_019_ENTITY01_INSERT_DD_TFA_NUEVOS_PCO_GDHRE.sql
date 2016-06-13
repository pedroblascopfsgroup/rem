--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160608
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1117
--## PRODUCTO=NO
--## Finalidad: DML Insert registros en DD_TFA nuevos tipos de fichero de TAC: PCO para GestorDocumental HRE
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
    V_TAC_ID NUMBER(16);
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    	T_FUNCION('ENOV','Escritura Novación','Escritura de Novación'),
		T_FUNCION('EAMP','Escritura ampliación','Escritura de ampliación'),
		T_FUNCION('EONDH','Escritura obra nueva y/o división horiz','Escritura obra nueva y/ o división horizontal'),
		T_FUNCION('EDRH','Escritura Distr. de Respons. Hipot.','Escritura de Distribución de Responsabilidad Hipotecaria'),
		T_FUNCION('ESAF','Escritura Afianzamiento','Escritura de Afianzamiento'),
		T_FUNCION('PREN','Prenda','Prenda'),
		T_FUNCION('TEEJ','Testimonio Ejecutivo','Testimonio Ejecutivo'),
		T_FUNCION('ESUB','Escritura subrogación','Escritura de subrogación')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    --Activamos el borrado lógico de los registros actuales, luego se activar si esta en el listado.
    --V_SQL := 'UPDATE '||V_ESQUEMA||'.MTC_MAPEO_TIPO_CONTENEDOR SET BORRADO = 1, USUARIOBORRAR =''PRODUCTO-1117'', FECHABORRAR = sysdate where BORRADO=0';
    --EXECUTE IMMEDIATE V_SQL;
    

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        -- INSERTANDO EN MTT_MAP_ADJRECOVERY_ADJCM

        IF V_NUM_TABLAS = 0 THEN   
        
            V_SQL_NEXT_ID := 'SELECT '|| V_ESQUEMA ||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL FROM DUAL';
        	EXECUTE IMMEDIATE V_SQL_NEXT_ID INTO V_NEXT_ID;

        	V_SQL := 'SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO=''PCO''';
        	EXECUTE IMMEDIATE V_SQL INTO V_TAC_ID;

	  		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TFA_FICHERO_ADJUNTO (' ||
      		'DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)' ||
      		'VALUES ('||V_NEXT_ID||','''||TRIM(V_TMP_FUNCION(1))||''','''||TRIM(V_TMP_FUNCION(2))||''','''||TRIM(V_TMP_FUNCION(3))||''', 0, ''PRODUCTO-1117'',SYSDATE,0,'||V_TAC_ID||')';
      		EXECUTE IMMEDIATE V_MSQL;
      		
       		DBMS_OUTPUT.PUT_LINE('INSERTANDO: en DD_TFA_FICHERO_ADJUNTO datos: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
       		COMMIT;

        ELSE    
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TFA_FICHERO_ADJUNTO... YA existe el registro con el DD_TFA_CODIGO '''|| TRIM(V_TMP_FUNCION(1))||'''');
        END IF;
      END LOOP;



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