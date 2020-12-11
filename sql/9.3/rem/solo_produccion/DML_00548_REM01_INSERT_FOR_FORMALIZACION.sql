--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201124
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8373
--## PRODUCTO=NO
--## 
--## Finalidad: Crear relación en la tabla FOR_FORMALIZACION para que la oferta 90281908 pueda editarse.
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
   V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8373';
   V_ID_EXPEDIENTE NUMBER(16);
   V_TABLA_EXPEDIENTE VARCHAR2(50 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
   V_TABLA_FORMALIZACION VARCHAR2(50 CHAR) := 'FOR_FORMALIZACION';
   V_EXPEDIENTE_NUM VARCHAR2(50 CHAR) := 228500;
 
BEGIN

   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.put_line('[INFO] INSERTAR RELACIÓN DE FORMALIZACIÓN DEL EXPEDIENTE '''|| V_EXPEDIENTE_NUM ||'''');

   -- Comprobamos que el expediente existe
   V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'|| V_TABLA_EXPEDIENTE ||' WHERE ECO_NUM_EXPEDIENTE = '|| V_EXPEDIENTE_NUM;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

   IF V_NUM_TABLAS = 1 THEN

      -- Obtenemos el ID del expediente
      V_MSQL := 'SELECT ECO_ID FROM '|| V_ESQUEMA ||'.'|| V_TABLA_EXPEDIENTE ||' WHERE ECO_NUM_EXPEDIENTE = '|| V_EXPEDIENTE_NUM;
	   EXECUTE IMMEDIATE V_MSQL INTO V_ID_EXPEDIENTE;	

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| V_TABLA_FORMALIZACION ||' (FOR_ID, ECO_ID, USUARIOCREAR, FECHACREAR) 
                        VALUES (
                        '|| V_ESQUEMA ||'.S_'|| V_TABLA_FORMALIZACION ||'.NEXTVAL,
                        '|| V_ID_EXPEDIENTE ||',
                        '''||V_USUARIO||''',
                        SYSDATE)';
            EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] RELACIÓN INSERTADA CON ÉXITO');
   
   ELSE 

      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL EXPEDIENTE '''|| V_EXPEDIENTE_NUM ||'''');

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
