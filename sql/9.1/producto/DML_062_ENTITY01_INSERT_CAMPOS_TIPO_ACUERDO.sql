--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=PRODUCTO-174
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Inserts de la tabla ACU_CAMPOS_TIPO_ACUERDO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_DDNAME VARCHAR2(30):= 'ACU_CAMPOS_TIPO_ACUERDO';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de los campos por tipo de acuerdo');
DBMS_OUTPUT.PUT('[INFO] Nuevo valor en el diccionario entidad información '||V_DDNAME||'...');

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Dación en pago
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''cargasPosteriores'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'') ';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - cargasPosteriores" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01''),''cargasPosteriores'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solicitarAlquiler'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'') ';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - solicitarAlquiler" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01''),''solicitarAlquiler'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''liquidez'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - liquidez" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01''),''liquidez'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''tasacion'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'') ';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - tasacion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01''),''tasacion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''numExpediente'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - numExpediente" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01''),''numExpediente'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Dación para pago
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''cargasPosteriores'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - cargasPosteriores" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03''),''cargasPosteriores'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solicitarAlquiler'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - solicitarAlquiler" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03''),''solicitarAlquiler'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''liquidez'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - liquidez" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03''),''liquidez'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''tasacion'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - tasacion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03''),''tasacion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''numExpediente'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Dación en pago - numExpediente" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''03''),''numExpediente'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;



--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Compraventa
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''cargasPosteriores'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - cargasPosteriores" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10''),''cargasPosteriores'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solicitarAlquiler'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - solicitarAlquiler" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10''),''solicitarAlquiler'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''liquidez'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - liquidez" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10''),''liquidez'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''tasacion'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - tasacion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10''),''tasacion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''numExpediente'' AND DD_TPA_ID =(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - numExpediente" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''10''),''numExpediente'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Quita
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeQuita'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - importeQuita" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''importeQuita'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''porcentajeQuita'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - porcentajeQuita" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''porcentajeQuita'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeVencido'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - importeVencido" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''importeVencido'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeNoVencido'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - importeNoVencido" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''importeNoVencido'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''interesesMoratorios'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - interesesMoratorios" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''interesesMoratorios'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''interesesOrdinarios'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - interesesOrdinarios" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''interesesOrdinarios'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''comision'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - comision" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''comision'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''gastos'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - gastos" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''05''),''gastos'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Cesión de remate
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''nombreCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - nombreCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11''),''nombreCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;



V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''relacionCesionarioTitular'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - relacionCesionarioTitular" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11''),''relacionCesionarioTitular'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solvenciaCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - solvenciaCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11''),''solvenciaCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeCesion'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - importeCesion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11''),''importeCesion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - fechaPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11''),''fechaPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;




--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Cesión de crédito
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''nombreCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - nombreCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12''),''nombreCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;



V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''relacionCesionarioTitular'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - relacionCesionarioTitular" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12''),''relacionCesionarioTitular'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solvenciaCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - solvenciaCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12''),''solvenciaCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeCesion'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - importeCesion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12''),''importeCesion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - fechaPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''12''),''fechaPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Regularización
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPlanPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Regularización - fechaPlanPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13''),''fechaPlanPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''frecuenciaPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Regularización - frecuenciaPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13''),''frecuenciaPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''numeroPagosPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Regularización - numeroPagosPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13''),''numeroPagosPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importePlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Regularización - importePlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''13''),''importePlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;



--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Cancelación
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPlanPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cancelación - fechaPlanPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14''),''fechaPlanPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''frecuenciaPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cancelación - frecuenciaPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14''),''frecuenciaPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''numeroPagosPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cancelación - numeroPagosPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14''),''numeroPagosPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importePlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cancelación - importePlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''14''),''importePlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Entrega voluntaria de llaves
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''analisiSolvencia'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''15'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Entrega voluntaria de llaves - analisiSolvencia" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''15''),''analisiSolvencia'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Alquiler especial
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''descripcionAcuerdo'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''16'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Alquiler especial - descripcionAcuerdo" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''16''),''descripcionAcuerdo'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Plan de pagos
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPlanPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - fechaPlanPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17''),''fechaPlanPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''frecuenciaPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - frecuenciaPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17''),''frecuenciaPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''numeroPagosPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - numeroPagosPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17''),''numeroPagosPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importePlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - importePlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''17''),''importePlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

