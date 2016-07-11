--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20151014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN


--##COMPROBACION EXISTENCIA TABLA BORRAR PRIMERO
select count(1) INTO V_NUM_TABLAS from all_tables 
where table_name = 'NMB_BIEN' and OWNER = V_ESQUEMA;

if V_NUM_TABLAS > 0 then 
--YA existe una versión de la tabla , se elimina primero
DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla NMB_BIEN: se ELIMINA...');
EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.NMB_BIEN';
DBMS_OUTPUT.PUT_LINE('OK');
END IF;


--##CREACION DE TABLA

-- !!!! OJO !!!! Estamos replicando la tabla bien provisionalmente para utilizar la estrategia de herencia JOIN
-- ************* entre BIE_BIEN y NMB_BIEN. En caso de continuar con esta estrategia la tabla NMB_BIEN debería contener unicamente
-- ************* los campos exculsivos de NMB_BIEN. 

-- ************* Finalmente no se replica asi que este script se queda para borrar la tabla en caso de existir
	
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