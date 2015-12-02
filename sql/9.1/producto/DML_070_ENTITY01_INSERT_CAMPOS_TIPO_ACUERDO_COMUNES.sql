--/*
--##########################################
--## AUTOR=AGUSTIN MOMPO
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
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Compraventa
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''cargasPosteriores'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - cargasPosteriores" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV''),''cargasPosteriores'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solicitarAlquiler'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - solicitarAlquiler" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV''),''solicitarAlquiler'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''liquidez'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - liquidez" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV''),''liquidez'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''tasacion'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Compraventa - tasacion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DA_CV''),''tasacion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Quita
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeQuita'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - importeQuita" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''importeQuita'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''porcentajeQuita'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - porcentajeQuita" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''porcentajeQuita'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeVencido'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - importeVencido" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''importeVencido'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeNoVencido'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - importeNoVencido" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''importeNoVencido'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''interesesMoratorios'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - interesesMoratorios" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''interesesMoratorios'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''interesesOrdinarios'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - interesesOrdinarios" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''interesesOrdinarios'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''comision'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - comision" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''comision'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''gastos'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Quita - gastos" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''),''gastos'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Cesión de remate
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''nombreCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - nombreCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM''),''nombreCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;



V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''relacionCesionarioTitular'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - relacionCesionarioTitular" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM''),''relacionCesionarioTitular'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solvenciaCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - solvenciaCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM''),''solvenciaCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeCesion'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - importeCesion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM''),''importeCesion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - fechaPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM''),''fechaPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''modoPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - modoPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_REM''),''modoPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Cesión de crédito
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''nombreCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - nombreCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED''),''nombreCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;



V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''relacionCesionarioTitular'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - relacionCesionarioTitular" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED''),''relacionCesionarioTitular'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''solvenciaCesionario'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - solvenciaCesionario" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED''),''solvenciaCesionario'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importeCesion'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - importeCesion" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED''),''importeCesion'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de crédito - fechaPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED''),''fechaPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''modoPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Cesión de remate - modoPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED''),''modoPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;



--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION Para el tipo de acuerdo Plan de pagos
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''fechaPlanPago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - fechaPlanPago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO''),''fechaPlanPago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''frecuenciaPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - frecuenciaPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO''),''frecuenciaPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''numeroPagosPlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - numeroPagosPlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO''),''numeroPagosPlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE CMP_NOMBRE_CAMPO= ''importePlanpago'' AND DD_TPA_ID =(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO'')';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Plan de pagos - importePlanpago" '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.nextval,(SELECT DD_TPA_ID from '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PLAN_PAGO''),''importePlanpago'',''0'',''PRODUCTO'',sysdate,''0'') ';

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

