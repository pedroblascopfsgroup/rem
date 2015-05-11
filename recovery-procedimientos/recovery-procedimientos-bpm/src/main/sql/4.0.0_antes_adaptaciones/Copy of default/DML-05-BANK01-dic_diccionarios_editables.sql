

	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
	--Diccionario Editable de Gestorías
Insert into dic_diccionarios_editables (
DIC_ID,
DIC_NBTABLA,
DIC_CODIGO,
DIC_DESCRIPCION,
DIC_DESCRIPCION_LARGA,
DIC_EDICION,
DIC_ADD,
VERSION,
USUARIOCREAR,
FECHACREAR,
USUARIOMODIFICAR,
FECHAMODIFICAR,
USUARIOBORRAR,
FECHABORRAR,
BORRADO) 
values (
s_dic_diccionarios_editables.nextval,
'DD_GES_GESTORIA',
(select max(to_number(dic_codigo))+1 from dic_diccionarios_editables),
'Diccionario de Gestorías.',
null,
'1',
'1',
'1',
'DD',
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