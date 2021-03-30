--/*
--######################################### 
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210323
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13578
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
    V_USU VARCHAR2(30 CHAR) := 'HREOS-13578';
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INICIO]: BORRADO REGISTROS EN DD_EAC_ESTADO_ACTIVO');
    
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO EAC
    			SET
    			    EAC.BORRADO = 1
			    , EAC.USUARIOBORRAR = '''||V_USU||'''
			    , EAC.FECHABORRAR = SYSDATE
			WHERE EAC.DD_EAC_CODIGO IN (''08'',''11'')';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADOS: ' || SQL%ROWCOUNT);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_ACTIVO ACTUALIZADA CORRECTAMENTE ');

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
