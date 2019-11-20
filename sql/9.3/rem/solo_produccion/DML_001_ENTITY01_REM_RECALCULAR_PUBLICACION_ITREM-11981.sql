--/*
--##########################################
--## AUTOR=Patricio Grisolia Romano
--## FECHA_CREACION=20191016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=ITREM-11981
--## PRODUCTO=NO
--## Finalidad:
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				-- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 	-- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); 								-- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); 								-- Vble. para validar la existencia de una tabla.   
    err_num NUMBER; 										-- Numero de errores
    err_msg VARCHAR2(2048); 								-- Mensaje de error
	V_USUARIO VARCHAR2(24 CHAR):= 'ITREM-11981';
	V_ACT_ID VARCHAR2(24 CHAR);


  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
T_TIPO_DATA('7070876')

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_SQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVOS WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_SQL INTO V_ACT_ID;
    
		#ESQUEMA#.SP_CAMBIO_ESTADO_PUBLICACION(V_ACT_ID,1,V_USUARIO);
	    
		
	END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
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
  	
