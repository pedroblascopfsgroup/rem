--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20151029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.17-bk
--## INCIDENCIA_LINK=BKREC-1290
--## PRODUCTO=NO
--## Finalidad: DML
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
	
    V_NUM1 NUMBER(20); -- Vble. auxiliar
    V_NUM2 NUMBER(20); -- Vble. auxiliar
    V_NUM3 NUMBER(20); -- Vble. auxiliar
    V_NUM4 NUMBER(20); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 --/**
    -- * Modificación de USD_USUARIOS_DESPACHOS, donde dejaremos solamente un 1 USD_GESTOR_DEFECTO activo por DES_ID (despacho)
    -- */
    V_SQL := 'select count(*) from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A172244''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN  
      V_SQL := 'select usu_id from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A172244''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM1;
      execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0, usuariomodificar=''BKREC-1290'', fechamodificar=sysdate where DES_ID=(select des_id from '||V_ESQUEMA||'.des_despacho_externo where des_despacho=''ACUERDO'' AND BORRADO = 0 and des_id in (select des_id from usd_usuarios_despachos where usu_id='||V_NUM1||')) and USU_ID='||V_NUM1||'';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el usuario o esta duplicado');
        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro para el usuario A168771');
    END IF;
    
    V_SQL := 'select count(*) from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A127028''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN  
      V_SQL := 'select usu_id from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A127028''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM1;
      execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0, usuariomodificar=''BKREC-1290'', fechamodificar=sysdate where DES_ID=(select des_id from '||V_ESQUEMA||'.des_despacho_externo where des_despacho=''HAYA'' AND BORRADO = 0 and des_id in (select des_id from usd_usuarios_despachos where usu_id='||V_NUM1||')) and USU_ID='||V_NUM1||'';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el usuario o esta duplicado');
        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro para el usuario A127028');
    END IF;
    
    V_SQL := 'select count(*) from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A112600''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
    IF V_NUM_TABLAS = 1 THEN  
      V_SQL := 'select usu_id from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A112600''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM1;
      execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0, usuariomodificar=''BKREC-1290'', fechamodificar=sysdate where DES_ID=(select des_id from '||V_ESQUEMA||'.des_despacho_externo where des_despacho=''HAYA'' AND BORRADO = 0 and des_id in (select des_id from usd_usuarios_despachos where usu_id='||V_NUM1||')) and USU_ID='||V_NUM1||'';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el usuario o esta duplicado');
        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro para el usuario A112600');
    END IF;
    
    V_SQL := 'select count(*) from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A168771''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN
      V_SQL := 'select usu_id from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A168771''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM1;
      execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0, usuariomodificar=''BKREC-1290'', fechamodificar=sysdate where DES_ID=(select des_id from '||V_ESQUEMA||'.des_despacho_externo where des_despacho=''LUPICINIO RODRIGUEZ JIMENEZ'' AND BORRADO = 0 and des_id in (select des_id from usd_usuarios_despachos where usu_id='||V_NUM1||')) and USU_ID='||V_NUM1||'';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el usuario o esta duplicado');
        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro para el usuario A168771');
    END IF;
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          
END;
/
EXIT;