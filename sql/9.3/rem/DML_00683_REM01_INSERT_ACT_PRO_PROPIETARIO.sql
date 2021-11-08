--/*
--######################################### 
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211108
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15581
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  INSERTAR PROPIETARIO
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='HREOS-15581'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PRO_PROPIETARIO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_CODIGO_LOC VARCHAR2(100 CHAR):='29067';
    V_PRO_DOCIDENTIF VARCHAR2(100 CHAR):='B16896616';
    V_COUNT NUMBER(16) :=0;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN '||V_TABLA||' '); 

    DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos si ya existe propietario con docidentif '||V_PRO_DOCIDENTIF||' ');

    V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_DOCIDENTIF = '''||V_PRO_DOCIDENTIF||''' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;       

    IF V_COUNT = 0 THEN     

        DBMS_OUTPUT.PUT_LINE('[INFO]: Insertamos propietario '||V_PRO_DOCIDENTIF||' ');            

        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
        (PRO_ID,     
        PRO_NOMBRE, 
        DD_TDI_ID, 
        PRO_DOCIDENTIF, 
        PRO_DIR,
        USUARIOCREAR, 
        FECHACREAR, 
        DD_CRA_ID) VALUES (
        '||V_ESQUEMA||'.S_ACT_PRO_PROPIETARIO.NEXTVAL,
      
        ''Promontoria Jaguar Real Estate, S.L.U.'',
        (SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''02''),
        '''||V_PRO_DOCIDENTIF||''',
        ''C/ Serrano 26, 6ª planta, 28001 Madrid'',
        '''||V_USUARIO||''',
        SYSDATE,
        (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''))
        ';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: PROPIETARIO INSERTADO CORRECTAMENTE');

    ELSE
         DBMS_OUTPUT.PUT_LINE('[ERROR]: El propietario '||V_PRO_DOCIDENTIF||' ya existe ');    
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
EXIT