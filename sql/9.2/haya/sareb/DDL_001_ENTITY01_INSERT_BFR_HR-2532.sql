--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=20160531
--## ARTEFACTO=BACHT
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2532
--## PRODUCTO=NO
--## Finalidad: Creación de los nuevos registros de la tabla DD_PCO_BFR_RESULTADO
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
    V_MSQL VARCHAR2(32000 CHAR);
 -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01';
 -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER';
 -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16);
 -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);
  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);
 -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(1024 CHAR);

    V_USUARIO VARCHAR2(1024 CHAR);

    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');


V_TABLA :='DD_PCO_BFR_RESULTADO';

DBMS_OUTPUT.PUT_LINE(' ');

DBMS_OUTPUT.PUT_LINE('[INFO] Crear tabla: '||V_TABLA);

V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN	

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''100'',''EN REPARTO'',''EN REPARTO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,0)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''102'',''CAMBIO DE DOMICILIO'',''CAMBIO DE DOMICILIO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''103'',''DESCONOCIDO'',''DESCONOCIDO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''104'',''REHUSADO'',''REHUSADO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''105'',''DESHABITADO'',''DESHABITADO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;


V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''107'',''IMPOSIBLE ENTREGA'',''IMPOSIBLE ENTREGA'',0,''HR-2532'',SYSDATE,null,null,null,null,0,0)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;


V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''110'',''EXTRAVIADO'',''EXTRAVIADO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,0)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''111'',''AUSENTE DEJADO EN BUZON'',''AUSENTE DEJADO EN BUZON'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''112'',''NULO'',''NULO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,0)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''114'',''NUEVO DOMICILIO ENTREGA'',''NUEVO DOMICILIO ENTREGA'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''116'',''AUSENTE DEJADO AVISO'',''AUSENTE DEJADO AVISO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''118'',''IMP.CONFIRMAR ENTREGA'',''IMP.CONFIRMAR ENTREGA'',0,''HR-2532'',SYSDATE,null,null,null,null,0,0)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''127'',''ROBO'',''ROBO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,0)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''131'',''ENTREGADO.ACUSE PENDIENTE'',''ENTREGADO.ACUSE PENDIENTE'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''138'',''VENCIDO PLAZO ESPERA OFICINA  '',''VENCIDO PLAZO ESPERA OFICINA  '',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''139'',''NADIE SE HACE CARGO'',''NADIE SE HACE CARGO'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

V_MSQL :='INSERT into '||V_ESQUEMA||'.'||V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,''168'',''NO DEPOSITADO EN UNIPOST'',''NO DEPOSITADO EN UNIPOST'',0,''HR-2532'',SYSDATE,null,null,null,null,0,1)';
 DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	 EXECUTE IMMEDIATE V_MSQL;

ELSE
	DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla '||V_TABLA||' NO existe');
END IF;


DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;

          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));

          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;

          RAISE;
          
END;

/
EXIT