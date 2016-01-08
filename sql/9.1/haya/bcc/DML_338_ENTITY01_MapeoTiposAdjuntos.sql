--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20151216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO
--## PRODUCTO=NO
--## Finalidad: DML
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_ID VARCHAR2(4000 CHAR); -- Vble. para consulta del id.
    V_SQL_NEXT_ID VARCHAR2(4000 CHAR); -- Vble. para consulta del id.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TFA_ID NUMBER(16); -- Vble. para almacenar el id de DD_TFA_FICHERO_ADJUNTO.
    V_NEXT_ID NUMBER(16); -- Vble. para almacenar el siguiente id de MTT_MAP_ADJRECOVERY_ADJCM.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('ACPSAREB', '00369'),
      T_FUNCION('CRACCES', '00369'),
      T_FUNCION('ANDPP', '00369'),
      T_FUNCION('AC218', '00369'),
      T_FUNCION('AAEEE', '00245'),
      T_FUNCION('ACTJUNACR', '00159'),
      T_FUNCION('ANLS', '00340'),
      T_FUNCION('MEMB', '00366'),
      T_FUNCION('AACONV', '00332'),
      T_FUNCION('AAPLIQ', '00332'),
      T_FUNCION('CNAUAP', '00332'),
      T_FUNCION('AACO', '00325'),
      T_FUNCION('DFA', '00371'),
      T_FUNCION('DECADM', '00360'),
      T_FUNCION('ADEC', '00360'),
      T_FUNCION('ADEH', '00360'),
      T_FUNCION('ADEM', '00360'),
      T_FUNCION('ADEO', '00360'),
      T_FUNCION('ADETJ', '00360'),
      T_FUNCION('ADETNJ', '00360'),
      T_FUNCION('ADEV', '00360'),
      T_FUNCION('AUTO', '00360'),
      T_FUNCION('AAC', '00360'),
      T_FUNCION('ADS', '00360'),
      T_FUNCION('ASDJM', '00360'),
      T_FUNCION('ARPEP', '00360'),
      T_FUNCION('AREDI', '00360'),
      T_FUNCION('ARETJ', '00360'),
      T_FUNCION('AUTORE', '00360'),
      T_FUNCION('AUTORF', '00360'),
      T_FUNCION('MANCANCAR', '00388'),
      T_FUNCION('MCC', '00388'),
      T_FUNCION('SCBCCR', '00388'),
      T_FUNCION('PCCSC', '00388'),
      T_FUNCION('CCB', '00084'),
      T_FUNCION('CCH', '00084'),
      T_FUNCION('DSCC', '00367'),
      T_FUNCION('CRG', '00339'),
      T_FUNCION('CEEAN', '00113'),
      T_FUNCION('CERDEU', '00113'),
      T_FUNCION('CS', '00113'),
      T_FUNCION('BOP', '00551'),
      T_FUNCION('CCAN', '00252'),
      T_FUNCION('CVIP', '00252'),
      T_FUNCION('LIBARR', '00252'),
      T_FUNCION('IFISCAL', '00240'),
      T_FUNCION('CAS', '00068'),
      T_FUNCION('ACPCARDP', '00272'),
      T_FUNCION('CON', '00486'),
      T_FUNCION('ADCO', '00311'),
      T_FUNCION('CERFIO', '00169'),
      T_FUNCION('DSO', '00358'),
      T_FUNCION('EDCSDE', '00358'),
      T_FUNCION('EDH', '00358'),
      T_FUNCION('DSPJ', '00358'),
      T_FUNCION('EDC', '00358'),
      T_FUNCION('EDM', '00358'),
      T_FUNCION('EDO', '00358'),
      T_FUNCION('EDTJ', '00358'),
      T_FUNCION('EDV', '00358'),
      T_FUNCION('INTDEM', '00358'),
      T_FUNCION('EDCO', '00358'),
      T_FUNCION('DEINC', '00330'),
      T_FUNCION('ESCJUZ', '00330'),
      T_FUNCION('RPFDE', '00362'),
      T_FUNCION('DJP', '00362'),
      T_FUNCION('DJL', '00362'),
      T_FUNCION('DUEDIL', '00362'),
      T_FUNCION('OCO', '00334'),
      T_FUNCION('OAP', '00320'),
      T_FUNCION('ODE', '00320'),
      T_FUNCION('OEJ', '00320'),
      T_FUNCION('OEX', '00320'),
      T_FUNCION('OTR', '00320'),
      T_FUNCION('DJAC', '00322'),
      T_FUNCION('DRO', '00322'),
      T_FUNCION('INS', '00319'),
      T_FUNCION('INSEXT', '00319'),
      T_FUNCION('INSL', '00319'),
      T_FUNCION('ACS', '00319'),
      T_FUNCION('ASU', '00319'),
      T_FUNCION('ESRAS', '00319'),
      T_FUNCION('INSUFI', '00319'),
      T_FUNCION('INFSUBEXT', '00319'),
      T_FUNCION('PRI', '00319'),
      T_FUNCION('PIN', '00319'),
      T_FUNCION('CRSOLADJ', '00319'),
      T_FUNCION('RCT', '00319'),
      T_FUNCION('TVAPJ', '00319'),      
      T_FUNCION('BOE', '00389'),
      T_FUNCION('EPME', '00384'),
      T_FUNCION('INFSOBVEN', '00503'),
      T_FUNCION('ECC', '00327'),
      T_FUNCION('ESCSUS', '00365'),
      T_FUNCION('EODI', '00365'),
      T_FUNCION('EOETJ', '00365'),
      T_FUNCION('EOETNJ', '00365'),
      T_FUNCION('EOH', '00365'),
      T_FUNCION('EOM', '00365'),
	  T_FUNCION('EOO', '00365'),
	  T_FUNCION('EORC', '00365'),
	  T_FUNCION('EOSC', '00365'),
	  T_FUNCION('ESC', '00023'),
	  T_FUNCION('CEHE', '00052'),
	  T_FUNCION('ILCRLM', '00294'),
	  T_FUNCION('INFTC', '00294'),
	  T_FUNCION('INFVL', '00294'),
	  T_FUNCION('INFCON', '00331'),
	  T_FUNCION('INFPRO', '00298'),
	  T_FUNCION('ESI', '00392'),
	  T_FUNCION('LICPRIO', '00282'),
	  T_FUNCION('CLD', '00276'),
	  T_FUNCION('EDPIN', '00276'),
	  T_FUNCION('INFLIQ', '00276'),
	  T_FUNCION('CALHAC', '00046'),
	  T_FUNCION('COAPH', '00046'),
	  T_FUNCION('MINEN', '00029'),
	  T_FUNCION('MINUTA', '00029'),
	  T_FUNCION('NOSI', '00024'),
	  T_FUNCION('SCBCPC', '00021'),
	  T_FUNCION('MP', '00021'),
	  T_FUNCION('MPEN', '00021'),
	  T_FUNCION('NSE', '00024'),
	  T_FUNCION('NSISE', '00024'),
	  T_FUNCION('PLALIQ', '00333'),
	  T_FUNCION('POL', '00022'),
	  T_FUNCION('HCI', '00370'),
	  T_FUNCION('PREPCO', '00329'),
	  T_FUNCION('PCTER', '00329'),
	  T_FUNCION('PRAC', '00329'),
	  T_FUNCION('IACPAC', '00329'),
	  T_FUNCION('INFAC', '00329'),
	  T_FUNCION('INACPC', '00329'),
	  T_FUNCION('INFADMCON', '00329'),
	  T_FUNCION('IPAC', '00329'),
	  T_FUNCION('PRVFND', '00044'),
	  T_FUNCION('EXT', '00116'),
	  T_FUNCION('RSIEN', '00275'),
	  T_FUNCION('RSIND', '00275'),
	  T_FUNCION('AUTCONCON', '00395'),
	  T_FUNCION('REAC', '00390'),
	  T_FUNCION('INFCANOPE', '00299'),
	  T_FUNCION('TAB', '00025'),
	  T_FUNCION('TSU', '00025'),
	  T_FUNCION('PSTRCE', '00271')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        -- INSERTANDO EN DD_TFA_FICHERO_ADJUNTO

        IF V_NUM_TABLAS > 0 THEN   
        
            V_SQL_ID := 'SELECT DD_TFA_ID FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        	EXECUTE IMMEDIATE V_SQL_ID INTO V_TFA_ID;
        	
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM WHERE DD_TFA_ID = '''||V_TFA_ID||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        	
        	IF V_NUM_TABLAS > 0 THEN
        	
        			V_MSQL := 'UPDATE '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM SET TFA_CODIGO_EXTERNO =  '''||TRIM(V_TMP_FUNCION(2))||''' ,FECHAMODIFICAR = SYSDATE  WHERE DD_TFA_ID = '''||V_TFA_ID||'''';
	    			EXECUTE IMMEDIATE V_MSQL;
	    			DBMS_OUTPUT.PUT_LINE('[INFO] Campo TFA_CODIGO_EXTERNO '''||TRIM(V_TMP_FUNCION(2))||''' actualizado para DD_TFA_ID = '''||V_TFA_ID||'''.');
        	
        	ELSE
        	
        			V_SQL_NEXT_ID := 'SELECT NVL(MAX(MTT_ID)+1,1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM';
        			EXECUTE IMMEDIATE V_SQL_NEXT_ID INTO V_NEXT_ID;
        	  
        	  		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.MTT_MAP_ADJRECOVERY_ADJCM (' ||
              		'MTT_ID, DD_TFA_ID, TFA_CODIGO_EXTERNO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
              		'VALUES ('||V_NEXT_ID||','||V_TFA_ID||','''||TRIM(V_TMP_FUNCION(2))||''', 0, ''DML'',SYSDATE,0)';
              
               		DBMS_OUTPUT.PUT_LINE('INSERTANDO: en MTT_MAP_ADJRECOVERY_ADJCM datos: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
          	   		EXECUTE IMMEDIATE V_MSQL;
          
        	END IF;
        ELSE    
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TFA_FICHERO_ADJUNTO... No existe el registro con el DD_TFA_CODIGO '''|| TRIM(V_TMP_FUNCION(1))||'''');
        END IF;
      END LOOP;

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
EXIT;
