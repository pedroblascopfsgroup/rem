package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.segmento.model.DDSegmento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.factory.AltaActivoTPFactoryApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoBbvaActivos;
import es.pfsgroup.plugin.rem.model.ActivoDeudoresAcreditados;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoThirdParty;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDeDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSegmento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.service.AltaActivoThirdPartyService;

@Component
public class MSVAltaBBVAExcelValidator extends AbstractMSVActualizador implements MSVLiberator{
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private AltaActivoTPFactoryApi altaActivoTPFactoryApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	public static final class COL_NUM{
		static final int FILA_CABECERA = 1;
		static final int DATOS_PRIMERA_FILA = 2;
		
		//lalves
		static final int NUM_ACTIVO_HAYA = 0;
		static final int COD_SUBCARTERA = 1;
		static final int COD_SUBTIPO_TITULO = 2;
		static final int NUM_ACTIVO_EXTERNO = 3;
		static final int COD_TIPO_ACTIVO = 4;
		static final int COD_SUBTIPO_ACTIVO = 5;
		static final int COD_ESTADO_FISICO = 6;
		static final int COD_USO_DOMINANTE = 7;
		static final int DESC_ACTIVO = 8;
		
		//Dirección
		static final int COD_TIPO_VIA = 9;
		static final int NOMBRE_VIA = 10;
		static final int NUM_VIA = 11;
		static final int ESCALERA = 12;
		static final int PLANTA = 13;
		static final int PUERTA = 14;
		static final int COD_PROVINCIA = 15;
		static final int COD_MUNICIPIO = 16;
		static final int COD_UNIDAD_MUNICIPIO = 17;
		static final int CODPOSTAL = 18;
		
		//Comercializacion
		static final int COD_DESTINO_COMER = 19;
		static final int COD_TIPO_ALQUILER = 20;
		static final int COD_TIPO_DE_COMERCIALIZACION = 21;
		
		//Inscripción
		static final int POBL_REGISTRO = 22;
		static final int NUM_REGISTRO = 23;
		static final int TOMO = 24;
		static final int LIBRO = 25;
		static final int FOLIO = 26;
		static final int FINCA = 27;
		static final int IDUFIR_CRU = 28;
		static final int SUPERFICIE_CONSTRUIDA_M2 = 29;
		static final int SUPERFICIE_UTIL_M2 = 30;
		static final int SUPERFICIE_REPERCUSION_EE_CC = 31;
		static final int PARCELA = 32; // (INCLUIDA OCUPADA EDIFICACION)
		static final int ES_INTEGRADO_DIV_HORIZONTAL = 33;
		
		//Titulo
		static final int NIF_PROPIETARIO = 34;
		static final int GRADO_PROPIEDAD = 35;
		static final int PERCENT_PROPIEDAD = 36;
		static final int PROP_ANTERIOR = 37;
		
		//
		static final int REF_CATASTRAL = 38;
		static final int VPO = 39;
		static final int CALIFICACION_CEE = 40;
		static final int CED_HABITABILIDAD = 41;
		
		//Información publicación
		static final int NIF_MEDIADOR = 42;
		static final int VIVIENDA_NUM_PLANTAS = 43;
		static final int VIVIENDA_NUM_BANYOS = 44;
		static final int VIVIENDA_NUM_ASEOS = 45;
		static final int VIVIENDA_NUM_DORMITORIOS = 46;
		static final int TRASTERO_ANEJO = 47;
		static final int GARAJE_ANEJO = 48;
		static final int ASCENSOR = 49;
		
		//Información precios
		static final int PRECIO_MINIMO = 50;
		static final int PRECIO_VENTA_WEB = 51;
		static final int VALOR_TASACION = 52;
		static final int FECHA_TASACION = 53;
		
		//Gestores del activo
		static final int GESTOR_COMERCIAL = 54;
		static final int SUPER_GESTOR_COMERCIAL = 55;
		static final int GESTOR_FORMALIZACION = 56;
		static final int SUPER_GESTOR_FORMALIZACION = 57;
		static final int GESTOR_ADMISION = 58;
		static final int GESTOR_ACTIVOS = 59;
		static final int GESTORIA_DE_FORMALIZACION= 60;
		
		//Datos relevantes admisión
		static final int FECHA_INSCRIPCION = 61;
		static final int FECHA_OBT_TITULO = 62;
		static final int FECHA_TOMA_POSESION = 63;
		static final int FECHA_LANZAMIENTO = 64;
		static final int OCUPADO = 65;
		static final int TIENE_TITULO = 66;
		static final int LLAVES = 67;
		static final int CARGAS = 68;
		
		//
		static final int TIPO_ACTIVO = 69;
		static final int FORMALIZACION = 70;
		
		//Datos propietarios
		static final int NOMBRE_PROPIETARIO = 71;
		static final int APELLIDO1_PROPIETARIO = 72;
		static final int APELLIDO2_PROPIETARIO = 73;
		static final int TIPO_PROPIETARIO = 74;
		static final int NIF_CIF_PROPIETARIO = 75;
		
		//BBVA
		static final int ACTIVO_BBVA = 76;
		static final int ID_APP_DIVARIAN_BBVA = 77;
		static final int TIPO_TITULO_BBVA = 78;
		static final int SEGMENTO_BBVA = 79;
		static final int ID_HAYA_ORIGEN_BBVA = 80;
		static final int TIPO_TRANSMISION_BBVA = 81;
		static final int TIPO_DE_ALTA_BBVA = 82;
		static final int IUC_BBVA = 83;
		static final int CEXPER_BBVA = 84;
		static final int INDICADOR_ACTIVO_EPA_BBVA = 85;
		
		//CUENTA DE MORA
		static final int EMPRESA_CM = 86;
		static final int OFICINA_CM = 87;
		static final int CONTRAPARTIDA_CM = 88;
		static final int FOLIO_CM = 89;
		static final int CDPEN_CM = 90;
		
		//VPO
		static final int REGIMEN_DE_PROTECCION_VPO = 91;
		static final int DESCALIFICADO_VPO = 92;
		static final int FECHA_CALIFICACION_VPO = 93;
		static final int N_EXPEDIENTE_CALIFICACION_VPO = 94;
		static final int F_FIN_VIGENCIA_VPO=95;
		static final int PRECISA_COMUNICAR_VPO = 96;
		static final int NECESARIO_INSCRIBIR_EN_REGISTRO_VPO = 97;

		
		//DEUDOR ACREDITADO 1
		static final int TIPO_DOCUMENTO_DEUDOR1= 98;
		static final int N_DOCUMENTO_DEUDOR1= 99;
		static final int RAZON_SOCIAL_DEUDOR1 = 100;
		static final int APELLIDO_DEUDOR1 = 101;
		static final int APELLIDO2_DEUDOR1 = 102;
		
		//DEUDOR ACREDITADO 2
		static final int TIPO_DOCUMENTO_DEUDOR2= 103;
		static final int N_DOCUMENTO_DEUDOR2= 104;
		static final int RAZON_SOCIAL_DEUDOR2 = 105;
		static final int APELLIDO_DEUDOR2 = 106;
		static final int APELLIDO2_DEUDOR2 = 107;
		
		//DEUDOR ACREDITADO 3
		static final int TIPO_DOCUMENTO_DEUDOR3= 108;
		static final int N_DOCUMENTO_DEUDOR3= 109;
		static final int RAZON_SOCIAL_DEUDOR3 = 110;
		static final int APELLIDO_DEUDOR3 = 111;
		static final int APELLIDO2_DEUDOR3 = 112;
		
		//DEUDOR ACREDITADO 4
		static final int TIPO_DOCUMENTO_DEUDOR4= 113;
		static final int N_DOCUMENTO_DEUDOR4= 114;
		static final int RAZON_SOCIAL_DEUDOR4 = 115;
		static final int APELLIDO_DEUDOR4 = 116;
		static final int APELLIDO2_DEUDOR4 = 117;
		
		//DEUDOR ACREDITADO 5
		static final int TIPO_DOCUMENTO_DEUDOR5= 118;
		static final int N_DOCUMENTO_DEUDOR5= 119;
		static final int RAZON_SOCIAL_DEUDOR5 = 120;
		static final int APELLIDO_DEUDOR5 = 121;
		static final int APELLIDO2_DEUDOR5 = 122;
	};
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_ACTIVOS_BBVA;
	}
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		// Carga los datos de activo de la Fila excel al DTO
		String colNActivo = exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA);
		String colNActivoBBVA = exc.dameCelda(fila, COL_NUM.ACTIVO_BBVA);
		String colIdAppDivarian = exc.dameCelda(fila, COL_NUM.ID_APP_DIVARIAN_BBVA);
		String colIdHayaOrigen = exc.dameCelda(fila, COL_NUM.ID_HAYA_ORIGEN_BBVA);		
		String colTipoTransmision = exc.dameCelda(fila, COL_NUM.TIPO_TRANSMISION_BBVA);
		String colTipoDeAlta = exc.dameCelda(fila, COL_NUM.TIPO_DE_ALTA_BBVA);
		String colIuc = exc.dameCelda(fila, COL_NUM.IUC_BBVA);
		String colCexper = exc.dameCelda(fila, COL_NUM.CEXPER_BBVA);
		String colIndicadorActivoEPA = exc.dameCelda(fila, COL_NUM.INDICADOR_ACTIVO_EPA_BBVA);
		String colEmpresa = exc.dameCelda(fila, COL_NUM.EMPRESA_CM);
		String colOficina = exc.dameCelda(fila, COL_NUM.OFICINA_CM);
		String colContrapartida =  exc.dameCelda(fila, COL_NUM.CONTRAPARTIDA_CM);
		String colFolio =  exc.dameCelda(fila, COL_NUM.FOLIO_CM);
		String colCDPEN = exc.dameCelda(fila, COL_NUM.CDPEN_CM);
		
		String colSegmento = exc.dameCelda(fila, COL_NUM.SEGMENTO_BBVA);
		String colTipoDeTitulo = exc.dameCelda(fila, COL_NUM.TIPO_TITULO_BBVA);
		
		String colRegimenDeProteccion = exc.dameCelda(fila, COL_NUM.REGIMEN_DE_PROTECCION_VPO);
		String colDescalificado = exc.dameCelda(fila, COL_NUM.DESCALIFICADO_VPO);
		String colFDeCalificacion= exc.dameCelda(fila, COL_NUM.FECHA_CALIFICACION_VPO);
		String colNumeroExpedienteCalificacion= exc.dameCelda(fila, COL_NUM.N_EXPEDIENTE_CALIFICACION_VPO);
		String colFFinVigencia = exc.dameCelda(fila, COL_NUM.F_FIN_VIGENCIA_VPO);
		String colPrecisaComunicarAdquisicion = exc.dameCelda(fila, COL_NUM.PRECISA_COMUNICAR_VPO);
		String colNecesarioInscribirRE = exc.dameCelda(fila, COL_NUM.NECESARIO_INSCRIBIR_EN_REGISTRO_VPO);
		
		String colTipoDocumentoDeudor1 = exc.dameCelda(fila, COL_NUM.TIPO_DOCUMENTO_DEUDOR1);
		String colNDocumentoDeudor1 = exc.dameCelda(fila, COL_NUM.N_DOCUMENTO_DEUDOR1);
		String colNRazonSocialDeudor1 = exc.dameCelda(fila, COL_NUM.RAZON_SOCIAL_DEUDOR1);
		String colApellido1Deudor1 =  exc.dameCelda(fila, COL_NUM.APELLIDO_DEUDOR1);
		String colApellido2Deudor1 = exc.dameCelda(fila, COL_NUM.APELLIDO2_DEUDOR1);
		
		
		
		String colTipoDocumentoDeudor2 = exc.dameCelda(fila, COL_NUM.TIPO_DOCUMENTO_DEUDOR2);
		String colNDocumentoDeudor2 = exc.dameCelda(fila, COL_NUM.N_DOCUMENTO_DEUDOR2);
		String colNRazonSocialDeudor2 = exc.dameCelda(fila, COL_NUM.RAZON_SOCIAL_DEUDOR2);
		String colApellido1Deudor2 =  exc.dameCelda(fila, COL_NUM.APELLIDO_DEUDOR2);
		String colApellido2Deudor2 = exc.dameCelda(fila, COL_NUM.APELLIDO2_DEUDOR2);
		
		
		String colTipoDocumentoDeudor3 = exc.dameCelda(fila, COL_NUM.TIPO_DOCUMENTO_DEUDOR3);
		String colNDocumentoDeudor3 = exc.dameCelda(fila, COL_NUM.N_DOCUMENTO_DEUDOR3);
		String colNRazonSocialDeudor3 = exc.dameCelda(fila, COL_NUM.RAZON_SOCIAL_DEUDOR3);
		String colApellido1Deudor3 =  exc.dameCelda(fila, COL_NUM.APELLIDO_DEUDOR3);
		String colApellido2Deudor3 = exc.dameCelda(fila, COL_NUM.APELLIDO2_DEUDOR3);
		
		String colTipoDocumentoDeudor4 = exc.dameCelda(fila, COL_NUM.TIPO_DOCUMENTO_DEUDOR4);
		String colNDocumentoDeudor4 = exc.dameCelda(fila, COL_NUM.N_DOCUMENTO_DEUDOR4);
		String colNRazonSocialDeudor4 = exc.dameCelda(fila, COL_NUM.RAZON_SOCIAL_DEUDOR4);
		String colApellido1Deudor4 =  exc.dameCelda(fila, COL_NUM.APELLIDO_DEUDOR4);
		String colApellido2Deudor4 = exc.dameCelda(fila, COL_NUM.APELLIDO2_DEUDOR4);
		
		String colTipoDocumentoDeudor5 = exc.dameCelda(fila, COL_NUM.TIPO_DOCUMENTO_DEUDOR5);
		String colNDocumentoDeudor5 = exc.dameCelda(fila, COL_NUM.N_DOCUMENTO_DEUDOR5);
		String colNRazonSocialDeudor5 = exc.dameCelda(fila, COL_NUM.RAZON_SOCIAL_DEUDOR5);
		String colApellido1Deudor5 =  exc.dameCelda(fila, COL_NUM.APELLIDO_DEUDOR5);
		String colApellido2Deudor5 = exc.dameCelda(fila, COL_NUM.APELLIDO2_DEUDOR5);
		String colVPO = exc.dameCelda(fila, COL_NUM.VPO);
		
		
		
		
		
		try{
			DtoAltaActivoThirdParty dtoAATP = new DtoAltaActivoThirdParty();
			dtoAATP = filaExcelToDtoAltaActivoThirdParty(exc, dtoAATP, fila);

			// Factoria de alta de activos
			// -------------------------------------------------

			AltaActivoThirdPartyService altaActivoThirdPartyService = altaActivoTPFactoryApi.getService(AltaActivoThirdPartyService.CODIGO_ALTA_ACTIVO_THIRD_PARTY);
			altaActivoThirdPartyService.procesarAlta(dtoAATP);
			
			Activo activo = activoApi.getByNumActivo(Long.parseLong(colNActivo));
			final String codigo = "codigo";
			SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
				Date fecha = null;
			//ACT_ACTIVO Segmento y titulo
			DDTipoTituloActivo tipoTitulo = null;
			DDTipoSegmento tipoSegmento = null;
			Filter filtroTitulo = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDeTitulo);
			tipoTitulo = genericDao.get(DDTipoTituloActivo.class, filtroTitulo);
			Filter filtroSegmento = genericDao.createFilter(FilterType.EQUALS, codigo, colSegmento);
			tipoSegmento = genericDao.get(DDTipoSegmento.class, filtroSegmento);
			
			if(colSegmento!=null && !colSegmento.isEmpty()) {
				activo.setTipoSegmento(tipoSegmento);
			}
			if(tipoTitulo!=null) {
				activo.setTipoTitulo(tipoTitulo);
			}
			
			genericDao.save(Activo.class,activo);
			
			//ACT_BBVA_ACTIVOS
			ActivoBbvaActivos activoBBVA = new ActivoBbvaActivos();
			DDTipoTransmision tipoTransmision=null;
			DDTipoAlta tipoAlta = null;
			
			Filter filtroSi = genericDao.createFilter(FilterType.EQUALS, "codigo",  DDSinSiNo.CODIGO_SI);
			Filter filtroNo = genericDao.createFilter(FilterType.EQUALS, "codigo",  DDSinSiNo.CODIGO_NO);				
			DDSinSiNo ddSi = genericDao.get(DDSinSiNo.class, filtroSi);
			DDSinSiNo ddNo = genericDao.get(DDSinSiNo.class,filtroNo);	
			Filter filtroTipoTransmision = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoTransmision);
			tipoTransmision = genericDao.get(DDTipoTransmision.class, filtroTipoTransmision);
			
			Filter filtroTipoAlta = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDeAlta);
			tipoAlta = genericDao.get(DDTipoAlta.class, filtroTipoAlta);
			
			
			
			if(activo!=null) {
				activoBBVA.setActivo(activo);
			}			
			if(colNActivoBBVA!=null && !colNActivoBBVA.isEmpty()) {
				activoBBVA.setNumActivoBbva(colNActivoBBVA);
			}
			if(colIdAppDivarian!=null && !colIdAppDivarian.isEmpty()) {
				activoBBVA.setIdDivarianBbva(Long.parseLong(colIdAppDivarian));
			}
			if(colIdHayaOrigen!=null && !colIdHayaOrigen.isEmpty()) {
				activoBBVA.setIdOrigenHre(Long.parseLong(colIdHayaOrigen));
			}
			if(colTipoTransmision!=null && !colTipoTransmision.isEmpty()) {
				activoBBVA.setTipoTransmision(tipoTransmision);
			}
			if(colTipoDeAlta!=null && !colTipoDeAlta.isEmpty()) {
				activoBBVA.setTipoAlta(tipoAlta);
			}
			if(colIuc !=null && !colIuc.isEmpty()) {
				activoBBVA.setUicBbva(colIuc);
			}			
			if(colCexper!=null && !colCexper.isEmpty()) {
				activoBBVA.setCexperBbva(colCexper);
			}
			if(colIndicadorActivoEPA!=null &&  !colIndicadorActivoEPA.isEmpty()) {
				if(colIndicadorActivoEPA.contains("s") || colIndicadorActivoEPA.contains("S")) {
					activoBBVA.setActivoEpa(ddSi);
				}else {
					activoBBVA.setActivoEpa(ddNo);
				}
			}
			if(colEmpresa!=null && !colEmpresa.isEmpty()) {
				activoBBVA.setEmpresa(Long.parseLong(colEmpresa));
			}
			if(colOficina!=null && !colOficina.isEmpty() ) {
				activoBBVA.setOficina(Long.parseLong(colOficina));
			}
			if(colContrapartida!=null && !colContrapartida.isEmpty()) {
				activoBBVA.setContrapartida(Long.parseLong(colContrapartida));
			}
			if(colFolio!=null && !colFolio.isEmpty()) {
				activoBBVA.setFolio(Long.parseLong(colFolio));
			}
			if(colCDPEN!=null && !colCDPEN.isEmpty()) {
				activoBBVA.setCdpen(Long.parseLong(colCDPEN));
			}
			genericDao.save(ActivoBbvaActivos.class,activoBBVA);
			
			
			//ACT_ADM_INF_ADMINISTRATIVA
			
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoInfAdministrativa actInfoAdministrativa = genericDao.get(ActivoInfAdministrativa.class, filtroActivo);
			DDTipoVpo tipoRegimen = null;
			
			Filter filtroRegimen = genericDao.createFilter(FilterType.EQUALS, codigo, colRegimenDeProteccion);
			tipoRegimen = genericDao.get(DDTipoVpo.class, filtroRegimen);
			
			
			if(colVPO!=null && !colVPO.isEmpty()) {
				if(colVPO.contains("S") || colVPO.contains("s")) {
					actInfoAdministrativa.setSueloVpo(1);
				}else{
					actInfoAdministrativa.setSueloVpo(0);				
				}
				
			}
			
			if(tipoRegimen!=null) {
				actInfoAdministrativa.setTipoVpo(tipoRegimen);
			}
			
			if(colDescalificado!=null && !colDescalificado.isEmpty()) {
				if(colDescalificado.contains("S") || colDescalificado.contains("s")) {
					actInfoAdministrativa.setDescalificado(1);
				}else{
					actInfoAdministrativa.setDescalificado(0);				
				}
			}
			if(colFDeCalificacion!=null &&  !colFDeCalificacion.isEmpty()) {
				fecha = formato.parse(colFDeCalificacion);
				actInfoAdministrativa.setFechaCalificacion(fecha);
			}
			if(colNumeroExpedienteCalificacion!=null && !colNumeroExpedienteCalificacion.isEmpty()) {
				actInfoAdministrativa.setNumExpediente(colNumeroExpedienteCalificacion);
			}
			if(colFFinVigencia!=null && !colFFinVigencia.isEmpty()) {
				fecha = formato.parse(colFFinVigencia);
				actInfoAdministrativa.setVigencia(fecha);
			}
			if(colPrecisaComunicarAdquisicion!=null && !colPrecisaComunicarAdquisicion.isEmpty()) {
				if(colPrecisaComunicarAdquisicion.contains("S") || colPrecisaComunicarAdquisicion.contains("s")) {
					actInfoAdministrativa.setComunicarAdquisicion(1);
				}else{
					actInfoAdministrativa.setComunicarAdquisicion(0);				
				}
			}
			if(colNecesarioInscribirRE!=null && !colNecesarioInscribirRE.isEmpty()) {
				if(colNecesarioInscribirRE.contains("S") || colNecesarioInscribirRE.contains("s")) {
					actInfoAdministrativa.setNecesarioInscribirVpo(1);
				}else{
					actInfoAdministrativa.setNecesarioInscribirVpo(0);				
				}
			}
			
			genericDao.save(ActivoInfAdministrativa.class,actInfoAdministrativa);
			
			
			//ACT_DEU_DEUDOR_ACREDITADO
		 ActivoDeudoresAcreditados tipoDeudorAcr1 = new ActivoDeudoresAcreditados();
		 ActivoDeudoresAcreditados tipoDeudorAcr2 = new ActivoDeudoresAcreditados();
		 ActivoDeudoresAcreditados tipoDeudorAcr3 = new ActivoDeudoresAcreditados();
		 ActivoDeudoresAcreditados tipoDeudorAcr4 = new ActivoDeudoresAcreditados();
		 ActivoDeudoresAcreditados tipoDeudorAcr5 = new ActivoDeudoresAcreditados();
			 DDTipoDeDocumento tipoDeudor1Doc=null;
			 Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		 	 DDTipoDeDocumento tipoDeudor2Doc=null;
			 DDTipoDeDocumento tipoDeudor3Doc=null;
			 DDTipoDeDocumento tipoDeudor4Doc=null;
		     DDTipoDeDocumento tipoDeudor5Doc=null;
			Filter filtroDeudorAcreditado = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDocumentoDeudor1);
			tipoDeudor1Doc = genericDao.get(DDTipoDeDocumento.class, filtroDeudorAcreditado);
			Filter filtroDeudorAcreditado2 = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDocumentoDeudor2);
			tipoDeudor2Doc = genericDao.get(DDTipoDeDocumento.class, filtroDeudorAcreditado2);
			Filter filtroDeudorAcreditado3 = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDocumentoDeudor3);
			tipoDeudor3Doc = genericDao.get(DDTipoDeDocumento.class, filtroDeudorAcreditado3);
			Filter filtroDeudorAcreditado4 = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDocumentoDeudor4);
			tipoDeudor4Doc = genericDao.get(DDTipoDeDocumento.class, filtroDeudorAcreditado4);
			Filter filtroDeudorAcreditado5 = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDocumentoDeudor5);
			tipoDeudor5Doc = genericDao.get(DDTipoDeDocumento.class, filtroDeudorAcreditado5);
			//Deudor1		
			if(colTipoDocumentoDeudor1!=null  && !colTipoDocumentoDeudor1.isEmpty()
				&& colNDocumentoDeudor1!=null && !colNDocumentoDeudor1.isEmpty() 
				&& colNRazonSocialDeudor1!=null && !colNRazonSocialDeudor1.isEmpty()) {
				tipoDeudorAcr1.setActivo(activo);
				tipoDeudorAcr1.setUsuario(usuarioLogado);
				tipoDeudorAcr1.setTipoDocumento(tipoDeudor1Doc);
				tipoDeudorAcr1.setNumeroDocumentoDeudor(colNDocumentoDeudor1);
				tipoDeudorAcr1.setNombreDeudor(colNRazonSocialDeudor1);
				if(colApellido1Deudor1!=null && !colApellido1Deudor1.isEmpty()) {
					tipoDeudorAcr1.setApellido1Deudor(colApellido1Deudor1);
				}
				if(colApellido2Deudor1!=null && !colApellido2Deudor1.isEmpty()) {
					tipoDeudorAcr1.setApellido2Deudor(colApellido2Deudor1);
				}
				tipoDeudorAcr1.setFechaAlta(new Date());
				genericDao.save(ActivoDeudoresAcreditados.class,tipoDeudorAcr1);
			}
			
			
			
			//Deudor2	
			if(colTipoDocumentoDeudor2!=null  && !colTipoDocumentoDeudor2.isEmpty()
				&& colNDocumentoDeudor2!=null && !colNDocumentoDeudor2.isEmpty() 
				&& colNRazonSocialDeudor2!=null && !colNRazonSocialDeudor2.isEmpty()) {
				tipoDeudorAcr2.setActivo(activo);
				tipoDeudorAcr2.setUsuario(usuarioLogado);
				tipoDeudorAcr2.setTipoDocumento(tipoDeudor2Doc);
				tipoDeudorAcr2.setNumeroDocumentoDeudor(colNDocumentoDeudor2);
				tipoDeudorAcr2.setNombreDeudor(colNRazonSocialDeudor2);
				if(colApellido1Deudor2!=null && !colApellido1Deudor2.isEmpty()) {
					tipoDeudorAcr2.setApellido1Deudor(colApellido1Deudor2);
				}
				if(colApellido2Deudor2!=null && !colApellido2Deudor2.isEmpty()) {
					tipoDeudorAcr2.setApellido2Deudor(colApellido2Deudor2);
				}
				tipoDeudorAcr2.setFechaAlta(new Date());
				genericDao.save(ActivoDeudoresAcreditados.class,tipoDeudorAcr2);
			}
			//Deudor3	
			if(colTipoDocumentoDeudor3!=null  && !colTipoDocumentoDeudor3.isEmpty()
				&& colNDocumentoDeudor3!=null && !colNDocumentoDeudor3.isEmpty() 
				&& colNRazonSocialDeudor3!=null && !colNRazonSocialDeudor3.isEmpty()) {
				tipoDeudorAcr3.setActivo(activo);
				tipoDeudorAcr3.setUsuario(usuarioLogado);
				tipoDeudorAcr3.setTipoDocumento(tipoDeudor3Doc);
				tipoDeudorAcr3.setNumeroDocumentoDeudor(colNDocumentoDeudor3);
				tipoDeudorAcr3.setNombreDeudor(colNRazonSocialDeudor3);
				if(colApellido1Deudor3!=null && !colApellido1Deudor3.isEmpty()) {
					tipoDeudorAcr3.setApellido1Deudor(colApellido1Deudor3);
				}
				if(colApellido2Deudor3!=null && !colApellido2Deudor3.isEmpty()) {
					tipoDeudorAcr3.setApellido2Deudor(colApellido2Deudor3);
				}
				tipoDeudorAcr3.setFechaAlta(new Date());
				genericDao.save(ActivoDeudoresAcreditados.class,tipoDeudorAcr3);
			}
			//Deudor4
			if(colTipoDocumentoDeudor4!=null  && !colTipoDocumentoDeudor4.isEmpty()
				&& colNDocumentoDeudor4!=null && !colNDocumentoDeudor4.isEmpty() 
				&& colNRazonSocialDeudor4!=null && !colNRazonSocialDeudor4.isEmpty()) {
				tipoDeudorAcr4.setActivo(activo);
				tipoDeudorAcr4.setUsuario(usuarioLogado);
				tipoDeudorAcr4.setTipoDocumento(tipoDeudor4Doc);
				tipoDeudorAcr4.setNumeroDocumentoDeudor(colNDocumentoDeudor4);
				tipoDeudorAcr4.setNombreDeudor(colNRazonSocialDeudor4);
				if(colApellido1Deudor4!=null && !colApellido1Deudor4.isEmpty()) {
					tipoDeudorAcr4.setApellido1Deudor(colApellido1Deudor4);
				}
				if(colApellido2Deudor4!=null && !colApellido2Deudor4.isEmpty()) {
					tipoDeudorAcr4.setApellido2Deudor(colApellido2Deudor4);
				}
				tipoDeudorAcr4.setFechaAlta(new Date());
				genericDao.save(ActivoDeudoresAcreditados.class,tipoDeudorAcr4);
			}
			
			
			//Deudor5	
			if(colTipoDocumentoDeudor5!=null  && !colTipoDocumentoDeudor5.isEmpty()
				&& colNDocumentoDeudor5!=null && !colNDocumentoDeudor5.isEmpty() 
				&& colNRazonSocialDeudor5!=null && !colNRazonSocialDeudor5.isEmpty()) {
				tipoDeudorAcr5.setActivo(activo);
				tipoDeudorAcr5.setUsuario(usuarioLogado);
				tipoDeudorAcr5.setTipoDocumento(tipoDeudor5Doc);
				tipoDeudorAcr5.setNumeroDocumentoDeudor(colNDocumentoDeudor5);
				tipoDeudorAcr5.setNombreDeudor(colNRazonSocialDeudor5);
				if(colApellido1Deudor5!=null && !colApellido1Deudor5.isEmpty()) {
					tipoDeudorAcr5.setApellido1Deudor(colApellido1Deudor5);
				}
				if(colApellido2Deudor5!=null && !colApellido2Deudor5.isEmpty()) {
					tipoDeudorAcr5.setApellido2Deudor(colApellido2Deudor5);
				}
				tipoDeudorAcr5.setFechaAlta(new Date());
				genericDao.save(ActivoDeudoresAcreditados.class,tipoDeudorAcr5);
			}
			
			
			
		}catch(Exception e){
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}
	
	private DtoAltaActivoThirdParty filaExcelToDtoAltaActivoThirdParty (MSVHojaExcel exc,DtoAltaActivoThirdParty dtoAATP, int fila) throws IllegalArgumentException, IOException, ParseException
	{
	
		dtoAATP.setNumActivoHaya(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA)));
		dtoAATP.setCodSubCartera(exc.dameCelda(fila, COL_NUM.COD_SUBCARTERA));
		dtoAATP.setSubtipoTituloCodigo(exc.dameCelda(fila, COL_NUM.COD_SUBTIPO_TITULO));
		dtoAATP.setNumActivoExterno(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_EXTERNO)));
		dtoAATP.setTipoActivoCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_ACTIVO));
		dtoAATP.setSubtipoActivoCodigo(exc.dameCelda(fila, COL_NUM.COD_SUBTIPO_ACTIVO));
		dtoAATP.setEstadoFisicoCodigo(exc.dameCelda(fila, COL_NUM.COD_ESTADO_FISICO));
		dtoAATP.setUsoDominanteCodigo(exc.dameCelda(fila, COL_NUM.COD_USO_DOMINANTE));
		dtoAATP.setDescripcionActivo(exc.dameCelda(fila, COL_NUM.DESC_ACTIVO));
		
		dtoAATP.setTipoViaCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_VIA));
		dtoAATP.setNombreVia(exc.dameCelda(fila, COL_NUM.NOMBRE_VIA));
		dtoAATP.setNumVia(exc.dameCelda(fila, COL_NUM.NUM_VIA));
		dtoAATP.setEscalera(exc.dameCelda(fila, COL_NUM.ESCALERA));
		dtoAATP.setPlanta(exc.dameCelda(fila, COL_NUM.PLANTA));
		dtoAATP.setPuerta(exc.dameCelda(fila, COL_NUM.PUERTA));
		dtoAATP.setProvinciaCodigo(exc.dameCelda(fila, COL_NUM.COD_PROVINCIA));
		dtoAATP.setMunicipioCodigo(exc.dameCelda(fila, COL_NUM.COD_MUNICIPIO));
		dtoAATP.setUnidadMunicipioCodigo(exc.dameCelda(fila, COL_NUM.COD_UNIDAD_MUNICIPIO));
		dtoAATP.setCodigoPostal(exc.dameCelda(fila, COL_NUM.CODPOSTAL));
		
		dtoAATP.setDestinoComercialCodigo(exc.dameCelda(fila, COL_NUM.COD_DESTINO_COMER));
		dtoAATP.setTipoAlquilerCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_ALQUILER));
		dtoAATP.setTipoDeComercializacion(exc.dameCelda(fila, COL_NUM.COD_TIPO_DE_COMERCIALIZACION));
		
		dtoAATP.setPoblacionRegistroCodigo(exc.dameCelda(fila, COL_NUM.POBL_REGISTRO));
		dtoAATP.setNumRegistro(exc.dameCelda(fila, COL_NUM.NUM_REGISTRO));
		dtoAATP.setTomoRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.TOMO)));
		dtoAATP.setLibroRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.LIBRO)));
		dtoAATP.setFolioRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.FOLIO)));
		dtoAATP.setFincaRegistro(exc.dameCelda(fila, COL_NUM.FINCA));
		dtoAATP.setIdufirCruRegistro(exc.dameCelda(fila, COL_NUM.IDUFIR_CRU));
		dtoAATP.setSuperficieConstruidaRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_CONSTRUIDA_M2)));
		dtoAATP.setSuperficieUtilRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_UTIL_M2)));
		dtoAATP.setSuperficieRepercusionEECCRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_REPERCUSION_EE_CC)));
		dtoAATP.setParcelaRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.PARCELA)));
		dtoAATP.setEsIntegradoDivHorizontalRegistro(exc.dameCelda(fila, COL_NUM.ES_INTEGRADO_DIV_HORIZONTAL));
		
		dtoAATP.setNifPropietario(exc.dameCelda(fila, COL_NUM.NIF_PROPIETARIO));
		dtoAATP.setGradoPropiedadCodigo(exc.dameCelda(fila, COL_NUM.GRADO_PROPIEDAD));
		dtoAATP.setPercentParticipacionPropiedad(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.PERCENT_PROPIEDAD)));
		
		dtoAATP.setPropiedadAnterior(exc.dameCelda(fila, COL_NUM.PROP_ANTERIOR));
		dtoAATP.setReferenciaCatastral(exc.dameCelda(fila, COL_NUM.REF_CATASTRAL));
		dtoAATP.setEsVPO(exc.dameCelda(fila, COL_NUM.VPO));
		dtoAATP.setCalificacionCeeCodigo(exc.dameCelda(fila, COL_NUM.CALIFICACION_CEE));
		dtoAATP.setCedudaHabitabilidad(exc.dameCelda(fila, COL_NUM.CED_HABITABILIDAD));
		
		dtoAATP.setNifMediador(exc.dameCelda(fila, COL_NUM.NIF_MEDIADOR));
		dtoAATP.setNumPlantasVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_PLANTAS)));
		dtoAATP.setNumBanyosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_BANYOS)));
		dtoAATP.setNumAseosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_ASEOS)));
		dtoAATP.setNumDormitoriosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_DORMITORIOS)));
		dtoAATP.setTrasteroAnejo(exc.dameCelda(fila, COL_NUM.TRASTERO_ANEJO));
		dtoAATP.setGarajeAnejo(exc.dameCelda(fila, COL_NUM.GARAJE_ANEJO));
		dtoAATP.setAscensor(exc.dameCelda(fila, COL_NUM.ASCENSOR));
		
		dtoAATP.setPrecioMinimo(this.obtenerDoubleExcel(exc.dameCelda(fila, COL_NUM.PRECIO_MINIMO)));
		dtoAATP.setPrecioVentaWeb(this.obtenerDoubleExcel(exc.dameCelda(fila, COL_NUM.PRECIO_VENTA_WEB)));
		dtoAATP.setValorTasacion(this.obtenerDoubleExcel(exc.dameCelda(fila, COL_NUM.VALOR_TASACION)));
		dtoAATP.setFechaTasacion(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_TASACION)));
		
		dtoAATP.setGestorComercial(exc.dameCelda(fila, COL_NUM.GESTOR_COMERCIAL));
		dtoAATP.setSupervisorGestorComercial(exc.dameCelda(fila, COL_NUM.SUPER_GESTOR_COMERCIAL));
		dtoAATP.setGestorFormalizacion(exc.dameCelda(fila, COL_NUM.GESTOR_FORMALIZACION));
		dtoAATP.setSupervisorGestorFormalizacion(exc.dameCelda(fila, COL_NUM.SUPER_GESTOR_FORMALIZACION));
		dtoAATP.setGestorAdmision(exc.dameCelda(fila, COL_NUM.GESTOR_ADMISION));
		dtoAATP.setGestorActivos(exc.dameCelda(fila, COL_NUM.GESTOR_ACTIVOS));
		dtoAATP.setGestoriaDeFormalizacion(exc.dameCelda(fila, COL_NUM.GESTORIA_DE_FORMALIZACION));
		
		dtoAATP.setFechaInscripcion(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_INSCRIPCION)));
		dtoAATP.setFechaObtencionTitulo(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_OBT_TITULO)));
		dtoAATP.setFechaTomaPosesion(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_TOMA_POSESION)));
		dtoAATP.setFechaLanzamiento(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_LANZAMIENTO)));
		dtoAATP.setOcupado(exc.dameCelda(fila, COL_NUM.OCUPADO));
		dtoAATP.setTieneTitulo(exc.dameCelda(fila, COL_NUM.TIENE_TITULO));
		dtoAATP.setLlave(exc.dameCelda(fila, COL_NUM.LLAVES));
		dtoAATP.setCargas(exc.dameCelda(fila, COL_NUM.CARGAS));
		
		dtoAATP.setTipoActivo(exc.dameCelda(fila, COL_NUM.TIPO_ACTIVO));
		dtoAATP.setFormalizacion(exc.dameCelda(fila, COL_NUM.FORMALIZACION));
		
		dtoAATP.setNombrePropietario(exc.dameCelda(fila, COL_NUM.NOMBRE_PROPIETARIO));
		dtoAATP.setApellidoPropietario1(exc.dameCelda(fila, COL_NUM.APELLIDO1_PROPIETARIO));
		dtoAATP.setApellidoPropietario2(exc.dameCelda(fila, COL_NUM.APELLIDO2_PROPIETARIO));
		dtoAATP.setTipoPropietario(exc.dameCelda(fila, COL_NUM.TIPO_PROPIETARIO));
		dtoAATP.setNIFCIFPropietario(exc.dameCelda(fila, COL_NUM.NIF_CIF_PROPIETARIO));		
			
		return dtoAATP;
	}
	
	
	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	private Integer obtenerIntegerExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}else{
			if(celdaExcel.contains("%")){
				celdaExcel = celdaExcel.replace("%", "");
			}
		}

		return Integer.valueOf(celdaExcel);
	}
	
	private Double obtenerDoubleExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Double.valueOf(celdaExcel);
	}
	
	private Float obtenerFloatExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Float.parseFloat(celdaExcel);
	}
	
	private Boolean obtenerBooleanExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		if (celdaExcel.equalsIgnoreCase("s") || celdaExcel.equalsIgnoreCase("si")) {
			return true;
		} else {
			return false;
		}
	}
	
	private Date obtenerDateExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;

		try {
			fecha = ft.parse(celdaExcel);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return fecha;
	}
	
	@Override
	public int getFilaInicial() {
		return COL_NUM.DATOS_PRIMERA_FILA;
	}
}
