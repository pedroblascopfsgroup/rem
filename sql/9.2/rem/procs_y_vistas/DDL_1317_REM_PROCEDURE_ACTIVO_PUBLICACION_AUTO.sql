--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2583
--## PRODUCTO=NO
--## Finalidad: Crear una procedure para establecer el estado de publicación de los activos a publicado segun condiciones.
--## REPETIDO: Este script está repetido por cuestiones de actualización del contenido del procedure 'ACTIVO_PUBLICACION_AUTO'.
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN
  DBMS_OUTPUT.PUT_LINE('[INFO] Procedure PROCEDURE ACTIVO_PUBLICACION_AUTO: INICIANDO...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE REM01.ACTIVO_PUBLICACION_AUTO (ACT_ID_PARAM IN NUMBER, USERNAME_PARAM IN VARCHAR2) IS

		idHistEpu NUMBER(16); -- Vble. id generado para histórico.
		LAST_ID_NUM NUMBER(16); -- Vble. último id encontrado en el histórico.
		ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
		ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    	EXC_NOTFOUND_ACTIVO EXCEPTION; -- Excepcion de usuario que controla un activo que no se encuentra en las vistas.
		USERNAME_MODIFY VARCHAR2(250 CHAR):= USERNAME_PARAM; -- Nombre de usuario que realiza la ejecución del procedure.

		TYPE PUBLICAR_REF IS REF CURSOR;
		V_PUBLICAR PUBLICAR_REF;
    --Cursor por referencia

    V_ACT_ID NUMBER(16);
    V_ESTADO_PUBLICACION_CODIGO VARCHAR2(20 CHAR);
    V_CONDICIONADO NUMBER;
    --Variables para campos de cada fila del cursor
    --TODO: Cambiar esta forma de asignacion de variables para que no se tenga
    -- que indicar el tipo de dato (resistente a cambios de tipo en las vistas)

		BEGIN

	    DBMS_OUTPUT.PUT_LINE(''[INICIO]'');

		IF(USERNAME_MODIFY IS NULL) THEN
        	USERNAME_MODIFY:= ''REM'';
		END IF;

	    IF(ACT_ID_PARAM IS NOT NULL) THEN
        OPEN V_PUBLICAR FOR
          SELECT ACT_ID, ESTADO_PUBLICACION_CODIGO, CONDICIONADO from REM01.V_ACTIVO_PUBLI_MAN WHERE ACT_ID = ACT_ID_PARAM AND (ESTADO_PUBLICACION_CODIGO IS NULL OR ESTADO_PUBLICACION_CODIGO <> ''05'')
          UNION
          SELECT ACT_ID, ESTADO_PUBLICACION_CODIGO, CONDICIONADO from REM01.V_ACTIVO_SIN_PRECIO_PUBLI_MAN WHERE ACT_ID = ACT_ID_PARAM AND (ESTADO_PUBLICACION_CODIGO IS NULL OR ESTADO_PUBLICACION_CODIGO <> ''05'');
      ELSE
	    	OPEN V_PUBLICAR FOR
          SELECT ACT_ID, ESTADO_PUBLICACION_CODIGO, CONDICIONADO from REM01.V_ACTIVO_PUBLI_MAN WHERE (ESTADO_PUBLICACION_CODIGO IS NULL OR ESTADO_PUBLICACION_CODIGO <> ''05'')
          UNION
          SELECT ACT_ID, ESTADO_PUBLICACION_CODIGO, CONDICIONADO from REM01.V_ACTIVO_SIN_PRECIO_PUBLI_MAN WHERE (ESTADO_PUBLICACION_CODIGO IS NULL OR ESTADO_PUBLICACION_CODIGO <> ''05'');
	    END IF;
      --Escoge entre cursores dependiendo de si se llama al procedure con o sin parametro de activo
      --Asigna el cursor escogido, al cursor por referencia
      --En ejecuciones OFFLINE(ACT_ID_PARAM = null) se filtran los casos que no tengan IC aceptado, en online se acepta antes de llamar al procedure

	    FETCH V_PUBLICAR INTO V_ACT_ID, V_ESTADO_PUBLICACION_CODIGO, V_CONDICIONADO;

      --IF(ACT_ID_PARAM IS NOT NULL AND V_PUBLICAR%NOTFOUND) THEN RAISE EXC_NOTFOUND_ACTIVO; END IF;
      -- Solo en ejecucion por parametro de activo: Si no se encuentra el activo
      -- en las vistas, provoca una excepcion.

	    WHILE (V_PUBLICAR%FOUND) LOOP

	        DBMS_OUTPUT.PUT_LINE(''[INFO] procesando activo con ID: ''||V_ACT_ID);
	        -- (Sin preciar) No publicado, publicado forzado o campo no seteado.
	        IF (V_ESTADO_PUBLICACION_CODIGO != ''07'' or V_ESTADO_PUBLICACION_CODIGO is null) THEN
	              SELECT REM01.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL INTO idHistEpu FROM DUAL;

	              -- Actualizar estado activo.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar estado del activo ''||V_ACT_ID||'' a publicado'');
	              UPDATE REM01.ACT_ACTIVO act SET
	              act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM REM01.DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''01''),
	              act.fechamodificar = SYSDATE,
	              act.usuariomodificar = USERNAME_MODIFY
	              WHERE act.ACT_ID = V_ACT_ID;

	              -- Actualizar último registro, si lo hubiese.
	              EXECUTE IMMEDIATE ''SELECT MAX(HEP_ID) FROM REM01.ACT_HEP_HIST_EST_PUBLICACION WHERE ACT_ID = ''||V_ACT_ID||'''' INTO LAST_ID_NUM;
	              IF LAST_ID_NUM IS NOT NULL THEN
	                  DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar último histórico del activo ''||V_ACT_ID);
	                  UPDATE REM01.ACT_HEP_HIST_EST_PUBLICACION HIST SET
	                  HIST.HEP_FECHA_HASTA = SYSDATE,
	                  HIST.fechamodificar = SYSDATE,
	                  HIST.usuariomodificar = USERNAME_MODIFY
	                  WHERE HIST.HEP_ID = LAST_ID_NUM;
	              END IF;

	              -- Insertar cambio de estado del activo en el historico.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] insertar cambio en el histórico del activo ''||V_ACT_ID);
	              INSERT INTO ACT_HEP_HIST_EST_PUBLICACION (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID, DD_EPU_ID, HEP_MOTIVO, USUARIOCREAR, FECHACREAR)
	              VALUES (idHistEpu, V_ACT_ID, SYSDATE, (SELECT por.DD_POR_ID FROM REM01.DD_POR_PORTAL por WHERE por.DD_POR_CODIGO = decode(V_CONDICIONADO, 0, ''01'',''02'')), (SELECT tpu.DD_TPU_ID FROM REM01.DD_TPU_TIPO_PUBLICACION tpu WHERE tpu.DD_TPU_CODIGO = ''01''), (SELECT epu.DD_EPU_ID FROM REM01.DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''01''), ''Proceso automático de publicación'', USERNAME_MODIFY, SYSDATE);
	        END IF;

	        -- (Sin preciar) Publicado forzado con precio oculto.
	        IF (V_ESTADO_PUBLICACION_CODIGO = ''07'') THEN
	              SELECT REM01.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL INTO idHistEpu FROM DUAL;

	              -- Actualizar estado activo.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar estado del activo ''||V_ACT_ID||'' a publicado con precio oculto'');
	              UPDATE REM01.ACT_ACTIVO act SET
	              act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM REM01.DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''04''),
	              act.fechamodificar = SYSDATE,
	              act.usuariomodificar = USERNAME_MODIFY
	              WHERE act.ACT_ID = V_ACT_ID;

	              -- Actualizar último registro, si lo hubiese.
	              EXECUTE IMMEDIATE ''SELECT MAX(HEP_ID) FROM REM01.ACT_HEP_HIST_EST_PUBLICACION WHERE ACT_ID = ''||V_ACT_ID||'''' INTO LAST_ID_NUM;
	              IF LAST_ID_NUM IS NOT NULL THEN
	                  DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar último histórico del activo ''||V_ACT_ID);
	                  UPDATE REM01.ACT_HEP_HIST_EST_PUBLICACION HIST SET
	                  HIST.HEP_FECHA_HASTA = SYSDATE,
	                  HIST.fechamodificar = SYSDATE,
	                  HIST.usuariomodificar = USERNAME_MODIFY
	                  WHERE HIST.HEP_ID = LAST_ID_NUM;
	              END IF;

	              -- Insertar cambio de estado del activo en el historico.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] insertar cambio en el histórico del activo ''||V_ACT_ID);
	              INSERT INTO REM01.ACT_HEP_HIST_EST_PUBLICACION (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID, DD_EPU_ID, HEP_MOTIVO, USUARIOCREAR, FECHACREAR)
	              VALUES (idHistEpu, V_ACT_ID, SYSDATE, (SELECT por.DD_POR_ID FROM REM01.DD_POR_PORTAL por WHERE por.DD_POR_CODIGO = decode(V_CONDICIONADO, 0, ''01'',''02'')), (SELECT tpu.DD_TPU_ID FROM REM01.DD_TPU_TIPO_PUBLICACION tpu WHERE tpu.DD_TPU_CODIGO = ''01''), (SELECT epu.DD_EPU_ID FROM REM01.DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''04''), ''Proceso automático de publicación'', USERNAME_MODIFY, SYSDATE);
	        END IF;

          FETCH V_PUBLICAR INTO V_ACT_ID, V_ESTADO_PUBLICACION_CODIGO, V_CONDICIONADO;

	    END LOOP;

	    DBMS_OUTPUT.PUT_LINE(''[FIN]'');

	    CLOSE V_PUBLICAR;

	    COMMIT;

	EXCEPTION
    WHEN EXC_NOTFOUND_ACTIVO THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := ''El activo indicado por parametro no existe o no cumple las condiciones de las vistas y no puede publicarse'';
	    DBMS_OUTPUT.put_line(''[ERROR] El activo indicado por parametro no existe o no cumple las condiciones de las vistas y no puede publicarse:''||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line(''-----------------------------------------------------------'');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line(''[ERROR] Se ha producido un error en la ejecución:''||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line(''-----------------------------------------------------------'');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;

		END ACTIVO_PUBLICACION_AUTO;
		';
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Procedure creada.');
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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