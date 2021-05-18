--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9572
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  INSERTAR PROVISION
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9572'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='PRG_PROVISION_GASTOS'; --Vble. auxiliar para almacenar la tabla a insertar
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN '||V_TABLA||' ');                            

    V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
    (PRG_ID, 
    PRG_NUM_PROVISION, 
    DD_EPR_ID, 
    PRG_FECHA_ALTA, 
    PVE_ID_GESTORIA, 
    PRG_FECHA_ENVIO, 
    PRG_FECHA_RESPUESTA, 
    USUARIOCREAR, 
    FECHACREAR) VALUES (
    '||V_ESQUEMA||'.S_PRG_PROVISION_GASTOS.NEXTVAL,
    173923586,
    6,
    TO_DATE(''03/02/2021'', ''DD/MM/YY''),
    2821,
    TO_DATE(''04/02/2021'', ''DD/MM/YY''),
    TO_DATE(''04/02/2021'', ''DD/MM/YY''),
    '''||V_USUARIO||''',
    SYSDATE)
    ';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: PROVISIÓN INSERTADA');

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