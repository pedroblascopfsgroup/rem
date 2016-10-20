--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
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
  DBMS_OUTPUT.PUT_LINE('[INFO] Procedure PROCEDURE ACTIVO_PUBLICACION_AUTO: INICIANDO...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.ACTIVO_PUBLICACION_AUTO IS

		idHistEpu NUMBER(16); -- Vble. id generado para histórico.
	    LAST_ID_NUM NUMBER(16); -- Vble. último id encontrado en el histórico.
		ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	    CURSOR VISTA IS SELECT * from V_ACTIVO_PUBLI_AUTO UNION select * from V_ACTIVO_SIN_PRECIO_PUBLI_AUTO; -- Cursor con query.
	    FILA VISTA%ROWTYPE; -- Registro para el loop.

		BEGIN

	    DBMS_OUTPUT.PUT_LINE(''[INICIO]'');
	
	    IF (NOT VISTA%ISOPEN) THEN
	        OPEN VISTA;
	    END IF;
	
	    FETCH VISTA INTO FILA;
	
	    WHILE (VISTA%FOUND) LOOP
	        DBMS_OUTPUT.PUT_LINE(''[INFO] procesando activo con ID: ''||FILA.ACT_ID);
	        -- (Sin preciar) No publicado, publicado forzado o campo no seteado.
	        IF (FILA.ESTADO_PUBLICACION_CODIGO != ''07'' or FILA.ESTADO_PUBLICACION_CODIGO is null) THEN
	              SELECT S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL INTO idHistEpu FROM DUAL;
	        
	              -- Actualizar estado activo.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar estado del activo ''||FILA.ACT_ID||'' a publicado'');
	              UPDATE ACT_ACTIVO act SET
	              act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''01''),
	              act.fechamodificar = SYSDATE,
	              act.usuariomodificar = ''REM''
	              WHERE act.ACT_ID = FILA.ACT_ID;
	
	              -- Actualizar último registro, si lo hubiese.
	              EXECUTE IMMEDIATE ''SELECT MAX(HEP_ID) FROM ACT_HEP_HIST_EST_PUBLICACION WHERE ACT_ID = ''||FILA.ACT_ID||'''' INTO LAST_ID_NUM;
	              IF LAST_ID_NUM IS NOT NULL THEN
	                  DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar último histórico del activo ''||FILA.ACT_ID);
	                  UPDATE ACT_HEP_HIST_EST_PUBLICACION HIST SET
	                  HIST.HEP_FECHA_HASTA = SYSDATE,
	                  HIST.fechamodificar = SYSDATE,
	                  HIST.usuariomodificar = ''REM''
	                  WHERE HIST.HEP_ID = LAST_ID_NUM;
	              END IF;
	
	              -- Insertar cambio de estado del activo en el historico.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] insertar cambio en el histórico del activo ''||FILA.ACT_ID);
	              INSERT INTO ACT_HEP_HIST_EST_PUBLICACION (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID, DD_EPU_ID, HEP_MOTIVO, USUARIOCREAR, FECHACREAR)
	              VALUES (idHistEpu, FILA.ACT_ID, SYSDATE, (SELECT por.DD_POR_ID FROM DD_POR_PORTAL por WHERE por.DD_POR_CODIGO = decode(FILA.CONDICIONADO, 0, ''01'',''02'')), (SELECT tpu.DD_TPU_ID FROM DD_TPU_TIPO_PUBLICACION tpu WHERE tpu.DD_TPU_CODIGO = ''01''), (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''01''), ''Proceso automático de publicación'', ''REM'', SYSDATE);
	        END IF;
	        
	        -- (Sin preciar) Publicado forzado con precio oculto.
	        IF (FILA.ESTADO_PUBLICACION_CODIGO = ''07'') THEN
	              SELECT S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL INTO idHistEpu FROM DUAL;
	        
	              -- Actualizar estado activo.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar estado del activo ''||FILA.ACT_ID||'' a publicado con precio oculto'');
	              UPDATE ACT_ACTIVO act SET
	              act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''04''),
	              act.fechamodificar = SYSDATE,
	              act.usuariomodificar = ''REM''
	              WHERE act.ACT_ID = FILA.ACT_ID;
	
	              -- Actualizar último registro, si lo hubiese.
	              EXECUTE IMMEDIATE ''SELECT MAX(HEP_ID) FROM ACT_HEP_HIST_EST_PUBLICACION WHERE ACT_ID = ''||FILA.ACT_ID||'''' INTO LAST_ID_NUM;
	              IF LAST_ID_NUM IS NOT NULL THEN
	                  DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar último histórico del activo ''||FILA.ACT_ID);
	                  UPDATE ACT_HEP_HIST_EST_PUBLICACION HIST SET
	                  HIST.HEP_FECHA_HASTA = SYSDATE,
	                  HIST.fechamodificar = SYSDATE,
	                  HIST.usuariomodificar = ''REM''
	                  WHERE HIST.HEP_ID = LAST_ID_NUM;
	              END IF;
	
	              -- Insertar cambio de estado del activo en el historico.
	              DBMS_OUTPUT.PUT_LINE(''[INFO] insertar cambio en el histórico del activo ''||FILA.ACT_ID);
	              INSERT INTO ACT_HEP_HIST_EST_PUBLICACION (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID, DD_EPU_ID, HEP_MOTIVO, USUARIOCREAR, FECHACREAR)
	              VALUES (idHistEpu, FILA.ACT_ID, SYSDATE, (SELECT por.DD_POR_ID FROM DD_POR_PORTAL por WHERE por.DD_POR_CODIGO = decode(FILA.CONDICIONADO, 0, ''01'',''02'')), (SELECT tpu.DD_TPU_ID FROM DD_TPU_TIPO_PUBLICACION tpu WHERE tpu.DD_TPU_CODIGO = ''01''), (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''04''), ''Proceso automático de publicación'', ''REM'', SYSDATE);
	        END IF;
	
	        FETCH VISTA INTO FILA;
	
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