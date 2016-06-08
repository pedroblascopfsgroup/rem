/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160608
--## ARTEFACTO=haya-sareb
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1365
--## PRODUCTO=NO
--##
--## Finalidad: DML Poblacion de la tabla DD_TAE_TIPO_ADJUNTO_ENTIDAD con datos particulares de Haya-Sareb (adaptados a Gestor Documental Haya)
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_TABLENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
T_TIPO_TPO('AF-01-CEDU-01','Cédula urbanística'),
T_TIPO_TPO('AF-01-CERJ-47','Registro Propiedad: certificación dominio y cargas'),
T_TIPO_TPO('AF-01-CERT-20','Vivienda de protección: certificado provisional'),
T_TIPO_TPO('AF-01-CNCV-50','Reserva: contrato'),
T_TIPO_TPO('AF-01-ESCR-13','Escritura obra nueva y/ o división horizontal'),
T_TIPO_TPO('AF-01-ESTT-03','Estudio geotécnico: documento'),
T_TIPO_TPO('AF-01-FICH-10','Ficha resumen'),
T_TIPO_TPO('AF-01-LIPR-05','Obra: licencia obras'),
T_TIPO_TPO('AF-01-MEMO-05','Memoria calidades'),
T_TIPO_TPO('AF-01-PLAO-27','Plano situación'),
T_TIPO_TPO('AF-01-PLAP-07','Planificación económica de la promoción'),
T_TIPO_TPO('AF-01-PRES-13','Presupuesto'),
T_TIPO_TPO('AF-01-PRES-05','Presupuesto ejecución material'),
T_TIPO_TPO('AF-01-PRES-04','Contrato: presupuesto'),
T_TIPO_TPO('AF-01-PRYT-02','Documentación técnica proyecto'),
T_TIPO_TPO('AF-01-SEGU-11','Seguro responsabilidad decenal: póliza'),
T_TIPO_TPO('AF-01-CUAD-02','Cuadro amortización'),
T_TIPO_TPO('AF-01-CUAD-04','Cuadro distribución responsabilidad hipotecaria'),
T_TIPO_TPO('AF-01-ESIN-26','Informe CIRBE situación con el resto del sistema financiero'),
T_TIPO_TPO('AF-01-ESIN-90','Informe legal activo'),
T_TIPO_TPO('AF-01-ESIN-39','Informe rating interno'),
T_TIPO_TPO('AF-01-ACUE-01','Aprobación / denegación operación financiera'),
T_TIPO_TPO('AF-01-ESIN-91','Informe ejecutivo activo'),

T_TIPO_TPO('AF-02-ACUE-08','Acuerdo despignoración'),
T_TIPO_TPO('AF-02-ANEX-02','Ayuda y/o subvención: anexo información básica del deudor y de la operación solicitada al ICO'),
T_TIPO_TPO('AF-02-ANEX-01','Ayuda y/o subvención: anexo finalidad operación financiera'),
T_TIPO_TPO('AF-02-ANEX-03','Ayuda y/o subvención: anexo mínimos'),
T_TIPO_TPO('AF-02-CNCV-10','Ayuda y/o subvención: contrato reafianzamiento'),
T_TIPO_TPO('AF-02-CNCV-24','Contrato subrogación'),
T_TIPO_TPO('AF-02-CNCV-23','Contrato operación financiera'),
T_TIPO_TPO('AF-02-CNCV-18','Contrato constitución garantía'),
T_TIPO_TPO('AF-02-CNCV-09','Ayuda y/o subvención: contrato colaboración entidad otorgante'),
T_TIPO_TPO('AF-02-CNCV-34','Covenant - Indicadores de calidad del riesgo o de control'),
T_TIPO_TPO('AF-02-CNCV-16','Contrato cobertura'),
T_TIPO_TPO('AF-02-CNCV-08','Ayuda y/o subvención: acuerdo marco y/o pliego de condiciones'),
T_TIPO_TPO('AF-02-CNCV-38','Operaciones sindicadas: contrato entidades participantes'),
T_TIPO_TPO('AF-02-CNCV-35','Dación: contrato'),
T_TIPO_TPO('AF-02-CNCV-12','Cancelación: contrato'),
T_TIPO_TPO('AF-02-CNCV-17','Contrato compraventa'),
T_TIPO_TPO('AF-02-COMU-47','Autorización de acreditado y propietario levantamiento pignoración'),
T_TIPO_TPO('AF-02-DOCN-06','Traspaso Sareb: acta complementaria cambio titularidad'),
T_TIPO_TPO('AF-02-ESCR-12','Escritura covenant'),
T_TIPO_TPO('AF-02-ESCR-11','Escritura constitución de garantía'),
T_TIPO_TPO('AF-02-ESCR-18','Escritura subrogación'),
T_TIPO_TPO('AF-02-ESCR-16','Escritura préstamo'),
T_TIPO_TPO('AF-02-ESCR-09','Escritura cobertura'),
T_TIPO_TPO('AF-02-ESCR-23','Operaciones sindicadas: escritura entidades participantes'),
T_TIPO_TPO('AF-02-ESCR-02','Cancelación: escritura'),
T_TIPO_TPO('AF-02-ESCR-01','Cancelación carga hipotecaria: escritura'),
T_TIPO_TPO('AF-02-ESCR-06','Dación: escritura'),
T_TIPO_TPO('AF-02-INRG-08','Registro Propiedad: calificación y/o inscripción'),
T_TIPO_TPO('AF-02-NOVA-04','Novación: escritura/contrato'),
T_TIPO_TPO('AF-02-NOVA-02','Documento liberación IPF'),
T_TIPO_TPO('AF-02-NOVA-06','Refinanciación: escritura/contrato'),
T_TIPO_TPO('AF-02-NOVA-05','Quita: escritura/ contrato'),
T_TIPO_TPO('AF-02-NOVA-03','Liberación fiadores: escritura/ contrato'),
T_TIPO_TPO('AF-02-NOVA-01','Cesión crédito: escritura/ contrato'),

T_TIPO_TPO('AF-03-ACUI-01','Acuerdo Sareb de R&R'),
T_TIPO_TPO('AF-03-CERA-19','Justificante abono'),
T_TIPO_TPO('AF-03-CERA-05','Carta pago'),
T_TIPO_TPO('AF-03-CERA-09','Documento desembolso disposición de crédito'),
T_TIPO_TPO('AF-03-CERA-01','Amortización cuenta préstamo'),
T_TIPO_TPO('AF-03-CERA-11','Extracto préstamo donde figure la IPF aplicada o justificante gasto'),
T_TIPO_TPO('AF-03-CERJ-10','Certificado financiación'),
T_TIPO_TPO('AF-03-CERJ-57','Certificado deuda saldo pendiente'),
T_TIPO_TPO('AF-03-CNCV-13','Cobros de regularización específicos: acuerdo'),
T_TIPO_TPO('AF-03-CNCV-58','Cobros de regularización específicos: Plan de Pagos'),
T_TIPO_TPO('AF-03-CNCV-22','Contrato marco PDV'),
T_TIPO_TPO('AF-03-CNCV-56','Waiver: acuerdo'),
T_TIPO_TPO('AF-03-CNCV-52','Standstill: acuerdo'),
T_TIPO_TPO('AF-03-CNCV-61','Comercialización: Mandato'),
T_TIPO_TPO('AF-03-COMU-07','Notificación deudor'),
T_TIPO_TPO('AF-03-COMU-08','Cancelación: notificación cancelación anticipada'),
T_TIPO_TPO('AF-03-COMU-43','Traspaso Sareb: notificación cambio titularidad'),
T_TIPO_TPO('AF-03-CORR-03','Llamada telefónica'),
T_TIPO_TPO('AF-03-CORR-01','Carta correo ordinario'),
T_TIPO_TPO('AF-03-CORR-02','Correo electrónico'),
T_TIPO_TPO('AF-03-CUAD-02','Cuadro amortización'),
T_TIPO_TPO('AF-03-DOCN-03','Disposición préstamo y pólizas crédito: acta notarial'),
T_TIPO_TPO('AF-03-ESIN-28','Informe de "transfer" Sareb'),
T_TIPO_TPO('AF-03-ESIN-90','Informe legal activo'),
T_TIPO_TPO('AF-03-ESIN-91','Informe ejecutivo activo'),
T_TIPO_TPO('AF-03-ESIN-40','Informe solvencia titular / avalista'),
T_TIPO_TPO('AF-03-ESIN-54','Precio transferencia'),
T_TIPO_TPO('AF-03-ESIN-16','Due diligence (legal, fiscal, técnica, urbanística…)'),
T_TIPO_TPO('AF-03-FICH-10','Ficha resumen'),
T_TIPO_TPO('AF-03-PRPE-11','Propuesta regularización'),
T_TIPO_TPO('AF-03-PRPE-08','Propuesta aprobación operación financiera'),
T_TIPO_TPO('AF-03-PRPE-14','Solicitud de la operación'),
T_TIPO_TPO('AF-03-PRPE-10','Propuesta PDV'),
T_TIPO_TPO('AF-03-TASA-13','Valoración Préstamos'),
T_TIPO_TPO('EN-01-CERA-13','Impuesto de sucesiones: justificante abono'),
T_TIPO_TPO('EN-01-CERJ-01','Bastanteo poderes'),
T_TIPO_TPO('EN-01-CERJ-28','Manifestación titularidad real: certificación'),
T_TIPO_TPO('EN-01-CERJ-19','Defunción: certificado'),
T_TIPO_TPO('EN-01-CERJ-51','Ultimas voluntades: certificado'),
T_TIPO_TPO('EN-01-CERJ-55','Certificado de empadronamiento'),
T_TIPO_TPO('EN-01-DOCA-37','Sucesiones: otro documento'),
T_TIPO_TPO('EN-01-DOCI-01','DNI'),
T_TIPO_TPO('EN-01-DOCI-07','CIF'),
T_TIPO_TPO('EN-01-DOCI-02','Documento identidad Ministerio de Asuntos Exteriores'),
T_TIPO_TPO('EN-01-DOCI-03','Documento oficial identidad (país de origen UE)'),
T_TIPO_TPO('EN-01-DOCI-04','Libro de familia'),
T_TIPO_TPO('EN-01-DOCI-05','Pasaporte'),
T_TIPO_TPO('EN-01-DOCI-06','Tarjeta de residencia'),
T_TIPO_TPO('EN-01-DOCN-02','Acta protocolización acuerdos sociales'),
T_TIPO_TPO('EN-01-DOCN-05','Manifestación titularidad real: acta notarial'),
T_TIPO_TPO('EN-01-ESCR-04','Constitución: escritura'),
T_TIPO_TPO('EN-01-ESCR-15','Escritura poder'),
T_TIPO_TPO('EN-01-ESCR-21','Herencia: escritura adjudicación y aceptación'),
T_TIPO_TPO('EN-01-ESCR-22','Herencia: testamento o declaración de herederos'),
T_TIPO_TPO('EN-01-ESIN-25','Herencia: dictamen jurídico'),
T_TIPO_TPO('EN-01-ESTA-02','Estatutos sociales'),
T_TIPO_TPO('EN-01-FICH-19','Ficha cliente'),
T_TIPO_TPO('EN-01-FICH-04','Ficha conocimiento cliente (KYC)'),
T_TIPO_TPO('EN-01-LICM-03','Libro registro socios'),

T_TIPO_TPO('EN-02-AYSU-01','Subvención recibida'),
T_TIPO_TPO('EN-02-CERA-06','Colegio profesional: recibo'),
T_TIPO_TPO('EN-02-CERA-31','Régimen especial de autónomos (RETA): recibo'),
T_TIPO_TPO('EN-02-CERA-33','Seguridad social: certificado estar al corriente de pagos'),
T_TIPO_TPO('EN-02-CERA-21','Obligaciones tributarias: certificado estar al corriente de pago'),
T_TIPO_TPO('EN-02-CERA-46','Impuesto actividades económicas (IAE): recibo'),
T_TIPO_TPO('EN-02-CERJ-13','Contrato laboral: certificación'),
T_TIPO_TPO('EN-02-CERJ-15','Cuentas anuales: presentación registro'),
T_TIPO_TPO('EN-02-CERJ-23','Extracto bancario'),
T_TIPO_TPO('EN-02-CERJ-24','Impuesto actividades económicas (IAE): certificación alta'),
T_TIPO_TPO('EN-02-CERJ-44','Referencia escrita entidades financieras'),
T_TIPO_TPO('EN-02-CERJ-16','Cumplimiento Ley integración social minusvalidos (LISMI): certificado'),
T_TIPO_TPO('EN-02-CERJ-18','Declaración idoneidad'),
T_TIPO_TPO('EN-02-CERJ-45','Régimen especial de autónomos (RETA): alta'),
T_TIPO_TPO('EN-02-CERJ-56','Certificado de vida laboral'),
T_TIPO_TPO('EN-02-CNCV-21','Contrato laboral'),
T_TIPO_TPO('EN-02-CULC-03','Estados financieros'),
T_TIPO_TPO('EN-02-DECL-03','Impuesto general indirecto canario (IGIC): declaración'),
T_TIPO_TPO('EN-02-DECL-04','Impuesto país origen'),
T_TIPO_TPO('EN-02-DECL-06','Impuesto renta personas físicas (IRPF): declaración'),
T_TIPO_TPO('EN-02-DECL-07','Impuesto renta personas físicas (IRPF): retención'),
T_TIPO_TPO('EN-02-DECL-08','Impuesto sociedades: declaración'),
T_TIPO_TPO('EN-02-DECL-09','Impuesto valor añadido (IVA): declaración'),
T_TIPO_TPO('EN-02-ESIN-14','Cuentas anuales: informe auditoría'),
T_TIPO_TPO('EN-02-ESIN-30','Informe de revisión de experto'),
T_TIPO_TPO('EN-02-ESIN-35','Informe factiva'),
T_TIPO_TPO('EN-02-INSS-01','Impuesto actividades económicas (IAE): alta'),
T_TIPO_TPO('EN-02-LICM-06','Manual PBC'),
T_TIPO_TPO('EN-02-LICM-11','Política prevención riesgos penales'),
T_TIPO_TPO('EN-02-MEMO-04','Memoria actividades'),
T_TIPO_TPO('EN-02-PLAP-04','Plan de negocio'),
T_TIPO_TPO('EN-02-PRES-13','Presupuesto'),
T_TIPO_TPO('EN-02-RETR-01','Desempleo'),
T_TIPO_TPO('EN-02-RETR-02','Nómina'),
T_TIPO_TPO('EN-02-RETR-03','Pensión'),
T_TIPO_TPO('EN-02-SEGU-09','Seguro responsabilidad civil o indemnización: póliza'),

T_TIPO_TPO('EN-03-AYSU-01','Subvención recibida'),
T_TIPO_TPO('EN-03-CERA-18','Indemnización: cobro'),
T_TIPO_TPO('EN-03-CERJ-34','Premio lotería: certificado'),
T_TIPO_TPO('EN-03-CERJ-35','Préstamo financiación operación: certificación / nota simple'),
T_TIPO_TPO('EN-03-CNCV-44','Préstamo financiación operación: contrato privado'),
T_TIPO_TPO('EN-03-CNCV-25','Contrato transacción comercial o prestación de servicios'),
T_TIPO_TPO('EN-03-DECL-05','Impuesto patrimonio'),
T_TIPO_TPO('EN-03-DECL-02','Declaración operación con tercero o inversión'),
T_TIPO_TPO('EN-03-ESCR-26','Titularidad del activo: otra escritura'),
T_TIPO_TPO('EN-03-ESCR-10','Escritura compraventa'),
T_TIPO_TPO('EN-03-FACT-06','Factura comercial'),
T_TIPO_TPO('EN-03-PRPE-07','Préstamo financiación operación: comunicación concesión financiación bancaria'),

T_TIPO_TPO('EN-04-CEDU-01','Cédula urbanística'),
T_TIPO_TPO('EN-04-CERJ-47','Registro Propiedad: certificación dominio y cargas'),
T_TIPO_TPO('EN-04-CERJ-26','Inversión en instrumentos de capital'),
T_TIPO_TPO('EN-04-CNCV-15','Contrato arrendamiento'),
T_TIPO_TPO('EN-04-CNCV-14','Contrato apertura de cuentas'),
T_TIPO_TPO('EN-04-ESIN-64','Informe ASNEF'),
T_TIPO_TPO('EN-04-FIAV-04','Imposiciones a plazo'),
T_TIPO_TPO('EN-04-FICH-03','Declaración de bienes'),
T_TIPO_TPO('EN-04-TASA-09','Tasación activo'),
T_TIPO_TPO('EN-04-TASA-07','Informe valoración patrimonio'),
T_TIPO_TPO('EN-04-IPLS-32','Justificante de datos patrimoniales'), 

T_TIPO_TPO('AF-05-IPLS-02','Carta de aval'),
T_TIPO_TPO('AF-05-IPLS-03','Disposiciones'),
T_TIPO_TPO('AF-05-IPLS-04','Documento de formalización'),
T_TIPO_TPO('AF-05-IPLS-05','Ficha personalizada'),
T_TIPO_TPO('AF-05-IPLS-06','Ficha precontractual'),
T_TIPO_TPO('AF-05-IPLS-07','Información normalizada europea (INE)'),
T_TIPO_TPO('AF-05-IPLS-08','Informes jurídicos'),
T_TIPO_TPO('AF-05-IPLS-09','Oferta vinculante'),
T_TIPO_TPO('AF-05-IPLS-10','Recuperaciones'),
T_TIPO_TPO('AF-05-IPLS-11','Solicitud'),
T_TIPO_TPO('AF-05-IPLS-12','Documento doc'),
T_TIPO_TPO('AF-05-IPLS-13','Documento genérico'),
T_TIPO_TPO('AF-05-IPLS-14','Transfer certificate provisional'),
T_TIPO_TPO('AF-05-IPLS-34','Justificantes de compromisos de pago'),
T_TIPO_TPO('AF-05-IPLS-35','Justificantes inversión/finalidad'),

T_TIPO_TPO('EN-06-IPLS-29','Documentación RBE'),
T_TIPO_TPO('EN-06-IPLS-30','Otras escrituras'),
T_TIPO_TPO('EN-06-IPLS-31','Justificante de actividad'),
T_TIPO_TPO('EN-06-IPLS-32','Justificante de datos patrimoniales'),
T_TIPO_TPO('EN-06-IPLS-33','Justificante de ingresos')

    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    TYPE T_REL IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_REL IS TABLE OF T_REL;
    V_REL T_ARRAY_REL := T_ARRAY_REL(
T_REL('AF-01-CEDU-01','Contrato'),
T_REL('AF-01-CERJ-47','Contrato'),
T_REL('AF-01-CERT-20','Contrato'),
T_REL('AF-01-CNCV-50','Contrato'),
T_REL('AF-01-ESCR-13','Contrato'),
T_REL('AF-01-ESTT-03','Contrato'),
T_REL('AF-01-FICH-10','Contrato'),
T_REL('AF-01-LIPR-05','Contrato'),
T_REL('AF-01-MEMO-05','Contrato'),
T_REL('AF-01-PLAO-27','Contrato'),
T_REL('AF-01-PLAP-07','Contrato'),
T_REL('AF-01-PRES-13','Contrato'),
T_REL('AF-01-PRES-05','Contrato'),
T_REL('AF-01-PRES-04','Contrato'),
T_REL('AF-01-PRYT-02','Contrato'),
T_REL('AF-01-SEGU-11','Contrato'),
T_REL('AF-01-CUAD-02','Contrato'),
T_REL('AF-01-CUAD-04','Contrato'),
T_REL('AF-01-ESIN-26','Contrato'),
T_REL('AF-01-ESIN-90','Contrato'),
T_REL('AF-01-ESIN-39','Contrato'),
T_REL('AF-01-ACUE-01','Contrato'),
T_REL('AF-01-ESIN-91','Contrato'),

T_REL('AF-02-ACUE-08','Contrato'),
T_REL('AF-02-ANEX-02','Contrato'),
T_REL('AF-02-ANEX-01','Contrato'),
T_REL('AF-02-ANEX-03','Contrato'),
T_REL('AF-02-CNCV-10','Contrato'),
T_REL('AF-02-CNCV-24','Contrato'),
T_REL('AF-02-CNCV-23','Contrato'),
T_REL('AF-02-CNCV-18','Contrato'),
T_REL('AF-02-CNCV-09','Contrato'),
T_REL('AF-02-CNCV-34','Contrato'),
T_REL('AF-02-CNCV-16','Contrato'),
T_REL('AF-02-CNCV-08','Contrato'),
T_REL('AF-02-CNCV-38','Contrato'),
T_REL('AF-02-CNCV-35','Contrato'),
T_REL('AF-02-CNCV-12','Contrato'),
T_REL('AF-02-CNCV-17','Contrato'),
T_REL('AF-02-COMU-47','Contrato'),
T_REL('AF-02-DOCN-06','Contrato'),
T_REL('AF-02-ESCR-12','Contrato'),
T_REL('AF-02-ESCR-11','Contrato'),
T_REL('AF-02-ESCR-18','Contrato'),
T_REL('AF-02-ESCR-16','Contrato'),
T_REL('AF-02-ESCR-09','Contrato'),
T_REL('AF-02-ESCR-23','Contrato'),
T_REL('AF-02-ESCR-02','Contrato'),
T_REL('AF-02-ESCR-01','Contrato'),
T_REL('AF-02-ESCR-06','Contrato'),
T_REL('AF-02-INRG-08','Contrato'),
T_REL('AF-02-NOVA-04','Contrato'),
T_REL('AF-02-NOVA-02','Contrato'),
T_REL('AF-02-NOVA-06','Contrato'),
T_REL('AF-02-NOVA-05','Contrato'),
T_REL('AF-02-NOVA-03','Contrato'),
T_REL('AF-02-NOVA-01','Contrato'),

T_REL('AF-03-ACUI-01','Contrato'),
T_REL('AF-03-CERA-19','Contrato'),
T_REL('AF-03-CERA-05','Contrato'),
T_REL('AF-03-CERA-09','Contrato'),
T_REL('AF-03-CERA-01','Contrato'),
T_REL('AF-03-CERA-11','Contrato'),
T_REL('AF-03-CERJ-10','Contrato'),
T_REL('AF-03-CERJ-57','Contrato'),
T_REL('AF-03-CNCV-13','Contrato'),
T_REL('AF-03-CNCV-58','Contrato'),
T_REL('AF-03-CNCV-22','Contrato'),
T_REL('AF-03-CNCV-56','Contrato'),
T_REL('AF-03-CNCV-52','Contrato'),
T_REL('AF-03-CNCV-61','Contrato'),
T_REL('AF-03-COMU-07','Contrato'),
T_REL('AF-03-COMU-08','Contrato'),
T_REL('AF-03-COMU-43','Contrato'),
T_REL('AF-03-CORR-03','Contrato'),
T_REL('AF-03-CORR-01','Contrato'),
T_REL('AF-03-CORR-02','Contrato'),
T_REL('AF-03-CUAD-02','Contrato'),
T_REL('AF-03-DOCN-03','Contrato'),
T_REL('AF-03-ESIN-28','Contrato'),
T_REL('AF-03-ESIN-90','Contrato'),
T_REL('AF-03-ESIN-91','Contrato'),
T_REL('AF-03-ESIN-40','Contrato'),
T_REL('AF-03-ESIN-54','Contrato'),
T_REL('AF-03-ESIN-16','Contrato'),
T_REL('AF-03-FICH-10','Contrato'),
T_REL('AF-03-PRPE-11','Contrato'),
T_REL('AF-03-PRPE-08','Contrato'),
T_REL('AF-03-PRPE-14','Contrato'),
T_REL('AF-03-PRPE-10','Contrato'),
T_REL('AF-03-TASA-13','Contrato'),

T_REL('EN-01-CERA-13','Persona'),
T_REL('EN-01-CERJ-01','Persona'),
T_REL('EN-01-CERJ-28','Persona'),
T_REL('EN-01-CERJ-19','Persona'),
T_REL('EN-01-CERJ-51','Persona'),
T_REL('EN-01-CERJ-55','Persona'),
T_REL('EN-01-DOCA-37','Persona'),
T_REL('EN-01-DOCI-01','Persona'),
T_REL('EN-01-DOCI-07','Persona'),
T_REL('EN-01-DOCI-02','Persona'),
T_REL('EN-01-DOCI-03','Persona'),
T_REL('EN-01-DOCI-04','Persona'),
T_REL('EN-01-DOCI-05','Persona'),
T_REL('EN-01-DOCI-06','Persona'),
T_REL('EN-01-DOCN-02','Persona'),
T_REL('EN-01-DOCN-05','Persona'),
T_REL('EN-01-ESCR-04','Persona'),
T_REL('EN-01-ESCR-15','Persona'),
T_REL('EN-01-ESCR-21','Persona'),
T_REL('EN-01-ESCR-22','Persona'),
T_REL('EN-01-ESIN-25','Persona'),
T_REL('EN-01-ESTA-02','Persona'),
T_REL('EN-01-FICH-19','Persona'),
T_REL('EN-01-FICH-04','Persona'),
T_REL('EN-01-LICM-03','Persona'),

T_REL('EN-02-AYSU-01','Persona'),
T_REL('EN-02-CERA-06','Persona'),
T_REL('EN-02-CERA-31','Persona'),
T_REL('EN-02-CERA-33','Persona'),
T_REL('EN-02-CERA-21','Persona'),
T_REL('EN-02-CERA-46','Persona'),
T_REL('EN-02-CERJ-13','Persona'),
T_REL('EN-02-CERJ-15','Persona'),
T_REL('EN-02-CERJ-23','Persona'),
T_REL('EN-02-CERJ-24','Persona'),
T_REL('EN-02-CERJ-44','Persona'),
T_REL('EN-02-CERJ-16','Persona'),
T_REL('EN-02-CERJ-18','Persona'),
T_REL('EN-02-CERJ-45','Persona'),
T_REL('EN-02-CERJ-56','Persona'),
T_REL('EN-02-CNCV-21','Persona'),
T_REL('EN-02-CULC-03','Persona'),
T_REL('EN-02-DECL-03','Persona'),
T_REL('EN-02-DECL-04','Persona'),
T_REL('EN-02-DECL-06','Persona'),
T_REL('EN-02-DECL-07','Persona'),
T_REL('EN-02-DECL-08','Persona'),
T_REL('EN-02-DECL-09','Persona'),
T_REL('EN-02-ESIN-14','Persona'),
T_REL('EN-02-ESIN-30','Persona'),
T_REL('EN-02-ESIN-35','Persona'),
T_REL('EN-02-INSS-01','Persona'),
T_REL('EN-02-LICM-06','Persona'),
T_REL('EN-02-LICM-11','Persona'),
T_REL('EN-02-MEMO-04','Persona'),
T_REL('EN-02-PLAP-04','Persona'),
T_REL('EN-02-PRES-13','Persona'),
T_REL('EN-02-RETR-01','Persona'),
T_REL('EN-02-RETR-02','Persona'),
T_REL('EN-02-RETR-03','Persona'),
T_REL('EN-02-SEGU-09','Persona'),

T_REL('EN-03-AYSU-01','Persona'),
T_REL('EN-03-CERA-18','Persona'),
T_REL('EN-03-CERJ-34','Persona'),
T_REL('EN-03-CERJ-35','Persona'),
T_REL('EN-03-CNCV-44','Persona'),
T_REL('EN-03-CNCV-25','Persona'),
T_REL('EN-03-DECL-05','Persona'),
T_REL('EN-03-DECL-02','Persona'),
T_REL('EN-03-ESCR-26','Persona'),
T_REL('EN-03-ESCR-10','Persona'),
T_REL('EN-03-FACT-06','Persona'),
T_REL('EN-03-PRPE-07','Persona'),

T_REL('EN-04-CEDU-01','Persona'),
T_REL('EN-04-CERJ-47','Persona'),
T_REL('EN-04-CERJ-26','Persona'),
T_REL('EN-04-CNCV-15','Persona'),
T_REL('EN-04-CNCV-14','Persona'),
T_REL('EN-04-ESIN-64','Persona'),
T_REL('EN-04-FIAV-04','Persona'),
T_REL('EN-04-FICH-03','Persona'),
T_REL('EN-04-TASA-09','Persona'),
T_REL('EN-04-TASA-07','Persona'),
T_REL('EN-04-IPLS-32','Persona'), 

T_REL('AF-05-IPLS-02','Contrato'), 
T_REL('AF-05-IPLS-03','Contrato'), 
T_REL('AF-05-IPLS-04','Contrato'), 
T_REL('AF-05-IPLS-05','Contrato'), 
T_REL('AF-05-IPLS-06','Contrato'), 
T_REL('AF-05-IPLS-07','Contrato'), 
T_REL('AF-05-IPLS-08','Contrato'), 
T_REL('AF-05-IPLS-09','Contrato'), 
T_REL('AF-05-IPLS-10','Contrato'), 
T_REL('AF-05-IPLS-11','Contrato'), 
T_REL('AF-05-IPLS-12','Contrato'), 
T_REL('AF-05-IPLS-13','Contrato'), 
T_REL('AF-05-IPLS-14','Contrato'), 
T_REL('AF-05-IPLS-34','Contrato'), 
T_REL('AF-05-IPLS-35','Contrato'), 

T_REL('EN-06-IPLS-29','Persona'), 
T_REL('EN-06-IPLS-30','Persona'), 
T_REL('EN-06-IPLS-31','Persona'), 
T_REL('EN-06-IPLS-32','Persona'), 
T_REL('EN-06-IPLS-33','Persona')

    ); 
    V_TMP_REL T_REL;


BEGIN

    V_TABLENAME := V_ESQUEMA || '.DD_TAE_TIPO_ADJUNTO_ENTIDAD';
    V_SEQUENCENAME := V_ESQUEMA || '.S_DD_TAE_TIPO_ADJUNTO_ENTIDAD';

    DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado LÓGICO de datos previos en '||V_TABLENAME || '.');
	V_SQL := 'UPDATE ' || V_TABLENAME || ' SET BORRADO=1';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE BORRADO LÓGICO DE LA TABLA ' || V_TABLENAME);

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME || '.');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_SQL := q'[MERGE INTO ]' || V_TABLENAME || q'[ tabla  USING (select ']' || V_TMP_TIPO_TPO(1) || q'[' codigo, ']' || V_TMP_TIPO_TPO(2) || q'[' descripcion, ']' || V_TMP_TIPO_TPO(2) || 
            q'[' descripcion_larga, 'GDHAYA' usuariocrear, sysdate fechacrear, 0 version, 0 borrado from DUAL) actual
    ON (tabla.DD_TAE_CODIGO=actual.codigo)
    WHEN NOT MATCHED THEN
    INSERT (DD_TAE_ID,DD_TAE_CODIGO,DD_TAE_DESCRIPCION,DD_TAE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,VERSION,BORRADO)
    VALUES (]' || V_SEQUENCENAME || q'[.NEXTVAL, actual.codigo, actual.descripcion, actual.descripcion_larga, actual.usuariocrear, actual.fechacrear, actual.version, actual.borrado)]';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME || ': ' || V_TMP_TIPO_TPO(1) || '... registros afectados: ' || sql%rowcount);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE INSERCION DE EN LA TABLA ' || V_TABLENAME);

    V_TABLENAME2 := V_ESQUEMA || '.TAE_EIN';
    V_SEQUENCENAME2 := V_ESQUEMA || '.S_TAE_EIN';

    DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado LÓGICO de datos previos en '||V_TABLENAME2 || '.');
	V_SQL := 'UPDATE ' || V_TABLENAME2 || ' SET BORRADO=1';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE BORRADO LÓGICO DE LA TABLA ' || V_TABLENAME2);

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME2 || '.');
    FOR I IN V_REL.FIRST .. V_REL.LAST LOOP
        V_TMP_REL := V_REL(I);
        V_SQL := q'[MERGE INTO ]' || V_TABLENAME2 || q'[ tabla  USING (select (select DD_TAE_ID from ]' || V_TABLENAME || q'[ where DD_TAE_CODIGO=']' || V_TMP_REL(1) || q'[') id_tae, 
            (select DD_EIN_ID from ]' || V_ESQUEMA_M || q'[.DD_EIN_ENTIDAD_INFORMACION where DD_EIN_DESCRIPCION=']' || V_TMP_REL(2) || q'[') id_ein, 
            'GDHAYA' usuariocrear, sysdate fechacrear, 0 version, 0 borrado from DUAL) actual
    ON (tabla.DD_TAE_ID=actual.id_tae AND tabla.DD_EIN_ID=actual.id_ein)
    WHEN NOT MATCHED THEN
    INSERT (TAE_EIN_ID,DD_TAE_ID,DD_EIN_ID,USUARIOCREAR,FECHACREAR,VERSION,BORRADO)
    VALUES (]' || V_SEQUENCENAME2 || q'[.NEXTVAL, actual.id_tae, actual.id_ein, actual.usuariocrear, actual.fechacrear, actual.version, actual.borrado)]';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME2 || ': ' || V_TMP_REL(1) || '-' || V_TMP_REL(2) || '... registros afectados: ' || sql%rowcount);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE INSERCION DE EN LA TABLA ' || V_TABLENAME2);

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
