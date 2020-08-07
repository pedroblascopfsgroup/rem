--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7195
--## PRODUCTO=NO
--##
--## Finalidad: Insertar Tipo de documento
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
       
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#REMMASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'DD_TPD_TIPO_DOCUMENTO';
    V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7195';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); --Vble. auxiliar que almacena el id del registro
  
    
    V_COUNT NUMBER(16); --Vble para comprobar si existe el tipo de Documento
    V_CODIGO_EXISTE NUMBER(16); --Vble para comprobar si existe el codigo

    TIPO_DESCRIPCION VARCHAR2(55 CHAR);

    TIPO_MATRICULA VARCHAR2(55 CHAR);
    TIPO_CODIGO VARCHAR2(55 CHAR);
	
    TYPE T_JBV IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV('Ficha valoración Advisory','AI-04-TASA-33','161')		
	); 
	V_TMP_JBV T_JBV;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    	FOR I IN V_JBV.FIRST .. V_JBV.LAST
 	 LOOP

 		V_TMP_JBV := V_JBV(I);

 		TIPO_DESCRIPCION := TRIM(V_TMP_JBV(1));
		TIPO_MATRICULA := TRIM(V_TMP_JBV(2));
		TIPO_CODIGO := TRIM(V_TMP_JBV(3));
        
        V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TPD_DESCRIPCION = '''||TIPO_DESCRIPCION||'''';

        
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

		DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBACION CORRECTA');		
								
			IF V_COUNT = 0 THEN 	

			        V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TPD_DESCRIPCION = '''||TIPO_DESCRIPCION||'''';
				EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_EXISTE;

				IF V_CODIGO_EXISTE = 0 THEN

					DBMS_OUTPUT.PUT_LINE('[INFO] INICIANDO PROCESO INSERCCION');
				
					V_SQL :='SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
				
			    		EXECUTE IMMEDIATE V_SQL INTO V_ID;
				
						
					V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_TPD_ID, DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA,DD_TPD_MATRICULA_GD, USUARIOCREAR, FECHACREAR,DD_TPD_VISIBLE) VALUES ('''||V_ID||''','''||TIPO_CODIGO||''','''||TIPO_DESCRIPCION||''','''||TIPO_DESCRIPCION||''','''||TIPO_MATRICULA||''','''||V_USUARIO||''', SYSDATE,1)';

			    		EXECUTE IMMEDIATE V_SQL;


					DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO CORRECTAMENTE');

				ELSE
				DBMS_OUTPUT.PUT_LINE('El Tipo de documento '''||TIPO_CODIGO||''' ya existe');
				END IF;
			ELSE
				DBMS_OUTPUT.PUT_LINE('El Tipo de documento '''||TIPO_DESCRIPCION||''' ya existia');
			END IF;
END LOOP;
    
			DBMS_OUTPUT.PUT_LINE('[FIN] LA INSERCCION DEL TIPO DE DOCUMENTO SE A COMPLETADO SATISFACTORIAMENTE');
    
    COMMIT;
   

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
EXIT;
