--/*
--######################################### 
--## AUTOR=Hector Crespo
--## FECHA_CREACION=20210421
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13686
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Modificar formato
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'HREOS-13686';
    V_DESCRIPCION VARCHAR2(50 CHAR):='Notarial (compra)  Adj. No Judicial';
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INICIO]: UPDATE REGISTROS EN DD_STA_SUBTIPO_TITULO_ACTIVO');
    
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA
    			SET
			     STA.USUARIOMODIFICAR = '''||V_USU||'''
			    , STA.FECHAMODIFICAR = SYSDATE
                , STA.DD_STA_DESCRIPCION = '''||V_DESCRIPCION||'''
                , STA.DD_STA_DESCRIPCION_LARGA = '''||V_DESCRIPCION||'''
			WHERE STA.DD_STA_CODIGO IN (''03'')';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO: ' || SQL%ROWCOUNT);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA DD_STA_SUBTIPO_TITULO_ACTIVO ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;
