--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc01
--## INCIDENCIA_LINK=HR-940
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
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    ID_ASUNTO NUMBER(16);
    ID_TGE NUMBER(16);
    ID_USD NUMBER(16);
    ID_USU NUMBER(16);
    ID_TAS NUMBER(16);
    TGE_COD VARCHAR2(10 CHAR);
    DES_COD VARCHAR2(10 CHAR);
    USERNAME VARCHAR2(10 CHAR);
    USERNAME_CUR VARCHAR2(10 CHAR);
    TOTAL_INSERTS NUMBER(3); -- Variable para controlar el número de inserts realizados
    
    ASUNTOS_CURSOR SYS_REFCURSOR;
    
BEGIN
	DES_COD := 'DSUPASU';
	USERNAME := 'S_UCO_H';
	TGE_COD := 'SUP';
	ID_TAS := 2;
	USERNAME_CUR := 'LETRADO_H';
	
	V_SQL := 'SELECT USD.USD_ID FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD ' || 
			'INNER JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON DES.DES_ID = USD.DES_ID AND DES.DES_CODIGO = '''||DES_COD||''' ' ||
			'INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = USD.USU_ID AND USU.USU_USERNAME = '''||USERNAME||''' ';
	EXECUTE IMMEDIATE V_SQL INTO ID_USD;
	
	V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TGE_COD||''' ';
	EXECUTE IMMEDIATE V_SQL INTO ID_TGE;
	
	OPEN ASUNTOS_CURSOR FOR 'SELECT a.ASU_ID ' ||
							' FROM '||V_ESQUEMA||'.ASU_ASUNTOS a, '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa, '||
							V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd '||
							'WHERE gaa.ASU_ID = a.ASU_ID AND gaa.USD_ID = usd.USD_ID AND a.DD_TAS_ID = '||ID_TAS||' AND ' ||
							' usd.USU_ID IN (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||USERNAME_CUR||''')';
 	
	TOTAL_INSERTS := 0;
 	LOOP
 		FETCH ASUNTOS_CURSOR INTO ID_ASUNTO;
 		EXIT WHEN ASUNTOS_CURSOR%NOTFOUND;

 	 		--Sólo si no tiene el usuario y tipo de gestor ya asignados lo doy de alta
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO WHERE ASU_ID='||ID_ASUNTO||' AND DD_TGE_ID='||ID_TGE;
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
        IF V_NUM_TABLAS < 1 THEN 
        --Saco el insert a realizar por cada tipo de gestor que tengo que carterizar	
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)'
			    		|| ' VALUES ('
			    		
						|| 'S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL,'
						|| ID_ASUNTO || ','
						|| ID_USD || ','
						|| ID_TGE || ','
						|| '0,'
						|| ' ''GESTOR'','
						|| 'SYSDATE,'
						|| '0'
						|| ')';
						
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
							
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO'
						|| ' ('
						|| ' GAH_ID, '
						|| ' GAH_GESTOR_ID, '
						|| ' GAH_ASU_ID, '
						|| ' GAH_TIPO_GESTOR_ID, '
						|| ' GAH_FECHA_DESDE, '
						|| ' VERSION, '
						|| ' USUARIOCREAR, '
						|| ' FECHACREAR, '
						|| ' BORRADO'
						|| ' )'
						|| ' VALUES '
						|| ' ('
						|| ' S_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL,'
						|| ID_USD || ','
						|| ID_ASUNTO || ','
						|| ID_TGE || ','
						|| ' SYSDATE,'
						|| ' 0,'
						|| ' ''GESTOR'','
						|| ' SYSDATE,'
						|| ' 0'
						|| ' )';
						
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;							
			
			TOTAL_INSERTS := TOTAL_INSERTS + 1; 
			
			IF (TOTAL_INSERTS=100) THEN		
				COMMIT;					
				TOTAL_INSERTS := 0; 
			END IF;
						
			--DBMS_OUTPUT.PUT_LINE('El usuario '||gestores.usu_username||' ha sido dado de alta como gestor para el asunto con asu_id='||asuntos.asu_id);				
			END IF;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('Usuarios gestores y supervisores de prueba ya asignados.');
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('El proceso ha finalizado correctamente.');
						
    CLOSE ASUNTOS_CURSOR;
    
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;