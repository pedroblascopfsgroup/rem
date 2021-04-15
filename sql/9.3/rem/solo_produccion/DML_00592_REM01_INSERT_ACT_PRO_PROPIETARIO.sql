--/*
--###########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8594
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAR PROPIETARIO
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

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO PROPIETARIO');

    V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO||' WHERE PRO_DOCIDENTIF = ''A04914099'' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR ACTIVO EN GASTO' );

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO||'(PRO_ID, DD_LOC_ID, DD_PRV_ID, DD_TPE_ID, PRO_NOMBRE, DD_TDI_ID, PRO_DOCIDENTIF, PRO_DIR, PRO_CP, USUARIOCREAR, FECHACREAR)
        VALUES (
        '||V_ESQUEMA||'.S_'||V_TABLA_PROPIETARIO||'.NEXTVAL,
        (SELECT DD_LOC_ID FROM '||V_ESQUEMA||'.APR_AUX_DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = ''04013''),
        (SELECT DD_PRV_ID FROM '||V_ESQUEMA||'.APR_AUX_DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = ''04''),
        (SELECT DD_TPE_ID FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = ''2''),
        ''Cimenta Desarrollos Inmobiliarios SAU'',
        (SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''02''),
        ''A04914099'',
        ''Plaza Juan del Aguila Molina, 5'',
        ''04006'',
        '''||V_USUARIO||''',
        SYSDATE )';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: PROPIETARIO CREADO CORRECTAMENTE' );

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: EL PROPIETARIO YA EXISTE' );
        
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