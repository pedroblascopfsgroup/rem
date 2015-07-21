--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.2-hy
--## INCIDENCIA_LINK=HR-977
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar mensajes de validacion
--## INSTRUCCIONES: Relanzable
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

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');

EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Amistosa'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Amistosa'' WHERE DD_TFA_CODIGO = ''OCA'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Trámites'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Trámites'' WHERE DD_TFA_CODIGO = ''OTR'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Otros Trámites'', DD_TFA_DESCRIPCION_LARGA = ''Otros Otros Trámites'' WHERE DD_TFA_CODIGO = ''O03'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Contratos bloqueados'', DD_TFA_DESCRIPCION_LARGA = ''Otros Contratos bloqueados'' WHERE DD_TFA_CODIGO = ''O04'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Concursal'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Concursal'' WHERE DD_TFA_CODIGO = ''OCO'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Penal'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Penal'' WHERE DD_TFA_CODIGO = ''OPE'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Adjudicados'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Adjudicados'' WHERE DD_TFA_CODIGO = ''OAD'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Ejecutivo y cambiario'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Ejecutivo'' WHERE DD_TFA_CODIGO = ''OEJ'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Declarativo y monitorio'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Declarativo'' WHERE DD_TFA_CODIGO = ''ODE'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Apremio'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Apremio'' WHERE DD_TFA_CODIGO = ''OAP'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Borrado logico'', DD_TFA_DESCRIPCION_LARGA = ''Otros Borrado logico'' WHERE DD_TFA_CODIGO = ''ODEL'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Recobro'', DD_TFA_DESCRIPCION_LARGA = ''Otros Tipo de Actuación Recobro'' WHERE DD_TFA_CODIGO = ''OREC'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Gestión Interna'', DD_TFA_DESCRIPCION_LARGA = ''Otros Gestión Interna'' WHERE DD_TFA_CODIGO = ''OGI'' ';
EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''Otros Extrajudicial'', DD_TFA_DESCRIPCION_LARGA = ''Otros Extrajudicial'' WHERE DD_TFA_CODIGO = ''OEX'' ';

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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
