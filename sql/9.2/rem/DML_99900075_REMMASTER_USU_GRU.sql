--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20170209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1489
--## PRODUCTO=NO
--##
--## Finalidad: Crea tipos de gestor, tgp, des y pef
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TIPO_ID NUMBER(16); --Vle para el id DD_TGE_TIPO_GESTOR 

	-- USUARIOS GRUPO
	TYPE T_TIPO_USU_GRU IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_USU_GRU IS TABLE OF T_TIPO_USU_GRU;
	V_TIPO_USU_GRU T_ARRAY_USU_GRU := T_ARRAY_USU_GRU(
		--			ENTIDAD	  NOMBRE_USU	  	EMAIL   		USERNAME							P	APELL2	EMAIL      			GRP	 PEF_COD			DESPACHO_EXTERNO
T_TIPO_USU_GRU('1','acases01','1234','AGUSTIN CASES PEREZ                     ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','iberpho01','1234','IBERPHONE S.A.U.                        ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','gl01','1234','GUTIERREZ-LABRADOR, S.L.                ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','montalvo01','1234','GESTORIA MONTALVO, S.L.P.               ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','garsa01','1234','GESTORES ADMINISTRATIVOS REUNIDOS SAE   ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','uniges01','1234','UNIGES AGRUPACION DE GESTORIAS SL       ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','inforaga01','1234','INFORAGA                                ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','gicsa01','1234','GESTION INMOBILIARIA CIUDAD, S.A.       ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','mundiges01','1234','MUNDIGESTION ECONOMICA Y FISCAL, S.L.P  ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','granizo01','1234','GRANIZO                                 ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','pinos01','1234','GESTORIA PINOS XXI,S.L.                 ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','gestinov01','1234','GESTINOVA 99, S.L.                      ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','inforeg01','1234','INFOREGISTRO, S.L.                      ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','menpro01','1234','MENPROTEL ASISTENCIA AL PROFESIONAL, SL ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','piquer01','1234','INMOBILIARIA GESTORIA PIQUER S.L.U      ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','grm01','1234','ALL CONSULTING SERVICES GRM S.L.        ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','abitaria01','1234','ABITARIA CONSULTORIA Y GESTION, S.A.    ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','gesfirma01','1234','OFICINA DE GESTION DE FIRMAS SL         ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','cases01','1234','GESTORIA CASES SIERRA S.L.              ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','diagonal01','1234','DIAGONAL GEST, S.L.                     ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','acuerdo01','1234','ACUERDO SERVICIOS JURIDICOS, S.L.       ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','gma01','1234','G.M.A. GESTORIA ADMINISTRATIVA S.L.     ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','indra01','1234','INDRA BPO SL                            ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','gesnova01','1234','GESNOVA GESTION INMOBILIARIA INTEGRAL SL','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','allen01','1234','ALLEN & OVERY                           ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','lener01','1234','LENER ASESORES LEGALES Y ECONOMICOS     ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','ugehi01','1234','UNION DE GESTION HIPOTECARIA SL         ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','pons01','1234','PONS CONSULTORES REGISTRALES SA         ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','semper01','1234','OSCAR MERCE SEMPER SLU                  ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','bureau01','1234','BUREAU VERITAS IBERIA S.L.U.            ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','asb01','1234','ASB POLAND SP                           ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','granizom01','1234','GESTORIA GRANIZO MUÑOZ, S. L.           ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','cenahi01','1234','CENTRO DE ASESORIA HIPOTECARIA S.L.     ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','tinsacer01','1234','TINSA CERTIFY S.L.                      ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','fincasba01','1234','FINCAS BARCELONA 1964, S.L.             ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','tecnotra01','1234','TECNOTRAMIT GESTION SL.                 ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','unidadff01','1234','UNIDAD F&F                              ','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','ogf01','1234','OGF','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','cobian01','1234','JAIME NAVASQUES Y COBIAN','Admisión','','email@email.es','1','HAYAGESTADM','REMGGADM'),
		T_TIPO_USU_GRU('1','acases02','1234','AGUSTIN CASES PEREZ                     ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','iberpho02','1234','IBERPHONE S.A.U.                        ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','gl02','1234','GUTIERREZ-LABRADOR, S.L.                ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','montalvo02','1234','GESTORIA MONTALVO, S.L.P.               ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','garsa02','1234','GESTORES ADMINISTRATIVOS REUNIDOS SAE   ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','uniges02','1234','UNIGES AGRUPACION DE GESTORIAS SL       ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','inforaga02','1234','INFORAGA                                ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','gicsa02','1234','GESTION INMOBILIARIA CIUDAD, S.A.       ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','mundiges02','1234','MUNDIGESTION ECONOMICA Y FISCAL, S.L.P  ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','granizo02','1234','GRANIZO                                 ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','pinos02','1234','GESTORIA PINOS XXI,S.L.                 ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','gestinov02','1234','GESTINOVA 99, S.L.                      ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','inforeg02','1234','INFOREGISTRO, S.L.                      ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','menpro02','1234','MENPROTEL ASISTENCIA AL PROFESIONAL, SL ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','piquer02','1234','INMOBILIARIA GESTORIA PIQUER S.L.U      ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','grm02','1234','ALL CONSULTING SERVICES GRM S.L.        ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','abitaria02','1234','ABITARIA CONSULTORIA Y GESTION, S.A.    ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','gesfirma02','1234','OFICINA DE GESTION DE FIRMAS SL         ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','cases02','1234','GESTORIA CASES SIERRA S.L.              ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','diagonal02','1234','DIAGONAL GEST, S.L.                     ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','acuerdo02','1234','ACUERDO SERVICIOS JURIDICOS, S.L.       ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','gma02','1234','G.M.A. GESTORIA ADMINISTRATIVA S.L.     ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','indra02','1234','INDRA BPO SL                            ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','gesnova02','1234','GESNOVA GESTION INMOBILIARIA INTEGRAL SL','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','allen02','1234','ALLEN & OVERY                           ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','lener02','1234','LENER ASESORES LEGALES Y ECONOMICOS     ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','ugehi02','1234','UNION DE GESTION HIPOTECARIA SL         ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','pons02','1234','PONS CONSULTORES REGISTRALES SA         ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','semper02','1234','OSCAR MERCE SEMPER SLU                  ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','bureau02','1234','BUREAU VERITAS IBERIA S.L.U.            ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','asb02','1234','ASB POLAND SP                           ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','granizom02','1234','GESTORIA GRANIZO MUÑOZ, S. L.           ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','cenahi02','1234','CENTRO DE ASESORIA HIPOTECARIA S.L.     ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','tinsacer02','1234','TINSA CERTIFY S.L.                      ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','fincasba02','1234','FINCAS BARCELONA 1964, S.L.             ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','tecnotra02','1234','TECNOTRAMIT GESTION SL.                 ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','unidadff02','1234','UNIDAD F&F                              ','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','ogf02','1234','OGF','Administración','','email@email.es','1','HAYAGESTADMT','REMGIAADMT'),
		T_TIPO_USU_GRU('1','acases03','1234','AGUSTIN CASES PEREZ                     ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','iberpho03','1234','IBERPHONE S.A.U.                        ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','gl03','1234','GUTIERREZ-LABRADOR, S.L.                ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','montalvo03','1234','GESTORIA MONTALVO, S.L.P.               ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','garsa03','1234','GESTORES ADMINISTRATIVOS REUNIDOS SAE   ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','uniges03','1234','UNIGES AGRUPACION DE GESTORIAS SL       ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','inforaga03','1234','INFORAGA                                ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','gicsa03','1234','GESTION INMOBILIARIA CIUDAD, S.A.       ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','mundiges03','1234','MUNDIGESTION ECONOMICA Y FISCAL, S.L.P  ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','granizo03','1234','GRANIZO                                 ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','pinos03','1234','GESTORIA PINOS XXI,S.L.                 ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','gestinov03','1234','GESTINOVA 99, S.L.                      ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','inforeg03','1234','INFOREGISTRO, S.L.                      ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','menpro03','1234','MENPROTEL ASISTENCIA AL PROFESIONAL, SL ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','piquer03','1234','INMOBILIARIA GESTORIA PIQUER S.L.U      ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','grm03','1234','ALL CONSULTING SERVICES GRM S.L.        ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','abitaria03','1234','ABITARIA CONSULTORIA Y GESTION, S.A.    ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','gesfirma03','1234','OFICINA DE GESTION DE FIRMAS SL         ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','cases03','1234','GESTORIA CASES SIERRA S.L.              ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','diagonal03','1234','DIAGONAL GEST, S.L.                     ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','acuerdo03','1234','ACUERDO SERVICIOS JURIDICOS, S.L.       ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','gma03','1234','G.M.A. GESTORIA ADMINISTRATIVA S.L.     ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','indra03','1234','INDRA BPO SL                            ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','gesnova03','1234','GESNOVA GESTION INMOBILIARIA INTEGRAL SL','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','allen03','1234','ALLEN & OVERY                           ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','lener03','1234','LENER ASESORES LEGALES Y ECONOMICOS     ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','ugehi03','1234','UNION DE GESTION HIPOTECARIA SL         ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','pons03','1234','PONS CONSULTORES REGISTRALES SA         ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','semper03','1234','OSCAR MERCE SEMPER SLU                  ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','bureau03','1234','BUREAU VERITAS IBERIA S.L.U.            ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','asb03','1234','ASB POLAND SP                           ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','granizom03','1234','GESTORIA GRANIZO MUÑOZ, S. L.           ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','cenahi03','1234','CENTRO DE ASESORIA HIPOTECARIA S.L.     ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','tinsacer03','1234','TINSA CERTIFY S.L.                      ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','fincasba03','1234','FINCAS BARCELONA 1964, S.L.             ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','tecnotra03','1234','TECNOTRAMIT GESTION SL.                 ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','unidadff03','1234','UNIDAD F&F                              ','Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM'),
		T_TIPO_USU_GRU('1','ogf03'	,'1234'		,'OGF'								,'Formalización','','email@email.es','1','GESTIAFORM','GESTORIAFORM')
	); 
	V_TMP_TIPO_USU_GRU T_TIPO_USU_GRU;
	  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

 	------------------------------------------------------------------------------------------------------------------------
	--								USU_USUARIOS, ZON_PEF_USU Y USD_USUARIOS_DESPACHOS
	------------------------------------------------------------------------------------------------------------------------
  	FOR I IN V_TIPO_USU_GRU.FIRST .. V_TIPO_USU_GRU.LAST
     LOOP
    
       V_TMP_TIPO_USU_GRU := V_TIPO_USU_GRU(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS ');
       
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS > 0 THEN				         
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS...no se modifica nada.');
			
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' EN USU_USUARIOS');   
        
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.USU_USUARIOS (' ||
                      'USU_ID,
                       ENTIDAD_ID,
                       USU_USERNAME,
                       USU_PASSWORD,
                       USU_NOMBRE,
                       USU_APELLIDO1,
                       USU_APELLIDO2,
                       USU_MAIL,
                       USU_GRUPO,
                       USU_FECHA_VIGENCIA_PASS,
                       USUARIOCREAR,
                       FECHACREAR,
                       BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      '|| TRIM(V_TMP_TIPO_USU_GRU(1)) ||',
                      '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''',
                      '''|| TRIM(V_TMP_TIPO_USU_GRU(3)) ||''',
                      '''|| TRIM(V_TMP_TIPO_USU_GRU(4)) ||''',
                      '''|| TRIM(V_TMP_TIPO_USU_GRU(5)) ||''',
                      '''|| TRIM(V_TMP_TIPO_USU_GRU(6)) ||''',
                      '''|| TRIM(V_TMP_TIPO_USU_GRU(7)) ||''',
                      '|| TRIM(V_TMP_TIPO_USU_GRU(8)) ||',
                      SYSDATE,
                      ''REM_F2_GEST'',
                      SYSDATE,
                      0 
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' INSERTADO CORRECTAMENTE EN USU_USUARIOS');
      
       END IF;
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en zon_pef_usu--
       -------------------------------------------------
        
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU '); 
        
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
						(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_USU_GRU(9))||''') 
							AND USU_ID = 
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
			
		ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' EN ZON_PEF_USU');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
					' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
					' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
					' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_USU_GRU(9))||'''),' ||
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||'''),' ||
					' ''REM_F2_GEST'',
					SYSDATE,
					0 
					FROM DUAL';
		   	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' INSERTADO CORRECTAMENTE EN ZON_PEF_USU');
			
		END IF;
		
	   ------------------------------------------------------------
       --Comprobamos el dato a insertar en usd_usuarios_despachos--
       ------------------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS ');
       
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
			WHERE DES_ID = 
				(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
				WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_USU_GRU(10))||''') 
				AND USU_ID = 
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
			
		ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' EN USD_USUARIOS_DESPACHOS');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
					' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
					' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_USU_GRU(10))||'''),' ||							
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||'''),' ||
					' 1,1,''REM_F2_GEST'',SYSDATE,0 FROM DUAL';
		  	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' INSERTADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');
			
		END IF;	
		
		
	   ---------------------------------------------------------
       --Comprobamos el dato a insertar en gru_grupos_usuarios--
       ---------------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN GRU_GRUPOS_USUARIOS ');	
	   
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
			WHERE USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||''')
			AND USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||''')';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.GRU_GRUPOS_USUARIOS...no se modifica nada.');
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' EN GRU_GRUPOS_USUARIOS');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
				(GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO) 
				SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||'''),
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_USU_GRU(2))||'''),
				''REM_F2_GEST'',SYSDATE,	0 FROM DUAL';
				
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_USU_GRU(2)) ||''' INSERTADO CORRECTAMENTE EN GRU_GRUPOS_USUARIOS');
			
		END IF;

	   DBMS_OUTPUT.PUT_LINE('');
       
    END LOOP;
 

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
   

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



   