
	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	insert into DD_RCC_RES_COMITE_CONCURS (DD_RCC_ID,DD_RCC_CODIGO,DD_RCC_DESCRIPCION,DD_RCC_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values (S_DD_RCC_RES_COMITE_CONCURS.nextval,'CONCEDIDO','CONCEDIDO','CONCEDIDO',0,'DGG',sysdate,0);
insert into DD_RCC_RES_COMITE_CONCURS (DD_RCC_ID,DD_RCC_CODIGO,DD_RCC_DESCRIPCION,DD_RCC_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values (S_DD_RCC_RES_COMITE_CONCURS.nextval,'CONCONMOD','CONCEDIDO CON MODIFICACIONES','CONCEDIDO CON MODIFICACIONES',0,'DGG',sysdate,0);
insert into DD_RCC_RES_COMITE_CONCURS (DD_RCC_ID,DD_RCC_CODIGO,DD_RCC_DESCRIPCION,DD_RCC_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values (S_DD_RCC_RES_COMITE_CONCURS.nextval,'MODIFICAR','MODIFICAR','MODIFICAR',0,'DGG',sysdate,0);
insert into DD_RCC_RES_COMITE_CONCURS (DD_RCC_ID,DD_RCC_CODIGO,DD_RCC_DESCRIPCION,DD_RCC_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values (S_DD_RCC_RES_COMITE_CONCURS.nextval,'DENEGADA','DENEGADA','DENEGADA',0,'DGG',sysdate,0);

  
  
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