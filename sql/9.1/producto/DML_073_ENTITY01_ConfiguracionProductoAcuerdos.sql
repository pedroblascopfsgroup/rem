--/*
--##########################################
--## AUTOR=PEDROBLASCOS
--## FECHA_CREACION=20150916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-174
--## PRODUCTO=SI
--##
--## Finalidad: INSERCIÓN DE CONFIGURACIÓN DE ACUERDOS POR DEFECTO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_ENTIDAD#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
    V_INSERT VARCHAR2(4000 CHAR);
    V_VALUES VARCHAR2(4000 CHAR);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('INSERCIÓN DE CONFIGURACIÓN DE ACUERDOS POR DEFECTO');
	DBMS_OUTPUT.PUT_LINE('***** Inserción -- Nuevos tipos de gestor ******');

	V_INSERT := 'Insert into ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,' || 
		'VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values ';
	V_VALUES := q'[('550','PROPACU','Proponente acuerdo extrajudicial','Proponente acuerdo extrajudicial','0','DD',sysdate,null,null,null,null,'0','0')]';
	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[('560','VALIACU','Validador acuerdo extrajudicial','Validador acuerdo extrajudicial','0','DD',sysdate,null,null,null,null,'0','0')]';  
	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[('570','DECIACU','Decisor acuerdo extrajudicial','Decisor acuerdo extrajudicial','0','DD',sysdate,null,null,null,null,'0','0')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;

	DBMS_OUTPUT.PUT_LINE('***** Inserción -- Nuevos tipos de depacho ******');
 
 	V_INSERT := 'Insert into ' || V_ESQUEMA_M || '.dd_tde_tipo_despacho tde (tde.DD_TDE_ID, tde.DD_TDE_CODIGO, tde.DD_TDE_DESCRIPCION, ' ||
 		' tde.DD_TDE_DESCRIPCION_LARGA, tde.FECHACREAR, tde.usuariocrear) values (' || V_ESQUEMA_M;

	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'OFICINA', 'Oficina', 'Oficina', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'GESRIESGO', 'Gestor de riesgo', 'Gestor de riesgo', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'DEPRECUDE', 'Departamento de recuperación de Deuda', 'Departamento de recuperación de Deuda', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'DIRTER', 'Dirección territorial', 'Dirección territorial', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'HRE', 'Haya Real State?', 'Haya Real State?', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'HRELET', 'Haya Real State Letrado?', 'Haya Real State? Letrado', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'HRESUP', 'Haya Real State Supervisor?', 'Haya Real State Supervisor?', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'ASECON', 'Asesoría concursal?', 'Asesoría concursal??', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_dd_tde_tipo_despacho.nextval, 'DIRRIESGO', 'Director de Riesgos', 'Director de Riesgos??', sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;

	DBMS_OUTPUT.PUT_LINE('***** Inserción -- que roles pueden asumir en el asunto los distintos dtipos de despacho ******');

 	V_INSERT := 'Insert into ' || V_ESQUEMA || '.TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear) ' ||
 		'values (' || V_ESQUEMA ;

	V_VALUES := q'[.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from ]' || V_ESQUEMA_M || 
		q'[.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'PROPACU'),'DES_VALIDOS', 'OFICINA,GESRIESGO,DEPRECUDE,DIRTER,HRE,HRELET,HRESUP,ASECON,DIRRIESGO','SAG',sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from ]' || V_ESQUEMA_M || 
		q'[.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'VALIACU'), 'DES_VALIDOS', 'DIRTER,DEPRECUDE,HRESUP', 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from ]' || V_ESQUEMA_M || 
		q'[.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'DECIACU'), 'DES_VALIDOS', 'DEPRECUDE', 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;

	DBMS_OUTPUT.PUT_LINE('***** Inserción -- insertar un despacho por cada tipo de despacho ******');

 	V_INSERT := 'insert into ' || V_ESQUEMA || '.des_despacho_externo des (des_id, des_despacho, fechacrear, usuariocrear, dd_tde_id, zon_id) values (' || V_ESQUEMA;

	V_VALUES := q'[.s_des_despacho_externo.nextval, 'Departamento de Recuperación de Deuda', sysdate, 'SAG', (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'DEPRECUDE'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'Letrado HRE', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'HRELET'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'Supervisor HRE', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'HRESUP'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'Asesoría Concursal', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'ASECON'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'HRE', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'HRE'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'Director de Riesgos', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'DIRRIESGO'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'Gestor de Riesgos', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'GESRIESGO'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'OFICINA', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'OFICINA'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_des_despacho_externo.nextval, 'Dirección territorial', sysdate, 'SAG',    (select dd_tde_id from ]' || V_ESQUEMA_M || 
		q'[.dd_tde_tipo_despacho where dd_tde_codigo = 'DIRTER'),     (select max(zon_id) from ]' || V_ESQUEMA || q'[.zon_zonificacion where zon_cod = '01'))]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;

	DBMS_OUTPUT.PUT_LINE('***** Inserción -- insertar usuario por defecto en cada despacho ******');

 	V_INSERT := 'insert into ' || V_ESQUEMA_M || 
 		'.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (' || V_ESQUEMA_M;

	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'DEPRECUDE', '1234', 'Grupo - Dpto. Recuperación Deuda', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'HRELET', '1234', 'Grupo - Letrado HRE', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'HRESUP', '1234', 'Grupo - Supervisor HRE', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'ASECON', '1234', 'Grupo - Asesoría Concursal', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'HRE', '1234', 'Grupo - HRE', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'DIRRIESGO', '1234', 'Grupo - Director de Riesgos', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'GESRIESGO', '1234', 'Grupo - Gestor de Riesgos', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'OFICINA', '1234', 'Grupo - OFICINA', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usu_usuarios.nextval, 1, 'DIRTER', '1234', 'Grupo - Dirección territorial', sysdate, 'SAG', 1, 1)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); EXECUTE IMMEDIATE V_INSERT || V_VALUES;

	DBMS_OUTPUT.PUT_LINE('***** Inserción -- insertar zonificacion usuarios ******');

 	V_INSERT := 'insert into ' || V_ESQUEMA || 
 		'.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear) values (' || V_ESQUEMA;


	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'DEPRECUDE'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'HRELET'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'HRESUP'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'ASECON'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'HRE'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'DIRRIESGO'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'GESRIESGO'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'OFICINA'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_zon_pef_usu.nextval, (select max(zon_id) from ]' || V_ESQUEMA || 
		q'[.zon_zonificacion where zon_cod = '01'),  (select pef_id from ]' || V_ESQUEMA || 
		q'[.pef_perfiles where pef_codigo = 'FPFSRLETEXT'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'DIRTER'), 'SAG', sysdate)]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;

	DBMS_OUTPUT.PUT_LINE('***** Inserción -- insertar usuarios despachos ******');

	V_INSERT := 'insert into ' || V_ESQUEMA || '.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (' || V_ESQUEMA;

	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'Departamento de Recuperación de Deuda'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'DEPRECUDE' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'Letrado HRE'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'HRELET' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'Supervisor HRE'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'HRESUP' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'Asesoría Concursal'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'ASECON' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'HRE'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'HRE' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'Director de Riesgos'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'DIRRIESGO' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'Gestor de Riesgos'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'GESRIESGO' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'OFICINA'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'OFICINA' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;
	V_VALUES := q'[.s_usd_usuarios_despachos.nextval,  (select des_id from ]' || V_ESQUEMA || 
		q'[.des_despacho_externo where borrado = 0 and des_despacho = 'Dirección territorial'), (select usu_id from ]' || V_ESQUEMA_M || 
		q'[.usu_usuarios where usu_username = 'DIRTER' and borrado = 0), 1, 0, sysdate, 'SAG')]';
 	DBMS_OUTPUT.PUT_LINE(V_INSERT || V_VALUES); -- EXECUTE IMMEDIATE V_INSERT || V_VALUES;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('***** FIN DE LA INSERCIÓN DE CONFIGURACIÓN DE ACUERDOS POR DEFECTO ***');
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;