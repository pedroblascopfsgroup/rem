--/*
--######################################### 
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200926
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11306
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de 
    
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-11306';

   	PRO_ID NUMBER(16);
    DD_SCR_ID NUMBER(16);
    
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  	T_JBV('A28515088', '154'),
			T_JBV('B78689841', '154'),
			T_JBV('A83827907', '154'),
			--T_JBV('V85576239', '01'),
			T_JBV('B64921083', '155'),
			T_JBV('B64921091', '155'),
			T_JBV('B64504731', '155'),
			T_JBV('B81260911', '155'),
			T_JBV('B64921109', '155'),
			T_JBV('B11819935', '155'),
			T_JBV('B39488549', '155'),
			T_JBV('B63821383', '155'),
			T_JBV('A60118098', '155'),
			T_JBV('B65853210', '155'),
			T_JBV('B64929334', '155'),
			T_JBV('B65072803', '155'),
			T_JBV('B43965037', '155'),
			T_JBV('V85172252', '157'),
			T_JBV('V84994144', '157'),
			T_JBV('V85044451', '157'),
			T_JBV('V86245453', '157'),
			T_JBV('V64705924', '156'),
			T_JBV('V85143931', '157'),
			T_JBV('V85129138', '157'),
			T_JBV('V85447654', '157'),
			T_JBV('V84859644', '157'),
			T_JBV('V86005485', '157'),
			T_JBV('V86488368', '157'),
			T_JBV('V85936391', '157'),
			T_JBV('V86887791', '157'),
			T_JBV('V64006075', '157'),
			T_JBV('V85271229', '157'),
			T_JBV('V84455740', '157'),
			T_JBV('V86170537', '157'),
			T_JBV('V86359734', '157'),
			T_JBV('V86623634', '157'),
			T_JBV('V85413359', '157'),
			T_JBV('V85848422', '157'),
			T_JBV('V84373000', '157'),
			T_JBV('V85576239', '157'),
			T_JBV('V84533793', '157'),
			T_JBV('V85496008', '157'),
			T_JBV('V84901461', '157'),
			T_JBV('V84170901', '157'),
			T_JBV('V85653186', '157'),
			T_JBV('V84702752', '157'),
			T_JBV('V85257657', '157'),
			T_JBV('V85350304', '157'),
			T_JBV('V85839009', '157'),
			T_JBV('V64241474', '157'),
			T_JBV('V63511554', '157'),
			T_JBV('V63803969', '157'),
			T_JBV('V65102576', '157'),
			T_JBV('V63275259', '157'),
			T_JBV('V65161754', '156'),
			T_JBV('V64915424', '156'),
			T_JBV('V64302862', '156'),
			T_JBV('V65203275', '156'),
			T_JBV('V65146995', '156'),
			T_JBV('V64980824', '156'),
			T_JBV('V65332686', '156'),
			T_JBV('V64998925', '156'),
			T_JBV('B63933758', '158'),
			T_JBV('A65934101', '158'),
			T_JBV('A61650867', '158'),
			T_JBV('B08253197', '158'),
			T_JBV('A62812953', '158'),
			T_JBV('A63128284', '158'),
			T_JBV('B63268601', '158'),
			T_JBV('G65142929', '158'),
			T_JBV('B63625107', '158'),
			T_JBV('B63442974', '158'),
			T_JBV('B64986938', '158'),
			T_JBV('B63248579', '158'),
			T_JBV('B63377212', '158')

	); 
	V_TMP_JBV T_JBV;
    
BEGIN
     
     FOR I IN V_JBV.FIRST .. V_JBV.LAST
	 LOOP
	 
	 V_TMP_JBV := V_JBV(I);
				  
				PRO_ID := TRIM(V_TMP_JBV(2));
				DD_SCR_ID := TRIM(V_TMP_JBV(2));


				EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||TRIM(V_TMP_JBV(1))||''' AND BORRADO = 0 AND ROWNUM = 1 ORDER BY FECHACREAR ASC' INTO V_COUNT;

				
				IF V_COUNT > 0 THEN
					
					EXECUTE IMMEDIATE 'SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||TRIM(V_TMP_JBV(1))||''' AND BORRADO = 0 AND ROWNUM = 1 ORDER BY FECHACREAR ASC' INTO PRO_ID;
					EXECUTE IMMEDIATE 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_JBV(2))||''' AND BORRADO = 0' INTO DD_SCR_ID;
					EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PRO_SCR WHERE PRO_ID = '||PRO_ID INTO V_COUNT;
					
					IF V_COUNT = 0 THEN 								
						V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PRO_SCR (
									  PRO_ID
									, DD_SCR_ID
									, FECHACREAR
									, USUARIOCREAR
									) VALUES (
									 '||PRO_ID||'
									,'||DD_SCR_ID||'
									, SYSDATE
									,'''||V_USUARIO||'''
									)
						';
					    EXECUTE IMMEDIATE V_SQL;
					
						DBMS_OUTPUT.PUT_LINE('Insertada la relación entre el propietario con número de documento '''||TRIM(V_TMP_JBV(1))||''' y código de subcartera '''||TRIM(V_TMP_JBV(2))||'''');	
			
				
					ELSE
						 V_SQL := 'UPDATE '|| V_ESQUEMA ||'.PRO_SCR 
									SET DD_SCR_ID = '||DD_SCR_ID||'
									, FECHAMODIFICAR = SYSDATE
									, USUARIOCREAR = '''||V_USUARIO||'''
									WHERE PRO_ID = '||PRO_ID;
	          			EXECUTE IMMEDIATE V_SQL;
						
	          			DBMS_OUTPUT.PUT_LINE('Actualizada la subcartera relacionada al propietario con número de documento '''||TRIM(V_TMP_JBV(1))||'''');	
		
					END IF;
				ELSE
					DBMS_OUTPUT.PUT_LINE('No se ha encontrado ningún propietario con número de documento '''||TRIM(V_TMP_JBV(1))||'''');	
				END IF;

	 END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');    

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

EXIT;
