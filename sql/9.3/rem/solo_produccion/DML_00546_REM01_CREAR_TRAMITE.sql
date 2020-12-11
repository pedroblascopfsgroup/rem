--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201124
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8373
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar trámite de venta e insertar los registros en formalización para que la oferta pueda ser editada. Oferta 90281908.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
   V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
   V_MSQL VARCHAR(20000 CHAR);
   V_NUM_TABLAS NUMBER(16);
   PL_OUTPUT VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
   V_TABLA_OFERTAS VARCHAR2(50 CHAR) := 'OFR_OFERTAS';
   V_OFERTA_NUM VARCHAR2(50 CHAR) := 90281908;
 
BEGIN

   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.put_line('[INFO] ACTUALIZAR LA OFERTA '''|| V_OFERTA_NUM ||'''');

   -- Comprobamos que el gasto existe
   V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'|| V_TABLA_OFERTAS ||' WHERE OFR_NUM_OFERTA = '|| V_OFERTA_NUM;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

   IF V_NUM_TABLAS = 1 THEN

      REM01.REPOSICIONAMIENTO_TRAMITE('REMVIP-8373','228500','T013_DefinicionOferta',null,null,PL_OUTPUT);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

      DBMS_OUTPUT.PUT_LINE('[INFO] OFERTA ACTUALIZADA CON ÉXITO');
   
   ELSE 

      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA '''|| V_OFERTA_NUM ||'''');

   END IF;
               
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

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
EXIT;
