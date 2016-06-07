--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160606
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1117
--## PRODUCTO=NO
--## Finalidad: DML Insert registros en MTC_MAPEO_TIPO_CONTENEDOR
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
    	T_FUNCION('RSANSU','PR-01-ACUI-07'),
		T_FUNCION('RSAR','PR-01-ACUI-16'),
		T_FUNCION('RSARSI','PR-01-ACUI-17'),
		T_FUNCION('EOH','PR-01-ALEG-34'),
		T_FUNCION('CCH','PR-01-CERJ-62'),
		T_FUNCION('EJUZTBS','PR-01-COMU-59'),
		T_FUNCION('CALHAC','PR-01-DEAC-11'),
		T_FUNCION('COAPH','PR-01-DEAC-12'),
		T_FUNCION('DJP','PR-01-DOCA-41'),
		T_FUNCION('DJL','PR-01-DOCA-42'),
		T_FUNCION('ACS','PR-01-DOCJ-29'),
		T_FUNCION('AAC','PR-01-DOCJ-31'),
		T_FUNCION('ADEH','PR-01-DOCJ-36'),
		T_FUNCION('DTC','PR-01-DOCJ-42'),
		T_FUNCION('DSSDA','PR-01-DOCJ-43'),
		T_FUNCION('DSCC','PR-01-DOCJ-44'),
		T_FUNCION('ESRAS','PR-01-DOCJ-50'),
		T_FUNCION('ECM','PR-01-DOCJ-51'),
		T_FUNCION('EIC','PR-01-DOCJ-53'),
		T_FUNCION('EII','PR-01-DOCJ-54'),
		T_FUNCION('EDH','PR-01-DOCJ-57'),
		T_FUNCION('ESADJ','PR-01-DOCJ-63'),
		T_FUNCION('MCC','PR-01-DOCJ-64'),
		T_FUNCION('MP','PR-01-DOCJ-66'),
		T_FUNCION('TITINSC','PR-01-DOCJ-70'),
		T_FUNCION('EDCINR','PR-01-ESCR-27'),
		T_FUNCION('EPSSE','PR-01-ESCR-28'),
		T_FUNCION('DUEDIL','PR-01-ESIN-93'),
		T_FUNCION('HCI','PR-01-ESIN-94'),
		T_FUNCION('ISP','PR-01-ESIN-97'),
		T_FUNCION('INS','PR-01-ESIN-98'),
		T_FUNCION('INSL','PR-01-ESIN-99'),
		T_FUNCION('ILCRLM','PR-01-ESIN-AD'),
		T_FUNCION('INFFIS','PR-01-ESIN-AE'),
		T_FUNCION('RCT','PR-01-ESIN-AI'),
		T_FUNCION('DPRCD','PR-01-INRG-09'),
		T_FUNCION('PCCSC','PR-01-PRPE-27'),
		T_FUNCION('PRI','PR-01-PRPE-28'),
		T_FUNCION('PSFDUL','PR-01-PRPE-31'),
		T_FUNCION('RECGES','PR-01-PRPE-33'),
		T_FUNCION('RECIGEST','PR-01-PRPE-34'),
		T_FUNCION('RSIND','PR-01-PRPE-35'),
		T_FUNCION('FSSB','PR-01-PRPI-20'),
		T_FUNCION('FSSF','PR-01-PRPI-21'),
		T_FUNCION('PSSB','PR-01-PRPI-22'),
		T_FUNCION('DECRADJ','PR-01-SERE-40'),
		T_FUNCION('DFA','PR-01-SERE-41'),
		T_FUNCION('REM','PR-01-SERE-47'),
		T_FUNCION('REOC','PR-01-SERE-48'),
		T_FUNCION('REI','PR-01-SERE-51'),
		T_FUNCION('TIRNR','PR-01-SERE-56'),
		T_FUNCION('TAB','PR-01-TASA-14'),
		T_FUNCION('TJC','PR-01-TASA-16'),
		T_FUNCION('RSANSU','PR-02-ACUI-07'),
		T_FUNCION('RSAR','PR-02-ACUI-16'),
		T_FUNCION('RSARSI','PR-02-ACUI-17'),
		T_FUNCION('EOETJ','PR-02-ALEG-32'),
		T_FUNCION('EOETNJ','PR-02-ALEG-33'),
		T_FUNCION('ELAA','PR-02-ALEG-39'),
		T_FUNCION('EIETJ','PR-02-ALEG-40'),
		T_FUNCION('CCB','PR-02-CERJ-63'),
		T_FUNCION('POL','PR-02-CNCV-62'),
		T_FUNCION('EJUZTBS','PR-02-COMU-59'),
		T_FUNCION('CALHAC','PR-02-DEAC-11'),
		T_FUNCION('COAPH','PR-02-DEAC-12'),
		T_FUNCION('DJP','PR-02-DOCA-41'),
		T_FUNCION('DJL','PR-02-DOCA-42'),
		T_FUNCION('AAEEE','PR-02-DOCA-43'),
		T_FUNCION('ACPCARDP','PR-02-DOCJ-28'),
		T_FUNCION('ACS','PR-02-DOCJ-29'),
		T_FUNCION('ACUENTDP','PR-02-DOCJ-30'),
		T_FUNCION('AAC','PR-02-DOCJ-31'),
		T_FUNCION('ARETJ','PR-02-DOCJ-32'),
		T_FUNCION('ADETJ','PR-02-DOCJ-34'),
		T_FUNCION('ADETNJ','PR-02-DOCJ-35'),
		T_FUNCION('AVPR','PR-02-DOCJ-41'),
		T_FUNCION('DTC','PR-02-DOCJ-42'),
		T_FUNCION('DSSDA','PR-02-DOCJ-43'),
		T_FUNCION('DSO','PR-02-DOCJ-46'),
		T_FUNCION('DREP','PR-02-DOCJ-48'),
		T_FUNCION('RAP','PR-02-DOCJ-49'),
		T_FUNCION('ESRAS','PR-02-DOCJ-50'),
		T_FUNCION('ECM','PR-02-DOCJ-51'),
		T_FUNCION('EIC','PR-02-DOCJ-53'),
		T_FUNCION('EII','PR-02-DOCJ-54'),
		T_FUNCION('EDTJ','PR-02-DOCJ-56'),
		T_FUNCION('ENES','PR-02-DOCJ-58'),
		T_FUNCION('EPME','PR-02-DOCJ-59'),
		T_FUNCION('ESADJ','PR-02-DOCJ-63'),
		T_FUNCION('MCC','PR-02-DOCJ-64'),
		T_FUNCION('MEMB','PR-02-DOCJ-65'),
		T_FUNCION('MP','PR-02-DOCJ-66'),
		T_FUNCION('REREVC','PR-02-DOCJ-68'),
		T_FUNCION('TITINSC','PR-02-DOCJ-70'),
		T_FUNCION('EDCINR','PR-02-ESCR-27'),
		T_FUNCION('EPSSE','PR-02-ESCR-28'),
		T_FUNCION('DRO','PR-02-ESIN-92'),
		T_FUNCION('DUEDIL','PR-02-ESIN-93'),
		T_FUNCION('HCI','PR-02-ESIN-94'),
		T_FUNCION('ISP','PR-02-ESIN-97'),
		T_FUNCION('INS','PR-02-ESIN-98'),
		T_FUNCION('INSL','PR-02-ESIN-99'),
		T_FUNCION('ILCRLM','PR-02-ESIN-AD'),
		T_FUNCION('INFFIS','PR-02-ESIN-AE'),
		T_FUNCION('RCT','PR-02-ESIN-AI'),
		T_FUNCION('DPRCD','PR-02-INRG-09'),
		T_FUNCION('PCCSC','PR-02-PRPE-27'),
		T_FUNCION('PRI','PR-02-PRPE-28'),
		T_FUNCION('PSFDUL','PR-02-PRPE-31'),
		T_FUNCION('RECGES','PR-02-PRPE-33'),
		T_FUNCION('RECIGEST','PR-02-PRPE-34'),
		T_FUNCION('RSIND','PR-02-PRPE-35'),
		T_FUNCION('FSSB','PR-02-PRPI-20'),
		T_FUNCION('FSSF','PR-02-PRPI-21'),
		T_FUNCION('PSSB','PR-02-PRPI-22'),
		T_FUNCION('DECRADJ','PR-02-SERE-40'),
		T_FUNCION('DFA','PR-02-SERE-41'),
		T_FUNCION('RETNJ','PR-02-SERE-45'),
		T_FUNCION('REME','PR-02-SERE-46'),
		T_FUNCION('REM','PR-02-SERE-47'),
		T_FUNCION('REOC','PR-02-SERE-48'),
		T_FUNCION('REI','PR-02-SERE-51'),
		T_FUNCION('TAB','PR-02-TASA-14'),
		T_FUNCION('TVAPJ','PR-02-TASA-15'),
		T_FUNCION('TJC','PR-02-TASA-16'),
		T_FUNCION('EOO','PR-03-ALEG-36'),
		T_FUNCION('AAC','PR-03-DOCJ-31'),
		T_FUNCION('ADEO','PR-03-DOCJ-38'),
		T_FUNCION('DTC','PR-03-DOCJ-42'),
		T_FUNCION('DSO','PR-03-DOCJ-46'),
		T_FUNCION('EIC','PR-03-DOCJ-53'),
		T_FUNCION('EII','PR-03-DOCJ-54'),
		T_FUNCION('DRO','PR-03-ESIN-92'),
		T_FUNCION('HCI','PR-03-ESIN-94'),
		T_FUNCION('REO','PR-03-SERE-52'),
		T_FUNCION('TJC','PR-03-TASA-16'),
		T_FUNCION('AAC','PR-04-DOCJ-31'),
		T_FUNCION('DTC','PR-04-DOCJ-42'),
		T_FUNCION('DSO','PR-04-DOCJ-46'),
		T_FUNCION('EIC','PR-04-DOCJ-53'),
		T_FUNCION('EII','PR-04-DOCJ-54'),
		T_FUNCION('TJC','PR-04-TASA-16'),
		T_FUNCION('EOM','PR-05-ALEG-35'),
		T_FUNCION('AAC','PR-05-DOCJ-31'),
		T_FUNCION('ADEM','PR-05-DOCJ-37'),
		T_FUNCION('DTC','PR-05-DOCJ-42'),
		T_FUNCION('DSO','PR-05-DOCJ-46'),
		T_FUNCION('EIC','PR-05-DOCJ-53'),
		T_FUNCION('EII','PR-05-DOCJ-54'),
		T_FUNCION('REI','PR-05-SERE-51'),
		T_FUNCION('TJC','PR-05-TASA-16'),
		T_FUNCION('AAC','PR-06-DOCJ-31'),
		T_FUNCION('ADEC','PR-06-DOCJ-33'),
		T_FUNCION('ARPEP','PR-06-DOCJ-40'),
		T_FUNCION('DTC','PR-06-DOCJ-42'),
		T_FUNCION('DSO','PR-06-DOCJ-46'),
		T_FUNCION('EIC','PR-06-DOCJ-53'),
		T_FUNCION('EII','PR-06-DOCJ-54'),
		T_FUNCION('REC','PR-06-SERE-43'),
		T_FUNCION('REI','PR-06-SERE-51'),
		T_FUNCION('TJC','PR-06-TASA-16'),
		T_FUNCION('AAC','PR-07-DOCJ-31'),
		T_FUNCION('ADEV','PR-07-DOCJ-39'),
		T_FUNCION('DTC','PR-07-DOCJ-42'),
		T_FUNCION('DSO','PR-07-DOCJ-46'),
		T_FUNCION('EIC','PR-07-DOCJ-53'),
		T_FUNCION('EII','PR-07-DOCJ-54'),
		T_FUNCION('REI','PR-07-SERE-51'),
		T_FUNCION('REVM','PR-07-SERE-53'),
		T_FUNCION('REV','PR-07-SERE-54'),
		T_FUNCION('TJC','PR-07-TASA-16'),
		T_FUNCION('RSANSU','PR-08-ACUI-07'),
		T_FUNCION('RSAR','PR-08-ACUI-16'),
		T_FUNCION('RSARSI','PR-08-ACUI-17'),
		T_FUNCION('EOETJ','PR-08-ALEG-32'),
		T_FUNCION('EOETNJ','PR-08-ALEG-33'),
		T_FUNCION('EOH','PR-08-ALEG-34'),
		T_FUNCION('ELAA','PR-08-ALEG-39'),
		T_FUNCION('EIETJ','PR-08-ALEG-40'),
		T_FUNCION('JUSPG','PR-08-CERA-59'),
		T_FUNCION('CCH','PR-08-CERJ-62'),
		T_FUNCION('CCB','PR-08-CERJ-63'),
		T_FUNCION('EJUZTBS','PR-08-COMU-59'),
		T_FUNCION('CALHAC','PR-08-DEAC-11'),
		T_FUNCION('COAPH','PR-08-DEAC-12'),
		T_FUNCION('DJP','PR-08-DOCA-41'),
		T_FUNCION('DJL','PR-08-DOCA-42'),
		T_FUNCION('AAEEE','PR-08-DOCA-43'),
		T_FUNCION('ACS','PR-08-DOCJ-29'),
		T_FUNCION('AAC','PR-08-DOCJ-31'),
		T_FUNCION('ARETJ','PR-08-DOCJ-32'),
		T_FUNCION('ADETJ','PR-08-DOCJ-34'),
		T_FUNCION('ADETNJ','PR-08-DOCJ-35'),
		T_FUNCION('ADEH','PR-08-DOCJ-36'),
		T_FUNCION('AVPR','PR-08-DOCJ-41'),
		T_FUNCION('DTC','PR-08-DOCJ-42'),
		T_FUNCION('DSSDA','PR-08-DOCJ-43'),
		T_FUNCION('ESRAS','PR-08-DOCJ-50'),
		T_FUNCION('ECM','PR-08-DOCJ-51'),
		T_FUNCION('EIC','PR-08-DOCJ-53'),
		T_FUNCION('EII','PR-08-DOCJ-54'),
		T_FUNCION('EDTJ','PR-08-DOCJ-56'),
		T_FUNCION('EDH','PR-08-DOCJ-57'),
		T_FUNCION('EPME','PR-08-DOCJ-59'),
		T_FUNCION('ESCPRJUZ','PR-08-DOCJ-60'),
		T_FUNCION('ESADJ','PR-08-DOCJ-63'),
		T_FUNCION('MCC','PR-08-DOCJ-64'),
		T_FUNCION('MP','PR-08-DOCJ-66'),
		T_FUNCION('TITINSC','PR-08-DOCJ-70'),
		T_FUNCION('DUEDIL','PR-08-ESIN-93'),
		T_FUNCION('HCI','PR-08-ESIN-94'),
		T_FUNCION('ISP','PR-08-ESIN-97'),
		T_FUNCION('INS','PR-08-ESIN-98'),
		T_FUNCION('INSL','PR-08-ESIN-99'),
		T_FUNCION('ILCRLM','PR-08-ESIN-AD'),
		T_FUNCION('INFFIS','PR-08-ESIN-AE'),
		T_FUNCION('RCT','PR-08-ESIN-AI'),
		T_FUNCION('DPRCD','PR-08-INRG-09'),
		T_FUNCION('PCCSC','PR-08-PRPE-27'),
		T_FUNCION('PRI','PR-08-PRPE-28'),
		T_FUNCION('PSFDUL','PR-08-PRPE-31'),
		T_FUNCION('RECGES','PR-08-PRPE-33'),
		T_FUNCION('RECIGEST','PR-08-PRPE-34'),
		T_FUNCION('RSIND','PR-08-PRPE-35'),
		T_FUNCION('FSSB','PR-08-PRPI-20'),
		T_FUNCION('FSSF','PR-08-PRPI-21'),
		T_FUNCION('PSSB','PR-08-PRPI-22'),
		T_FUNCION('DECRADJ','PR-08-SERE-40'),
		T_FUNCION('DFA','PR-08-SERE-41'),
		T_FUNCION('REM','PR-08-SERE-47'),
		T_FUNCION('REOC','PR-08-SERE-48'),
		T_FUNCION('REI','PR-08-SERE-51'),
		T_FUNCION('TIRNR','PR-08-SERE-56'),
		T_FUNCION('TAB','PR-08-TASA-14'),
		T_FUNCION('TVAPJ','PR-08-TASA-15'),
		T_FUNCION('TJC','PR-08-TASA-16'),
		T_FUNCION('RSANSU','PR-09-ACUI-07'),
		T_FUNCION('RSCOPR','PR-09-ACUI-08'),
		T_FUNCION('RSFSCO','PR-09-ACUI-09'),
		T_FUNCION('RSISDI','PR-09-ACUI-10'),
		T_FUNCION('RSINFC','PR-09-ACUI-11'),
		T_FUNCION('RSINPA','PR-09-ACUI-12'),
		T_FUNCION('RSIPAC','PR-09-ACUI-13'),
		T_FUNCION('RSPRAL','PR-09-ACUI-14'),
		T_FUNCION('RSPPAL','PR-09-ACUI-15'),
		T_FUNCION('RSAR','PR-09-ACUI-16'),
		T_FUNCION('RSARSI','PR-09-ACUI-17'),
		T_FUNCION('ESALEG','PR-09-ALEG-30'),
		T_FUNCION('EODI','PR-09-ALEG-31'),
		T_FUNCION('EORC','PR-09-ALEG-37'),
		T_FUNCION('EOSC','PR-09-ALEG-38'),
		T_FUNCION('REAFC','PR-09-ALEG-41'),
		T_FUNCION('JUSPG','PR-09-CERA-59'),
		T_FUNCION('EJUZTBS','PR-09-COMU-59'),
		T_FUNCION('CALHAC','PR-09-DEAC-11'),
		T_FUNCION('COAPH','PR-09-DEAC-12'),
		T_FUNCION('DJP','PR-09-DOCA-41'),
		T_FUNCION('DJL','PR-09-DOCA-42'),
		T_FUNCION('ACS','PR-09-DOCJ-29'),
		T_FUNCION('AAC','PR-09-DOCJ-31'),
		T_FUNCION('DTC','PR-09-DOCJ-42'),
		T_FUNCION('DSSDA','PR-09-DOCJ-43'),
		T_FUNCION('DEINC','PR-09-DOCJ-45'),
		T_FUNCION('DJAC','PR-09-DOCJ-47'),
		T_FUNCION('ESRAS','PR-09-DOCJ-50'),
		T_FUNCION('ECM','PR-09-DOCJ-51'),
		T_FUNCION('ECC','PR-09-DOCJ-52'),
		T_FUNCION('ESI','PR-09-DOCJ-55'),
		T_FUNCION('ESCPRJUZ','PR-09-DOCJ-60'),
		T_FUNCION('ESSORE','PR-09-DOCJ-61'),
		T_FUNCION('ESCJUZ','PR-09-DOCJ-62'),
		T_FUNCION('ESADJ','PR-09-DOCJ-63'),
		T_FUNCION('MCC','PR-09-DOCJ-64'),
		T_FUNCION('MP','PR-09-DOCJ-66'),
		T_FUNCION('P5BIS','PR-09-DOCJ-67'),
		T_FUNCION('TDAC','PR-09-DOCJ-69'),
		T_FUNCION('TITINSC','PR-09-DOCJ-70'),
		T_FUNCION('DUEDIL','PR-09-ESIN-93'),
		T_FUNCION('IACPAC','PR-09-ESIN-95'),
		T_FUNCION('INFAC','PR-09-ESIN-96'),
		T_FUNCION('ISP','PR-09-ESIN-97'),
		T_FUNCION('INS','PR-09-ESIN-98'),
		T_FUNCION('INSL','PR-09-ESIN-99'),
		T_FUNCION('INACPC','PR-09-ESIN-AA'),
		T_FUNCION('INFLETRADO','PR-09-ESIN-AB'),
		T_FUNCION('INFLFL','PR-09-ESIN-AC'),
		T_FUNCION('ILCRLM','PR-09-ESIN-AD'),
		T_FUNCION('INFFIS','PR-09-ESIN-AE'),
		T_FUNCION('IPAC','PR-09-ESIN-AF'),
		T_FUNCION('INFTC','PR-09-ESIN-AG'),
		T_FUNCION('INFVL','PR-09-ESIN-AH'),
		T_FUNCION('RCT','PR-09-ESIN-AI'),
		T_FUNCION('MINUTA','PR-09-FACT-18'),
		T_FUNCION('DPRCD','PR-09-INRG-09'),
		T_FUNCION('NOSI','PR-09-NOTS-02'),
		T_FUNCION('OCO','PR-09-OTRO-01'),
		T_FUNCION('OTR','PR-09-OTRO-02'),
		T_FUNCION('PRAC','PR-09-PRPE-25'),
		T_FUNCION('PCTER','PR-09-PRPE-26'),
		T_FUNCION('PCCSC','PR-09-PRPE-27'),
		T_FUNCION('PRI','PR-09-PRPE-28'),
		T_FUNCION('PREPCO','PR-09-PRPE-29'),
		T_FUNCION('PSFDUC','PR-09-PRPE-30'),
		T_FUNCION('PSUDUL','PR-09-PRPE-32'),
		T_FUNCION('RECGES','PR-09-PRPE-33'),
		T_FUNCION('RECIGEST','PR-09-PRPE-34'),
		T_FUNCION('RSIND','PR-09-PRPE-35'),
		T_FUNCION('FSSB','PR-09-PRPI-20'),
		T_FUNCION('FSSF','PR-09-PRPI-21'),
		T_FUNCION('PSSB','PR-09-PRPI-22'),
		T_FUNCION('PSUSB','PR-09-PRPI-23'),
		T_FUNCION('AACO','PR-09-SERE-31'),
		T_FUNCION('AACONV','PR-09-SERE-32'),
		T_FUNCION('AULIQUI','PR-09-SERE-33'),
		T_FUNCION('ADCO','PR-09-SERE-34'),
		T_FUNCION('ASDJM','PR-09-SERE-35'),
		T_FUNCION('AUTORF','PR-09-SERE-36'),
		T_FUNCION('AREDI','PR-09-SERE-37'),
		T_FUNCION('AUTORE','PR-09-SERE-38'),
		T_FUNCION('CNAUAP','PR-09-SERE-39'),
		T_FUNCION('DECRADJ','PR-09-SERE-40'),
		T_FUNCION('DFA','PR-09-SERE-41'),
		T_FUNCION('RECA','PR-09-SERE-42'),
		T_FUNCION('REDIT','PR-09-SERE-44'),
		T_FUNCION('REM','PR-09-SERE-47'),
		T_FUNCION('REOC','PR-09-SERE-48'),
		T_FUNCION('REAC','PR-09-SERE-49'),
		T_FUNCION('REFC','PR-09-SERE-50'),
		T_FUNCION('REI','PR-09-SERE-51'),
		T_FUNCION('REACHA','PR-09-SERE-55'),
		T_FUNCION('TIRNR','PR-09-SERE-56'),
		T_FUNCION('TAB','PR-09-TASA-14'),
		T_FUNCION('EDCINR','PR-01-ESCR-27'),
		T_FUNCION('EPSSE','PR-01-ESCR-28'),
		T_FUNCION('PSFDUC','PR-09-PRPE-30'),
		T_FUNCION('DSCC','PR-06-DOCJ-46'),
		T_FUNCION('DSCC','PR-02-DOCJ-46'),
		T_FUNCION('DSCC','PR-02-DOCJ-46'),
		T_FUNCION('EDM','PR-05-DOCJ-46'),
		T_FUNCION('EDO','PR-03-DOCJ-46'),
		T_FUNCION('EDV','PR-07-DOCJ-46'),
		T_FUNCION('OEJ','PR-01-OTRO-03'),
		T_FUNCION('OEJ','PR-02-OTRO-03'),
		T_FUNCION('OEJ','PR-02-OTRO-03'),
		T_FUNCION('O03','PR-03-OTRO-02'),
		T_FUNCION('ODE','PR-03-OTRO-04'),
		T_FUNCION('ODE','PR-05-OTRO-04'),
		T_FUNCION('EDC','PR-06-DOCJ-71'),
		T_FUNCION('EDCO','PR-06-DOCJ-72'),
		T_FUNCION('OEJ','PR-06-OTRO-03'),
		T_FUNCION('ODE','PR-07-OTRO-04'),
		T_FUNCION('INFTAVA','PR-08-ESIN-AJ'),
		T_FUNCION('NOSI','PR-08-NOTS-02'),
		T_FUNCION('OAP','PR-08-OTRO-05'),
		T_FUNCION('CON','PR-09-DOCJ-73'),
		T_FUNCION('CON','PR-09-DOCJ-73'),
		T_FUNCION('ESC','PR-09-ESCR-29'),
		T_FUNCION('ESC','PR-09-ESCR-29'),
		T_FUNCION('EXT','PR-09-DOCJ-74'),
		T_FUNCION('EXT','PR-09-DOCJ-74'),
		T_FUNCION('LIC','PR-09-SERE-57'),
		T_FUNCION('LIC','PR-09-SERE-57'),
		T_FUNCION('PBOE','PR-09-DOCJ-75'),
		T_FUNCION('PBOE','PR-09-DOCJ-75'),
		T_FUNCION('POL','PR-09-CNCV-62'),
		T_FUNCION('POL','PR-09-CNCV-62'),
		T_FUNCION('RSPCCA','PR-09-ACUI-20'),
		T_FUNCION('RSPCCA','PR-09-ACUI-20'),
		T_FUNCION('CEHE','PR-13-ESCR-29'),
		T_FUNCION('RPFDE','PR-13-DOCJ-71'),
		T_FUNCION('ANLS','PR-13-DOCJ-72'),
		T_FUNCION('CEEAN','PR-13-CERJ-69'),
		T_FUNCION('CVIP','PR-13-CERJ-70'),
		T_FUNCION('EDPIN','PR-13-CERA-60'),
		T_FUNCION('CSH','PR-13-CERJ-71'),
		T_FUNCION('NSE','PR-13-NOTS-03'),
		T_FUNCION('ANDPP','PR-13-DOCJ-73'),
		T_FUNCION('ACPSAREB','PR-13-DOCJ-74'),
		T_FUNCION('NSISE','PR-13-NOTS-02'),
		T_FUNCION('PSTRCE','PR-13-DOCJ-75'),
		T_FUNCION('CCAN','PR-13-CERJ-72'),
		T_FUNCION('AC218','PR-13-DOCJ-76'),
		T_FUNCION('ECDRE','PR-13-DOCJ-77'),
		T_FUNCION('EDPI','PR-13-DOCJ-78'),
		T_FUNCION('PROTN','PR-13-DOCJ-79'),
		T_FUNCION('TTEPPM','PR-13-DOCJ-80'),
		T_FUNCION('CLD','PR-13-CERJ-73'),
		T_FUNCION('ICP','PR-13-ESIN-AJ'),
		T_FUNCION('CS','PR-13-CERJ-74'),
		T_FUNCION('OEJ','PR-01-OTRO-03'),
		T_FUNCION('OEJ','PR-02-OTRO-03'),
		T_FUNCION('OEJ','PR-02-OTRO-03'),
		T_FUNCION('O03','PR-03-OTRO-02'),
		T_FUNCION('ODE','PR-03-OTRO-04'),
		T_FUNCION('ODE','PR-05-OTRO-04'),
		T_FUNCION('EDC','PR-06-DOCJ-71'),
		T_FUNCION('EDCO','PR-06-DOCJ-72'),
		T_FUNCION('OEJ','PR-06-OTRO-03'),
		T_FUNCION('ODE','PR-07-OTRO-04'),
		T_FUNCION('INFTAVA','PR-08-ESIN-AJ'),
		T_FUNCION('NOSI','PR-08-NOTS-02'),
		T_FUNCION('OAP','PR-08-OTRO-05'),
		T_FUNCION('CON','PR-09-DOCJ-73'),
		T_FUNCION('CON','PR-09-DOCJ-73'),
		T_FUNCION('ESC','PR-09-ESCR-29'),
		T_FUNCION('ESC','PR-09-ESCR-29'),
		T_FUNCION('EXT','PR-09-DOCJ-74'),
		T_FUNCION('EXT','PR-09-DOCJ-74'),
		T_FUNCION('LIC','PR-09-SERE-57'),
		T_FUNCION('LIC','PR-09-SERE-57'),
		T_FUNCION('PBOE','PR-09-DOCJ-75'),
		T_FUNCION('PBOE','PR-09-DOCJ-75'),
		T_FUNCION('POL','PR-09-CNCV-62'),
		T_FUNCION('POL','PR-09-CNCV-62'),
		T_FUNCION('RSPCCA','PR-09-ACUI-20'),
		T_FUNCION('RSPCCA','PR-09-ACUI-20'),
		T_FUNCION('DCSU','PR-01-DOCJ-84'),
		T_FUNCION('DCSU','PR-09-DOCJ-84'),
		T_FUNCION('DO','PR-01-DOCJ-85'),
		T_FUNCION('DO','PR-09-DOCJ-85'),
		T_FUNCION('ESSU','PR-01-DOCJ-86'),
		T_FUNCION('ESSU','PR-09-DOCJ-86'),
		T_FUNCION('ICP','PR-13-ESIN-AJ'),
		T_FUNCION('INSREGPCO','PR-13-INRG-10'),
		T_FUNCION('O03','PR-13-OTRO-06'),
		T_FUNCION('PPSBOE','PR-01-DOCJ-83'),
		T_FUNCION('PPSBOE','PR-09-DOCJ-83'),
		T_FUNCION('PTSU','PR-01-OTRO-03'),
		T_FUNCION('PTSU','PR-09-CERJ-79')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    --Activamos el borrado lógico de los registros actuales, luego se activar si esta en el listado.
    V_SQL := 'UPDATE '||V_ESQUEMA||'.MTC_MAPEO_TIPO_CONTENEDOR SET BORRADO = 1, USUARIOBORRAR =''PRODUCTO-1117'', FECHABORRAR = sysdate where BORRADO=0';
    EXECUTE IMMEDIATE V_SQL;
    

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        -- INSERTANDO EN MTT_MAP_ADJRECOVERY_ADJCM

        IF V_NUM_TABLAS > 0 THEN   
        
            V_SQL_ID := 'SELECT DD_TFA_ID FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
        	EXECUTE IMMEDIATE V_SQL_ID INTO V_TFA_ID;
        	
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MTC_MAPEO_TIPO_CONTENEDOR WHERE DD_TFA_ID = '''||V_TFA_ID||''' AND MTC_TDN2_CODIGO='''||TRIM(V_TMP_FUNCION(2))||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        	
        	IF V_NUM_TABLAS = 0 THEN
        	
        			V_SQL_NEXT_ID := 'SELECT '|| V_ESQUEMA ||'.S_MTC_MAPEO_TIPO_CONTENEDOR.NEXTVAL FROM DUAL';
        			EXECUTE IMMEDIATE V_SQL_NEXT_ID INTO V_NEXT_ID;
        	  
        	  		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.MTC_MAPEO_TIPO_CONTENEDOR (' ||
              		'MTC_ID, DD_TFA_ID, MTC_TDN2_CODIGO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
              		'VALUES ('||V_NEXT_ID||','||V_TFA_ID||','''||TRIM(V_TMP_FUNCION(2))||''', 0, ''PRODUCTO-1117'',SYSDATE,0)';
              
               		DBMS_OUTPUT.PUT_LINE('INSERTANDO: en MTC_MAPEO_TIPO_CONTENEDOR datos: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
          	   		EXECUTE IMMEDIATE V_MSQL;
          	ELSE
          	
          		    DBMS_OUTPUT.PUT_LINE('YA EXISTE en MTC_MAPEO_TIPO_CONTENEDOR, Actualizando los datos: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
          			V_MSQL := 'UPDATE '||V_ESQUEMA||'.MTC_MAPEO_TIPO_CONTENEDOR SET BORRADO = 0, USUARIOMODIFICAR =''PRODUCTO-1117'', FECHAMODIFICAR = sysdate, USUARIOBORRAR=NULL, FECHABORRAR=NULL '||
          						'WHERE DD_TFA_ID = '''||V_TFA_ID||''' AND MTC_TDN2_CODIGO='''||TRIM(V_TMP_FUNCION(2))||'''';
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
