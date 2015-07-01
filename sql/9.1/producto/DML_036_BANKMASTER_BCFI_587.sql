--/*
--##########################################
--## AUTOR=ALBERTO RAMÍREZ LOSILLA
--## FECHA_CREACION=20150701
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=BCFI-587
--## PRODUCTO=NO
--## Finalidad: CREAR LA NUEVA FUNCIÓN PARA VER EL MENSAJE DE AGENCIAS EN LA CABECERA DE EXPEDIENTE DE RECOBRO
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

whenever sqlerror exit sql.sqlcode;


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
 	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN



	DBMS_OUTPUT.PUT_LINE('[START]  Insert into FUN_FUNCIONES');

 
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''PUEDE_VER_INFO_ADICIONAL_EXP''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.FUN_FUNCIONES ...no se modificará nada.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES fun 
					(fun.FUN_ID,fun.FUN_DESCRIPCION,fun.FUN_DESCRIPCION_LARGA,fun.VERSION, fun.USUARIOCREAR, fun.FECHACREAR, fun.BORRADO)
					VALUES
					('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval, ''PUEDE_VER_INFO_ADICIONAL_EXP'',''Ver la etiqueta información adicional en la cabecera de expedientes de recobro.'', 0,''BCFI-587'',sysdate,0)';
        
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Datos del diccionario insertado');
        
    END IF;	

    COMMIT;


EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT