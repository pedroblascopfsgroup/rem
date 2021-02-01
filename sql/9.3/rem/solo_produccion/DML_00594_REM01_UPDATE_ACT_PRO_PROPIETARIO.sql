--/*
--###########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8594
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR PROPIETARIO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-8594';
  V_TABLA_PROPIETARIO VARCHAR2(100 CHAR):='ACT_PRO_PROPIETARIO';
  
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO PROPIETARIO');

    V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO||' WHERE PRO_DOCIDENTIF = ''A04914099'' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PROPIETARIO' );

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO||' SET
        DD_LOC_ID = (SELECT DD_LOC_ID FROM '||V_ESQUEMA||'.APR_AUX_DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = ''04013''), 
        DD_PRV_ID = (SELECT DD_PRV_ID FROM '||V_ESQUEMA||'.APR_AUX_DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = ''04''),
        DD_TPE_ID = (SELECT DD_TPE_ID FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = ''2''),
        PRO_NOMBRE = ''Cimenta Desarrollos Inmobiliarios SAU'', 
        DD_TDI_ID = (SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''02''),
        PRO_DIR = ''Plaza Juan del Aguila Molina, 5'',
        PRO_CP = ''04006'',
        USUARIOMODIFICAR = '''||V_USUARIO||''',
        FECHAMODIFICAR = SYSDATE
        WHERE PRO_DOCIDENTIF = ''A04914099''';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: PROPIETARIO ACTUALIZADO CORRECTAMENTE' );

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: EL PROPIETARIO NO EXISTE' );
        
    END IF;

  	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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