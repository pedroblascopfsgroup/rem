--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8419
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar publicación a oculta.
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
   V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8419';
   V_TABLA_PUBLICACION VARCHAR2(50 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION';
   V_TABLA_HISTORICO VARCHAR2(50 CHAR) := 'ACT_AHP_HIST_PUBLICACION';
   V_ACT_NUM NUMBER(16) := 7386458;
   V_ACT_ID NUMBER(16);
 
BEGIN

   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.put_line('[INFO] CAMBIAR ESTADO DEL ACTIVO '''|| V_ACT_NUM ||''' A OCULTO');

   -- Comprobamos que el activo existe
   V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| V_ACT_NUM;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

   IF V_NUM_TABLAS > 0 THEN

      -- Obtenemos el ID del activo
      V_MSQL := 'SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| V_ACT_NUM;
	   EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;	

      -- Se actualiza la publicación del activo
      V_MSQL:= 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_PUBLICACION ||' SET
               DD_EPA_ID = 4,
               DD_MTO_A_ID = 3,
               APU_MOT_OCULTACION_MANUAL_A = NULL,
               APU_CHECK_PUBLICAR_A = 1,
               APU_CHECK_OCULTAR_A = 1,
               APU_CHECK_PUB_SIN_PRECIO_A = 0,
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE 
               WHERE ACT_ID = '|| V_ACT_ID ||'';

		EXECUTE IMMEDIATE V_MSQL;

      -- Se actualiza la fecha de fin del historico anterior
      V_MSQL:= 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_HISTORICO ||' SET
               AHP_FECHA_FIN_ALQUILER = SYSDATE,
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE 
               WHERE ACT_ID = '|| V_ACT_ID ||'
               AND USUARIOCREAR = ''ndelaossa''';

		EXECUTE IMMEDIATE V_MSQL;

      -- Se introduce el nuevo histórico
      V_MSQL:= 'INSERT INTO '|| V_ESQUEMA ||'.'|| V_TABLA_HISTORICO ||' 
      (AHP_ID, 
       ACT_ID, 
       DD_EPV_ID, 
       DD_EPA_ID, 
       DD_TCO_ID, 
       AHP_CHECK_PUBLICAR_V, 
       AHP_CHECK_OCULTAR_V,
       AHP_CHECK_OCULTAR_PRECIO_V,
       AHP_CHECK_PUB_SIN_PRECIO_V,
       DD_MTO_A_ID,
       AHP_CHECK_PUBLICAR_A, 
       AHP_CHECK_OCULTAR_A,
       AHP_CHECK_OCULTAR_PRECIO_A,
       AHP_CHECK_PUB_SIN_PRECIO_A,
       AHP_FECHA_INI_ALQUILER,
       VERSION,
       USUARIOCREAR,
       FECHACREAR,
       BORRADO,
       ES_CONDICONADO_ANTERIOR,
       DD_TPU_A_ID
       ) VALUES 
       (
          '|| V_ESQUEMA ||'.S_'|| V_TABLA_HISTORICO ||'.NEXTVAL,
          '|| V_ACT_ID ||',
          1,
          4,
          3,
          0,
          0,
          0,
          0,
          3,
          1,
          1,
          0,
          0,      
          SYSDATE,
          0,
          '''|| V_USUARIO ||''',
         SYSDATE,
         0,
         1,
         1         
       )';

		EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] ESTADO DE PUBLICACIÓN ACTUALIZADO CON ÉXITO');
   
   ELSE 

      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''|| V_ACT_NUM ||'''');

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
