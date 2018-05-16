--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-505
--## PRODUCTO=NO
--##
--## Finalidad: Insercion en la TMP_APROV_DACIONES
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--BIE_ENTIDAD_ID	
		       T_TIPO_DATA(74289)
			 , T_TIPO_DATA(201275)
			 , T_TIPO_DATA(176123)
			 , T_TIPO_DATA(91445)
			 , T_TIPO_DATA(152198)
			 , T_TIPO_DATA(152214)
			 , T_TIPO_DATA(152255)
			 , T_TIPO_DATA(152257)
			 , T_TIPO_DATA(152261)
			 , T_TIPO_DATA(178573)
			 , T_TIPO_DATA(117340)
			 , T_TIPO_DATA(105286)
			 , T_TIPO_DATA(105528)
			 , T_TIPO_DATA(111784)
			 , T_TIPO_DATA(105287)
			 , T_TIPO_DATA(105093)
			 , T_TIPO_DATA(117554)
			 , T_TIPO_DATA(117136)
			 , T_TIPO_DATA(117322)
			 , T_TIPO_DATA(112106)
			 , T_TIPO_DATA(115316)
			 , T_TIPO_DATA(112004)
			 , T_TIPO_DATA(117323)
			 , T_TIPO_DATA(117137)
			 , T_TIPO_DATA(111785)
			 , T_TIPO_DATA(117138)
			 , T_TIPO_DATA(115809)
			 , T_TIPO_DATA(117324)
			 , T_TIPO_DATA(111786)
			 , T_TIPO_DATA(117139)
			 , T_TIPO_DATA(132771)
			 , T_TIPO_DATA(144635)
			 , T_TIPO_DATA(148273)
			 , T_TIPO_DATA(132772)
			 , T_TIPO_DATA(156722)
			 , T_TIPO_DATA(156723)
			 , T_TIPO_DATA(132675)
			 , T_TIPO_DATA(145247)
			 , T_TIPO_DATA(156933)
			 , T_TIPO_DATA(156934)
			 , T_TIPO_DATA(132676)
			 , T_TIPO_DATA(152450)
			 , T_TIPO_DATA(200751)
			 , T_TIPO_DATA(161779)
			 , T_TIPO_DATA(161272)
			 , T_TIPO_DATA(176122)
			 , T_TIPO_DATA(65980)
			 , T_TIPO_DATA(129330)
			 , T_TIPO_DATA(107744)
			 , T_TIPO_DATA(95834)
			 , T_TIPO_DATA(102065)
			 , T_TIPO_DATA(109821)
			 , T_TIPO_DATA(95704)
			 , T_TIPO_DATA(109767)
			 , T_TIPO_DATA(6976748)
			 , T_TIPO_DATA(6976749)
			 , T_TIPO_DATA(6976750)

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en TMP_APROV_DACIONES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TMP_APROV_DACIONES... Empezando a insertar datos en la tabla TMP_APROV_DACIONES');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
   		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_APROV_DACIONES(BIE_ENTIDAD_ID)
			  VALUES('||V_TMP_TIPO_DATA(1)||')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('INSERTANDO BIE_ENTIDAD_ID: '''||V_TMP_TIPO_DATA(1)||'''');
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TMP_APROV_DACIONES... Datos de la tabla insertados');
   

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


