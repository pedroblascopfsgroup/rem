--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190603
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4353
--## PRODUCTO=NO
--##
--## Finalidad: Script que corrige codigos de tarifa de Apple
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
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4353'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    DD_TTF_CODIGO VARCHAR2(30 CHAR);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
            T_JBV('AP-OM1','OM1'),
            T_JBV('AP-VER1','VER1'),
            T_JBV('AP-OM3','OM3'),
            T_JBV('AP-OM4','OM4'),
            T_JBV('AP-OM5','OM5'),
            T_JBV('AP-OM6','OM6'),
            T_JBV('AP-OM7','OM7'),
            T_JBV('AP-OM8','OM8'),
            T_JBV('AP-OM9','OM9'),
            T_JBV('AP-OM10','OM10'),
            T_JBV('AP-OM11','OM11'),
            T_JBV('AP-OM12','OM12'),
            T_JBV('AP-OM13','OM13'),
            T_JBV('AP-OM14','OM14'),
            T_JBV('AP-OM15','OM15'),
            T_JBV('AP-OM16','OM16'),
            T_JBV('AP-OM17','OM17'),
            T_JBV('AP-OM18','OM18'),
            T_JBV('AP-OM19','OM19'),
            T_JBV('AP-OM20','OM20'),
            T_JBV('AP-OM21','OM21'),
            T_JBV('AP-OM22','OM22'),
            T_JBV('AP-OM23','OM23'),
            T_JBV('AP-OM24','OM24'),
            T_JBV('AP-OM25','OM25'),
            T_JBV('AP-OM26','OM26'),
            T_JBV('AP-OM27','OM27'),
            T_JBV('AP-OM28','OM28'),
            T_JBV('AP-OM29','OM29'),
            T_JBV('AP-OM30','OM30'),
            T_JBV('AP-OM31','OM31'),
            T_JBV('AP-OM32','OM32'),
            T_JBV('AP-OM33','OM33'),
            T_JBV('AP-OM34','OM34'),
            T_JBV('AP-OM35','OM35'),
            T_JBV('AP-OM36','OM36'),
            T_JBV('AP-OM37','OM37'),
            T_JBV('AP-OM38','OM38'),
            T_JBV('AP-OM40','OM40'),
            T_JBV('AP-OM41','OM41'),
            T_JBV('AP-OM42','OM42'),
            T_JBV('AP-OM43','OM43'),
            T_JBV('AP-OM44','OM44'),
            T_JBV('AP-OM45','OM45'),
            T_JBV('AP-OM46','OM46'),
            T_JBV('AP-OM47','OM47'),
            T_JBV('AP-OM48','OM48'),
            T_JBV('AP-OM49','OM49'),
            T_JBV('AP-OM50','OM50'),
            T_JBV('AP-OM51','OM51'),
            T_JBV('AP-OM52','OM52'),
            T_JBV('AP-OM53','OM53'),
            T_JBV('AP-OM54','OM54'),
            T_JBV('AP-OM55','OM55'),
            T_JBV('AP-OM56','OM56'),
            T_JBV('AP-OM57','OM57'),
            T_JBV('AP-OM58','OM58'),
            T_JBV('AP-OM59','OM59'),
            T_JBV('AP-OM60','OM60'),
            T_JBV('AP-OM61','OM61'),
            T_JBV('AP-OM62','OM62'),
            T_JBV('AP-OM63','OM63'),
            T_JBV('AP-OM64','OM64'),
            T_JBV('AP-OM65','OM65'),
            T_JBV('AP-OM66','OM66'),
            T_JBV('AP-OM67','OM67'),
            T_JBV('AP-OM68','OM68'),
            T_JBV('AP-OM69','OM69'),
            T_JBV('AP-OM70','OM70'),
            T_JBV('AP-OM71','OM71'),
            T_JBV('AP-OM72','OM72'),
            T_JBV('AP-OM73','OM73'),
            T_JBV('AP-OM74','OM74'),
            T_JBV('AP-OM75','OM75'),
            T_JBV('AP-OM39','OM39'),
            T_JBV('AP-OM76','OM76'),
            T_JBV('AP-OM77','OM77'),
            T_JBV('AP-OM78','OM78'),
            T_JBV('AP-OM79','OM79'),
            T_JBV('AP-OM80','OM80'),
            T_JBV('AP-OM81','OM81'),
            T_JBV('AP-OM82','OM82'),
            T_JBV('AP-OM83','OM83'),
            T_JBV('AP-OM84','OM84'),
            T_JBV('AP-OM85','OM85'),
            T_JBV('AP-OM86','OM86'),
            T_JBV('AP-OM87','OM87'),
            T_JBV('AP-OM88','OM88'),
            T_JBV('AP-OM322','OM322'),
            T_JBV('AP-OM323','OM323'),
            T_JBV('AP-OM324','OM324'),
            T_JBV('AP-OM325','OM325'),
            T_JBV('AP-OM326','OM326'),
            T_JBV('AP-OTR3','OTR3'),
            T_JBV('AP-OTR4','OTR4'),
            T_JBV('AP-OTR5','OTR5'),
            T_JBV('AP-OTR6','OTR6'),
            T_JBV('AP-OM331','OM331'),
            T_JBV('AP-OM332','OM332'),
            T_JBV('AP-OTR7','OTR7'),
            T_JBV('AP-OM334','OM334'),
            T_JBV('AP-OM335','OM335'),
            T_JBV('AP-OM336','OM336'),
            T_JBV('AP-OM337','OM337'),
            T_JBV('AP-OM338','OM338'),
            T_JBV('AP-OM339','OM339'),
            T_JBV('AP-OM340','OM340'),
            T_JBV('AP-OM341','OM341'),
            T_JBV('AP-OM342','OM342'),
            T_JBV('AP-OM343','OM343'),
            T_JBV('AP-OM344','OM344'),
            T_JBV('AP-OM345','OM345'),
            T_JBV('AP-OM346','OM346'),
            T_JBV('AP-OM347','OM347'),
            T_JBV('AP-OM348','OM348'),
            T_JBV('AP-CEE18','CEE18'),
            T_JBV('AP-CEE19','CEE19'),
            T_JBV('AP-CEE2','CEE2'),
            T_JBV('AP-CEE20','CEE20'),
            T_JBV('AP-CEE3','CEE3'),
            T_JBV('AP-CEE4','CEE4'),
            T_JBV('AP-CEE5','CEE5'),
            T_JBV('AP-CEE6','CEE6'),
            T_JBV('AP-CEE7','CEE7'),
            T_JBV('AP-CEE8','CEE8'),
            T_JBV('AP-CEE9','CEE9'),
            T_JBV('AP-OM349','OM349'),
            T_JBV('AP-OM350','OM350'),
            T_JBV('AP-BOL8','BOL8'),
            T_JBV('AP-OM352','OM352'),
            T_JBV('AP-OM353','OM353'),
            T_JBV('AP-OM354','OM354'),
            T_JBV('AP-OM355','OM355'),
            T_JBV('AP-OM356','OM356'),
            T_JBV('AP-OM357','OM357'),
            T_JBV('AP-OM358','OM358'),
            T_JBV('AP-OM359','OM359'),
            T_JBV('AP-OM360','OM360'),
            T_JBV('AP-OM361','OM361'),
            T_JBV('AP-OM362','OM362'),
            T_JBV('AP-OM363','OM363'),
            T_JBV('AP-OM364','OM364'),
            T_JBV('AP-OM365','OM365'),
            T_JBV('AP-OM366','OM366'),
            T_JBV('AP-OM367','OM367'),
            T_JBV('AP-OM368','OM368'),
            T_JBV('AP-BOL1','BOL1'),
            T_JBV('AP-BOL2','BOL2'),
            T_JBV('AP-BOL3','BOL3'),
            T_JBV('AP-OM372','OM372'),
            T_JBV('AP-OM373','OM373'),
            T_JBV('AP-OM374','OM374'),
            T_JBV('AP-OM375','OM375'),
            T_JBV('AP-OM376','OM376'),
            T_JBV('AP-OM377','OM377'),
            T_JBV('AP-OM378','OM378'),
            T_JBV('AP-OM379','OM379'),
            T_JBV('AP-OM380','OM380'),
            T_JBV('AP-OM381','OM381'),
            T_JBV('AP-OM382','OM382'),
            T_JBV('AP-OM383','OM383'),
            T_JBV('AP-OM384','OM384'),
            T_JBV('AP-OM385','OM385'),
            T_JBV('AP-OM386','OM386'),
            T_JBV('AP-OM387','OM387'),
            T_JBV('AP-OM388','OM388'),
            T_JBV('AP-OM389','OM389'),
            T_JBV('AP-OM390','OM390'),
            T_JBV('AP-CEE1','CEE1'),
            T_JBV('AP-CEE10','CEE10'),
            T_JBV('AP-CEE11','CEE11'),
            T_JBV('AP-CEE12','CEE12'),
            T_JBV('AP-CEE13','CEE13'),
            T_JBV('AP-CEE14','CEE14'),
            T_JBV('AP-CEE15','CEE15'),
            T_JBV('AP-CEE16','CEE16'),
            T_JBV('AP-CEE17','CEE17'),
            T_JBV('AP-OM89','OM89'),
            T_JBV('AP-OM90','OM90'),
            T_JBV('AP-OM91','OM91'),
            T_JBV('AP-OM92','OM92'),
            T_JBV('AP-OM93','OM93'),
            T_JBV('AP-OM94','OM94'),
            T_JBV('AP-OM95','OM95'),
            T_JBV('AP-OM96','OM96'),
            T_JBV('AP-OM97','OM97'),
            T_JBV('AP-OM98','OM98'),
            T_JBV('AP-OM99','OM99'),
            T_JBV('AP-OM100','OM100'),
            T_JBV('AP-OM101','OM101'),
            T_JBV('AP-OM102','OM102'),
            T_JBV('AP-OM103','OM103'),
            T_JBV('AP-OM104','OM104'),
            T_JBV('AP-OM105','OM105'),
            T_JBV('AP-OM106','OM106'),
            T_JBV('AP-OM107','OM107'),
            T_JBV('AP-OM108','OM108'),
            T_JBV('AP-OM109','OM109'),
            T_JBV('AP-OM110','OM110'),
            T_JBV('AP-OM111','OM111'),
            T_JBV('AP-OM112','OM112'),
            T_JBV('AP-OM113','OM113'),
            T_JBV('AP-OM114','OM114'),
            T_JBV('AP-OM115','OM115'),
            T_JBV('AP-OM116','OM116'),
            T_JBV('AP-OM117','OM117'),
            T_JBV('AP-OM118','OM118'),
            T_JBV('AP-OM119','OM119'),
            T_JBV('AP-OM120','OM120'),
            T_JBV('AP-OM121','OM121'),
            T_JBV('AP-OM122','OM122'),
            T_JBV('AP-OM123','OM123'),
            T_JBV('AP-OM124','OM124'),
            T_JBV('AP-OM125','OM125'),
            T_JBV('AP-OM126','OM126'),
            T_JBV('AP-OM127','OM127'),
            T_JBV('AP-OM128','OM128'),
            T_JBV('AP-OM129','OM129'),
            T_JBV('AP-OM130','OM130'),
            T_JBV('AP-OM131','OM131'),
            T_JBV('AP-OM132','OM132'),
            T_JBV('AP-OM133','OM133'),
            T_JBV('AP-OM134','OM134'),
            T_JBV('AP-OM135','OM135'),
            T_JBV('AP-OM137','OM137'),
            T_JBV('AP-OM138','OM138'),
            T_JBV('AP-CM-CER1','CM-CER1'),
            T_JBV('AP-CM-CER2','CM-CER2'),
            T_JBV('AP-CM-CER3','CM-CER3'),
            T_JBV('AP-CM-CER4','CM-CER4'),
            T_JBV('AP-CM-CER5','CM-CER5'),
            T_JBV('AP-CM-CER6','CM-CER6'),
            T_JBV('AP-OM145','OM145'),
            T_JBV('AP-OM146','OM146'),
            T_JBV('AP-OM147','OM147'),
            T_JBV('AP-OM148','OM148'),
            T_JBV('AP-OM149','OM149'),
            T_JBV('AP-OM150','OM150'),
            T_JBV('AP-OM151','OM151'),
            T_JBV('AP-OM152','OM152'),
            T_JBV('AP-OM153','OM153'),
            T_JBV('AP-OM154','OM154'),
            T_JBV('AP-OM155','OM155'),
            T_JBV('AP-OM156','OM156'),
            T_JBV('AP-OM157','OM157'),
            T_JBV('AP-OM136','OM136'),
            T_JBV('AP-OM158','OM158'),
            T_JBV('AP-OM159','OM159'),
            T_JBV('AP-OM160','OM160'),
            T_JBV('AP-OM161','OM161'),
            T_JBV('AP-OM162','OM162'),
            T_JBV('AP-OM163','OM163'),
            T_JBV('AP-OM164','OM164'),
            T_JBV('AP-OM165','OM165'),
            T_JBV('AP-OM166','OM166'),
            T_JBV('AP-OM167','OM167'),
            T_JBV('AP-OM168','OM168'),
            T_JBV('AP-OM169','OM169'),
            T_JBV('AP-OM170','OM170'),
            T_JBV('AP-OM171','OM171'),
            T_JBV('AP-OM172','OM172'),
            T_JBV('AP-OM173','OM173'),
            T_JBV('AP-OM174','OM174'),
            T_JBV('AP-OM175','OM175'),
            T_JBV('AP-OM176','OM176'),
            T_JBV('AP-OM177','OM177'),
            T_JBV('AP-OM178','OM178'),
            T_JBV('AP-OM179','OM179'),
            T_JBV('AP-OM180','OM180'),
            T_JBV('AP-OM181','OM181'),
            T_JBV('AP-OM182','OM182'),
            T_JBV('AP-OM183','OM183'),
            T_JBV('AP-OM184','OM184'),
            T_JBV('AP-OM185','OM185'),
            T_JBV('AP-OM186','OM186'),
            T_JBV('AP-OM187','OM187'),
            T_JBV('AP-OM188','OM188'),
            T_JBV('AP-OM189','OM189'),
            T_JBV('AP-OM190','OM190'),
            T_JBV('AP-OM191','OM191'),
            T_JBV('AP-OM192','OM192'),
            T_JBV('AP-OM193','OM193'),
            T_JBV('AP-OM194','OM194'),
            T_JBV('AP-OM195','OM195'),
            T_JBV('AP-OM196','OM196'),
            T_JBV('AP-OM197','OM197'),
            T_JBV('AP-OM198','OM198'),
            T_JBV('AP-OM199','OM199'),
            T_JBV('AP-OM200','OM200'),
            T_JBV('AP-OM201','OM201'),
            T_JBV('AP-OM202','OM202'),
            T_JBV('AP-OM203','OM203'),
            T_JBV('AP-OM204','OM204'),
            T_JBV('AP-SOL1','SOL1'),
            T_JBV('AP-OM206','OM206'),
            T_JBV('AP-OM207','OM207'),
            T_JBV('AP-OM208','OM208'),
            T_JBV('AP-OM209','OM209'),
            T_JBV('AP-OM210','OM210'),
            T_JBV('AP-OM211','OM211'),
            T_JBV('AP-OM212','OM212'),
            T_JBV('AP-OM213','OM213'),
            T_JBV('AP-OM214','OM214'),
            T_JBV('AP-OM215','OM215'),
            T_JBV('AP-SOL2','SOL2'),
            T_JBV('AP-SOL3','SOL3'),
            T_JBV('AP-OM218','OM218'),
            T_JBV('AP-OM219','OM219'),
            T_JBV('AP-OM220','OM220'),
            T_JBV('AP-OM221','OM221'),
            T_JBV('AP-OTR2','OTR2'),
            T_JBV('AP-OTR1','OTR1'),
            T_JBV('AP-OM247','OM247'),
            T_JBV('AP-OM248','OM248'),
            T_JBV('AP-OM249','OM249'),
            T_JBV('AP-OM250','OM250'),
            T_JBV('AP-OM251','OM251'),
            T_JBV('AP-OM252','OM252'),
            T_JBV('AP-OM253','OM253'),
            T_JBV('AP-OM254','OM254'),
            T_JBV('AP-OM255','OM255'),
            T_JBV('AP-OM256','OM256'),
            T_JBV('AP-BOL4','BOL4'),
            T_JBV('AP-BOL5','BOL5'),
            T_JBV('AP-CED1','CED1'),
            T_JBV('AP-CED2','CED2'),
            T_JBV('AP-INF4','INF4'),
            T_JBV('AP-OM229','OM229'),
            T_JBV('AP-OM230','OM230'),
            T_JBV('AP-OM231','OM231'),
            T_JBV('AP-OM232','OM232'),
            T_JBV('AP-OM233','OM233'),
            T_JBV('AP-OM234','OM234'),
            T_JBV('AP-OM235','OM235'),
            T_JBV('AP-OM236','OM236'),
            T_JBV('AP-OM237','OM237'),
            T_JBV('AP-OM238','OM238'),
            T_JBV('AP-OM239','OM239'),
            T_JBV('AP-OM240','OM240'),
            T_JBV('AP-OM241','OM241'),
            T_JBV('AP-OM242','OM242'),
            T_JBV('AP-OM243','OM243'),
            T_JBV('AP-OM244','OM244'),
            T_JBV('AP-OM245','OM245'),
            T_JBV('AP-OM246','OM246'),
            T_JBV('AP-OM257','OM257'),
            T_JBV('AP-OM258','OM258'),
            T_JBV('AP-OM259','OM259'),
            T_JBV('AP-OM260','OM260'),
            T_JBV('AP-OM261','OM261'),
            T_JBV('AP-OM262','OM262'),
            T_JBV('AP-OM263','OM263'),
            T_JBV('AP-OM264','OM264'),
            T_JBV('AP-OM265','OM265'),
            T_JBV('AP-OM266','OM266'),
            T_JBV('AP-OM267','OM267'),
            T_JBV('AP-OM268','OM268'),
            T_JBV('AP-OM269','OM269'),
            T_JBV('AP-OM270','OM270'),
            T_JBV('AP-OM271','OM271'),
            T_JBV('AP-OM272','OM272'),
            T_JBV('AP-OM273','OM273'),
            T_JBV('AP-OM274','OM274'),
            T_JBV('AP-OM275','OM275'),
            T_JBV('AP-OM276','OM276'),
            T_JBV('AP-OM277','OM277'),
            T_JBV('AP-OM278','OM278'),
            T_JBV('AP-OM279','OM279'),
            T_JBV('AP-OM280','OM280'),
            T_JBV('AP-OM281','OM281'),
            T_JBV('AP-OM282','OM282'),
            T_JBV('AP-OM283','OM283'),
            T_JBV('AP-OM284','OM284'),
            T_JBV('AP-OM285','OM285'),
            T_JBV('AP-OM286','OM286'),
            T_JBV('AP-OM287','OM287'),
            T_JBV('AP-OM288','OM288'),
            T_JBV('AP-OM289','OM289'),
            T_JBV('AP-OM290','OM290'),
            T_JBV('AP-OM291','OM291'),
            T_JBV('AP-OM292','OM292'),
            T_JBV('AP-OM293','OM293'),
            T_JBV('AP-OM294','OM294'),
            T_JBV('AP-OM295','OM295'),
            T_JBV('AP-OM296','OM296'),
            T_JBV('AP-OM297','OM297'),
            T_JBV('AP-OM298','OM298'),
            T_JBV('AP-OM299','OM299'),
            T_JBV('AP-OM300','OM300'),
            T_JBV('AP-OM301','OM301'),
            T_JBV('AP-OM302','OM302'),
            T_JBV('AP-OM303','OM303'),
            T_JBV('AP-OM304','OM304'),
            T_JBV('AP-OM305','OM305'),
            T_JBV('AP-OM306','OM306'),
            T_JBV('AP-OM307','OM307'),
            T_JBV('AP-OM308','OM308'),
            T_JBV('AP-OM309','OM309'),
            T_JBV('AP-OM310','OM310'),
            T_JBV('AP-OM311','OM311'),
            T_JBV('AP-OM312','OM312'),
            T_JBV('AP-OM313','OM313'),
            T_JBV('AP-OM314','OM314'),
            T_JBV('AP-OM315','OM315'),
            T_JBV('AP-OM316','OM316'),
            T_JBV('AP-OM317','OM317'),
            T_JBV('AP-OM318','OM318'),
            T_JBV('AP-OM319','OM319'),
            T_JBV('AP-OM320','OM320'),
            T_JBV('AP-OM321','OM321')
			); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TARIFAS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	DD_TTF_CODIGO := TRIM(V_TMP_JBV(2));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA  CFG
              JOIN '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA TTF ON TTF.DD_TTF_ID = CFG.DD_TTF_ID 
              WHERE TTF.DD_TTF_CODIGO = '''||DD_TTF_CODIGO||''' 
              AND DD_SCR_ID = 323';
             
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL :=  'UPDATE '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA 
                    SET DD_TTF_ID =  (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||V_TMP_JBV(1)||'''),
                    USUARIOMODIFICAR = ''REMVIP-4353'',
                    FECHAMODIFICAR = SYSDATE 
                    WHERE DD_SCR_ID = 323 
		    AND DD_TTF_ID =   (SELECT CFG.DD_TTF_ID FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFG
                                        JOIN '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA TTF ON TTF.DD_TTF_ID = CFG.DD_TTF_ID 
                                        WHERE TTF.DD_TTF_CODIGO = '''||V_TMP_JBV(2)||''' 
                                        AND DD_SCR_ID = 323)';
	       
         
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_CFT_CONFIG_TARIFA: '||DD_TTF_CODIGO||' DE CARTERA APPLE ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');
 
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

