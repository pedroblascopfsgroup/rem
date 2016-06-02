--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1496
--## PRODUCTO=NO
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

---------------------------------------
----------------DESPACHOS
---------------------------------------
DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevos despachos de procuradores PFS, ABA Y MC');
V_NUM_TABLAS := 0;
V_SQL := 'SELECT DD_TDE_ID FROM ' || V_ESQUEMA_M || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''2''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TDE_ID_OFI;
DBMS_OUTPUT.PUT_LINE('[INFO] hay id de DD_TDE_TIPO_DESPACHO: ' || V_DD_TDE_ID_OFI );

DBMS_OUTPUT.PUT_LINE('[INFO] Se consulta tipo despacho Gestor de procuradores');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = ' || V_DD_TDE_ID_OFI;
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN
  V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO= ''Medina Cuadros Procuradores''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS = 0 THEN
  	V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, DD_TDE_ID) VALUES (' ||V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL, ''Medina Cuadros Procuradores'', 0, ''PRODUCTO-1496'', sysdate, ' || V_DD_TDE_ID_OFI || ')'; 
  	EXECUTE IMMEDIATE V_MSQL;
  END IF;

  V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO= ''ABA Procuradores''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS = 0 THEN
    V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, DD_TDE_ID) VALUES (' ||V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL, ''ABA Procuradores'', 0, ''PRODUCTO-1496'', sysdate, ' || V_DD_TDE_ID_OFI || ')'; 
    EXECUTE IMMEDIATE V_MSQL;
  END IF;

  V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO= ''Leticia Codias''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS = 0 THEN
    V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, VERSION, USUARIOCREAR, FECHACREAR, DD_TDE_ID) VALUES (' ||V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL, ''Leticia Codias'', 0, ''PRODUCTO-1496'', sysdate, ' || V_DD_TDE_ID_OFI || ')'; 
    EXECUTE IMMEDIATE V_MSQL;
  END IF;
END IF;

-----------------------------------------------------
--------------USUARIOS DE GRUPO
-----------------------------------------------------
DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevos usuarios de grupos Elena Medina, Francisco Abajo Y Leticia Codias');
V_NUM_TABLAS := 0;
V_DDNAME := 'USU_USUARIOS';
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE USU_USERNAME = ''GRELME''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en usu_usuarios Grupo Elena Medina');
V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M || '.USU_USUARIOS (usu_id, entidad_id, usu_username, usu_password, usu_nombre, usuariocrear,fechacrear, usu_grupo, usu_externo)  values  ('|| V_ESQUEMA_M ||'.s_usu_usuarios.nextval, ''41'',''GRELME'',''1234'',''Grupo - Elena Medina'', ''PRODUCTO-1496'', sysdate, 1, 1)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
ELSE
DBMS_OUTPUT.PUT_LINE('[INFO] UPDATEANDO en usu_usuarios Grupo Elena Medina');
V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET entidad_id = ''41'', usu_username = ''GRELME'', usu_password = ''1234'', usu_nombre = ''Grupo - Elena Medina'', usu_grupo = 1, usu_externo = 1 WHERE USU_USERNAME = ''GRELME''';
EXECUTE IMMEDIATE V_MSQL;
END IF;
DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevo usuario Francisco Abajo');
V_NUM_TABLAS := 0;
V_DDNAME := 'USU_USUARIOS';
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE USU_USERNAME = ''GRFRAB''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en usu_usuarios Francisco Abajo');
V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M || '.USU_USUARIOS (usu_id, entidad_id, usu_username, usu_password, usu_nombre, usuariocrear,fechacrear, usu_grupo, usu_externo)  values  ('|| V_ESQUEMA_M ||'.s_usu_usuarios.nextval, ''41'',''GRFRAB'',''1234'',''Grupo - Francisco Abajo'', ''PRODUCTO-1496'', sysdate, 1, 1)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
ELSE
DBMS_OUTPUT.PUT_LINE('[INFO] UPDATEANDO en usu_usuarios Francisco Abajo');
V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET entidad_id = ''41'', usu_username = ''GRFRAB'', usu_password = ''1234'', usu_nombre = ''Grupo - Francisco Abajo'', usu_grupo = 1, usu_externo = 1 WHERE USU_USERNAME = ''GRFRAB''';
EXECUTE IMMEDIATE V_MSQL;
END IF;
DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevo usuario Leticia Codias');
V_NUM_TABLAS := 0;
V_DDNAME := 'USU_USUARIOS';
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE USU_USERNAME = ''GRLECO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en usu_usuarios Leticia Codias');
V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M || '.USU_USUARIOS (usu_id, entidad_id, usu_username, usu_password, usu_nombre, usuariocrear,fechacrear, usu_grupo, usu_externo)  values  ('|| V_ESQUEMA_M ||'.s_usu_usuarios.nextval, ''41'',''GRLECO'',''1234'',''Grupo - Leticia Codias'', ''PRODUCTO-1496'', sysdate, 1, 1)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
ELSE
DBMS_OUTPUT.PUT_LINE('[INFO] UPDATEANDO en usu_usuarios Leticia Codias');
V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET entidad_id = ''41'', usu_username = ''GRLECO'', usu_password = ''1234'', usu_nombre = ''Grupo - Leticia Codias'', usu_grupo = 1, usu_externo = 1 WHERE USU_USERNAME = ''GRLECO''';
EXECUTE IMMEDIATE V_MSQL;
END IF;

----------------------------------------------------------------
-------------ASIGNAMOS EL PERFIL AL USUARIO
----------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada ZON_PEF_USU');
V_DDNAME := 'ZON_PEF_USU';
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GRELME''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
V_SQL := 'SELECT PEF_ID FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND PEF_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en ZON_PEF_USU');
V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ((SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' and ZON_DESCRIPCION <> ''BANKIA'' AND rownum = 1) ,' ||V_TMP_2 || ',' || V_TMP || ',' ||V_ESQUEMA|| '.S_ZON_PEF_USU.NEXTVAL, 0,''PRODUCTO-1496'', SYSDATE, 0)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF; 

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada ZON_PEF_USU');
V_DDNAME := 'ZON_PEF_USU';
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GRFRAB''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
V_SQL := 'SELECT PEF_ID FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND PEF_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en ZON_PEF_USU');
V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ((SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' and ZON_DESCRIPCION <> ''BANKIA'' AND rownum = 1) ,' ||V_TMP_2 || ',' || V_TMP || ',' ||V_ESQUEMA|| '.S_ZON_PEF_USU.NEXTVAL, 0,''PRODUCTO-1496'', SYSDATE, 0)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF; 

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada ZON_PEF_USU');
V_DDNAME := 'ZON_PEF_USU';
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GRLECO''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
V_SQL := 'SELECT PEF_ID FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRPROC''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND PEF_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en ZON_PEF_USU');
V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ((SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' and ZON_DESCRIPCION <> ''BANKIA'' AND rownum = 1) ,' ||V_TMP_2 || ',' || V_TMP || ',' ||V_ESQUEMA|| '.S_ZON_PEF_USU.NEXTVAL, 0,''PRODUCTO-1496'', SYSDATE, 0)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF;
----------------------------------------------------------------
---------RELACIONAMOS USUARIOS CON DESPACHOS CON USUARIOS-------
----------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada USD_USUARIOS_DESPACHOS');
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_DDNAME := 'USD_USUARIOS_DESPACHOS';
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GRELME''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
DBMS_OUTPUT.PUT_LINE('EL ID DEL USUARIO ES ' || V_TMP);
V_SQL := 'SELECT DES_ID FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''Medina Cuadros Procuradores''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
DBMS_OUTPUT.PUT_LINE('EL ID DEL DESPACHO ES ' || V_TMP_2);
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND DES_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
DBMS_OUTPUT.PUT_LINE('EL TOTAL PARA USUARIO-DESPACHO ES ' || V_NUM_TABLAS);

IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en USD_USUARIOS_DESPACHOS');
V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || '(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES('|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'|| V_TMP ||','|| V_TMP_2 ||',1,0,''PRODUCTO-1496'',sysdate)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF;	

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada USD_USUARIOS_DESPACHOS');
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_DDNAME := 'USD_USUARIOS_DESPACHOS';
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GRFRAB''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
V_SQL := 'SELECT DES_ID FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''ABA Procuradores''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND DES_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en USD_USUARIOS_DESPACHOS');
V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || '(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES('|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'|| V_TMP ||','|| V_TMP_2 ||',1,0,''PRODUCTO-1496'',sysdate)';
DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO esta query: ' || V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
END IF; 

DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nueva entrada USD_USUARIOS_DESPACHOS');
V_NUM_TABLAS := 0;
V_TMP := 0;
V_TMP_2 := 0;
V_DDNAME := 'USD_USUARIOS_DESPACHOS';
V_SQL := 'SELECT USU_ID FROM ' || V_ESQUEMA_M || '.USU_USUARIOS WHERE USU_USERNAME = ''GRLECO''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP;
V_SQL := 'SELECT DES_ID FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''Leticia Codias''';
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE USU_ID = '|| V_TMP ||' AND DES_ID = '|| V_TMP_2 ||'';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en USD_USUARIOS_DESPACHOS');
V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || '(USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES('|| V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,'|| V_TMP ||','|| V_TMP_2 ||',1,0,''PRODUCTO-1496'',sysdate)';
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

