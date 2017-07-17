--/*
--##########################################
--## AUTOR=BRUNO ANGLÉS
--## FECHA_CREACION=20170714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2377
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TPD_TIPOS_DOCUMENTO_GASTO los datos añadidos en T_ARRAY_DATA
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
    V_EVI_ID NUMBER(16);



    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
          t_tipo_data('29','Impuesto: IBI urbana (Recibo)','Impuesto: IBI urbana (Recibo)','AI-15-FACT-24'),
t_tipo_data('30','Impuesto: IBI rústica (Recibo)','Impuesto: IBI rústica (Recibo)','AI-15-FACT-25'),
t_tipo_data('31','Impuesto: Recargos e intereses (Recibo)','Impuesto: Recargos e intereses (Recibo)','AI-15-FACT-26'),
t_tipo_data('32','Impuesto: ITPAJD (Recibo)','Impuesto: ITPAJD (Recibo)','AI-15-FACT-27'),
t_tipo_data('33','Impuesto: ICIO (Recibo)','Impuesto: ICIO (Recibo)','AI-15-FACT-28'),
t_tipo_data('34','Impuesto: IAAEE (Recibo)','Impuesto: IAAEE (Recibo)','AI-15-FACT-29'),
t_tipo_data('35','Impuesto: Plusvalía (IIVTNU) venta (Recibo)','Impuesto: Plusvalía (IIVTNU) venta (Recibo)','AI-15-FACT-30'),
t_tipo_data('36','Impuesto: Plusvalía (IIVTNU) compra (Recibo)','Impuesto: Plusvalía (IIVTNU) compra (Recibo)','AI-15-FACT-31'),
t_tipo_data('37','Tasa: Basura (Recibo)','Tasa: Basura (Recibo)','AI-15-FACT-32'),
t_tipo_data('38','Tasa: Alcantarillado (Recibo)','Tasa: Alcantarillado (Recibo)','AI-15-FACT-33'),
t_tipo_data('39','Tasa: Vado (Recibo)','Tasa: Vado (Recibo)','AI-15-FACT-34'),
t_tipo_data('40','Tasa: Ecotasa (Recibo)','Tasa: Ecotasa (Recibo)','AI-15-FACT-35'),
t_tipo_data('41','Tasa: Regularización catastral (Recibo)','Tasa: Regularización catastral (Recibo)','AI-15-FACT-36'),
t_tipo_data('42','Tasa: Expedición documentos (Recibo)','Tasa: Expedición documentos (Recibo)','AI-15-FACT-37'),
t_tipo_data('43','Tasa: Obras / Rehabilitación / Mantenimiento (Recibo)','Tasa: Obras / Rehabilitación / Mantenimiento (Recibo)','AI-15-FACT-38'),
t_tipo_data('44','Tasa: Judicial (Recibo)','Tasa: Judicial (Recibo)','AI-15-FACT-39'),
t_tipo_data('45','Tasa: Agua (Recibo)','Tasa: Agua (Recibo)','AI-15-FACT-40'),
t_tipo_data('46','Otros tributos: Contribución especial (Recibo)','Otros tributos: Contribución especial (Recibo)','AI-15-FACT-41'),
t_tipo_data('47','Sanción: Urbanística (Recibo)','Sanción: Urbanística (Recibo)','AI-15-FACT-42'),
t_tipo_data('48','Sanción: Tributaria (Recibo)','Sanción: Tributaria (Recibo)','AI-15-FACT-43'),
t_tipo_data('49','Sanción: Ruina (Recibo)','Sanción: Ruina (Recibo)','AI-15-FACT-44'),
t_tipo_data('50','Sanción: Multa coercitiva (Recibo)','Sanción: Multa coercitiva (Recibo)','AI-15-FACT-45'),
t_tipo_data('51','Comunidad de propietarios: Cuota extraordinaria (derrama) (Recibo)','Comunidad de propietarios: Cuota extraordinaria (derrama) (Recibo)','AI-15-FACT-46'),
t_tipo_data('52','Comunidad de propietarios: Certificado deuda comunidad (Recibo)','Comunidad de propietarios: Certificado deuda comunidad (Recibo)','AI-15-FACT-47'),
t_tipo_data('53','Comunidad de propietarios: Cuota ordinaria (Recibo)','Comunidad de propietarios: Cuota ordinaria (Recibo)','AI-15-FACT-48'),
t_tipo_data('54','Complejo inmobiliario: Cuota ordinaria (Recibo)','Complejo inmobiliario: Cuota ordinaria (Recibo)','AI-15-FACT-49'),
t_tipo_data('55','Complejo inmobiliario: Cuota extraordinaria (derrama) (Recibo)','Complejo inmobiliario: Cuota extraordinaria (derrama) (Recibo)','AI-15-FACT-50'),
t_tipo_data('56','Junta de compensación / EUC: Gastos generales (Recibo)','Junta de compensación / EUC: Gastos generales (Recibo)','AI-15-FACT-51'),
t_tipo_data('57','Junta de compensación / EUC: Cuotas y derramas (Recibo)','Junta de compensación / EUC: Cuotas y derramas (Recibo)','AI-15-FACT-52'),
t_tipo_data('58','Otras entidades en que se integra el activo: Gastos generales (Recibo)','Otras entidades en que se integra el activo: Gastos generales (Recibo)','AI-15-FACT-53'),
t_tipo_data('59','Otras entidades en que se integra el activo: Cuotas y derramas (Recibo)','Otras entidades en que se integra el activo: Cuotas y derramas (Recibo)','AI-15-FACT-54'),
t_tipo_data('60','Suministro: Agua (Recibo)','Suministro: Agua (Recibo)','AI-15-FACT-55'),
t_tipo_data('61','Suministro: Electricidad (Recibo)','Suministro: Electricidad (Recibo)','AI-15-FACT-56'),
t_tipo_data('62','Suministro: Gas (Recibo)','Suministro: Gas (Recibo)','AI-15-FACT-57'),
t_tipo_data('63','Seguros: Prima RC (responsabilidad civil) (Recibo)','Seguros: Prima RC (responsabilidad civil) (Recibo)','AI-15-FACT-58'),
t_tipo_data('64','Seguros: Prima TRDM (todo riesgo daño material) (Recibo)','Seguros: Prima TRDM (todo riesgo daño material) (Recibo)','AI-15-FACT-59'),
t_tipo_data('65','Seguros: Parte daños propios (Recibo)','Seguros: Parte daños propios (Recibo)','AI-15-FACT-60'),
t_tipo_data('66','Seguros: Parte daños a terceros (Recibo)','Seguros: Parte daños a terceros (Recibo)','AI-15-FACT-61'),
t_tipo_data('67','Servicios profesionales independientes: Abogado (Asuntos generales) (Recibo)','Servicios profesionales independientes: Abogado (Asuntos generales) (Recibo)','AI-15-FACT-62'),
t_tipo_data('68','Servicios profesionales independientes: Abogado (Asistencia jurídica) (Recibo)','Servicios profesionales independientes: Abogado (Asistencia jurídica) (Recibo)','AI-15-FACT-63'),
t_tipo_data('69','Servicios profesionales independientes: Registro (Recibo)','Servicios profesionales independientes: Registro (Recibo)','AI-15-FACT-64'),
t_tipo_data('70','Servicios profesionales independientes: Notaría (Recibo)','Servicios profesionales independientes: Notaría (Recibo)','AI-15-FACT-65'),
t_tipo_data('71','Servicios profesionales independientes: Abogado (Recibo)','Servicios profesionales independientes: Abogado (Recibo)','AI-15-FACT-66'),
t_tipo_data('72','Servicios profesionales independientes: Procurador (Recibo)','Servicios profesionales independientes: Procurador (Recibo)','AI-15-FACT-67'),
t_tipo_data('73','Servicios profesionales independientes: Otros servicios jurídicos (Recibo)','Servicios profesionales independientes: Otros servicios jurídicos (Recibo)','AI-15-FACT-68'),
t_tipo_data('74','Servicios profesionales independientes: Administrador Comunidad Propietarios (Recibo)','Servicios profesionales independientes: Administrador Comunidad Propietarios (Recibo)','AI-15-FACT-69'),
t_tipo_data('75','Servicios profesionales independientes: Asesoría (Recibo)','Servicios profesionales independientes: Asesoría (Recibo)','AI-15-FACT-70'),
t_tipo_data('76','Servicios profesionales independientes: Técnico (Recibo)','Servicios profesionales independientes: Técnico (Recibo)','AI-15-FACT-71'),
t_tipo_data('77','Servicios profesionales independientes: Tasación (Recibo)','Servicios profesionales independientes: Tasación (Recibo)','AI-15-FACT-72'),
t_tipo_data('78','Servicios profesionales independientes: Gestión de suelo (Recibo)','Servicios profesionales independientes: Gestión de suelo (Recibo)','AI-15-FACT-73'),
t_tipo_data('79','Servicios profesionales independientes: Abogado (Ocupacional) (Recibo)','Servicios profesionales independientes: Abogado (Ocupacional) (Recibo)','AI-15-FACT-74'),
t_tipo_data('80','Gestoría: Honorarios gestión ventas (Recibo)','Gestoría: Honorarios gestión ventas (Recibo)','AI-15-FACT-75'),
t_tipo_data('81','Gestoría: Honorarios gestión activos (Recibo)','Gestoría: Honorarios gestión activos (Recibo)','AI-15-FACT-76'),
t_tipo_data('82','Comisiones: Fuerza de Venta Directa (Recibo)','Comisiones: Fuerza de Venta Directa (Recibo)','AI-15-FACT-77'),
t_tipo_data('83','Comisiones: Mediador (Recibo)','Comisiones: Mediador (Recibo)','AI-15-FACT-78'),
t_tipo_data('84','Informes técnicos y obtención documentos: Inspección técnica de edificios (Recibo)','Informes técnicos y obtención documentos: Inspección técnica de edificios (Recibo)','AI-15-FACT-79'),
t_tipo_data('85','Informes técnicos y obtención documentos: Informe topográfico (Recibo)','Informes técnicos y obtención documentos: Informe topográfico (Recibo)','AI-15-FACT-80'),
t_tipo_data('86','Informes técnicos y obtención documentos: VPO: Autorización de venta (Recibo)','Informes técnicos y obtención documentos: VPO: Autorización de venta (Recibo)','AI-15-FACT-81'),
t_tipo_data('87','Informes técnicos y obtención documentos: VPO: Notificación adjudicación (tanteo) (Recibo)','Informes técnicos y obtención documentos: VPO: Notificación adjudicación (tanteo) (Recibo)','AI-15-FACT-82'),
t_tipo_data('88','Informes técnicos y obtención documentos: VPO: Solicitud devolución ayudas (Recibo)','Informes técnicos y obtención documentos: VPO: Solicitud devolución ayudas (Recibo)','AI-15-FACT-83'),
t_tipo_data('89','Informes técnicos y obtención documentos: Nota simple actualizada (Recibo)','Informes técnicos y obtención documentos: Nota simple actualizada (Recibo)','AI-15-FACT-84'),
t_tipo_data('90','Informes técnicos y obtención documentos: Obtención certificados y documentación (Recibo)','Informes técnicos y obtención documentos: Obtención certificados y documentación (Recibo)','AI-15-FACT-85'),
t_tipo_data('91','Informes técnicos y obtención documentos: Boletín instalaciones y suministros (Recibo)','Informes técnicos y obtención documentos: Boletín instalaciones y suministros (Recibo)','AI-15-FACT-86'),
t_tipo_data('92','Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Recibo)','Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Recibo)','AI-15-FACT-87'),
t_tipo_data('93','Informes técnicos y obtención documentos: Cédula Habitabilidad (Recibo)','Informes técnicos y obtención documentos: Cédula Habitabilidad (Recibo)','AI-15-FACT-88'),
t_tipo_data('94','Informes técnicos y obtención documentos: Licencia Primera Ocupación (LPO) (Recibo)','Informes técnicos y obtención documentos: Licencia Primera Ocupación (LPO) (Recibo)','AI-15-FACT-89'),
t_tipo_data('95','Informes técnicos y obtención documentos: Certif. eficiencia energética (CEE) (Recibo)','Informes técnicos y obtención documentos: Certif. eficiencia energética (CEE) (Recibo)','AI-15-FACT-90'),
t_tipo_data('96','Informes técnicos y obtención documentos: Informes (Recibo)','Informes técnicos y obtención documentos: Informes (Recibo)','AI-15-FACT-91'),
t_tipo_data('97','Actuación técnica y mantenimiento: Limpieza y retirada de enseres (Recibo)','Actuación técnica y mantenimiento: Limpieza y retirada de enseres (Recibo)','AI-15-FACT-92'),
t_tipo_data('98','Actuación técnica y mantenimiento: Limpieza, desinfección… (solares) (Recibo)','Actuación técnica y mantenimiento: Limpieza, desinfección… (solares) (Recibo)','AI-15-FACT-93'),
t_tipo_data('99','Actuación técnica y mantenimiento: Cambio de cerradura (Recibo)','Actuación técnica y mantenimiento: Cambio de cerradura (Recibo)','AI-15-FACT-94'),
t_tipo_data('100','Actuación técnica y mantenimiento: Tapiado (Recibo)','Actuación técnica y mantenimiento: Tapiado (Recibo)','AI-15-FACT-95'),
t_tipo_data('101','Actuación técnica y mantenimiento: Retirada de enseres (Recibo)','Actuación técnica y mantenimiento: Retirada de enseres (Recibo)','AI-15-FACT-96'),
t_tipo_data('102','Actuación técnica y mantenimiento: Limpieza (Recibo)','Actuación técnica y mantenimiento: Limpieza (Recibo)','AI-15-FACT-97'),
t_tipo_data('103','Actuación técnica y mantenimiento: Actuación post-venta (Recibo)','Actuación técnica y mantenimiento: Actuación post-venta (Recibo)','AI-15-FACT-98'),
t_tipo_data('104','Actuación técnica y mantenimiento: Mobiliario (Recibo)','Actuación técnica y mantenimiento: Mobiliario (Recibo)','AI-15-FACT-99'),
t_tipo_data('105','Actuación técnica y mantenimiento: Colocación puerta antiocupa (Recibo)','Actuación técnica y mantenimiento: Colocación puerta antiocupa (Recibo)','AI-15-FACT-AA'),
t_tipo_data('106','Actuación técnica y mantenimiento: Control de actuaciones (dirección técnica) (Recibo)','Actuación técnica y mantenimiento: Control de actuaciones (dirección técnica) (Recibo)','AI-15-FACT-AB'),
t_tipo_data('107','Actuación técnica y mantenimiento: Obra mayor. Edificación (certif. de obra) (Recibo)','Actuación técnica y mantenimiento: Obra mayor. Edificación (certif. de obra) (Recibo)','AI-15-FACT-AC'),
t_tipo_data('108','Actuación técnica y mantenimiento: Obra menor (Recibo)','Actuación técnica y mantenimiento: Obra menor (Recibo)','AI-15-FACT-AD'),
t_tipo_data('109','Actuación técnica y mantenimiento: Verificación de averías (Recibo)','Actuación técnica y mantenimiento: Verificación de averías (Recibo)','AI-15-FACT-AE'),
t_tipo_data('110','Actuación técnica y mantenimiento: Seguridad y Salud (SS) (Recibo)','Actuación técnica y mantenimiento: Seguridad y Salud (SS) (Recibo)','AI-15-FACT-AF'),
t_tipo_data('111','Actuación técnica y mantenimiento: Limpieza, retirada de enseres y descerraje (Recibo)','Actuación técnica y mantenimiento: Limpieza, retirada de enseres y descerraje (Recibo)','AI-15-FACT-AG'),
t_tipo_data('112','Vigilancia y seguridad: Servicios auxiliares (Recibo)','Vigilancia y seguridad: Servicios auxiliares (Recibo)','AI-15-FACT-AH'),
t_tipo_data('113','Vigilancia y seguridad: Alarmas (Recibo)','Vigilancia y seguridad: Alarmas (Recibo)','AI-15-FACT-AI'),
t_tipo_data('114','Vigilancia y seguridad: Vigilancia y seguridad (Recibo)','Vigilancia y seguridad: Vigilancia y seguridad (Recibo)','AI-15-FACT-AJ'),
t_tipo_data('115','Publicidad: Publicidad (Recibo)','Publicidad: Publicidad (Recibo)','AI-15-FACT-AK'),
t_tipo_data('116','Otros gastos: Costas judiciales (Recibo)','Otros gastos: Costas judiciales (Recibo)','AI-15-FACT-AL'),
t_tipo_data('117','Otros gastos: Mensajería/correos/copias (Recibo)','Otros gastos: Mensajería/correos/copias (Recibo)','AI-15-FACT-AM'),
t_tipo_data('118','Otros gastos: Costas judiciales (demanda comunidad propietarios) (Recibo)','Otros gastos: Costas judiciales (demanda comunidad propietarios) (Recibo)','AI-15-FACT-AN'),
t_tipo_data('119','Otros gastos: Costas judiciales (otras demandas) (Recibo)','Otros gastos: Costas judiciales (otras demandas) (Recibo)','AI-15-FACT-AO'),
t_tipo_data('120','Impuesto: IBI urbana (Justificante de pago)','Impuesto: IBI urbana (Justificante de pago)','AI-15-CERA-79'),
t_tipo_data('121','Impuesto: IBI rústica (Justificante de pago)','Impuesto: IBI rústica (Justificante de pago)','AI-15-CERA-80'),
t_tipo_data('122','Impuesto: Recargos e intereses (Justificante de pago)','Impuesto: Recargos e intereses (Justificante de pago)','AI-15-CERA-81'),
t_tipo_data('123','Impuesto: ITPAJD (Justificante de pago)','Impuesto: ITPAJD (Justificante de pago)','AI-15-CERA-82'),
t_tipo_data('124','Impuesto: ICIO (Justificante de pago)','Impuesto: ICIO (Justificante de pago)','AI-15-CERA-83'),
t_tipo_data('125','Impuesto: IAAEE (Justificante de pago)','Impuesto: IAAEE (Justificante de pago)','AI-15-CERA-84'),
t_tipo_data('126','Impuesto: Plusvalía (IIVTNU) venta (Justificante de pago)','Impuesto: Plusvalía (IIVTNU) venta (Justificante de pago)','AI-15-CERA-85'),
t_tipo_data('127','Impuesto: Plusvalía (IIVTNU) compra (Justificante de pago)','Impuesto: Plusvalía (IIVTNU) compra (Justificante de pago)','AI-15-CERA-86'),
t_tipo_data('128','Tasa: Basura (Justificante de pago)','Tasa: Basura (Justificante de pago)','AI-15-CERA-87'),
t_tipo_data('129','Tasa: Alcantarillado (Justificante de pago)','Tasa: Alcantarillado (Justificante de pago)','AI-15-CERA-88'),
t_tipo_data('130','Tasa: Vado (Justificante de pago)','Tasa: Vado (Justificante de pago)','AI-15-CERA-89'),
t_tipo_data('131','Tasa: Ecotasa (Justificante de pago)','Tasa: Ecotasa (Justificante de pago)','AI-15-CERA-90'),
t_tipo_data('132','Tasa: Regularización catastral (Justificante de pago)','Tasa: Regularización catastral (Justificante de pago)','AI-15-CERA-91'),
t_tipo_data('133','Tasa: Expedición documentos (Justificante de pago)','Tasa: Expedición documentos (Justificante de pago)','AI-15-CERA-92'),
t_tipo_data('134','Tasa: Obras / Rehabilitación / Mantenimiento (Justificante de pago)','Tasa: Obras / Rehabilitación / Mantenimiento (Justificante de pago)','AI-15-CERA-93'),
t_tipo_data('135','Tasa: Judicial (Justificante de pago)','Tasa: Judicial (Justificante de pago)','AI-15-CERA-94'),
t_tipo_data('136','Tasa: Agua (Justificante de pago)','Tasa: Agua (Justificante de pago)','AI-15-CERA-95'),
t_tipo_data('137','Otros tributos: Contribución especial (Justificante de pago)','Otros tributos: Contribución especial (Justificante de pago)','AI-15-CERA-96'),
t_tipo_data('138','Sanción: Urbanística (Justificante de pago)','Sanción: Urbanística (Justificante de pago)','AI-15-CERA-97'),
t_tipo_data('139','Sanción: Tributaria (Justificante de pago)','Sanción: Tributaria (Justificante de pago)','AI-15-CERA-98'),
t_tipo_data('140','Sanción: Ruina (Justificante de pago)','Sanción: Ruina (Justificante de pago)','AI-15-CERA-99'),
t_tipo_data('141','Sanción: Multa coercitiva (Justificante de pago)','Sanción: Multa coercitiva (Justificante de pago)','AI-15-CERA-AA'),
t_tipo_data('142','Comunidad de propietarios: Cuota extraordinaria (derrama) (Justificante de pago)','Comunidad de propietarios: Cuota extraordinaria (derrama) (Justificante de pago)','AI-15-CERA-AB'),
t_tipo_data('143','Comunidad de propietarios: Certificado deuda comunidad (Justificante de pago)','Comunidad de propietarios: Certificado deuda comunidad (Justificante de pago)','AI-15-CERA-AC'),
t_tipo_data('144','Comunidad de propietarios: Cuota ordinaria (Justificante de pago)','Comunidad de propietarios: Cuota ordinaria (Justificante de pago)','AI-15-CERA-AD'),
t_tipo_data('145','Complejo inmobiliario: Cuota ordinaria (Justificante de pago)','Complejo inmobiliario: Cuota ordinaria (Justificante de pago)','AI-15-CERA-AE'),
t_tipo_data('146','Complejo inmobiliario: Cuota extraordinaria (derrama) (Justificante de pago)','Complejo inmobiliario: Cuota extraordinaria (derrama) (Justificante de pago)','AI-15-CERA-AF'),
t_tipo_data('147','Junta de compensación / EUC: Gastos generales (Justificante de pago)','Junta de compensación / EUC: Gastos generales (Justificante de pago)','AI-15-CERA-AG'),
t_tipo_data('148','Junta de compensación / EUC: Cuotas y derramas (Justificante de pago)','Junta de compensación / EUC: Cuotas y derramas (Justificante de pago)','AI-15-CERA-AH'),
t_tipo_data('149','Otras entidades en que se integra el activo: Gastos generales (Justificante de pago)','Otras entidades en que se integra el activo: Gastos generales (Justificante de pago)','AI-15-CERA-AI'),
t_tipo_data('150','Otras entidades en que se integra el activo: Cuotas y derramas (Justificante de pago)','Otras entidades en que se integra el activo: Cuotas y derramas (Justificante de pago)','AI-15-CERA-AJ'),
t_tipo_data('151','Suministro: Agua (Justificante de pago)','Suministro: Agua (Justificante de pago)','AI-15-CERA-AK'),
t_tipo_data('152','Suministro: Electricidad (Justificante de pago)','Suministro: Electricidad (Justificante de pago)','AI-15-CERA-AL'),
t_tipo_data('153','Suministro: Gas (Justificante de pago)','Suministro: Gas (Justificante de pago)','AI-15-CERA-AM'),
t_tipo_data('154','Seguros: Prima RC (responsabilidad civil) (Justificante de pago)','Seguros: Prima RC (responsabilidad civil) (Justificante de pago)','AI-15-CERA-AN'),
t_tipo_data('155','Seguros: Prima TRDM (todo riesgo daño material) (Justificante de pago)','Seguros: Prima TRDM (todo riesgo daño material) (Justificante de pago)','AI-15-CERA-AO'),
t_tipo_data('156','Seguros: Parte daños propios (Justificante de pago)','Seguros: Parte daños propios (Justificante de pago)','AI-15-CERA-AP'),
t_tipo_data('157','Seguros: Parte daños a terceros (Justificante de pago)','Seguros: Parte daños a terceros (Justificante de pago)','AI-15-CERA-AQ'),
t_tipo_data('158','Servicios profesionales independientes: Abogado (Asuntos generales) (Justificante de pago)','Servicios profesionales independientes: Abogado (Asuntos generales) (Justificante de pago)','AI-15-CERA-AR'),
t_tipo_data('159','Servicios profesionales independientes: Abogado (Asistencia jurídica) (Justificante de pago)','Servicios profesionales independientes: Abogado (Asistencia jurídica) (Justificante de pago)','AI-15-CERA-AS'),
t_tipo_data('160','Servicios profesionales independientes: Registro (Justificante de pago)','Servicios profesionales independientes: Registro (Justificante de pago)','AI-15-CERA-AT'),
t_tipo_data('161','Servicios profesionales independientes: Notaría (Justificante de pago)','Servicios profesionales independientes: Notaría (Justificante de pago)','AI-15-CERA-AU'),
t_tipo_data('162','Servicios profesionales independientes: Abogado (Justificante de pago)','Servicios profesionales independientes: Abogado (Justificante de pago)','AI-15-CERA-AV'),
t_tipo_data('163','Servicios profesionales independientes: Procurador (Justificante de pago)','Servicios profesionales independientes: Procurador (Justificante de pago)','AI-15-CERA-AW'),
t_tipo_data('164','Servicios profesionales independientes: Otros servicios jurídicos (Justificante de pago)','Servicios profesionales independientes: Otros servicios jurídicos (Justificante de pago)','AI-15-CERA-AX'),
t_tipo_data('165','Servicios profesionales independientes: Administrador Comunidad Propietarios (Justificante de pago)','Servicios profesionales independientes: Administrador Comunidad Propietarios (Justificante de pago)','AI-15-CERA-AY'),
t_tipo_data('166','Servicios profesionales independientes: Asesoría (Justificante de pago)','Servicios profesionales independientes: Asesoría (Justificante de pago)','AI-15-CERA-AZ'),
t_tipo_data('167','Servicios profesionales independientes: Técnico (Justificante de pago)','Servicios profesionales independientes: Técnico (Justificante de pago)','AI-15-CERA-BA'),
t_tipo_data('168','Servicios profesionales independientes: Tasación (Justificante de pago)','Servicios profesionales independientes: Tasación (Justificante de pago)','AI-15-CERA-BB'),
t_tipo_data('169','Servicios profesionales independientes: Gestión de suelo (Justificante de pago)','Servicios profesionales independientes: Gestión de suelo (Justificante de pago)','AI-15-CERA-BC'),
t_tipo_data('170','Servicios profesionales independientes: Abogado (Ocupacional) (Justificante de pago)','Servicios profesionales independientes: Abogado (Ocupacional) (Justificante de pago)','AI-15-CERA-BD'),
t_tipo_data('171','Gestoría: Honorarios gestión ventas (Justificante de pago)','Gestoría: Honorarios gestión ventas (Justificante de pago)','AI-15-CERA-BE'),
t_tipo_data('172','Gestoría: Honorarios gestión activos (Justificante de pago)','Gestoría: Honorarios gestión activos (Justificante de pago)','AI-15-CERA-BF'),
t_tipo_data('173','Comisiones: Fuerza de Venta Directa (Justificante de pago)','Comisiones: Fuerza de Venta Directa (Justificante de pago)','AI-15-CERA-BG'),
t_tipo_data('174','Comisiones: Mediador (Justificante de pago)','Comisiones: Mediador (Justificante de pago)','AI-15-CERA-BH'),
t_tipo_data('175','Informes técnicos y obtención documentos: Inspección técnica de edificios (Justificante de pago)','Informes técnicos y obtención documentos: Inspección técnica de edificios (Justificante de pago)','AI-15-CERA-BI'),
t_tipo_data('176','Informes técnicos y obtención documentos: Informe topográfico (Justificante de pago)','Informes técnicos y obtención documentos: Informe topográfico (Justificante de pago)','AI-15-CERA-BJ'),
t_tipo_data('177','Informes técnicos y obtención documentos: VPO: Autorización de venta (Justificante de pago)','Informes técnicos y obtención documentos: VPO: Autorización de venta (Justificante de pago)','AI-15-CERA-BK'),
t_tipo_data('178','Informes técnicos y obtención documentos: VPO: Notificación adjudicación (tanteo) (Justificante de p','Informes técnicos y obtención documentos: VPO: Notificación adjudicación (tanteo) (Justificante de pago)','AI-15-CERA-BL'),
t_tipo_data('179','Informes técnicos y obtención documentos: VPO: Solicitud devolución ayudas (Justificante de pago)','Informes técnicos y obtención documentos: VPO: Solicitud devolución ayudas (Justificante de pago)','AI-15-CERA-BM'),
t_tipo_data('180','Informes técnicos y obtención documentos: Nota simple actualizada (Justificante de pago)','Informes técnicos y obtención documentos: Nota simple actualizada (Justificante de pago)','AI-15-CERA-BN'),
t_tipo_data('181','Informes técnicos y obtención documentos: Obtención certificados y documentación (Justificante de pa','Informes técnicos y obtención documentos: Obtención certificados y documentación (Justificante de pago)','AI-15-CERA-BO'),
t_tipo_data('182','Informes técnicos y obtención documentos: Boletín instalaciones y suministros (Justificante de pago)','Informes técnicos y obtención documentos: Boletín instalaciones y suministros (Justificante de pago)','AI-15-CERA-BP'),
t_tipo_data('183','Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Justificante de pago)','Informes técnicos y obtención documentos: Certificado Final de Obra (CFO) (Justificante de pago)','AI-15-CERA-BQ'),
t_tipo_data('184','Informes técnicos y obtención documentos: Cédula Habitabilidad (Justificante de pago)','Informes técnicos y obtención documentos: Cédula Habitabilidad (Justificante de pago)','AI-15-CERA-BR'),
t_tipo_data('185','Informes técnicos y obtención documentos: Licencia Primera Ocupación (LPO) (Justificante de pago)','Informes técnicos y obtención documentos: Licencia Primera Ocupación (LPO) (Justificante de pago)','AI-15-CERA-BS'),
t_tipo_data('186','Informes técnicos y obtención documentos: Certif. eficiencia energética (CEE) (Justificante de pago)','Informes técnicos y obtención documentos: Certif. eficiencia energética (CEE) (Justificante de pago)','AI-15-CERA-BT'),
t_tipo_data('187','Informes técnicos y obtención documentos: Informes (Justificante de pago)','Informes técnicos y obtención documentos: Informes (Justificante de pago)','AI-15-CERA-BU'),
t_tipo_data('188','Actuación técnica y mantenimiento: Limpieza y retirada de enseres (Justificante de pago)','Actuación técnica y mantenimiento: Limpieza y retirada de enseres (Justificante de pago)','AI-15-CERA-BV'),
t_tipo_data('189','Actuación técnica y mantenimiento: Limpieza, desinfección… (solares) (Justificante de pago)','Actuación técnica y mantenimiento: Limpieza, desinfección… (solares) (Justificante de pago)','AI-15-CERA-BW'),
t_tipo_data('190','Actuación técnica y mantenimiento: Cambio de cerradura (Justificante de pago)','Actuación técnica y mantenimiento: Cambio de cerradura (Justificante de pago)','AI-15-CERA-BX'),
t_tipo_data('191','Actuación técnica y mantenimiento: Tapiado (Justificante de pago)','Actuación técnica y mantenimiento: Tapiado (Justificante de pago)','AI-15-CERA-BY'),
t_tipo_data('192','Actuación técnica y mantenimiento: Retirada de enseres (Justificante de pago)','Actuación técnica y mantenimiento: Retirada de enseres (Justificante de pago)','AI-15-CERA-BZ'),
t_tipo_data('193','Actuación técnica y mantenimiento: Limpieza (Justificante de pago)','Actuación técnica y mantenimiento: Limpieza (Justificante de pago)','AI-15-CERA-CA'),
t_tipo_data('194','Actuación técnica y mantenimiento: Actuación post-venta (Justificante de pago)','Actuación técnica y mantenimiento: Actuación post-venta (Justificante de pago)','AI-15-CERA-CB'),
t_tipo_data('195','Actuación técnica y mantenimiento: Mobiliario (Justificante de pago)','Actuación técnica y mantenimiento: Mobiliario (Justificante de pago)','AI-15-CERA-CC'),
t_tipo_data('196','Actuación técnica y mantenimiento: Colocación puerta antiocupa (Justificante de pago)','Actuación técnica y mantenimiento: Colocación puerta antiocupa (Justificante de pago)','AI-15-CERA-CD'),
t_tipo_data('197','Actuación técnica y mantenimiento: Control de actuaciones (dirección técnica) (Justificante de pago)','Actuación técnica y mantenimiento: Control de actuaciones (dirección técnica) (Justificante de pago)','AI-15-CERA-CE'),
t_tipo_data('198','Actuación técnica y mantenimiento: Obra mayor. Edificación (certif. de obra) (Justificante de pago)','Actuación técnica y mantenimiento: Obra mayor. Edificación (certif. de obra) (Justificante de pago)','AI-15-CERA-CF'),
t_tipo_data('199','Actuación técnica y mantenimiento: Obra menor (Justificante de pago)','Actuación técnica y mantenimiento: Obra menor (Justificante de pago)','AI-15-CERA-CG'),
t_tipo_data('200','Actuación técnica y mantenimiento: Verificación de averías (Justificante de pago)','Actuación técnica y mantenimiento: Verificación de averías (Justificante de pago)','AI-15-CERA-CH'),
t_tipo_data('201','Actuación técnica y mantenimiento: Seguridad y Salud (SS) (Justificante de pago)','Actuación técnica y mantenimiento: Seguridad y Salud (SS) (Justificante de pago)','AI-15-CERA-CI'),
t_tipo_data('202','Actuación técnica y mantenimiento: Limpieza, retirada de enseres y descerraje (Justificante de pago)','Actuación técnica y mantenimiento: Limpieza, retirada de enseres y descerraje (Justificante de pago)','AI-15-CERA-CJ'),
t_tipo_data('203','Vigilancia y seguridad: Servicios auxiliares (Justificante de pago)','Vigilancia y seguridad: Servicios auxiliares (Justificante de pago)','AI-15-CERA-CK'),
t_tipo_data('204','Vigilancia y seguridad: Alarmas (Justificante de pago)','Vigilancia y seguridad: Alarmas (Justificante de pago)','AI-15-CERA-CL'),
t_tipo_data('205','Vigilancia y seguridad: Vigilancia y seguridad (Justificante de pago)','Vigilancia y seguridad: Vigilancia y seguridad (Justificante de pago)','AI-15-CERA-CM'),
t_tipo_data('206','Publicidad: Publicidad (Justificante de pago)','Publicidad: Publicidad (Justificante de pago)','AI-15-CERA-CN'),
t_tipo_data('207','Otros gastos: Costas judiciales (Justificante de pago)','Otros gastos: Costas judiciales (Justificante de pago)','AI-15-CERA-CO'),
t_tipo_data('208','Otros gastos: Mensajería/correos/copias (Justificante de pago)','Otros gastos: Mensajería/correos/copias (Justificante de pago)','AI-15-CERA-CP'),
t_tipo_data('209','Otros gastos: Costas judiciales (demanda comunidad propietarios) (Justificante de pago)','Otros gastos: Costas judiciales (demanda comunidad propietarios) (Justificante de pago)','AI-15-CERA-CQ'),
t_tipo_data('210','Otros gastos: Costas judiciales (otras demandas) (Justificante de pago)','Otros gastos: Costas judiciales (otras demandas) (Justificante de pago)','AI-15-CERA-CR')


    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 -- borramos los datos existentes
     V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO ' ||
               'SET BORRADO = 1 WHERE DD_TPD_CODIGO IN (''26'',''27'',''28'') ';
     EXECUTE IMMEDIATE V_MSQL;


    -- LOOP para insertar los valores en DD_TPD_TIPOS_DOCUMENTO_GASTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPD_TIPOS_DOCUMENTO_GASTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPD_TIPOS_DOCUMENTO_GASTO WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;


       --Si no existe, lo insertamos
        IF V_NUM_TABLAS = 0 THEN

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO (' ||
                      'DD_TPD_ID,DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA, DD_TPD_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT S_DD_TPD_TP_DTO_GASTO.NEXTVAL,'''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

         ELSE
        --Si existe lo modificamos
         DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATEAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
         V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPD_TIPOS_DOCUMENTO_GASTO ' ||
                   'SET DD_TPD_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '  ||
                   ',   DD_TPD_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''  ' ||
	               ' WHERE DD_TPD_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';
           EXECUTE IMMEDIATE V_MSQL;
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EAC_ESTADO_ACTIVO ACTUALIZADO CORRECTAMENTE ');


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
