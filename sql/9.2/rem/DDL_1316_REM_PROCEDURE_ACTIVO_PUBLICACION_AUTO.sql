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
  DBMS_OUTPUT.PUT('[INFO] Procedure PROCEDURE ACTIVO_PUBLICACION_AUTO: CREADA...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.ACTIVO_PUBLICACION_AUTO AS
		BEGIN

	-- No publicado, publicado forzado o campo no seteado.
		MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO act USING '||V_ESQUEMA||'.V_ACTIVO_PUBLI_AUTO vista ON (act.ACT_ID = vista.ACT_ID)
		WHEN MATCHED THEN
			UPDATE SET
			act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''01''),
			act.fechamodificar = SYSDATE,
			act.usuariomodificar = ''REM''
			WHERE  vista.ESTADO_PUBLICACION_CODIGO != ''07'' or vista.ESTADO_PUBLICACION_CODIGO is null;;

	-- Publicado forzado con precio oculto.
		MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO act USING '||V_ESQUEMA||'.V_ACTIVO_PUBLI_AUTO vista ON (act.ACT_ID = vista.ACT_ID)
		WHEN MATCHED THEN
			UPDATE SET
			act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''04''),
			act.fechamodificar = SYSDATE,
			act.usuariomodificar = ''REM''
			WHERE  vista.ESTADO_PUBLICACION_CODIGO = ''07'';

	-- Sin preciar no publicado, publicado forzado o campo no seteado.
		MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO act USING '||V_ESQUEMA||'.V_ACTIVO_SIN_PRECIO_PUBLI_AUTO vista ON (act.ACT_ID = vista.ACT_ID)
		WHEN MATCHED THEN
			UPDATE SET
			act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''01''),
			act.fechamodificar = SYSDATE,
			act.usuariomodificar = ''REM''
			WHERE  vista.ESTADO_PUBLICACION_CODIGO != ''07'' or vista.ESTADO_PUBLICACION_CODIGO is null;;

	-- Sin preciar publicado forzado con precio oculto.
		MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO act USING '||V_ESQUEMA||'.V_ACTIVO_SIN_PRECIO_PUBLI_AUTO vista ON (act.ACT_ID = vista.ACT_ID)
		WHEN MATCHED THEN
			UPDATE SET
			act.DD_EPU_ID = (SELECT epu.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION epu WHERE epu.DD_EPU_CODIGO = ''04''),
			act.fechamodificar = SYSDATE,
			act.usuariomodificar = ''REM''
			WHERE  vista.ESTADO_PUBLICACION_CODIGO = ''07'';

		END ACTIVO_PUBLICACION_AUTO;
		';
  DBMS_OUTPUT.PUT_LINE('OK');

  
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
