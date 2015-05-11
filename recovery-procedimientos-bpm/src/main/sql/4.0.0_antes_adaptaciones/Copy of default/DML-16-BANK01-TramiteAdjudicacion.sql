

	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
	--Creo la relación entre BANKMASTER.DD_TDE_TIPO_DESPACHO y BANKMASTER.DD_TGE_TIPO_GESTOR en la tabla BANK01.TGP_TIPO_GESTOR_PROPIEDAD
Insert into BANK01.TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (
BANK01.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval,
(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGADJ'),
'DES_VALIDOS',
(select dd_tde_codigo from BANKMASTER.DD_TDE_TIPO_DESPACHO where dd_tde_codigo='GPA'),
'0',
'SAG',
sysdate,
null,
null,
null,
null,
'0');


Insert into BANK01.TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (
BANK01.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval,
(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GGSAN'),
'DES_VALIDOS',
(select dd_tde_codigo from BANKMASTER.DD_TDE_TIPO_DESPACHO where dd_tde_codigo='GPS'),
'0',
'SAG',
sysdate,
null,
null,
null,
null,
'0');


Insert into BANK01.TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (
BANK01.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval,
(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='SGADJ'),
'DES_VALIDOS',
(select dd_tde_codigo from BANKMASTER.DD_TDE_TIPO_DESPACHO where dd_tde_codigo='GPA'),
'0',
'SAG',
sysdate,
null,
null,
null,
null,
'0');


Insert into BANK01.TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (
BANK01.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval,
(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='SGSAN'),
'DES_VALIDOS',
(select dd_tde_codigo from BANKMASTER.DD_TDE_TIPO_DESPACHO where dd_tde_codigo='GPS'),
'0',
'SAG',
sysdate,
null,
null,
null,
null,
'0');

  
  
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