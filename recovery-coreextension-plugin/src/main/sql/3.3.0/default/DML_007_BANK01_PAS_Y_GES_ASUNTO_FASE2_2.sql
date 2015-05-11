--/*
--##########################################
--## Author: DGG
--## Finalidad: DML que añade nuevos valores a DD_PAS_PROPIEDAD_ASUNTO y DD_GES_GESTION_ASUNTO
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


SELECT COUNT(1) INTO V_NUM_TABLAS FROM BANK01.DD_PAS_PROPIEDAD_ASUNTO  
         WHERE DD_PAS_CODIGO  = 'SAREB'; 
          
     if V_NUM_TABLAS = 0 then 

EXECUTE IMMEDIATE 'insert into BANK01.DD_PAS_PROPIEDAD_ASUNTO(DD_PAS_ID,DD_PAS_CODIGO,DD_PAS_DESCRIPCION,DD_PAS_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR) values
(
BANK01.S_DD_PAS_PROPIEDAD_ASUNTO.nextval,
''SAREB'',
''SAREB'',
''SAREB.'',
0,
''DD'',
sysdate
)';

DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO REGISTRO EN DD_PAS_PROPIEDAD_ASUNTO '); 

EXECUTE IMMEDIATE 'insert into BANK01.DD_PAS_PROPIEDAD_ASUNTO(DD_PAS_ID,DD_PAS_CODIGO,DD_PAS_DESCRIPCION,DD_PAS_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR) values
(
BANK01.S_DD_PAS_PROPIEDAD_ASUNTO.nextval,
''BANKIA'',
''BANKIA'',
''BANKIA.'',
0,
''DD'',
sysdate
)';

DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO REGISTRO EN DD_PAS_PROPIEDAD_ASUNTO '); 

EXECUTE IMMEDIATE 'insert into BANK01.DD_GES_GESTION_ASUNTO(DD_GES_ID,DD_GES_CODIGO,DD_GES_DESCRIPCION,DD_GES_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR) values
(
BANK01.S_DD_GES_GESTION_ASUNTO.nextval,
''BANKIA'',
''BANKIA'',
''BANKIA.'',
0,
''DD'',
sysdate
)';

DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO REGISTRO EN DD_GES_GESTION_ASUNTO '); 

EXECUTE IMMEDIATE 'insert into BANK01.DD_GES_GESTION_ASUNTO(DD_GES_ID,DD_GES_CODIGO,DD_GES_DESCRIPCION,DD_GES_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR) values
(
BANK01.S_DD_GES_GESTION_ASUNTO.nextval,
''HAYA'',
''HAYA'',
''HAYA.'',
0,
''DD'',
sysdate
)';

DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO REGISTRO EN DD_GES_GESTION_ASUNTO '); 

   end if; 

COMMIT;


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



   