--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20180924
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CCC_CONFIG_CTAS_CONTABLES los subtipos de trabajos de Precios
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
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_STG_SUBTIPOS_GASTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES] ');
    
        --Comprobamos el dato a insertar
	V_SQL := 'SELECT COUNT(1)  
		FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
		INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CCC.EJE_ID
		INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CCC.DD_CRA_ID
		INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CCC.DD_STG_ID
		INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
		WHERE CRA.DD_CRA_CODIGO = ''03''
		AND EJE.EJE_ANYO = 2018
		AND STG.DD_STG_DESCRIPCION = ''Fianzas''
		AND TGA.DD_TGA_DESCRIPCION = ''Alquiler''
		AND CCC.CCC_ARRENDAMIENTO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si no existe, lo insertamos
        IF V_NUM_TABLAS = 0 THEN				
			  
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES(CCC_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CCC_CUENTA_CONTABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CCC_ARRENDAMIENTO) 
		VALUES ('||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL,
		(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = 2018),
		(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = ''Fianzas'' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = ''Alquiler'')),
		(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''03''), ''930504'',0,''REMVIP-1945'',SYSDATE,0,0)';
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE CORRECTAMENTE');
          
	EXECUTE IMMEDIATE V_MSQL;

       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE CC SIN ARRENDAMIENTO PARA EL TIPO ''Alquiler'' Y SUBTIPO ''Fianzas''');        
        
       END IF;
    COMMIT;
   

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

EXIT;
