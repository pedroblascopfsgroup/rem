--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20170207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-9999
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza campos de DD_UPO_UNID_POBLACIONAL
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    /* TABLA: DD_UPO_UNID_POBLACIONAL */
    TYPE T_UPO IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_UPO IS TABLE OF T_UPO;
    V_UPO T_ARRAY_UPO := T_ARRAY_UPO(
    --              DD_UPO_CODIGO     DD_UPO_DESCRIPCION    				DD_UPO_DESCRIPCION_LARGA
		   T_UPO(   '251200000'       ,'LLEIDA'      						,'LLEIDA'),
		   T_UPO(   '170790000'       ,'GIRONA'      						,'GIRONA'),
		   T_UPO(   '462440000'       ,'TORRENT'      						,'TORRENT'),
		   T_UPO(   '380380000'       ,'SANTA CRUZ DE TENERIFE'      		,'SANTA CRUZ DE TENERIFE'),
		   T_UPO(   '461450000'       ,'XATIVA'      						,'XATIVA'),
		   T_UPO(   '461940000'       ,'PICASSENT'      					,'PICASSENT'),
		   T_UPO(   '350140000'       ,'CORRALEJO'      					,'CORRALEJO'),
		   T_UPO(   '40350000'        ,'CUEVAS DEL ALMANZORA'      			,'CUEVAS DEL ALMANZORA'),
		   T_UPO(   '461470000'       ,'LLIRIA'      						,'LLIRIA'),
		   T_UPO(   '380230000'       ,'SAN CRISTOBAL DE LA LAGUNA'      	,'SAN CRISTOBAL DE LA LAGUNA')
		);
    V_TMP_T_UPO T_UPO;
    
    
    
 -- ## FIN DATOS
 -- ########################################################################################
      


BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando datos de DD_UPO_UNID_POBLACIONAL.');
    
	FOR I IN V_UPO.FIRST .. V_UPO.LAST
	LOOP
	  V_TMP_T_UPO := V_UPO(I);
	  V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL ' ||
	  			  ' SET DD_UPO_DESCRIPCION = '||''''||V_TMP_T_UPO(2)||''''||','||
	  			  ' DD_UPO_DESCRIPCION_LARGA = '||''''||V_TMP_T_UPO(3)||''''
	  ||' WHERE DD_UPO_CODIGO = '||''''||V_TMP_T_UPO(1)||'''';
	  EXECUTE IMMEDIATE V_MSQL;
	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Actualizado correctamente.');
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