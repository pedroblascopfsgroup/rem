--/*
--##########################################
--## AUTOR= GUILLEM REY
--## FECHA_CREACION=20170731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2578
--## PRODUCTO=NO
--## Finalidad: Crear una procedure para establecer el estado de publicación de los activos a publicado segun condiciones.
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
  DBMS_OUTPUT.PUT_LINE('[INFO] Procedure PROCEDURE ACTIVO_PUBLICACION_PORTAL: INICIANDO...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE REM01.ACTIVO_PUBLICACION_PORTAL(ACT_ID_PARAM IN NUMBER, USERNAME_PARAM IN VARCHAR2) IS



        idHistEpu NUMBER(16); -- Vble. id generado para histórico.

        LAST_ID_NUM NUMBER(16); -- Vble. último id encontrado en el histórico.

        ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

        ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

		USERNAME_MODIFY VARCHAR2(250 CHAR):= USERNAME_PARAM; -- Nombre de usuario que realiza la ejecución del procedure.



        TYPE PUBLICAR_REF IS REF CURSOR;

        VISTA PUBLICAR_REF;

    --Cursor por referencia



		V_ACT_ID NUMBER(16);

        V_CODIGO_PORTAL VARCHAR2(20 CHAR);

		V_CONDICIONADO NUMBER;    

        v_HEP_ID NUMBER(16);

        

        EXC_NOTFOUND_ACTIVO EXCEPTION;

		

        BEGIN



        DBMS_OUTPUT.PUT_LINE(''[INICIO]'');

		

		IF(USERNAME_MODIFY IS NULL) THEN

        	USERNAME_MODIFY:= ''REM'';

		END IF;		



        IF(ACT_ID_PARAM IS NOT NULL) THEN

        OPEN VISTA FOR

            SELECT ACT_ID, CONDICIONADO, CODIGO_PORTAL, HEP_ID from V_ACT_PUBLI_HEP_CONDICIONES WHERE ACT_ID = ACT_ID_PARAM;

        ELSE

            OPEN VISTA FOR

                SELECT * from V_ACT_PUBLI_HEP_CONDICIONES;

        END IF;          

      --Escoge entre cursores dependiendo de si se llama al procedure con o sin parametro de activo

      --Asigna el cursor escogido, al cursor por referencia

      --En ejecuciones OFFLINE(ACT_ID_PARAM = null) se filtran los casos que no tengan IC aceptado, en online se acepta antes de llamar al procedure



        FETCH VISTA INTO V_ACT_ID, V_CONDICIONADO , V_CODIGO_PORTAL, V_HEP_ID;



          --IF(ACT_ID_PARAM IS NOT NULL AND VISTA%NOTFOUND) THEN RAISE EXC_NOTFOUND_ACTIVO; END IF;

          -- Solo en ejecucion por parametro de activo: Si no se encuentra el activo

          -- en las vistas, provoca una excepcion.

      





        WHILE (VISTA%FOUND) LOOP

            DBMS_OUTPUT.PUT_LINE(''[INFO] procesando activo con ID: ''||V_ACT_ID);

            -- Comprobar si el portal del histórico se corresponde con el condicionado del activo.

            IF (V_CODIGO_PORTAL = ''01'' AND V_CONDICIONADO = 1) THEN -- HAYA y condicionado

              -- Actualizar último registro, si lo hubiese.

              EXECUTE IMMEDIATE ''SELECT MAX(HEP_ID) FROM ACT_HEP_HIST_EST_PUBLICACION WHERE ACT_ID = ''||V_ACT_ID||'''' INTO LAST_ID_NUM;

              IF LAST_ID_NUM IS NOT NULL THEN

                  DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar último histórico del activo ''||V_ACT_ID);

                  UPDATE ACT_HEP_HIST_EST_PUBLICACION HIST SET

                  HIST.HEP_FECHA_HASTA = SYSDATE,

                  HIST.fechamodificar = SYSDATE,

                  HIST.usuariomodificar = USERNAME_MODIFY

                  WHERE HIST.HEP_ID = LAST_ID_NUM;

              END IF;



            -- Insertar cambio de estado del activo en el historico.

                  DBMS_OUTPUT.PUT_LINE(''[INFO] insertar nuevo registro en el histórico del activo ''||V_ACT_ID);

                SELECT S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL INTO idHistEpu FROM DUAL;

                  INSERT INTO ACT_HEP_HIST_EST_PUBLICACION (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID, DD_EPU_ID, HEP_MOTIVO, USUARIOCREAR, FECHACREAR)

                  VALUES (idHistEpu, V_ACT_ID, SYSDATE, (SELECT por.DD_POR_ID FROM DD_POR_PORTAL por WHERE por.DD_POR_CODIGO = ''02''), (SELECT hep1.DD_TPU_ID FROM ACT_HEP_HIST_EST_PUBLICACION hep1 WHERE hep1.HEP_ID = V_HEP_ID), (SELECT hep2.DD_EPU_ID FROM ACT_HEP_HIST_EST_PUBLICACION hep2 WHERE hep2.HEP_ID = V_HEP_ID), ''Cambio automático de portal'', USERNAME_MODIFY, SYSDATE);

            END IF;



          IF (V_CODIGO_PORTAL = ''02'' AND V_CONDICIONADO = 0) THEN -- Inversores y no condicionado

              -- Actualizar último registro, si lo hubiese.

              EXECUTE IMMEDIATE ''SELECT MAX(HEP_ID) FROM ACT_HEP_HIST_EST_PUBLICACION WHERE ACT_ID = ''||V_ACT_ID||'''' INTO LAST_ID_NUM;

              IF LAST_ID_NUM IS NOT NULL THEN

                  DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar último histórico del activo ''||V_ACT_ID);

                  UPDATE ACT_HEP_HIST_EST_PUBLICACION HIST SET

                  HIST.HEP_FECHA_HASTA = SYSDATE,

                  HIST.fechamodificar = SYSDATE,

                  HIST.usuariomodificar = USERNAME_MODIFY

                  WHERE HIST.HEP_ID = LAST_ID_NUM;

              END IF;



            -- Insertar cambio de estado del activo en el historico.

                  DBMS_OUTPUT.PUT_LINE(''[INFO] insertar nuevo registro en el histórico del activo ''||V_ACT_ID);

                SELECT S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL INTO idHistEpu FROM DUAL;

                  INSERT INTO ACT_HEP_HIST_EST_PUBLICACION (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID, DD_EPU_ID, HEP_MOTIVO, USUARIOCREAR, FECHACREAR)

                  VALUES (idHistEpu, V_ACT_ID, SYSDATE, (SELECT por.DD_POR_ID FROM DD_POR_PORTAL por WHERE por.DD_POR_CODIGO = ''01''), (SELECT hep1.DD_TPU_ID FROM ACT_HEP_HIST_EST_PUBLICACION hep1 WHERE hep1.HEP_ID = V_HEP_ID), (SELECT hep2.DD_EPU_ID FROM ACT_HEP_HIST_EST_PUBLICACION hep2 WHERE hep2.HEP_ID = V_HEP_ID), ''Cambio automático de portal'', USERNAME_MODIFY, SYSDATE);

            END IF;



            FETCH VISTA INTO V_ACT_ID, V_CONDICIONADO , V_CODIGO_PORTAL, V_HEP_ID;



        END LOOP;



        DBMS_OUTPUT.PUT_LINE(''[FIN]'');



        CLOSE VISTA;



        COMMIT;



    EXCEPTION

      WHEN OTHERS THEN

        ERR_NUM := SQLCODE;

        ERR_MSG := SQLERRM;

        DBMS_OUTPUT.put_line(''[ERROR] Se ha producido un error en la ejecución:''||TO_CHAR(ERR_NUM));

        DBMS_OUTPUT.put_line(''-----------------------------------------------------------'');

        DBMS_OUTPUT.put_line(ERR_MSG);

        ROLLBACK;

        RAISE;



        END ACTIVO_PUBLICACION_PORTAL;

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