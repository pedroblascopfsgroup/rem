--/*
--##########################################
--## AUTOR=Juan Angel Sánchez
--## FECHA_CREACION=20180915
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4538
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TDP_TIPO_DOC_PRO los datos añadidos en T_ARRAY_DATA
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

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('01'	,'Junta de compensación / EUC: Acta Asamblea'					,'Junta de compensación / EUC: Acta Asamblea' 				,'AI-08-ACTR-10'),
		T_TIPO_DATA('02'	,'Junta de compensación / EUC: Acta Consejo Rector'				,'Junta de compensación / EUC: Acta Consejo Rector' 		,'AI-08-ACTR-11'),
		T_TIPO_DATA('03'	,'Junta de compensación / EUC: Convocatoria Asamblea'			,'Junta de compensación / EUC: Convocatoria Asamblea'		,'AI-08-ACTR-08'),
		T_TIPO_DATA('04'	,'Junta de compensación / EUC: Convocatoria Consejo Rector'		,'Junta de compensación / EUC: Convocatoria Consejo Rector'	,'AI-08-ACTR-09'),
		T_TIPO_DATA('05'	,'Acta Inspección Técnica de Edificios (ITE)'					,'Acta Inspección Técnica de Edificios (ITE)'				,'AI-03-ACTT-02'),
		T_TIPO_DATA('06'	,'Autorización venta Vivienda de Protección Oficial (VPO)'		,'Autorización venta Vivienda de Protección Oficial (VPO)'	,'AI-11-ACUE-07'),
		T_TIPO_DATA('07'	,'Estudio de detalle: alegación'								,'Estudio de detalle: alegación'							,'AI-07-ALEG-08'),
		T_TIPO_DATA('08'	,'Normas subsidiarias: alegación'								,'Normas subsidiarias: alegación'							,'AI-07-ALEG-14'),
		T_TIPO_DATA('09'	,'Plan especial de reforma interior: alegación'					,'Plan especial de reforma interior: alegación'				,'AI-07-ALEG-18'),
		T_TIPO_DATA('10'	,'Plan general: alegación'										,'Plan general: alegación'									,'AI-07-ALEG-21'),
		T_TIPO_DATA('11'	,'Plan general de ordenación territorial: alegación'			,'Plan general de ordenación territorial: alegación'		,'AI-07-ALEG-20'),
		T_TIPO_DATA('12'	,'Plan parcial: alegación'										,'Plan parcial: alegación'									,'AI-07-ALEG-22'),
		T_TIPO_DATA('13'	,'Proyecto actuación especial: alegación'						,'Proyecto actuación especial: alegación'					,'AI-08-ALEG-24'),
		T_TIPO_DATA('14'	,'Proyecto urbanización: alegación'								,'Proyecto urbanización: alegación'							,'AI-08-ALEG-28'),
		T_TIPO_DATA('15'	,'Plan general de ordenación territorial: anexo'				,'Plan general de ordenación territorial: anexo'			,'AI-07-ANEX-05'),
		T_TIPO_DATA('16'	,'Cédula urbanística'											,'Cédula urbanística'										,'AI-01-CEDU-01'),
		T_TIPO_DATA('17'	,'Obra: certificado final'										,'Obra: certificado final'									,'AI-09-CERT-17'),
		T_TIPO_DATA('18'	,'Acometida electricidad'										,'Acometida electricidad'									,'AI-09-CERT-29'),
		T_TIPO_DATA('19'	,'Acústica: certificación'										,'Acústica: certificación'									,'AI-09-CERT-01'),
		T_TIPO_DATA('20'	,'Instalación telecomunicaciones: certificación'				,'Instalación telecomunicaciones: certificación',	'AI-09-CERT-14'),
		T_TIPO_DATA('21'	,'Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Justificante de pago)'		,'Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Justificante de pago)',	'AI-15-CERA-BQ'),
		T_TIPO_DATA('22'	,'Tasa de inscripción en el Registro del Certificado Energético (CEE)'		,'Tasa de inscripción en el Registro del Certificado Energético (CEE)',	'AI-01-CERA-71'),
		T_TIPO_DATA('23'	,'Vigilancia y seguridad: Vigilancia y seguridad (Justificante de pago)'		,'Vigilancia y seguridad: Vigilancia y seguridad (Justificante de pago)',	'AI-15-CERA-CM'),
		T_TIPO_DATA('24'	,'Junta de compensación / EUC: Gastos generales (Justificante de pago)'		,'Junta de compensación / EUC: Gastos generales (Justificante de pago)',	'AI-15-CERA-AG'),
		T_TIPO_DATA('25'	,'Junta de compensación: Cuotas y derramas (Justificante de pago)'		,'Junta de compensación: Cuotas y derramas (Justificante de pago)',	'AI-15-CERA-AH'),
		T_TIPO_DATA('26'	,'Proyecto actuación especial: justificante abono tasa tramitación'		,'Proyecto actuación especial: justificante abono tasa tramitación',	'AI-08-CERA-25'),
		T_TIPO_DATA('27'	,'Proyecto urbanización: justificante abono tasa tramitación'		,'Proyecto urbanización: justificante abono tasa tramitación',	'AI-08-CERA-30'),
		T_TIPO_DATA('28'	,'Proyecto parcelación / segregación / agrupación: justificante abono tasa tramitación'		,'Proyecto parcelación / segregación / agrupación: justificante abono tasa tramitación',	'AI-08-CERA-29'),
		T_TIPO_DATA('29'	,'Estudio de detalle: solicitud aprobación ante administración actuante (entrada en registro)'		,'Estudio de detalle: solicitud aprobación ante administración actuante (entrada en registro)',	'AI-07-CERJ-22'),
		T_TIPO_DATA('30'	,'Registro Propiedad: certificación dominio y cargas'		,'Registro Propiedad: certificación dominio y cargas',	'AI-01-CERJ-47'),
		T_TIPO_DATA('31'	,'Plan especial de reforma interior: solicitud aprobación ante administración actuante (entrada en registro)'		,'Plan especial de reforma interior: solicitud aprobación ante administración actuante (entrada en registro)',	'AI-07-CERJ-31'),
		T_TIPO_DATA('32'	,'Plan parcial: solicitud aprobación ante administración actuante (entrada en registro)'		,'Plan parcial: solicitud aprobación ante administración actuante (entrada en registro)',	'AI-07-CERJ-33'),
		T_TIPO_DATA('33'	,'Proyecto actuación especial: solicitud aprobación ante administración actuante (entrada en registro)'		,'Proyecto actuación especial: solicitud aprobación ante administración actuante (entrada en registro)',	'AI-08-CERJ-37'),
		T_TIPO_DATA('34'	,'Proyecto calificación urbanística: solicitud aprobación ante administración actuante (entrada en registro)'		,'Proyecto calificación urbanística: solicitud aprobación ante administración actuante (entrada en registro)',	'AI-08-CERJ-38'),
		T_TIPO_DATA('35'	,'Proyecto urbanización: solicitud aprobación ante administración actuante (entrada en registro)'		,'Proyecto urbanización: solicitud aprobación ante administración actuante (entrada en registro)',	'AI-08-CERJ-42'),
		T_TIPO_DATA('36'	,'Proyecto parcelación/segregación/agrupación: solicitud aprobación ante administración actuante (entrada en registro)'		,'Proyecto parcelación/segregación/agrupación: solicitud aprobación ante administración actuante (entrada en registro)',	'AI-08-CERJ-41'),
		T_TIPO_DATA('37'	,'Tasación: certificado'		,'Tasación: certificado',	'AI-04-CERJ-49'),
		T_TIPO_DATA('38'	,'Contrato: documento contractual'		,'Contrato: documento contractual',	'AI-08-CNCV-30'),
		T_TIPO_DATA('39'	,'Obra: acuerdos con compañias suministradoras'		,'Obra: acuerdos con compañias suministradoras',	'AI-09-CNCV-57'),
		T_TIPO_DATA('40'	,'Proyecto urbanización: convenio'		,'Proyecto urbanización: convenio',	'AI-08-CNCV-48'),
		T_TIPO_DATA('41'	,'Contrato: planing'		,'Contrato: planing',	'AI-03-CUAD-01'),
		T_TIPO_DATA('42'	,'Estudio de detalle: otros documentos técnicos y estudios'		,'Estudio de detalle: otros documentos técnicos y estudios',	'AI-07-DOCT-02'),
		T_TIPO_DATA('43'	,'Normas subsidiarias: Otro documento técnico'		,'Normas subsidiarias: Otro documento técnico',	'AI-07-DOCT-04'),
		T_TIPO_DATA('44'	,'Plan especial de reforma interior: otros documentos técnicos y estudios'		,'Plan especial de reforma interior: otros documentos técnicos y estudios',	'AI-07-DOCT-09'),
		T_TIPO_DATA('45'	,'Plan general: otro documento técnico'		,'Plan general: otro documento técnico',	'AI-07-DOCT-12'),
		T_TIPO_DATA('46'	,'Plan general de ordenación territorial: otro documento técnico'		,'Plan general de ordenación territorial: otro documento técnico',	'AI-07-DOCT-11'),
		T_TIPO_DATA('47'	,'Plan parcial: otros documentos técnicos y estudios'		,'Plan parcial: otros documentos técnicos y estudios',	'AI-07-DOCT-13'),
		T_TIPO_DATA('48'	,'Proyecto urbanización: mediciones'		,'Proyecto urbanización: mediciones',	'AI-08-DOCT-18'),
		T_TIPO_DATA('49'	,'Proyecto urbanización: pliego condiciones'		,'Proyecto urbanización: pliego condiciones',	'AI-08-DOCT-19'),
		T_TIPO_DATA('50'	,'Estudio de detalle: otro documento administrativo'		,'Estudio de detalle: otro documento administrativo',	'AI-07-DOCA-06'),
		T_TIPO_DATA('51'	,'Autorización de gasto'		,'Autorización de gasto',	'AI-08-DOCA-56'),
		T_TIPO_DATA('52'	,'Estructura de Propiedad'		,'Estructura de Propiedad',	'AI-08-DOCA-54'),
		T_TIPO_DATA('53'	,'Ficha valoración'		,'Ficha valoración',	'AI-08-DOCA-53'),
		T_TIPO_DATA('54'	,'Plan de Acción urbanístico'		,'Plan de Acción urbanístico',	'AI-07-DOCA-46'),
		T_TIPO_DATA('55'	,'Plan de Mejora Urbana'		,'Plan de Mejora Urbana',	'AI-08-DOCA-49'),
		T_TIPO_DATA('56'	,'Presupuesto anual'		,'Presupuesto anual',	'AI-08-DOCA-48'),
		T_TIPO_DATA('57'	,'Propuesta de voto'		,'Propuesta de voto',	'AI-08-DOCA-55'),
		T_TIPO_DATA('58'	,'Junta de compensación / EUC: Bases y Estatutos'		,'Junta de compensación / EUC: Bases y Estatutos',	'AI-08-DOCA-44'),
		T_TIPO_DATA('59'	,'Junta de compensación / EUC: Cuentas anuales'		,'Junta de compensación / EUC: Cuentas anuales',	'AI-08-DOCA-45'),
		T_TIPO_DATA('60'	,'Normas subsidiarias: otro documento administrativo'		,'Normas subsidiarias: otro documento administrativo',	'AI-07-DOCA-13'),
		T_TIPO_DATA('61'	,'Plan especial de reforma interior: otro documento administrativo'		,'Plan especial de reforma interior: otro documento administrativo',	'AI-07-DOCA-18'),
		T_TIPO_DATA('62'	,'Plan general: otro documento administrativo'		,'Plan general: otro documento administrativo',	'AI-07-DOCA-21'),
		T_TIPO_DATA('63'	,'Plan general de ordenación territorial: otro documento administrativo'		,'Plan general de ordenación territorial: otro documento administrativo',	'AI-07-DOCA-20'),
		T_TIPO_DATA('64'	,'Plan parcial: otro documento administrativo'		,'Plan parcial: otro documento administrativo',	'AI-07-DOCA-23'),
		T_TIPO_DATA('65'	,'Proyecto actuación especial: otro documento administrativo'		,'Proyecto actuación especial: otro documento administrativo',	'AI-08-DOCA-26'),
		T_TIPO_DATA('66'	,'Modificación Proyecto de Compensación'		,'Modificación Proyecto de Compensación',	'AI-07-DOCA-50'),
		T_TIPO_DATA('67'	,'Proyecto de Compensación'		,'Proyecto de Compensación',	'AI-07-DOCA-47'),
		T_TIPO_DATA('68'	,'Modificación Proyecto de Reparcelación'		,'Modificación Proyecto de Reparcelación',	'AI-07-DOCA-51'),
		T_TIPO_DATA('69'	,'Modificación Proyecto de Urbanización'		,'Modificación Proyecto de Urbanización',	'AI-07-DOCA-52'),
		T_TIPO_DATA('70'	,'Proyecto urbanización: otro documento administrativo'		,'Proyecto urbanización: otro documento administrativo',	'AI-08-DOCA-33'),
		T_TIPO_DATA('71'	,'Proyecto parcelación / segregación / agrupación: otro documento administrativo'		,'Proyecto parcelación / segregación / agrupación: otro documento administrativo',	'AI-08-DOCA-32'),
		T_TIPO_DATA('72'	,'Posesión activo: acta'		,'Posesión activo: acta',	'AI-02-DOCJ-14'),
		T_TIPO_DATA('73'	,'Posesión activo: acta lanzamiento'		,'Posesión activo: acta lanzamiento',	'AI-02-DOCJ-15'),
		T_TIPO_DATA('74'	,'Posesión activo: moratoria suspensión lanzamiento'		,'Posesión activo: moratoria suspensión lanzamiento',	'AI-02-DOCJ-AK'),
		T_TIPO_DATA('75'	,'Título inscrito'		,'Título inscrito',	'AI-01-DOCJ-70'),
		T_TIPO_DATA('76'	,'Acta notarial final de obra'		,'Acta notarial final de obra',	'AI-01-DOCN-01'),
		T_TIPO_DATA('77'	,'Dossier Fotográfico'		,'Dossier Fotográfico',	'AI-01-DOSS-02'),
		T_TIPO_DATA('78'	,'Escritura compraventa'		,'Escritura compraventa',	'AI-01-ESCR-10'),
		T_TIPO_DATA('79'	,'Escritura obra nueva y/ o división horizontal'		,'Escritura obra nueva y/ o división horizontal',	'AI-01-ESCR-13'),
		T_TIPO_DATA('80'	,'Estudio de detalle: estudio de viabilidad económica'		,'Estudio de detalle: estudio de viabilidad económica',	'AI-07-ESIN-17'),
		T_TIPO_DATA('81'	,'Obra: informe estado'		,'Obra: informe estado',	'AI-09-ESIN-45'),
		T_TIPO_DATA('82'	,'Obra: informe organismo de control técnico (OCT)'		,'Obra: informe organismo de control técnico (OCT)',	'AI-09-ESIN-47'),
		T_TIPO_DATA('83'	,'Valoración comercial de la zona'		,'Valoración comercial de la zona',	'AI-11-ESIN-BH'),
		T_TIPO_DATA('84'	,'Plan especial de reforma interior: estudio de viabilidad económica'		,'Plan especial de reforma interior: estudio de viabilidad económica',	'AI-07-ESIN-50'),
		T_TIPO_DATA('85'	,'Plan general: estudio viabilidad económico-financiera'		,'Plan general: estudio viabilidad económico-financiera',	'AI-07-ESIN-52'),
		T_TIPO_DATA('86'	,'Plan parcial: estudio de viabilidad económica'		,'Plan parcial: estudio de viabilidad económica',	'AI-07-ESIN-53'),
		T_TIPO_DATA('87'	,'Informe de Estado Edificación (Informe 0)'		,'Informe de Estado Edificación (Informe 0)',	'AI-03-ESIN-34'),
		T_TIPO_DATA('88'	,'Informe de Estado Suelo (Informe 0)'		,'Informe de Estado Suelo (Informe 0)',	'AI-03-ESIN-BQ'),
		T_TIPO_DATA('89'	,'Proyecto urbanización: estudio gestión de residuos'		,'Proyecto urbanización: estudio gestión de residuos',	'AI-08-ESTT-08'),
		T_TIPO_DATA('90'	,'Proyecto urbanización: estudio seguridad y salud'		,'Proyecto urbanización: estudio seguridad y salud',	'AI-08-ESTT-09'),
		T_TIPO_DATA('91'	,'Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Recibo)'		,'Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Recibo)',	'AI-15-FACT-87'),
		T_TIPO_DATA('92'	,'Junta de compensación / EUC: Gastos generales (Recibo)'		,'Junta de compensación / EUC: Gastos generales (Recibo)',	'AI-15-FACT-51'),
		T_TIPO_DATA('93'	,'Junta de compensación: Cuotas y derramas (Recibo)'		,'Junta de compensación: Cuotas y derramas (Recibo)',	'AI-15-FACT-52'),
		T_TIPO_DATA('94'	,'Catastro: ficha'		,'Catastro: ficha',	'AI-01-FICH-02'),
		T_TIPO_DATA('95'	,'Ficha técnica / urbanística'		,'Ficha técnica / urbanística',	'AI-01-FICH-11'),
		T_TIPO_DATA('96'	,'Plan general de ordenación territorial: ficha'		,'Plan general de ordenación territorial: ficha',	'AI-07-FICH-12'),
		T_TIPO_DATA('97'	,'Ficha datos básicos proyecto'		,'Ficha datos básicos proyecto',	'AI-01-FICH-23'),
		T_TIPO_DATA('98'	,'Libro del edificio: memoria y anexos'		,'Libro del edificio: memoria y anexos',	'AI-09-LICM-02'),
		T_TIPO_DATA('99'	,'Obra: libro de órdenes, asistencias'		,'Obra: libro de órdenes, asistencias',	'AI-09-LICM-07'),
		T_TIPO_DATA('100'	,'Plan general: catálogo'		,'Plan general: catálogo',	'AI-07-LICM-10'),
		T_TIPO_DATA('101'	,'Actividad y apertura: licencia'		,'Actividad y apertura: licencia',	'AI-09-LIPR-01'),
		T_TIPO_DATA('102'	,'Actividad: licencia comercial'		,'Actividad: licencia comercial',	'AI-10-LIPR-02'),
		T_TIPO_DATA('103'	,'Informe técnico de habitabilidad'		,'Informe técnico de habitabilidad',	'AI-09-LIPR-13'),
		T_TIPO_DATA('104'	,'Obra: licencia garaje'		,'Obra: licencia garaje',	'AI-09-LIPR-12'),
		T_TIPO_DATA('105'	,'Obra: licencia obras'		,'Obra: licencia obras',	'AI-09-LIPR-05'),
		T_TIPO_DATA('106'	,'Obra: licencia primera ocupación'		,'Obra: licencia primera ocupación',	'AI-06-LIPR-06'),
		T_TIPO_DATA('107'	,'Obra: licencia vado'		,'Obra: licencia vado',	'AI-09-LIPR-08'),
		T_TIPO_DATA('108'	,'Proyecto parcelación/segregación/agrupación: licencia'		,'Proyecto parcelación/segregación/agrupación: licencia',	'AI-08-LIPR-11'),
		T_TIPO_DATA('109'	,'Estudio de detalle: memoria'		,'Estudio de detalle: memoria',	'AI-07-MEMO-03'),
		T_TIPO_DATA('110'	,'Normas subsidiarias: memoria plan'		,'Normas subsidiarias: memoria plan',	'AI-07-MEMO-07'),
		T_TIPO_DATA('111'	,'Plan especial de reforma interior: memoria'		,'Plan especial de reforma interior: memoria',	'AI-07-MEMO-11'),
		T_TIPO_DATA('112'	,'Plan general: memoria'		,'Plan general: memoria',	'AI-07-MEMO-14'),
		T_TIPO_DATA('113'	,'Plan general de ordenación territorial: memoria'		,'Plan general de ordenación territorial: memoria',	'AI-07-MEMO-13'),
		T_TIPO_DATA('114'	,'Plan parcial: memoria'		,'Plan parcial: memoria',	'AI-07-MEMO-15'),
		T_TIPO_DATA('115'	,'Proyecto urbanización: memoria'		,'Proyecto urbanización: memoria',	'AI-08-MEMO-19'),
		T_TIPO_DATA('116'	,'Estudio de detalle: normas urbanísticas'		,'Estudio de detalle: normas urbanísticas',	'AI-07-NORM-02'),
		T_TIPO_DATA('117'	,'Normas subsidiarias: normas urbanísticas'		,'Normas subsidiarias: normas urbanísticas',	'AI-07-NORM-06'),
		T_TIPO_DATA('118'	,'Normas subsidiarias: ordenanzas'		,'Normas subsidiarias: ordenanzas',	'AI-07-NORM-05'),
		T_TIPO_DATA('119'	,'Plan especial de reforma interior: normas urbanísticas'		,'Plan especial de reforma interior: normas urbanísticas',	'AI-07-NORM-11'),
		T_TIPO_DATA('120'	,'Plan general: normas urbanísticas'		,'Plan general: normas urbanísticas',	'AI-07-NORM-14'),
		T_TIPO_DATA('121'	,'Plan general de ordenación territorial: normas urbanísticas'		,'Plan general de ordenación territorial: normas urbanísticas',	'AI-07-NORM-13'),
		T_TIPO_DATA('122'	,'Plan parcial: normas urbanísticas'		,'Plan parcial: normas urbanísticas',	'AI-07-NORM-15'),
		T_TIPO_DATA('123'	,'Plan control calidad urbanización: documento'		,'Plan control calidad urbanización: documento',	'AI-08-PLAT-01'),
		T_TIPO_DATA('124'	,'Plan de mantenimiento'		,'Plan de mantenimiento',	'AI-03-PLAP-03'),
		T_TIPO_DATA('125'	,'Plan de Mantenimiento Individualizado'		,'Plan de Mantenimiento Individualizado',	'AI-03-PLAP-08'),
		T_TIPO_DATA('126'	,'Plan general: directrices evolución urbana y ocupación del territorio'		,'Plan general: directrices evolución urbana y ocupación del territorio',	'AI-07-PLAP-06'),
		T_TIPO_DATA('127'	,'Estudio de detalle: plano'		,'Estudio de detalle: plano',	'AI-07-PLAO-06'),
		T_TIPO_DATA('128'	,'Normas subsidiarias: Plano plan'		,'Normas subsidiarias: Plano plan',	'AI-07-PLAO-11'),
		T_TIPO_DATA('129'	,'Plan especial de reforma interior: planos'		,'Plan especial de reforma interior: planos',	'AI-07-PLAO-16'),
		T_TIPO_DATA('130'	,'Plan general: plano'		,'Plan general: plano',	'AI-07-PLAO-19'),
		T_TIPO_DATA('131'	,'Plan general de ordenación territorial: plano'		,'Plan general de ordenación territorial: plano',	'AI-07-PLAO-18'),
		T_TIPO_DATA('132'	,'Plan parcial: plano'		,'Plan parcial: plano',	'AI-07-PLAO-21'),
		T_TIPO_DATA('133'	,'Proyecto actuación especial: plano'		,'Proyecto actuación especial: plano',	'AI-08-PLAO-29'),
		T_TIPO_DATA('134'	,'Proyecto urbanización: plano'		,'Proyecto urbanización: plano',	'AI-08-PLAO-36'),
		T_TIPO_DATA('135'	,'Proyecto parcelación / segregación / agrupación: plano'		,'Proyecto parcelación / segregación / agrupación: plano',	'AI-08-PLAO-35'),
		T_TIPO_DATA('136'	,'Proyecto urbanización: presupuesto'		,'Proyecto urbanización: presupuesto',	'AI-08-PRES-10'),
		T_TIPO_DATA('137'	,'Estudio de detalle: anexos memoria'		,'Estudio de detalle: anexos memoria',	'AI-07-PRYT-03'),
		T_TIPO_DATA('138'	,'Plan especial de reforma interior: anexos memoria'		,'Plan especial de reforma interior: anexos memoria',	'AI-07-PRYT-05'),
		T_TIPO_DATA('139'	,'Plan parcial: anexos memoria'		,'Plan parcial: anexos memoria',	'AI-07-PRYT-07'),
		T_TIPO_DATA('140'	,'Proyecto actuación especial: memoria y anexos'		,'Proyecto actuación especial: memoria y anexos',	'AI-08-PRYT-08'),
		T_TIPO_DATA('141'	,'Proyecto urbanización: anexos a la memoria'		,'Proyecto urbanización: anexos a la memoria',	'AI-08-PRYT-15'),
		T_TIPO_DATA('142'	,'Proyecto parcelación/segregación/agrupación: memoria y anexos'		,'Proyecto parcelación/segregación/agrupación: memoria y anexos',	'AI-08-PRYT-14'),
		T_TIPO_DATA('143'	,'Estudio de detalle: publicación prensa'		,'Estudio de detalle: publicación prensa',	'AI-07-PUBM-04'),
		T_TIPO_DATA('144'	,'Normas subsidiarias: publicación prensa normas'		,'Normas subsidiarias: publicación prensa normas',	'AI-07-PUBM-08'),
		T_TIPO_DATA('145'	,'Plan especial de reforma interior: publicación prensa'		,'Plan especial de reforma interior: publicación prensa',	'AI-07-PUBM-12'),
		T_TIPO_DATA('146'	,'Plan general: publicación prensa'		,'Plan general: publicación prensa',	'AI-07-PUBM-15'),
		T_TIPO_DATA('147'	,'Plan general de ordenación territorial: publicación prensa'		,'Plan general de ordenación territorial: publicación prensa',	'AI-07-PUBM-14'),
		T_TIPO_DATA('148'	,'Plan parcial: publicación prensa'		,'Plan parcial: publicación prensa',	'AI-07-PUBM-16'),
		T_TIPO_DATA('149'	,'Proyecto actuación especial: publicación prensa'		,'Proyecto actuación especial: publicación prensa',	'AI-08-PUBM-18'),
		T_TIPO_DATA('150'	,'Proyecto urbanización: publicación prensa'		,'Proyecto urbanización: publicación prensa',	'AI-08-PUBM-22'),
		T_TIPO_DATA('151'	,'Estudio de detalle: publicación acuerdo información pública / aprobación'		,'Estudio de detalle: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-05'),
		T_TIPO_DATA('152'	,'Normas subsidiarias: Publicación acuerdo información pública / aprobación'		,'Normas subsidiarias: Publicación acuerdo información pública / aprobación',	'AI-07-PBLO-09'),
		T_TIPO_DATA('153'	,'Plan especial de reforma interior: publicación acuerdo información pública / aprobación'		,'Plan especial de reforma interior: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-15'),
		T_TIPO_DATA('154'	,'Plan general: publicación acuerdo información pública / aprobación'		,'Plan general: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-18'),
		T_TIPO_DATA('155'	,'Plan general de ordenación territorial: publicación acuerdo información pública / aprobación'		,'Plan general de ordenación territorial: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-17'),
		T_TIPO_DATA('156'	,'Plan parcial: publicación acuerdo información pública / aprobación'		,'Plan parcial: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-19'),
		T_TIPO_DATA('157'	,'Proyecto actuación especial: publicación acuerdo información pública / aprobación'		,'Proyecto actuación especial: publicación acuerdo información pública / aprobación',	'AI-08-PBLO-21'),
		T_TIPO_DATA('158'	,'Proyecto urbanización: publicación acuerdo información pública / aprobación'		,'Proyecto urbanización: publicación acuerdo información pública / aprobación',	'AI-08-PBLO-25'),
		T_TIPO_DATA('159'	,'Catálogo de bienes y espacios protegidos: publicación acuerdo información pública / aprobación'		,'Catálogo de bienes y espacios protegidos: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-02'),
		T_TIPO_DATA('160'	,'Instrucciones de planeamiento: Publicación acuerdo información pública / aprobación'		,'Instrucciones de planeamiento: Publicación acuerdo información pública / aprobación',	'AI-07-PBLO-06'),
		T_TIPO_DATA('161'	,'Normas complementarias: Publicación acuerdo información pública / aprobación'		,'Normas complementarias: Publicación acuerdo información pública / aprobación',	'AI-07-PBLO-08'),
		T_TIPO_DATA('162'	,'Normas técnicas de planeamiento: Publicación acuerdo información pública / aprobación'		,'Normas técnicas de planeamiento: Publicación acuerdo información pública / aprobación',	'AI-07-PBLO-10'),
		T_TIPO_DATA('163'	,'Ordenanzas: Publicación acuerdo información pública / aprobación'		,'Ordenanzas: Publicación acuerdo información pública / aprobación',	'AI-07-PBLO-11'),
		T_TIPO_DATA('164'	,'Plan de sectorización/delimitación: publicación acuerdo información pública / aprobación'		,'Plan de sectorización/delimitación: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-13'),
		T_TIPO_DATA('165'	,'Plan de singular interés: publicación acuerdo información pública / aprobación'		,'Plan de singular interés: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-14'),
		T_TIPO_DATA('166'	,'Plan especial: publicación acuerdo información pública / aprobación'		,'Plan especial: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-16'),
		T_TIPO_DATA('167'	,'Programa de actuación: publicación acuerdo información pública / aprobación'		,'Programa de actuación: publicación acuerdo información pública / aprobación',	'AI-08-PBLO-20'),
		T_TIPO_DATA('168'	,'Proyecto calificación urbanística: publicación acuerdo información pública/ aprobación'		,'Proyecto calificación urbanística: publicación acuerdo información pública/ aprobación',	'AI-08-PBLO-22'),
		T_TIPO_DATA('169'	,'Proyecto de delimitación de suelo urbano: publicación acuerdo información pública / aprobación'		,'Proyecto de delimitación de suelo urbano: publicación acuerdo información pública / aprobación',	'AI-07-PBLO-12'),
		T_TIPO_DATA('170'	,'Proyecto equidistribución: publicación acuerdo información pública / aprobación'		,'Proyecto equidistribución: publicación acuerdo información pública / aprobación',	'AI-08-PBLO-23'),
		T_TIPO_DATA('171'	,'Proyecto expropiación: publicación acuerdo información pública / aprobación'		,'Proyecto expropiación: publicación acuerdo información pública / aprobación',	'AI-08-PBLO-24'),
		T_TIPO_DATA('172'	,'Seguro responsabilidad decenal: póliza'		,'Seguro responsabilidad decenal: póliza',	'AI-09-SEGU-11'),
		T_TIPO_DATA('173'	,'Resolución (Ocupantes)'		,'Resolución (Ocupantes)',	'AI-02-SERE-48'),
		T_TIPO_DATA('174'	,'Subasta: auto / decreto adjudicación'		,'Subasta: auto / decreto adjudicación',	'AI-01-SERE-24'),
		T_TIPO_DATA('175'	,'Subasta: testimonio decreto adjudicación'		,'Subasta: testimonio decreto adjudicación',	'AI-01-SERE-26'),
		T_TIPO_DATA('176'	,'Tasación: informe activo'		,'Tasación: informe activo',	'AI-04-TASA-11')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TEP_TIPO_ENTIDAD_PRO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TDP_TIPO_DOC_PRO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDP_TIPO_DOC_PRO WHERE DD_TDP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TDP_TIPO_DOC_PRO '||
                    'SET DD_TDP_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TDP_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', DD_TDP_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''HREOS-4538'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TDP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TDP_TIPO_DOC_PRO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TDP_TIPO_DOC_PRO (' ||
                      'DD_TDP_ID, DD_TDP_CODIGO, DD_TDP_DESCRIPCION, DD_TDP_DESCRIPCION_LARGA, DD_TDP_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-4538'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TDP_TIPO_DOC_PRO ACTUALIZADO CORRECTAMENTE ');
   

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