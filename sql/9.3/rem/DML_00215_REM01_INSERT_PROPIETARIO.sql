--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7896
--## PRODUCTO=NO
--##
--## Finalidad: Modificar situacion comercial del activo
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-7896';
    V_EXISTE NUMBER(16); --Vble. para validar la existencia del registro
    PRO_DOCIDENTIF VARCHAR2(20 CHAR) :='A88534359';
    PRO_NOMBRE VARCHAR2(100 CHAR) := 'PROMONTORIA MACC 1X1 SOCIMI S.A.';
    
    
BEGIN	
	 DBMS_OUTPUT.put_line('[INFO] Inicio proceso de inserccion');
    
    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO (
				  PRO_ID
				, FECHACREAR
				, USUARIOCREAR
				, PRO_DOCIDENTIF
				, PRO_NOMBRE
				, DD_CRA_ID
				) VALUES (
				 '||V_ESQUEMA||'.S_ACT_PRO_PROPIETARIO.NEXTVAL
				, SYSDATE
				, '''||V_USUARIO||'''
				, '''||PRO_DOCIDENTIF||'''
				, '''||PRO_NOMBRE||'''
				, (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''11'')
				)';
    
   

        DBMS_OUTPUT.put_line('[INFO] Se ha INSERTADO '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
        
         EXECUTE IMMEDIATE V_SQL;
    
	  
        COMMIT;

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
