--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-708
--## PRODUCTO=SI
--## Finalidad: DML
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TMP NUMBER(16); -- Vble. para validar la existencia de una tabla.      
    V_TMP_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_DDNAME VARCHAR2(30);
    V_ID_MAX NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_DD_TDE_ID_OFI NUMBER(16); -- Vble. para almacenar el DD_TDE_ID del tipo despacho oficina.

BEGIN

V_DDNAME := 'DD_TGE_TIPO_GESTOR';
DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar tipo gestor Gestor procuradores: ' || V_DDNAME || '...');


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE DD_TGE_CODIGO = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar tipo gestor Gestor procuradores');
    EXECUTE IMMEDIATE 'INSERT INTO ' || V_ESQUEMA_M || '.' || V_DDNAME || ' (DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) 
    VALUES  ( ' || V_ESQUEMA_M || '.S_' || V_DDNAME || '.NEXTVAL,  ''GESPROC'', ''Gestor procuradores'', ''Gestor procuradores'', 0, ''PCO'', sysdate) ';
END IF;

V_DDNAME := 'DD_TDE_TIPO_DESPACHO';
DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar tipo despacho Gestor procuradores: ' || V_DDNAME || '...');
V_NUM_TABLAS := 0;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE DD_TDE_CODIGO = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar tipo despacho Gestor procuradores');
    EXECUTE IMMEDIATE 'INSERT INTO ' || V_ESQUEMA_M || '.' || V_DDNAME || ' (DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR,FECHACREAR) 
    VALUES  ( ' || V_ESQUEMA_M || '.S_' || V_DDNAME || '.NEXTVAL,  ''GESPROC'', ''Gestor procuradores'', ''Gestor procuradores'', 0, ''PCO'', sysdate) ';
END IF;




DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevo despacho Gestor procuradores');
V_NUM_TABLAS := 0;
V_SQL := 'SELECT DD_TDE_ID FROM ' || V_ESQUEMA_M || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TDE_ID_OFI;
DBMS_OUTPUT.PUT_LINE('[INFO] hay id de DD_TDE_TIPO_DESPACHO: ' || V_DD_TDE_ID_OFI );

DBMS_OUTPUT.PUT_LINE('[INFO] Se consulta si existe un DES_DESPACHO_EXTERNO con tipo Gestor de procuradores');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = ' || V_DD_TDE_ID_OFI;
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO DES_DESPACHO_EXTERNO con tipo gestor de procuradores');

	V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, DD_TDE_ID) VALUES (' ||V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL, ''Gestor procuradores'', 0, ''PCO'', sysdate, ' || V_DD_TDE_ID_OFI || ')'; 
	EXECUTE IMMEDIATE V_MSQL;
END IF;


DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevo usuario Grupo gestores de procuradores');
V_NUM_TABLAS := 0;
V_DDNAME := 'USU_USUARIOS';
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE USU_USERNAME = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en usu_usuarios grupo - gestor de procuradores');
V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M || '.USU_USUARIOS (usu_id, entidad_id, usu_username, usu_password, usu_nombre, usuariocrear,fechacrear, usu_grupo)  values  ('|| V_ESQUEMA_M ||'.s_usu_usuarios.nextval, ''41'',''GESPROC'',''1234'',''Grupo - Gestores de procuradores'', ''PCO'', sysdate, 1)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF;


DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada DD_STA_SUBTIPO_TAREA_BASE');
V_NUM_TABLAS := 0;
V_DDNAME := 'DD_STA_SUBTIPO_TAREA_BASE';
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE DD_STA_CODIGO = ''TGP''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
V_SQL := 'SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
DBMS_OUTPUT.PUT_LINE('[INFO] EL ID DE TGE A INSERTAR EN DD_STA_ID ES: ' || V_TMP);
IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en DD_STA_SUBTIPO_TAREA_BASE');
V_MSQL := 'INSERT INTO ' || V_ESQUEMA_M ||'.DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_TGE_ID,USUARIOCREAR,FECHACREAR) 
VALUES ('||V_ESQUEMA_M ||'.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL,1,''TGP'',''Tarea gestor procurador'',''Tarea gestor procurador'','|| V_TMP ||',''PCO'',sysdate)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF;


DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada TGP_TIPO_GESTOR_PROPIEDAD');
V_NUM_TABLAS := 0;
V_TMP := 0;
V_DDNAME := 'TGP_TIPO_GESTOR_PROPIEDAD';
V_SQL := 'SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
DBMS_OUTPUT.PUT_LINE('[INFO] EL ID DE TGE A INSERTAR EN TGP_TIPO_GESTOR_PROPIEDAD ES: ' || V_TMP);
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_TGE_ID = '|| V_TMP ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en TGP_TIPO_GESTOR_PROPIEDAD');
V_MSQL := 'INSERT INTO ' || V_ESQUEMA ||'.TGP_TIPO_GESTOR_PROPIEDAD  (TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values (' || V_ESQUEMA || '.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval, '|| V_TMP ||', ''DES_VALIDOS'', ''GESPROC'', ''PCO'', sysdate)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF;

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada USD_USUARIOS_DESPACHOS');
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_DDNAME := 'USD_USUARIOS_DESPACHOS';
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
V_SQL := 'SELECT DES_ID FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = (SELECT DD_TDE_ID FROM ' || V_ESQUEMA_M || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''GESPROC'')';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND DES_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en USD_USUARIOS_DESPACHOS');
V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || '(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES('|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'|| V_TMP ||','|| V_TMP_2 ||',1,0,''PCO'',sysdate)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF;	

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada ZON_PEF_USU');
V_DDNAME := 'ZON_PEF_USU';
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GESPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
V_SQL := 'SELECT PEF_ID FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGEST''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND PEF_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en ZON_PEF_USU');
V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ((SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND rownum = 1) ,' ||V_TMP_2 || ',' || V_TMP || ',' ||V_ESQUEMA|| '.S_ZON_PEF_USU.NEXTVAL, 0,''PCO'', SYSDATE, 0)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
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

