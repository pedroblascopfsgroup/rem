
	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
	
	Insert into BANKMASTER.DD_TDE_TIPO_DESPACHO 
(DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values 
(S_DD_TDE_TIPO_DESPACHO.nextval,'GLL','Gestoría para llaves','Gestoría para llaves','0','DD',sysdate,null,null,null,null,'0');


Insert into BANKMASTER.DD_TDE_TIPO_DESPACHO 
(DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values 
(S_DD_TDE_TIPO_DESPACHO.nextval,'GDLL','Gestoría depositaria de llaves','Gestoría depositaria de llaves','0','DD',sysdate,null,null,null,null,'0');









Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'GGLL','Gestor gestoría llaves','Gestor gestoría llaves','0','DD',sysdate,null,null,null,null,'0','1');

Insert into BANKMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) values (BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval,'GGDLL','Gestor gestoría depositaria llaves','Gestor gestoría depositaria llaves','0','DD',sysdate,null,null,null,null,'0','1');


insert into BANKMASTER.dd_sta_subtipo_tarea_base (
dd_sta_id,
dd_tar_id,
dd_sta_codigo,
dd_sta_descripcion,
dd_sta_descripcion_larga,
version,
usuariocrear,
fechacrear,
borrado,
dd_tge_id,
dtype
) values (
104,
1,
'104',
'Tarea externa',
'Tarea externa (Gestor gestoria llaves)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGLL'),
'EXTSubtipoTarea'
);

insert into BANKMASTER.dd_sta_subtipo_tarea_base (
dd_sta_id,
dd_tar_id,
dd_sta_codigo,
dd_sta_descripcion,
dd_sta_descripcion_larga,
version,
usuariocrear,
fechacrear,
borrado,
dd_tge_id,
dtype
) values (
105,
1,
'105',
'Tarea externa',
'Tarea externa (Gestor gestoria depositaria llaves)',
0,
'DD',
sysdate,
0,
(select dd_tge_id from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGDLL'),
'EXTSubtipoTarea'
);
  
  
  COMMIT;
  
  
EXCEPTION

     WHEN OTHERS THEN

          ERR_NUM := SQLCODE;

          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));

          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 

          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;

          RAISE;   

END;

/