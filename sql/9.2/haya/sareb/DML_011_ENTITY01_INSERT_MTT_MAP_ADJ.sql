--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1117
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
    	T_FUNCION('RSANSU','ACUI-07'),
		T_FUNCION('RSAR','ACUI-16'),
		T_FUNCION('RSARSI','ACUI-17'),
		T_FUNCION('EOH','ALEG-34'),
		T_FUNCION('CCH','CERJ-62'),
		T_FUNCION('EJUZTBS','COMU-59'),
		T_FUNCION('CALHAC','DEAC-11'),
		T_FUNCION('COAPH','DEAC-12'),
		T_FUNCION('DJP','DOCA-41'),
		T_FUNCION('DJL','DOCA-42'),
		T_FUNCION('ACS','DOCJ-29'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('ADEH','DOCJ-36'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSSDA','DOCJ-43'),
		T_FUNCION('DSCC','DOCJ-44'),
		T_FUNCION('ESRAS','DOCJ-50'),
		T_FUNCION('ECM','DOCJ-51'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('EDH','DOCJ-57'),
		T_FUNCION('ESADJ','DOCJ-63'),
		T_FUNCION('MCC','DOCJ-64'),
		T_FUNCION('MP','DOCJ-66'),
		T_FUNCION('TITINSC','DOCJ-70'),
		T_FUNCION('EDCINR','ESCR-27'),
		T_FUNCION('EPSSE','ESCR-28'),
		T_FUNCION('DUEDIL','ESIN-93'),
		T_FUNCION('HCI','ESIN-94'),
		T_FUNCION('ISP','ESIN-97'),
		T_FUNCION('INS','ESIN-98'),
		T_FUNCION('INSL','ESIN-99'),
		T_FUNCION('ILCRLM','ESIN-AD'),
		T_FUNCION('INFFIS','ESIN-AE'),
		T_FUNCION('RCT','ESIN-AI'),
		T_FUNCION('DPRCD','INRG-09'),
		T_FUNCION('PCCSC','PRPE-27'),
		T_FUNCION('PRI','PRPE-28'),
		T_FUNCION('PSFDUL','PRPE-31'),
		T_FUNCION('RECGES','PRPE-33'),
		T_FUNCION('RECIGEST','PRPE-34'),
		T_FUNCION('RSIND','PRPE-35'),
		T_FUNCION('FSSB','PRPI-20'),
		T_FUNCION('FSSF','PRPI-21'),
		T_FUNCION('PSSB','PRPI-22'),
		T_FUNCION('DECRADJ','SERE-40'),
		T_FUNCION('DFA','SERE-41'),
		T_FUNCION('REM','SERE-47'),
		T_FUNCION('REOC','SERE-48'),
		T_FUNCION('REI','SERE-51'),
		T_FUNCION('TIRNR','SERE-56'),
		T_FUNCION('TAB','TASA-14'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('RSANSU','ACUI-07'),
		T_FUNCION('RSAR','ACUI-16'),
		T_FUNCION('RSARSI','ACUI-17'),
		T_FUNCION('EOETJ','ALEG-32'),
		T_FUNCION('EOETNJ','ALEG-33'),
		T_FUNCION('ELAA','ALEG-39'),
		T_FUNCION('EIETJ','ALEG-40'),
		T_FUNCION('CCB','CERJ-63'),
		T_FUNCION('POL','CNCV-62'),
		T_FUNCION('EJUZTBS','COMU-59'),
		T_FUNCION('CALHAC','DEAC-11'),
		T_FUNCION('COAPH','DEAC-12'),
		T_FUNCION('DJP','DOCA-41'),
		T_FUNCION('DJL','DOCA-42'),
		T_FUNCION('AAEEE','DOCA-43'),
		T_FUNCION('ACPCARDP','DOCJ-28'),
		T_FUNCION('ACS','DOCJ-29'),
		T_FUNCION('ACUENTDP','DOCJ-30'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('ARETJ','DOCJ-32'),
		T_FUNCION('ADETJ','DOCJ-34'),
		T_FUNCION('ADETNJ','DOCJ-35'),
		T_FUNCION('AVPR','DOCJ-41'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSSDA','DOCJ-43'),
		T_FUNCION('DSO','DOCJ-46'),
		T_FUNCION('DREP','DOCJ-48'),
		T_FUNCION('RAP','DOCJ-49'),
		T_FUNCION('ESRAS','DOCJ-50'),
		T_FUNCION('ECM','DOCJ-51'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('EDTJ','DOCJ-56'),
		T_FUNCION('ENES','DOCJ-58'),
		T_FUNCION('EPME','DOCJ-59'),
		T_FUNCION('ESADJ','DOCJ-63'),
		T_FUNCION('MCC','DOCJ-64'),
		T_FUNCION('MEMB','DOCJ-65'),
		T_FUNCION('MP','DOCJ-66'),
		T_FUNCION('REREVC','DOCJ-68'),
		T_FUNCION('TITINSC','DOCJ-70'),
		T_FUNCION('EDCINR','ESCR-27'),
		T_FUNCION('EPSSE','ESCR-28'),
		T_FUNCION('DRO','ESIN-92'),
		T_FUNCION('DUEDIL','ESIN-93'),
		T_FUNCION('HCI','ESIN-94'),
		T_FUNCION('ISP','ESIN-97'),
		T_FUNCION('INS','ESIN-98'),
		T_FUNCION('INSL','ESIN-99'),
		T_FUNCION('ILCRLM','ESIN-AD'),
		T_FUNCION('INFFIS','ESIN-AE'),
		T_FUNCION('RCT','ESIN-AI'),
		T_FUNCION('DPRCD','INRG-09'),
		T_FUNCION('PCCSC','PRPE-27'),
		T_FUNCION('PRI','PRPE-28'),
		T_FUNCION('PSFDUL','PRPE-31'),
		T_FUNCION('RECGES','PRPE-33'),
		T_FUNCION('RECIGEST','PRPE-34'),
		T_FUNCION('RSIND','PRPE-35'),
		T_FUNCION('FSSB','PRPI-20'),
		T_FUNCION('FSSF','PRPI-21'),
		T_FUNCION('PSSB','PRPI-22'),
		T_FUNCION('DECRADJ','SERE-40'),
		T_FUNCION('DFA','SERE-41'),
		T_FUNCION('RETNJ','SERE-45'),
		T_FUNCION('REME','SERE-46'),
		T_FUNCION('REM','SERE-47'),
		T_FUNCION('REOC','SERE-48'),
		T_FUNCION('REI','SERE-51'),
		T_FUNCION('TAB','TASA-14'),
		T_FUNCION('TVAPJ','TASA-15'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('EOO','ALEG-36'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('ADEO','DOCJ-38'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSO','DOCJ-46'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('DRO','ESIN-92'),
		T_FUNCION('HCI','ESIN-94'),
		T_FUNCION('REO','SERE-52'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSO','DOCJ-46'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('EOM','ALEG-35'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('ADEM','DOCJ-37'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSO','DOCJ-46'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('REI','SERE-51'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('ADEC','DOCJ-33'),
		T_FUNCION('ARPEP','DOCJ-40'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSO','DOCJ-46'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('REC','SERE-43'),
		T_FUNCION('REI','SERE-51'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('ADEV','DOCJ-39'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSO','DOCJ-46'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('REI','SERE-51'),
		T_FUNCION('REVM','SERE-53'),
		T_FUNCION('REV','SERE-54'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('RSANSU','ACUI-07'),
		T_FUNCION('RSAR','ACUI-16'),
		T_FUNCION('RSARSI','ACUI-17'),
		T_FUNCION('EOETJ','ALEG-32'),
		T_FUNCION('EOETNJ','ALEG-33'),
		T_FUNCION('EOH','ALEG-34'),
		T_FUNCION('ELAA','ALEG-39'),
		T_FUNCION('EIETJ','ALEG-40'),
		T_FUNCION('JUSPG','CERA-59'),
		T_FUNCION('CCH','CERJ-62'),
		T_FUNCION('CCB','CERJ-63'),
		T_FUNCION('EJUZTBS','COMU-59'),
		T_FUNCION('CALHAC','DEAC-11'),
		T_FUNCION('COAPH','DEAC-12'),
		T_FUNCION('DJP','DOCA-41'),
		T_FUNCION('DJL','DOCA-42'),
		T_FUNCION('AAEEE','DOCA-43'),
		T_FUNCION('ACS','DOCJ-29'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('ARETJ','DOCJ-32'),
		T_FUNCION('ADETJ','DOCJ-34'),
		T_FUNCION('ADETNJ','DOCJ-35'),
		T_FUNCION('ADEH','DOCJ-36'),
		T_FUNCION('AVPR','DOCJ-41'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSSDA','DOCJ-43'),
		T_FUNCION('ESRAS','DOCJ-50'),
		T_FUNCION('ECM','DOCJ-51'),
		T_FUNCION('EIC','DOCJ-53'),
		T_FUNCION('EII','DOCJ-54'),
		T_FUNCION('EDTJ','DOCJ-56'),
		T_FUNCION('EDH','DOCJ-57'),
		T_FUNCION('EPME','DOCJ-59'),
		T_FUNCION('ESCPRJUZ','DOCJ-60'),
		T_FUNCION('ESADJ','DOCJ-63'),
		T_FUNCION('MCC','DOCJ-64'),
		T_FUNCION('MP','DOCJ-66'),
		T_FUNCION('TITINSC','DOCJ-70'),
		T_FUNCION('DUEDIL','ESIN-93'),
		T_FUNCION('HCI','ESIN-94'),
		T_FUNCION('ISP','ESIN-97'),
		T_FUNCION('INS','ESIN-98'),
		T_FUNCION('INSL','ESIN-99'),
		T_FUNCION('ILCRLM','ESIN-AD'),
		T_FUNCION('INFFIS','ESIN-AE'),
		T_FUNCION('RCT','ESIN-AI'),
		T_FUNCION('DPRCD','INRG-09'),
		T_FUNCION('PCCSC','PRPE-27'),
		T_FUNCION('PRI','PRPE-28'),
		T_FUNCION('PSFDUL','PRPE-31'),
		T_FUNCION('RECGES','PRPE-33'),
		T_FUNCION('RECIGEST','PRPE-34'),
		T_FUNCION('RSIND','PRPE-35'),
		T_FUNCION('FSSB','PRPI-20'),
		T_FUNCION('FSSF','PRPI-21'),
		T_FUNCION('PSSB','PRPI-22'),
		T_FUNCION('DECRADJ','SERE-40'),
		T_FUNCION('DFA','SERE-41'),
		T_FUNCION('REM','SERE-47'),
		T_FUNCION('REOC','SERE-48'),
		T_FUNCION('REI','SERE-51'),
		T_FUNCION('TIRNR','SERE-56'),
		T_FUNCION('TAB','TASA-14'),
		T_FUNCION('TVAPJ','TASA-15'),
		T_FUNCION('TJC','TASA-16'),
		T_FUNCION('RSANSU','ACUI-07'),
		T_FUNCION('RSCOPR','ACUI-08'),
		T_FUNCION('RSFSCO','ACUI-09'),
		T_FUNCION('RSISDI','ACUI-10'),
		T_FUNCION('RSINFC','ACUI-11'),
		T_FUNCION('RSINPA','ACUI-12'),
		T_FUNCION('RSIPAC','ACUI-13'),
		T_FUNCION('RSPRAL','ACUI-14'),
		T_FUNCION('RSPPAL','ACUI-15'),
		T_FUNCION('RSAR','ACUI-16'),
		T_FUNCION('RSARSI','ACUI-17'),
		T_FUNCION('ESALEG','ALEG-30'),
		T_FUNCION('EODI','ALEG-31'),
		T_FUNCION('EORC','ALEG-37'),
		T_FUNCION('EOSC','ALEG-38'),
		T_FUNCION('REAFC','ALEG-41'),
		T_FUNCION('JUSPG','CERA-59'),
		T_FUNCION('EJUZTBS','COMU-59'),
		T_FUNCION('CALHAC','DEAC-11'),
		T_FUNCION('COAPH','DEAC-12'),
		T_FUNCION('DJP','DOCA-41'),
		T_FUNCION('DJL','DOCA-42'),
		T_FUNCION('ACS','DOCJ-29'),
		T_FUNCION('AAC','DOCJ-31'),
		T_FUNCION('DTC','DOCJ-42'),
		T_FUNCION('DSSDA','DOCJ-43'),
		T_FUNCION('DEINC','DOCJ-45'),
		T_FUNCION('DJAC','DOCJ-47'),
		T_FUNCION('ESRAS','DOCJ-50'),
		T_FUNCION('ECM','DOCJ-51'),
		T_FUNCION('ECC','DOCJ-52'),
		T_FUNCION('ESI','DOCJ-55'),
		T_FUNCION('ESCPRJUZ','DOCJ-60'),
		T_FUNCION('ESSORE','DOCJ-61'),
		T_FUNCION('ESCJUZ','DOCJ-62'),
		T_FUNCION('ESADJ','DOCJ-63'),
		T_FUNCION('MCC','DOCJ-64'),
		T_FUNCION('MP','DOCJ-66'),
		T_FUNCION('P5BIS','DOCJ-67'),
		T_FUNCION('TDAC','DOCJ-69'),
		T_FUNCION('TITINSC','DOCJ-70'),
		T_FUNCION('DUEDIL','ESIN-93'),
		T_FUNCION('IACPAC','ESIN-95'),
		T_FUNCION('INFAC','ESIN-96'),
		T_FUNCION('ISP','ESIN-97'),
		T_FUNCION('INS','ESIN-98'),
		T_FUNCION('INSL','ESIN-99'),
		T_FUNCION('INACPC','ESIN-AA'),
		T_FUNCION('INFLETRADO','ESIN-AB'),
		T_FUNCION('INFLFL','ESIN-AC'),
		T_FUNCION('ILCRLM','ESIN-AD'),
		T_FUNCION('INFFIS','ESIN-AE'),
		T_FUNCION('IPAC','ESIN-AF'),
		T_FUNCION('INFTC','ESIN-AG'),
		T_FUNCION('INFVL','ESIN-AH'),
		T_FUNCION('RCT','ESIN-AI'),
		T_FUNCION('MINUTA','FACT-18'),
		T_FUNCION('DPRCD','INRG-09'),
		T_FUNCION('NOSI','NOTS-02'),
		T_FUNCION('OCO','OTRO-01'),
		T_FUNCION('OTR','OTRO-02'),
		T_FUNCION('PRAC','PRPE-25'),
		T_FUNCION('PCTER','PRPE-26'),
		T_FUNCION('PCCSC','PRPE-27'),
		T_FUNCION('PRI','PRPE-28'),
		T_FUNCION('PREPCO','PRPE-29'),
		T_FUNCION('PSFDUC','PRPE-30'),
		T_FUNCION('PSUDUL','PRPE-32'),
		T_FUNCION('RECGES','PRPE-33'),
		T_FUNCION('RECIGEST','PRPE-34'),
		T_FUNCION('RSIND','PRPE-35'),
		T_FUNCION('FSSB','PRPI-20'),
		T_FUNCION('FSSF','PRPI-21'),
		T_FUNCION('PSSB','PRPI-22'),
		T_FUNCION('PSUSB','PRPI-23'),
		T_FUNCION('AACO','SERE-31'),
		T_FUNCION('AACONV','SERE-32'),
		T_FUNCION('AULIQUI','SERE-33'),
		T_FUNCION('ADCO','SERE-34'),
		T_FUNCION('ASDJM','SERE-35'),
		T_FUNCION('AUTORF','SERE-36'),
		T_FUNCION('AREDI','SERE-37'),
		T_FUNCION('AUTORE','SERE-38'),
		T_FUNCION('CNAUAP','SERE-39'),
		T_FUNCION('DECRADJ','SERE-40'),
		T_FUNCION('DFA','SERE-41'),
		T_FUNCION('RECA','SERE-42'),
		T_FUNCION('REDIT','SERE-44'),
		T_FUNCION('REM','SERE-47'),
		T_FUNCION('REOC','SERE-48'),
		T_FUNCION('REAC','SERE-49'),
		T_FUNCION('REFC','SERE-50'),
		T_FUNCION('REI','SERE-51'),
		T_FUNCION('REACHA','SERE-55'),
		T_FUNCION('TIRNR','SERE-56'),
		T_FUNCION('TAB','TASA-14')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        -- INSERTANDO EN MTT_MAP_ADJRECOVERY_ADJCM

        IF V_NUM_TABLAS > 0 THEN   
        
            V_SQL_ID := 'SELECT DD_TFA_ID FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        	EXECUTE IMMEDIATE V_SQL_ID INTO V_TFA_ID;
        	
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM WHERE DD_TFA_ID = '''||V_TFA_ID||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        	
        	IF V_NUM_TABLAS > 0 THEN
        	
        			V_MSQL := 'UPDATE '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM SET TFA_CODIGO_EXTERNO =  '''||TRIM(V_TMP_FUNCION(2))||''' ,FECHAMODIFICAR = SYSDATE, USUARIOMODIFICAR = ''PRODUCTO-1117''  WHERE DD_TFA_ID = '''||V_TFA_ID||'''';
	    			EXECUTE IMMEDIATE V_MSQL;
	    			DBMS_OUTPUT.PUT_LINE('[INFO] Campo TFA_CODIGO_EXTERNO '''||TRIM(V_TMP_FUNCION(2))||''' actualizado para DD_TFA_ID = '''||V_TFA_ID||'''.');
        	
        	ELSE

        			V_SQL_NEXT_ID := 'SELECT NVL(MAX(MTT_ID)+1, 1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM';
        			EXECUTE IMMEDIATE V_SQL_NEXT_ID INTO V_NEXT_ID;
        	  
        	  		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.MTT_MAP_ADJRECOVERY_ADJCM (' ||
              		'MTT_ID, DD_TFA_ID, TFA_CODIGO_EXTERNO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
              		'VALUES ('||V_NEXT_ID||','||V_TFA_ID||','''||TRIM(V_TMP_FUNCION(2))||''', 0, ''PRODUCTO-1117'',SYSDATE,0)';
              
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
