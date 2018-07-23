--/*
--##########################################
--## AUTOR=JIN LI, HU
--## FECHA_CREACION=20180718
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4296
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_PRO_PROPIETARIO ';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_ACT_PRO_PROPIETARIO';  -- Tabla a modificar    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4296'; -- USUARIOCREAR/USUARIOMODIFICAR   
    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO LA COLUMNA DD_CRA_ID DE ACT_PRO_PROPIETARIO');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
      SET DD_CRA_ID = (SELECT CRA.DD_CRA_ID FROM DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''12''),
          USUARIOMODIFICAR = '''|| V_USR ||''',
          FECHAMODIFICAR = SYSDATE
      WHERE '||V_ESQUEMA||'.'||V_TABLA||'.PRO_NOMBRE IN (''G-GIANTS REO I, S.L.'', ''G-GIANTS REO II, S.L.'', ''G-GIANTS REO III, S.L.'', ''G-GIANTS REO IV, S.L.'')';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_PRO_PROPIETARIO ACTUALIZADO CORRECTAMENTE ');
  
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
