--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190226
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3455
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_PRO_PROPIETARIO ';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3455'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_PROPIETARIO VARCHAR(50 CHAR) := 'Vauxhall Propiedades SLU';
    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar los datos del propietario '||V_PROPIETARIO||'.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET PRO_DOCIDENTIF = ''B87872156'',
                    PRO_DIR = ''C/ Nanclares de Oca 1 B'',
                    DD_LOC_ID = (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_DESCRIPCION = ''Madrid''),
                    DD_PRV_ID = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION = ''Madrid''),
                    PRO_CP = 28022,
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE PRO_NOMBRE IN ('''||V_PROPIETARIO||''')';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] Propietario '||V_PROPIETARIO||' actualizado correctamente.');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT
