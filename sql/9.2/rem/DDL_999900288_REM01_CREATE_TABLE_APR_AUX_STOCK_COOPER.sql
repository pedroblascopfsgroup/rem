--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180801
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1408
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla APR_AUX_STOCK_COOPER.
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'APR_AUX_STOCK_COOPER'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1408';
    USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_QUERY';
    
 BEGIN
 
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
 
	IF V_COUNT = 0 THEN
	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
		
		EXECUTE IMMEDIATE V_SQL;
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
	  
	END IF;
 
		V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 1 THEN
 
		V_SQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA;
		
		EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha borrado la tabla '||V_TABLA);	
	
	END IF;
	
	V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
					CORTOR           VARCHAR2(2 CHAR)   
					,COACES   		 VARCHAR2(9 CHAR) NOT NULL  
					,COENGP           VARCHAR2(5 CHAR)   
					,COSPAT           VARCHAR2(5 CHAR)   
					,COSPAT_DES VARCHAR2(100 CHAR)   
					,COTSIN           VARCHAR2(4 CHAR)   
					,COTSIN_DES VARCHAR2(100 CHAR) 
					,NUINMU           VARCHAR2(9 CHAR)   
					,FEFOAC           VARCHAR2(8 CHAR)   
					,COENAE           VARCHAR2(2 CHAR)   
					,COENAE_DES VARCHAR2(100 CHAR) 
					,COESEN           VARCHAR2(2 CHAR)   
					,COESVE           VARCHAR2(2 CHAR) 
					,COESVE_DES   VARCHAR2(100 CHAR)
					,FEBAJA           VARCHAR2(8 CHAR)   
					,POPROP           VARCHAR2(6 CHAR)   
					,COGRAP           VARCHAR2(2 CHAR)   
					,CONIAP           VARCHAR2(2 CHAR)   
					,COENOR           VARCHAR2(5 CHAR)   
					,COENOR_DES VARCHAR2(100 CHAR) 
					,IDCOEQ           VARCHAR2(5 CHAR)   
					,XCOEMP           VARCHAR2(5 CHAR)   
					,COPSER           VARCHAR2(5 CHAR)   
					,IDPRIG           VARCHAR2(17 CHAR)  
					,IDCOEC           VARCHAR2(15 CHAR)  
					,COPRDW           VARCHAR2(16 CHAR)  
					,FETASA           VARCHAR2(8 CHAR)   
					,IMVATA           VARCHAR2(15 CHAR)  
					,COFITA           VARCHAR2(5 CHAR)   
					,COMOTA           VARCHAR2(2 CHAR)   
					,COMOTA_DES VARCHAR2(100 CHAR) 
					,IMRESU           VARCHAR2(15 CHAR)  
					,IMCONS           VARCHAR2(15 CHAR)  
					,BINECO           VARCHAR2(1 CHAR)   
					,FETECO           VARCHAR2(8 CHAR)   
					,IMVECO           VARCHAR2(15 CHAR)  
					,COTECO           VARCHAR2(5 CHAR)   
					,CO1ECO           VARCHAR2(2 CHAR)   
					,COTIRG           VARCHAR2(5 CHAR)   
					,NUIDOP           VARCHAR2(20 CHAR)  
					,COSTIT           VARCHAR2(2 CHAR)   
					,COSTIT_DES VARCHAR2(100 CHAR) 
					,COREAE           VARCHAR2(5 CHAR)   
					,COREAE_DES VARCHAR2(100 CHAR) 
					,FEREAI           VARCHAR2(8 CHAR)   
					,FEPHAC           VARCHAR2(8 CHAR)   
					,FEPREG           VARCHAR2(8 CHAR)   
					,FEINAU           VARCHAR2(8 CHAR)   
					,FEADAC           VARCHAR2(8 CHAR)   
					,FETIFI           VARCHAR2(8 CHAR)   
					,BIPOPO           VARCHAR2(1 CHAR)   
					,BINELA           VARCHAR2(1 CHAR)   
					,FESEPO           VARCHAR2(8 CHAR)   
					,FEREPO           VARCHAR2(8 CHAR)   
					,FESELA           VARCHAR2(8 CHAR)   
					,FERELA           VARCHAR2(8 CHAR)   
					,CODISC           VARCHAR2(2 CHAR)   
					,CODISC_DES VARCHAR2(100 CHAR) 
					,NULIBE           VARCHAR2(6 CHAR)   
					,NUTOME           VARCHAR2(6 CHAR)   
					,NUFOLE           VARCHAR2(6 CHAR)   
					,NUINSR           VARCHAR2(8 CHAR)   
					,COPRDI           VARCHAR2(12 CHAR)  
					,IMPADJ           VARCHAR2(15 CHAR)  
					,BINOCU           VARCHAR2(1 CHAR)   
					,FEENAG           VARCHAR2(8 CHAR)   
					,FEEAAU           VARCHAR2(8 CHAR)   
					,FESEPR           VARCHAR2(8 CHAR)   
					,FESUBT           VARCHAR2(8 CHAR)   
					,CORESB           VARCHAR2(2 CHAR)   
					,CORESB_DES VARCHAR2(100 CHAR)
					,FECRES           VARCHAR2(8 CHAR)   
					,IMVAJU           VARCHAR2(15 CHAR)  
					,COSOCU           VARCHAR2(2 CHAR)   
					,FICOAR           VARCHAR2(8 CHAR)   
					,NOARRE           VARCHAR2(35 CHAR)  
					,BIPOLA           VARCHAR2(1 CHAR)   
					,FESOLA           VARCHAR2(8 CHAR)   
					,QAVDAH           VARCHAR2(1 CHAR)   
					,QANFZP           VARCHAR2(1 CHAR)   
					,QAOCPV           VARCHAR2(1 CHAR)   
					,QFSLMR           VARCHAR2(8 CHAR)   
					,QCRSMR           VARCHAR2(1 CHAR)   
					,QCRSMR_DES VARCHAR2(100 CHAR)
					,QFRSMR           VARCHAR2(8 CHAR)   
					,FESOPO           VARCHAR2(8 CHAR)   
					,QAEVPS           VARCHAR2(1 CHAR)   
					,BIACSI           VARCHAR2(1 CHAR)   
					,FERLL6           VARCHAR2(8 CHAR)   
					,FENLLA           VARCHAR2(8 CHAR)   
					,IMREMA           VARCHAR2(15 CHAR)  
					,IMVACE           VARCHAR2(15 CHAR)  
					,COSIAU           VARCHAR2(1 CHAR)   
					,BIEXMU           VARCHAR2(1 CHAR)   
					,BIDEMU           VARCHAR2(1 CHAR)   
					,FECESI           VARCHAR2(8 CHAR)   
					,NORESP           VARCHAR2(30 CHAR)  
					,CODIJU           VARCHAR2(2 CHAR)   
					,CODIJU_DES VARCHAR2(100 CHAR)
					,BIREAR           VARCHAR2(1 CHAR)   
					,IDAUTO           VARCHAR2(10 CHAR)  
					,NOCURA           VARCHAR2(40 CHAR)  
					,OBRECO           VARCHAR2(6 CHAR)   
					,NUJUZD           VARCHAR2(2 CHAR)   
					,TIJUZD           VARCHAR2(3 CHAR)   
					,NOLOJZ           VARCHAR2(30 CHAR)  
					,NOSALA           VARCHAR2(20 CHAR)  
					,NONOES           VARCHAR2(50 CHAR)  
					,NUPROT           VARCHAR2(8 CHAR)   
					,IMDEMA           VARCHAR2(15 CHAR)  
					,FEDEMA           VARCHAR2(8 CHAR)   
					,FEREDE           VARCHAR2(8 CHAR)   
					,COTICO           VARCHAR2(2 CHAR)   
					,COSBIC           VARCHAR2(2 CHAR)   
					,POICOM           VARCHAR2(5 CHAR)   
					,QCIVAC           VARCHAR2(3 CHAR)   
					,BIREXE           VARCHAR2(1 CHAR)   
					,COTIVI           VARCHAR2(2 CHAR)   
					,COTIVI_DES VARCHAR2(100 CHAR)
					,NOVIAS           VARCHAR2(60 CHAR)  
					,NUPOAC           VARCHAR2(17 CHAR)  
					,NUESAC           VARCHAR2(5 CHAR)   
					,NUPIAC           VARCHAR2(11 CHAR)  
					,NUPUAC           VARCHAR2(17 CHAR)  
					,COPOIN           VARCHAR2(5 CHAR)   
					,COMUIN           VARCHAR2(9 CHAR)   
					,COPRAE           VARCHAR2(2 CHAR)   
					,NUMFIN           VARCHAR2(14 CHAR)  
					,NUREGP           VARCHAR2(3 CHAR)   
					,COMUIX           VARCHAR2(9 CHAR)   
					,COEXCA           VARCHAR2(2 CHAR)   
					,COEXCA_DES VARCHAR2(100 CHAR)
					,BIOBNU           VARCHAR2(1 CHAR)   
					,BIOBNU_DES VARCHAR2(100 CHAR)
					,PORBRA           VARCHAR2(6 CHAR)   
					,POPROC           VARCHAR2(6 CHAR)   
					,NURCAT           VARCHAR2(20 CHAR)  
					,BIASIN           VARCHAR2(1 CHAR)   
					,BIASIN_DES VARCHAR2(100 CHAR)
					,BISILO           VARCHAR2(1 CHAR)   
					,DESLO2           VARCHAR2(17 CHAR)  
					,BISILA           VARCHAR2(1 CHAR)   
					,DESLA2           VARCHAR2(17 CHAR)  
					,CASUTR           VARCHAR2(11 CHAR)  
					,CASUTG           VARCHAR2(11 CHAR)  
					,CASUTC           VARCHAR2(11 CHAR)  
					,CADORM           VARCHAR2(4 CHAR)   
					,CABANO           VARCHAR2(4 CHAR)   
					,BIGAPA           VARCHAR2(1 CHAR)   
					,CAGAPA           VARCHAR2(5 CHAR)   
					,BIARRE           VARCHAR2(1 CHAR)   
					,BIASCE           VARCHAR2(1 CHAR)   
					,BITRAS           VARCHAR2(1 CHAR)   
					,TIPOVT           VARCHAR2(1 CHAR)   
					,TIPOVT_DES VARCHAR2(100 CHAR)
					,CANTDE           VARCHAR2(4 CHAR)   
					,CORPRO           VARCHAR2(2 CHAR)   
					,CORPRO_DES VARCHAR2(100 CHAR)
					,FEACON           VARCHAR2(4 CHAR)   
					,FEREHA           VARCHAR2(4 CHAR)   
					,FEPORI           VARCHAR2(8 CHAR)   
					,IMAPOW           VARCHAR2(15 CHAR)  
					,FAFADE           VARCHAR2(8 CHAR)   
					,FECULV           VARCHAR2(8 CHAR)   
					,OBTTEX           VARCHAR2(110 CHAR) 
					,NPROMO           VARCHAR2(5 CHAR)   
					,FFCOAR           VARCHAR2(8 CHAR)   
					,APRESH           VARCHAR2(1 CHAR)   
					,APRESH_DES VARCHAR2(100 CHAR)
					,BIACSU           VARCHAR2(1 CHAR)   
					,GETEIN           VARCHAR2(40 CHAR)  
					,COEFEN           VARCHAR2(1 CHAR)   
					,FEEMEE           VARCHAR2(8 CHAR)   
					,FEFIEE           VARCHAR2(8 CHAR)   
					,BINAST           VARCHAR2(1 CHAR)   
					,BINAST_DES VARCHAR2(100 CHAR)
					,BINSMO           VARCHAR2(3 CHAR)   
					,COPUMO           VARCHAR2(2 CHAR)   
					,COPUMO_DES VARCHAR2(100 CHAR)
					,NUVISR           VARCHAR2(8 CHAR)   
					,NUOFET           VARCHAR2(8 CHAR)   
					,FEOFUL           VARCHAR2(8 CHAR)   
					,IMOFU            VARCHAR2(15 CHAR)  
					,NUOFDE           VARCHAR2(9 CHAR)   
					,IMOFMA           VARCHAR2(15 CHAR)  
					,COTSRE           VARCHAR2(4 CHAR)   
					,IMVACO           VARCHAR2(15 CHAR)  
					,FEVACO           VARCHAR2(8 CHAR)   
					,QMREFP           VARCHAR2(15 CHAR)  
					,QFRIRP           VARCHAR2(8 CHAR)   
					,IMALRE           VARCHAR2(15 CHAR)  
					,IMORAL           VARCHAR2(15 CHAR)  
					,IMVAPR           VARCHAR2(15 CHAR)  
					,IMPINE           VARCHAR2(15 CHAR)  
					,IMVACT           VARCHAR2(15 CHAR)  
					,FEVACT           VARCHAR2(8 CHAR)   
					,OBRTOR           VARCHAR2(40 CHAR)  
					,COCDIN           VARCHAR2(4 CHAR)   
					,IMAREN           VARCHAR2(15 CHAR)  
					,FEAREN           VARCHAR2(8 CHAR)   
					,IMPEAW           VARCHAR2(15 CHAR)  
					,FECEVT           VARCHAR2(8 CHAR)   
					,IDPROV           VARCHAR2(9 CHAR)   
					,CASPRE           VARCHAR2(11 CHAR)  
					,CASUCS           VARCHAR2(9 CHAR)   
					,CASUCB           VARCHAR2(9 CHAR)   
					,IMVLIQ           VARCHAR2(15 CHAR)  
					,IMVFSV           VARCHAR2(15 CHAR)  
					,COACHA           VARCHAR2(16 CHAR)  
					,COSPT1           VARCHAR2(1 CHAR)   
					,COSJUR           VARCHAR2(2 CHAR)   
					,RFILLER          VARCHAR2(64 CHAR)   
				)
			  ';

		EXECUTE IMMEDIATE V_SQL;
 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

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
