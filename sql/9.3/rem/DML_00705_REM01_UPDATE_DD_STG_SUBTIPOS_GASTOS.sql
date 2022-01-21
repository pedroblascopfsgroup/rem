--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16953
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-16953';
    
    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    

BEGIN

        DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = ''166'' AND  DD_STG_DESCRIPCION = ''Alarmas - Primera Posesión'' 
                                                                                    AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

		IF V_COUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[INICIO] PONEMOS BORRADO = 1 EN EL REGISTRO CON CÓDIGO 166');

    
            V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO
                        SET  BORRADO = 1
                            ,USUARIOBORRAR = '''||V_USUARIO||'''
                            ,FECHABORRAR = SYSDATE
                        WHERE DD_STG_CODIGO = ''166'' ';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico correcto');


        ELSE
	        DBMS_OUTPUT.PUT_LINE('No existe el registo');

        END IF;

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = ''167'' AND  DD_STG_DESCRIPCION = ''Duplicado Cédula Habitabilidad'' 
                                                                                    AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

		IF V_COUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[INICIO] CAMBIAMOS EL CÓDIGO AL REGISTRO CON CÓDIGO 167, AL 166');

    
            V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO
                        SET  DD_STG_CODIGO = ''166''
                            ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE DD_STG_DESCRIPCION = ''Duplicado Cédula Habitabilidad'' ';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico correcto');


        ELSE
	        DBMS_OUTPUT.PUT_LINE('No existe el registo');

        END IF;
  
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] Los activos se han actualizado correctamente');


EXCEPTION
     WHEN OTHERS THEN
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