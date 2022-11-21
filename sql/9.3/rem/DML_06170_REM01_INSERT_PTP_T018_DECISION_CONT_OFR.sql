--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20221031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18888
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_COUNT NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TAP_ID NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TAP'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18888';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(800);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('T018_DecisionContinuidadOferta')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
	BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');


		  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			 DBMS_OUTPUT.PUT_LINE(' INSERTANDO EN [DD_PTP_PLAZOS_TAREAS_PLAZAS] ');
		    EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') ' INTO V_COUNT;
		
		    IF V_COUNT = 0 THEN
		        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
		            VALUES (
		                '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL
		                ,null ,null
		                ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
		                ,''5*24*60*60*1000L''
		                ,0
		                ,''HREOS-18888''
		                ,SYSDATE
		                , null,null,null,null
		                ,0
		                ,0
		                ,null
		            )';
		        EXECUTE IMMEDIATE V_MSQL;
		        
		        DBMS_OUTPUT.PUT_LINE(' INSERCION EN [DD_PTP_PLAZOS_TAREAS_PLAZAS] CORRECTA');
		    ELSE
		        DBMS_OUTPUT.PUT_LINE(' LA FILA YA EXISE EN [DD_PTP_PLAZOS_TAREAS_PLAZAS]');
		    END IF;
		    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
		END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
