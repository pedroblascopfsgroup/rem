package es.pfsgroup.plugin.recovery.uvem.manager;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.gfi.webIntegrator.WIException;
import com.gfi.webIntegrator.WIService;

import es.cajamadrid.servicios.GM.GMP5JD20_INS.GMP5JD20_INS;
import es.cajamadrid.servicios.GM.GMP5JD20_INS.StructCabeceraAplicacionGMP5JD20_INS;
import es.cajamadrid.servicios.GM.GMP5JD20_INS.StructCabeceraFuncionalPeticion;
import es.cajamadrid.servicios.GM.GMP5JD20_INS.StructCabeceraTecnica;
import es.cajamadrid.servicios.GM.GMPETS07_INS.GMPETS07_INS;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraAplicacionGMPETS07_INS;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructGMPETS07_INS_NumeroDeOcurrenciasnumog1;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructGMPETS07_INS_NumeroDeOcurrenciasnumogt;
import es.cajamadrid.servicios.GM.GMPETS07_INS.VectorGMPETS07_INS_NumeroDeOcurrenciasnumog1;
import es.cajamadrid.servicios.GM.GMPETS07_INS.VectorGMPETS07_INS_NumeroDeOcurrenciasnumogt;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.cm.arq.tda.tiposdedatosbase.CantidadDecimal15;
import es.cm.arq.tda.tiposdedatosbase.Fecha;
import es.cm.arq.tda.tiposdedatosbase.ImporteMonetario;
import es.cm.arq.tda.tiposdedatosbase.Moneda;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastasServicioTasacionDelegateApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.procesosJudiciales.model.EXTTipoJuzgado;

/**
 *
 */




//@Component
@Service
//@ManagedResource("devon:type=UvemDelegateManagerJMX")
public class UvemDelegateManager implements SubastasServicioTasacionDelegateApi {
	
	//java -jar cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2096 devon:type=UvemDelegateManagerJMX solicitarNumeroActivo=1
	
	//https://localhost:8443/pfs/uvem/solicitarNumeroActivo.htm?idBien=1
	//https://localhost:8443/pfs/uvem/solicitarTasacion.htm?idBien=1
	
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private EntidadDao entidadDao;
	
	protected static final Log logger = LogFactory.getLog(UvemDelegateManager.class);
	
	@Resource
	private Properties appProperties;

	
	private static final String DEVON_HOME_BANKIA = "datos/usuarios/recovecp";
	private static final String DEVON_HOME = "DEVON_HOME";
	private static final String DEVON_PROPERTIES = "devon.properties";
	private static final String UVEM_URL = "uvem.url";
	private static String URL = "http://midtr2epd.cm.es:31485/bisa/endpoint";
	
	boolean uvemInstalado = false;
	
	public void UVEMUtils() {
		if (appProperties == null) {
			this.appProperties = cargarProperties(DEVON_PROPERTIES);
		} else {
			if(appProperties.contains(UVEM_URL) && appProperties.getProperty(UVEM_URL) != null){
				URL = appProperties.getProperty(UVEM_URL);
			}else{
				System.out.println("UVEM no instalado");
			}
		}
		
		if (appProperties == null) {
			System.out.println("No puedo consultar devon.properties");
		
		} else if (appProperties.containsKey(UVEM_URL) && appProperties.getProperty(UVEM_URL) != null) {
			System.out.println("UVEM instalado");
			URL = appProperties.getProperty(UVEM_URL);
		} else {
			System.out.println("UVEM no instalado");
		}

	}
	
	private Properties cargarProperties(String nombreProps) {

		InputStream input = null;
		Properties prop = new Properties();
		
		String devonHome = DEVON_HOME_BANKIA;
		if (System.getenv(DEVON_HOME) != null) {
			devonHome = System.getenv(DEVON_HOME);
		}
		
		try {
			input = new FileInputStream("/" + devonHome + "/" + nombreProps);
			prop.load(input);
		} catch (IOException ex) {
			System.out.println("[uvem.cargarProperties]: /" + devonHome + "/" + nombreProps + ":" + ex.getMessage());
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					System.out.println("[uvem.cargarProperties]: /" + devonHome + "/" + nombreProps + ":" + e.getMessage());
				}
			}
		}
		return prop;
	}
	
	
	


	@BusinessOperation(overrides = BO_UVEM_SOLICITUD_NUMERO_ACTIVO)
	public void solicitarNumeroActivo(Long idBien) {

		solicitarNumeroActivo(idBien, null);
	}

	@BusinessOperation(overrides = BO_UVEM_SOLICITUD_TASACION)
	@Transactional(readOnly = false)
	public void solicitarTasacion(Long idBien) {
		
		solicitarTasacion(idBien, null);
	}
	
	@BusinessOperation(overrides = BO_UVEM_SOLICITUD_NUMERO_ACTIVO_CON_RESPUESTA)
	@Transactional(readOnly = false,propagation = Propagation.REQUIRES_NEW)
	public String solicitarNumeroActivoConRespuesta(Long bienId){
		return solicitarNumeroActivoRespuesta(bienId, null);
	}

	@BusinessOperation(overrides = BO_UVEM_SOLICITUD_NUMERO_ACTIVO_BY_PRCID)
	public void solicitarNumeroActivoByPrcId(Long idBien, Long prcId) {

		solicitarNumeroActivo(idBien, prcId);
	}

	@BusinessOperation(overrides = BO_UVEM_SOLICITUD_TASACION_BY_PRCID)
	public void solicitarTasacionByPrcId(Long idBien, Long prcId) {
		
		solicitarTasacion(idBien, prcId);
	}
	
	
	/**
	 * Método que solicita el numero de activo de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	
	//@ManagedOperation(description ="Metodo que solicita el numero de activo de un bien a UVEM")
	//@ManagedOperationParameter(name="bienId", description= "id del bien.")
    @Transactional(readOnly = false)
	public void solicitarNumeroActivo(Long bienId, Long prcId){

    	solicitarNumeroActivoRespuesta(bienId, prcId);
    	
	};
	
	private String solicitarNumeroActivoRespuesta(Long bienId, Long prcId){
		
		try {
			
			//EPD
			//http://midtr2epd.cm.es:31485/bisa/endpoint

			//EPI1
			//http://midtr2epi.cm.es:31405/bisa/endpoint

			//EPI2 (EPP)
			//http://midtr2epp.cm.es:31405/bisa/endpoint

			//REAL
			//http://midtr2x.cm.es:31405/bisa/endpoint
			
			UVEMUtils();
			
			System.out.println("Iniciando.... solicitarNumeroActivo");
			logger.debug("Iniciando.... solicitarNumeroActivo");
			logger.info("Iniciando.... solicitarNumeroActivo");
			//final Entidad entidad = entidadDao.findByWorkingCode(workingCode);
			//DbIdContextHolder.setDbId(entidad.getId());
			
			NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(bienId);
			System.out.println("Bien encontrado.");
			EXTAsunto asunto = null;
			MEJProcedimiento procedimiento = null;
			EXTGestorAdicionalAsunto procuradorAsunto = null;
			EXTGestorAdicionalAsunto gestorAsunto = null;
			
			EXTTipoJuzgado juzgado = null;
			EXTContrato contrato = null;
			
			if(!Checks.esNulo(prcId)){
				procedimiento = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
				System.out.println("Procedimiento obtenido.");	
			}
			else{
				List<ProcedimientoBien> procedimientos = bien.getProcedimientos();
				System.out.println("Procedimientos recuperados.");
				if(procedimientos != null && procedimientos.size() > 0){
					//cogemos el ultimo procedimiento
					procedimiento = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", procedimientos.get(procedimientos.size()-1).getProcedimiento().getId()));
					System.out.println("Procedimiento obtenido.");	
				}else{
					return "El bien debe estar asociado a un procedimiento";
				}
			}			
			
			Asunto asuntoAux = procedimiento.getAsunto();
			asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", asuntoAux.getId()));
			System.out.println("Asunto obtenido.");
			
			List<ExpedienteContrato> expedienteContratos = asunto.getExpediente().getContratos();
			if(expedienteContratos != null && expedienteContratos.size() > 0){
				contrato = (EXTContrato) expedienteContratos.get(0).getContrato();
				System.out.println("Contrato obtenido.");
			}
			
			//Gestión: haya, bankia
			String gestion = null;
			if(!Checks.esNulo(asunto)){
				if(asunto instanceof EXTAsunto){
					gestion = ((EXTAsunto) asunto).getGestionAsunto().getCodigo();
				}
			}
			
			//validaciones
			if(asunto != null && procedimiento != null && bien != null) {
				System.out.println("Unidades de gestion no nulas.");
				List<EXTGestorAdicionalAsunto> gestores = asunto.getGestoresAsunto();
				if(gestores != null || gestores.size() > 0){
					for(EXTGestorAdicionalAsunto gestor : gestores){
						if (EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR.compareTo( gestor.getTipoGestor().getCodigo()) == 0){
							procuradorAsunto = gestor;
							System.out.println("Procurador recuperado");
						}
						if (EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO.compareTo( gestor.getTipoGestor().getCodigo()) == 0){
							gestorAsunto = gestor;
							System.out.println("Gestor recuperado.");
						}
					}
				}
			} else {
				//return null;
			}
			
			System.out.println("Inicialización del endpoint de MidTR. Se realiza una única vez para todos los servicios. La url de MidTR debe estar parametrizada pues varía en cada entorno");
			System.out.println("URL: " + URL);
			Hashtable htInitParams = new Hashtable();
			htInitParams.put(WIService.WORFLOW_PARAM, URL);
			htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);
			WIService.init(htInitParams);
			 
			System.out.println("Instanciación del servicio"); 
			GMP5JD20_INS servicioGMP5JD20 = new GMP5JD20_INS();
			 
			System.out.println("Inicialización de las cabeceras"); 
			StructCabeceraFuncionalPeticion cabeceraFuncional = new StructCabeceraFuncionalPeticion();
			StructCabeceraTecnica cabeceraTecnica = new StructCabeceraTecnica();                   
			StructCabeceraAplicacionGMP5JD20_INS cabeceraAplicacion = new StructCabeceraAplicacionGMP5JD20_INS();
			 
			servicioGMP5JD20.setcabeceraAplicacion(cabeceraAplicacion);    
			servicioGMP5JD20.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMP5JD20.setcabeceraTecnica(cabeceraTecnica);
			               
			System.out.println("Seteo de los datos de entrada del servicio"); 
			System.out.println("PROGRAMA	GMP5JD20"); 
			System.out.println("BIE_ID --> "+bien.getId());
			
			System.out.println("Requeridos por el servicio");
			servicioGMP5JD20.setnumeroCliente(0);
			servicioGMP5JD20.setnumeroUsuario("");
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
			servicioGMP5JD20.setidSesionWL(request != null ? request.getSession().getId() : "");
			
			System.out.println(" ***REQUERIDO*** COACEW"); // 	"NUMERICO_9" longitud="10"	 Número de activo	siempre 0
			servicioGMP5JD20.setIdentificadorActivoEspecialcoacew(0000000000);
			System.out.println(" ***REQUERIDO*** COPRVW"); // 	"NUMERICO_4" longitud="5"	 Código de Provincia short
			short codigoProvincia = 00000;
			if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getProvincia() != null){
				codigoProvincia = Short.parseShort(bien.getLocalizacionActual().getProvincia().getCodigo());
			} 
			System.out.println(" COPRVW: "+codigoProvincia); // 	"NUMERICO_4" longitud="5"	 Código de Provincia short
			servicioGMP5JD20.setCodigoDeProvinciacoprvw(codigoProvincia);
			System.out.println(" ***REQUERIDO*** CORTOR"); // 	"NUMERICO_D" longitud="2"	 Código de retorno	siempre 0
			servicioGMP5JD20.setCodigoDeRetornocortor((byte) 00);
			System.out.println(" ***REQUERIDO*** COPACE"); // 	longitud="8"	 Código objeto acceso	siempre " " (spaces)
			servicioGMP5JD20.setCodigoObjetoAccesocopace(StringUtils.rightPad("", 8, ' ').substring(0, 8));
			System.out.println(" ***REQUERIDO*** OBRTOR"); // 	longitud="40"	 Texto explicativo del código de retorno	siempre " " (spaces)
			servicioGMP5JD20.setTextoExplicativoDeCodigoRetornoobrtor(StringUtils.rightPad("", 40, ' ').substring(0, 40));
			
			System.out.println(" ***REQUERIDO*** NUPIIN"); // 	longitud="10"	 Piso del inmueble	siempre " " (spaces)
			servicioGMP5JD20.setPisoDelInmuebleLong10Nupiin(StringUtils.rightPad(bien.getLocalizacionActual().getPiso() != null ? bien.getLocalizacionActual().getPiso() : "", 10, ' ').substring(0, 10));
			System.out.println(" ***REQUERIDO*** TITEXO"); // 	longitud="1"	 Tipo de texto	siempre " " (spaces)
			char titexo = ' '; 
			servicioGMP5JD20.setTipoDeTextotitexo(titexo);
			System.out.println(" ***REQUERIDO*** NOLGMU"); // 	longitud="50"	 Localidad del inmueble	
			String nombreLargoMunicipio = bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getLocalidad() != null ? bien.getLocalizacionActual().getLocalidad().getDescripcion().toUpperCase() : "";
			//nombreLargoMunicipio = quitaTildes(nombreLargoMunicipio);
			servicioGMP5JD20.setNombreLargoDelMunicipionolgmu(StringUtils.rightPad((nombreLargoMunicipio!=null) ? nombreLargoMunicipio : "", 50, ' ').substring(0, 50));
			System.out.println("NOLGMU: "+StringUtils.rightPad((nombreLargoMunicipio!=null) ? nombreLargoMunicipio : "", 50, ' ').substring(0, 50)); // 	longitud="50"	 Localidad del inmueble	
			System.out.println(" ***REQUERIDO*** NOLGRP"); // 	longitud="50"	 Localidad del Registro	
			String nombreLargoRegistroPropiedad = bien.getDatosRegistralesActivo() != null ? bien.getDatosRegistralesActivo().getLocalidad() != null ? bien.getDatosRegistralesActivo().getLocalidad().getDescripcion().toUpperCase() : "" : "";
			servicioGMP5JD20.setNombreLargoRegistoDeLaPropiedadnolgrp(StringUtils.rightPad(nombreLargoRegistroPropiedad, 50, ' ').substring(0, 50));
			System.out.println(" ***REQUERIDO*** NUMFIN"); // 	longitud="14"	 Número de finca
			String numeroFincaRegistral = bien.getDatosRegistralesActivo() != null ? bien.getDatosRegistralesActivo().getNumFinca() != null ? bien.getDatosRegistralesActivo().getNumFinca() : "" : "";
			servicioGMP5JD20.setNumeroDeFincaRegistralnumfin(StringUtils.rightPad(numeroFincaRegistral,14,' ').substring(0, 14));
			System.out.println(" ***REQUERIDO*** NUREGW"); // 	"NUMERICO_4" longitud="5"	 Número de registro de la propiedad	
			short numeroRegistroPropiedad = Short.parseShort("0");
			try {
				numeroRegistroPropiedad = Short.parseShort(bien.getDatosRegistralesActivo().getNumRegistro());
			} catch (Exception e ){
				//ouch!
			}
			servicioGMP5JD20.setNumeroDeRegistroDeLaPropiedadnuregw(numeroRegistroPropiedad);

			
			//NUEVOS CONTENEDORES
			
			String cotiv4 = "";
			String comuid = "";
			String nupoac = "";
			String nuesac = "";
			String nupuac = "";
			String nobaac = "";
			String copoi5 = "";
			String noprac = "";
			String copaw3 = "";
			String cobipw = "";
			String comuix = "";
			String novias = "";
			
			System.out.println("COBIPW"); // longitud="15"	 Id bien en recovery
			cobipw = bien.getId().toString();
			
			if(!Checks.esNulo(bien.getDatosRegistralesActivo())){
				NMBInformacionRegistralBienInfo infoRegActual = bien.getDatosRegistralesActivo();
				
				// longitud="9"	 Código población registral Recibimos 5 dítigos, pero enviamos 9, rellenado con ceros por la derecha	
				comuix = infoRegActual.getLocalidad() != null ? infoRegActual.getLocalidad().getCodigo() : "";
				comuix = StringUtils.rightPad(comuix,9,"0");
			}
			
			if(!Checks.esNulo(bien.getLocalizacionActual())){
				NMBLocalizacionesBienInfo locActual = bien.getLocalizacionActual();
			
				// longitud="2"	 Código tipo de via	
				cotiv4 = locActual.getTipoVia() != null? locActual.getTipoVia().getCodigoUvem() : "";
				
				// longitud="9"	 Código población Recibimos 5 dítigos, pero enviamos 9, rellenado con ceros por la derecha	
				comuid = locActual.getLocalidad() != null ? locActual.getLocalidad().getCodigo() : "";
				comuid = StringUtils.rightPad(comuid,9,"0");
				
				// longitud="10"	 Portal	
				nupoac = locActual.getPortal();
				
				// longitud="5"	 Escalera
				nuesac = locActual.getEscalera();
				
				// longitud="17"	 Número de puerta
				nupuac = locActual.getPuerta();
				
				// longitud="55"	 Barrio
				nobaac = locActual.getBarrio();
				
				// longitud="5"	 Código postal
				copoi5 = locActual.getCodPostal();
				
				// longitud="18"	 Nombre de la provincia
				noprac = locActual.getProvincia() != null ? locActual.getProvincia().getDescripcion() : "";
				
				// longitud="3"	 Codigo pais
				copaw3 = locActual.getPais() != null ? locActual.getPais().getDescripcion() : "";
				
				novias = locActual.getNombreVia() != null ? locActual.getNombreVia() : "";
				novias += locActual.getNumeroDomicilio() != null ? " " + locActual.getNumeroDomicilio() : "";
				
			}

			System.out.println("COBIPW identificador bien recovery: " + cobipw);
			logger.debug("COBIPW identificador bien recovery: " + cobipw);
			servicioGMP5JD20.setIdBienEnRecoverycobipw(cobipw);
			System.out.println("COMUIX municipio registro: " + comuix);
			servicioGMP5JD20.setCodigoDeMunicipioRegistroAlfcomuix(comuix);
			System.out.println("COTIV4 tipo de vía: " + cotiv4);
			servicioGMP5JD20.setCodigoTipoDeViacotiv4(cotiv4);
			System.out.println("COMUID localidad localización: " + comuid);
			servicioGMP5JD20.setCodigoDeMunicipioIneSolviacomuid(comuid);
			System.out.println("NUPOAC portal: " + nupoac);
			servicioGMP5JD20.setPortalPuntoKilometriconupoac(nupoac);
			System.out.println("NUESAC escalera: " + nuesac);
			servicioGMP5JD20.setESCALERANUESAC(nuesac);
			System.out.println("NUPUAC número de puerta: " + nupuac);
			servicioGMP5JD20.setNumeroDePuertanupuac(nupuac);
			System.out.println("NOBAAC barrio: " + nobaac);
			servicioGMP5JD20.setBarrioOColonianobaac(nobaac);
			System.out.println("COPOI5 código postal: " + copoi5);
			servicioGMP5JD20.setCodigoPostalcopoi5(copoi5);
			System.out.println("NOPRAC nombre de la provincia localización: " + noprac);
			servicioGMP5JD20.setNombreDeLaProvincianoprac(noprac);
			System.out.println("COPAW3 pais: " + copaw3);
			servicioGMP5JD20.setCodigoPaisSede1copaw3(copaw3);
			System.out.println(" ***REQUERIDO*** NOVIAS:" + novias); // 	longitud="60"	 Dirección o Descripción del bien
			servicioGMP5JD20.setNombreDeLaVianovias(StringUtils.rightPad(novias, 60, ' ').substring(0, 60));
			
			
			//FIN DE NUEVO CONTENEDORES
			
			System.out.println(" ***REQUERIDO*** CORPRW"); // 	"NUMERICO_4" longitud="5"	 Código de régimen de protección 	siempre 0
			servicioGMP5JD20.setRegimenDeProteccioncorprw((short) 00000);
			System.out.println(" ***REQUERIDO*** COENAX"); // 	"NUMERICO_4" longitud="5"	 Código entrada activo 	siempre 1
			servicioGMP5JD20.setCodigoDeEntradaDelActivocoenax((short) 1);
			System.out.println(" ***REQUERIDO*** COPRAC"); // 	longitud="1"	 Procedencia del activo	siempre S
			servicioGMP5JD20.setProcedenciaDelActivocoprac('S');
			if(asunto.getPropiedadAsunto() != null && "SAREB".compareTo(asunto.getPropiedadAsunto().getCodigo()) == 0){
				System.out.println(" ***REQUERIDO*** COENGW"); // 	"NUMERICO_4" longitud="5"	 Código de Entidad	
				//FUNCIONAL, char_extra1 segun DR -> vease appconstants
				short codigoEntidad = 5074;
				servicioGMP5JD20.setCodigoEntidadcoengw(codigoEntidad);
				System.out.println(" ***REQUERIDO*** COENOW"); // 	"NUMERICO_4" longitud="5"	 Código de Entidad origen
				//FUNCIONAL, char_extra5 segun DR
				short codigoEntidadOrigen = 2069;
				servicioGMP5JD20.setCodigoEntidadOrigencoenow(codigoEntidadOrigen);
				System.out.println(" ***REQUERIDO*** COSOPW"); // 	"NUMERICO_4" longitud="5"	 Código de Sociedad Patrimonial
				//FUNCIONAL ??? segun DR
				short codigoSociedadPatrimonial = 9999;
				servicioGMP5JD20.setCodigoSociedadPatrimonialcosopw(codigoSociedadPatrimonial);
			} else { 
				//bankia BFA COENGW-> 990, COENOW->2038, COSOPW-> Titulizado s/n 99  
				//bankia NO BFA COENGW-> 0, COENOW->2038, COSOPW-> Titulizado s/n 1 
				System.out.println("//COENGW"); // 	"NUMERICO_4" longitud="5"	 Código de Entidad	
				//FUNCIONAL, char_extra1 segun DR -> vease appconstants
				short codigoEntidad = 0;
				servicioGMP5JD20.setCodigoEntidadcoengw(codigoEntidad);
				System.out.println("//COENOW"); // 	"NUMERICO_4" longitud="5"	 Código de Entidad origen
				//FUNCIONAL, char_extra5 segun DR
				short codigoEntidadOrigen = 2038;
				servicioGMP5JD20.setCodigoEntidadOrigencoenow(codigoEntidadOrigen);
				System.out.println("//COSOPW"); // 	"NUMERICO_4" longitud="5"	 Código de Sociedad Patrimonial
				//FUNCIONAL ??? segun DR
				short codigoSociedadPatrimonial = 1;
				servicioGMP5JD20.setCodigoSociedadPatrimonialcosopw(codigoSociedadPatrimonial);
			}
			System.out.println(" ***REQUERIDO*** IDPSEW"); // 	"NUMERICO_15" longitud="16"	 Identificador del procedimiento
			long identificadorProcedimiento = (asunto.getCodigoExterno() != null) ? Long.parseLong(asunto.getCodigoExterno()) : 0;
			servicioGMP5JD20.setIdentificadorProcedimientoSedasidpsew(identificadorProcedimiento);
			System.out.println(" ***REQUERIDO*** IDBISW"); // 	"NUMERICO_9" longitud="10"	 Identificador del bien
			int identificadorBien = 0;
			String idenInterno = bien.getCodigoInterno();
			if(!Checks.esNulo(idenInterno)){
				if(idenInterno.length() < 11){
					identificadorBien = Integer.parseInt(idenInterno);
				}else{
					identificadorBien = Integer.parseInt(idenInterno.substring(idenInterno.length()-10, idenInterno.length()-1));
				}
			}else{
				identificadorBien = bien.getId().intValue();
			}
			//int identificadorBien = bien.getCodigoInterno() != null ? Integer.parseInt(bien.getCodigoInterno()) : bien.getId().intValue() ;
			
			servicioGMP5JD20.setIdentificadorBienEnSedasidbisw(identificadorBien);
			//campo cd_expediente_nuse del expediente, metemos el asu_id
			System.out.println(" ***REQUERIDO*** IDEXSW"); // 	"NUMERICO_9" longitud="10"	 Identificador del expediente	
			int identificadorExpediente = asunto.getId().intValue();
			if(asunto.getId().compareTo(new Long(Integer.MAX_VALUE)) > 0){
				identificadorExpediente = new Integer(asunto.getCodigoExterno()).intValue();
			}
			servicioGMP5JD20.setIdentificadorExpedienteEnSedasidexsw(identificadorExpediente);
			System.out.println(" ***REQUERIDO*** NOCURA"); // 	longitud="40"	 Nombre del Procurador	
			String nombreProcurador = null;
			if(procuradorAsunto != null){
				nombreProcurador = StringUtils.rightPad(procuradorAsunto.getGestor().getUsuario().getApellidoNombre(), 40,' ').substring(0, 40);
			}else{
				nombreProcurador = StringUtils.rightPad("null", 40,' ').substring(0, 40);
			}
			servicioGMP5JD20.setNombreProcuradornocura(nombreProcurador);
			System.out.println(" ***REQUERIDO*** OBRECO"); // 	longitud="6"	 Referencia del Procurador
			String referenciaProcurador = StringUtils.rightPad(procuradorAsunto.getGestor().getUsuario().getUsername(), 6,' ');
			servicioGMP5JD20.setReferenciaProcuradorobreco(referenciaProcurador);
			System.out.println("*** NOLECA"); // 	longitud="40"	 Nombre del Letrado	
			String letradoCabecera = StringUtils.rightPad(gestorAsunto.getGestor().getUsuario().getUsername(),8,' ').substring(0, 8);
			servicioGMP5JD20.setLetradoDeCabeceranoleca(letradoCabecera);
			System.out.println("*** NOLOJZ"); // 	longitud="30"	 Nombre de localidad del Juzgado
			try {
			juzgado = (EXTTipoJuzgado) procedimiento.getJuzgado();
			} catch (Exception e) {
				juzgado = null;
			}
			String nombreLocalidadJudgado = "";
			if(juzgado == null){
				servicioGMP5JD20.setNombreLocalidadJuzgadonolojz(nombreLocalidadJudgado);
			} else {
				if(juzgado.getDireccion() != null && juzgado.getDireccion().getLocalidad() != null){
					nombreLocalidadJudgado = StringUtils.rightPad(juzgado.getDireccion().getLocalidad().getDescripcion(), 30,' ').substring(0, 30);
				} else {
					nombreLocalidadJudgado = StringUtils.rightPad(juzgado.getDireccion().getLocalidad().getDescripcion(), 30,' ').substring(0, 30);
				}
			}
			System.out.println("*** NUJUZW"); // 	"NUMERICO_4" longitud="5"	 Número de Juzgado
			if (juzgado != null) {
				short numeroJuzgado = Short.parseShort(procedimiento.getJuzgado().getCodigo().substring(0, 5));
				servicioGMP5JD20.setNumeroDeJuzgadonujuzw(numeroJuzgado);
			} else {
				servicioGMP5JD20.setNumeroDeJuzgadonujuzw(Short.parseShort("00000"));
			}
			System.out.println("*** TIJUZD"); // 	longitud="3"	 Tipo de Juzgado
			/*
			    “01” - JUZGADO DE PAZ
				“02” - JUZGADO DE 1ª INSTANCIA
				“03” - JUZGADO DE INSTRUCCION
				“04” - AUDIENCIA PROVINCIAL
				“05” - TRIBUNAL SUPERIOR DE JUSTICIA DE CCAA
				“06” - OTROS
			 */
			if (juzgado != null) {
				String tipoJuzgado = StringUtils.rightPad(juzgado.getPlaza() != null ? juzgado.getPlaza().getCodigo() : "06", 3,' ').substring(0, 3);
				servicioGMP5JD20.setTipoJuzgadotijuzd(tipoJuzgado);
			} else {
				servicioGMP5JD20.setTipoJuzgadotijuzd("006");
			}
			System.out.println("*** FEDEMW"); // 	"Fecha" longitud="10"	 Fecha de la demanda
			Fecha fechaDemanda = new Fecha(new Date());
			servicioGMP5JD20.setFechaDeLaDemandafedemw(fechaDemanda);
			System.out.println("*** IDAUTO"); // 	longitud="10"	 Número de autos del Juzgado	
			String numeroAutos = procedimiento.getCodigoProcedimientoEnJuzgado() != null ? procedimiento.getCodigoProcedimientoEnJuzgado() : "00000/0000";
			servicioGMP5JD20.setNumeroDeAutosJuzgadoidauto(StringUtils.rightPad(numeroAutos,10,' '));
			System.out.println("*** IMDEMX"); // 	"ImporteMonetario"	 Importe de la demanda
			long importe = 0;
			Moneda moneda = Moneda.getMonedaPorIdentificador("2811");
			ImporteMonetario importeMonetarioDemanda = new ImporteMonetario(importe, moneda);
			servicioGMP5JD20.setImporteMonetarioImporteDeLaDemanda(importeMonetarioDemanda);
			//IMDEMW	"NUMERICO_15" longitud="16"	IMPORTE DE LA DEMANDA          	Descomposición del elemento IMDEMW
			// entiendo que hay que meterlo en el importeMonetarioDemanda pero no veo como
			//COMN29	longitud="3"	MONEDA IMPORTE DE LA DEMANDA 
			// entiendo que hay que meterlo en el importeMonetarioDemanda pero no veo como
			//NUDM29	longitud="1"	CONTROL MONEDA IMPORTE DE LA D 	
			// entiendo que hay que meterlo en el importeMonetarioDemanda pero no veo como
			//CADI29	longitud="1"	DECIMALES IMPORTE DE LA DEMAND 	
			// entiendo que hay que meterlo en el importeMonetarioDemanda pero no veo como
			System.out.println("*** APRESH"); // 	longitud="1"	 Código de Vivienda Habitual
			/* Campo Vivienda Habitual à  APRESH:
				 
				“0” - OTROS
				“1” – PRIMERA VIVIENDA
				“2” – SEGUNDA VIVIENDA
				“3” - DESCONOCIDO
				
			*/	
			//char viviendaHabitual = bien.getViviendaHabitual() == null ? '3' : bien.getViviendaHabitual()  ? '1' : '0' ;
			//servicioGMP5JD20.setIndicadorResidenciaHabitualapresh(viviendaHabitual);
			
			//Como va en funcion del tipo de inmueble lo seteamos abajo
			
			System.out.println("*** COTSIN"); // 	longitud="4"	 Código de tipo/subtipo de inmueble
			String tipoInmueble = "OT05";
			if(bien.getAdicional() != null){
				if(bien.getAdicional().getTipoInmueble() != null){
					tipoInmueble = bien.getAdicional().getTipoInmueble().getCodigo();
				}
			}
			
			if(tipoInmueble.contains("VI"))			 
			{
				//tipoInmueble = "VI01";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh(bien.getViviendaHabitual() == null ? '3' : "1".equals(bien.getViviendaHabitual())  ? '1' : '2' );
			}
			else if(tipoInmueble.contains("UN"))
			{	
			    //tipoInmueble = "VI04";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh(bien.getViviendaHabitual() == null ? '3' : "1".equals(bien.getViviendaHabitual())  ? '1' : '2' );
			}
			else if(tipoInmueble.contains("CO"))
			{
				//tipoInmueble = "CO01";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh('0');
			}            
			else if(tipoInmueble.contains("IN"))
			{
				//tipoInmueble = "IN01";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh('0');
			}
			else if(tipoInmueble.contains("SU"))
			{
				//tipoInmueble = "SU01";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh('0');
			}
			else if(tipoInmueble.contains("GA") || tipoInmueble.contains("GJ"))
			{
				//tipoInmueble = "OT01";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh('0');
			}
			else if(tipoInmueble.contains("TR"))
			{
				//tipoInmueble = "OT03";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh('0');
			}
			else if(tipoInmueble.contains("OT"))
			{
				//tipoInmueble = "OT01";
			    servicioGMP5JD20.setIndicadorResidenciaHabitualapresh('0');
			}
			else {
				//tipoInmueble = "OT05";
				servicioGMP5JD20.setIndicadorResidenciaHabitualapresh('0');
			}
			
			System.out.println("COTSIN tipo inmueble: " + tipoInmueble);
			tipoInmueble = StringUtils.rightPad(tipoInmueble,4,' ').substring(0, 4);
			servicioGMP5JD20.setCodigoTipoSubtipoDeInmueblecotsin(tipoInmueble);
			
			//IDDSFU	longitud="4"	IDENTIFICADOR DISCRIMINADOR FUNCION	Elementos nuevos para la dirección del inmueble.
			// no lo encuentro
			//String identificadorFuncion = StringUtils.rightPad("",4,' ');
			//Se mantienen NOVIAS, NUPIIN y NOLGMU, y se añaden los aquí referenciados.
			//El elemento IDDSFU será el discriminador para que el servicio funcione como hasta ahora (espacios) o tenga en cuenta los nuevos elementos (DF01).
			//COTIVI 	"NUMERICO_4" longitud="5"	CODIGO TIPO DE VIA
			// no lo encuentro, subobject?
			//String codigoTipoVia = StringUtils.rightPad("",5,' ');
			//NOTIV1 	longitud="2"	DENOMINACION TIPO DE VIA (TRAB 	
			// no lo encuentro, subobject?
			//String denominacionTipoVia = StringUtils.rightPad("",2,' ');
			//NUPOAC 	longitud="17"	PORTAL PUNTO KILOMETRICO 
			// no lo encuentro, subobject?
			//String portal = StringUtils.rightPad("",17,' ');
			//NUESAC 	longitud="5"	ESCALERA
			// no lo encuentro, subobject?
			//String escalera = StringUtils.rightPad("",5,' ');
			//NUPUAC 	longitud="17"	NUMERO DE PUERTA
			// no lo encuentro, subobject?
			//String numero = StringUtils.rightPad("",17,' ');
			//NOBAAC 	longitud="55"	BARRIO O COLONIA
			// no lo encuentro, subobject?
			//String barrio = StringUtils.rightPad("",55,' ');
			//COPOIN 	"NUMERICO_9" longitud="10"	CODIGO POSTAL 
			// no lo encuentro, subobject?
			//String codigoPostal = StringUtils.rightPad(bien.getLocalizacionActual().getCodPostal(),10,' ');
			//COPRAE 	"NUMERICO_4" longitud="5"	CODIGO DE PROVINCIA 
			// no lo encuentro, subobject?
			//Declarado arriba
			//NOPRAC 	longitud="18"	NOMBRE DE LA PROVINCIA 
			//String nombreProvincia = StringUtils.rightPad(bien.getLocalizacionActual().getProvincia().getDescripcion(),18,' ');
			// no lo encuentro, subobject?
			//NOMUIN 	longitud="30"	NOMBRE DEL MUNICIPIO
			//String munucipio = StringUtils.rightPad(bien.getPoblacion(),30,' ');
			// no lo encuentro, subobject?
			 
			System.out.println("//Identificación de la aplicación que ejecuta el servicio");
			servicioGMP5JD20.setAlias("PFS");
			
			System.out.println("Invocamos al servicio");
			servicioGMP5JD20.execute();
			 
			System.out.println("Se recuperan los datos de vuelta del servicio");
			Integer numeroActivo = servicioGMP5JD20.getIdentificadorActivoEspecialcoacew2();
			System.out.println("Número de activooooo: "+numeroActivo);
			
			if( numeroActivo!=null && numeroActivo!=0 ){
				bien.setNumeroActivo(String.valueOf(numeroActivo));
				genericDao.update(NMBBien.class, bien);
				return "1";
			}
			else{
				return "-1";
			}
		
		} catch (Exception e) {
			if  (e instanceof WIException){
				WIException wi = ((WIException)e);
				System.out.println("ALIAS: " + wi.getAlias());
				System.out.println("CAUSE: " + wi.getCause());
				System.out.println("CONFIGURATIONVERSION: " + wi.getConfigurationVersion());
				System.out.println("CLASS: " + wi.getClass());
				System.out.println("ERRORCODE: " +wi.getErrorCode());
				System.out.println("ERRORCODECOMMUNICATION: " + wi.getErrorCodeCommunication());
				System.out.println("ERRORTYPE: " + wi.getErrorType());
				System.out.println("INFODEBUG: " +wi.getInfoDebug());
				System.out.println("LOCALIZEDMESSAGE: " + wi.getLocalizedMessage());
				System.out.println("MAQUINAEJECUCION: " + wi.getMaquinaEjecucion());
				System.out.println("MESSAGE: " + wi.getMessage());
				System.out.println("OPERATION: " + wi.getOperationId());
				System.out.println("PROVEEDOR: " + wi.getProveedor());
				System.out.println("SERVICE_MODULE: " + wi.getService_module());
				System.out.println("SERVICE_NAME: " + wi.getService_name());
				System.out.println("SERVICE_VERSION: " + wi.getService_version());
				System.out.println("STACKTRACE: " + wi.getStackTrace());
				System.out.println("SUBSYSTEM: " + wi.getSubsystem());
				System.out.println("URL: " + wi.getUrl());
				return wi.getMessage();
			} 
			e.printStackTrace();
			return "-1";
		}
		
	}

	
	
	
	/**
	 * Método que solicita la tasacion de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	//@Override
	
	//@ManagedOperation(description ="Método que solicita la tasacion de un bien a UVEM")
	//@ManagedOperationParameter(name="bienId", description= "id del bien.") 
	private void solicitarTasacion(Long bienId, Long prcId){
		
		try {
			
			UVEMUtils();
			
			System.out.println("Iniciando.... solicitarTasacion");
			//final Entidad entidad = entidadDao.findByWorkingCode(workingCode);
			//DbIdContextHolder.setDbId(entidad.getId());
			
			NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(bienId);
			System.out.println("Bien encontrado.");
			EXTAsunto asunto = null;
			MEJProcedimiento procedimiento = null;
			EXTGestorAdicionalAsunto procuradorAsunto = null;
			EXTGestorAdicionalAsunto gestorAsunto = null;
			EXTTipoJuzgado juzgado = null;
			EXTContrato contrato = null;
			
			if(!Checks.esNulo(prcId)){
				procedimiento = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
				System.out.println("Procedimiento obtenido.");	
			}
			else{
				List<ProcedimientoBien> procedimientos = bien.getProcedimientos();
				System.out.println("Procedimientos recuperados.");
				if(procedimientos != null && procedimientos.size() > 0){
					//cogemos el ultimo procedimiento
					procedimiento = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", procedimientos.get(procedimientos.size()-1).getProcedimiento().getId()));
					System.out.println("Procedimiento obtenido.");	
				}
			}	
			
			Asunto asuntoAux = procedimiento.getAsunto();
			asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", asuntoAux.getId()));
			System.out.println("Asunto obtenido.");
			
			//Gestión: haya, bankia
			String gestion = null;
			if(!Checks.esNulo(asunto)){
				if(asunto instanceof EXTAsunto){
					gestion = ((EXTAsunto) asunto).getGestionAsunto().getCodigo();
				}
			}
			
			List<ExpedienteContrato> expedienteContratos = asunto.getExpediente().getContratos();
			if(expedienteContratos != null && expedienteContratos.size() > 0){
				contrato = (EXTContrato) expedienteContratos.get(0).getContrato();
				System.out.println("Contrato obtenido.");
			}			
			
			//validaciones
			if(asunto != null && procedimiento != null && bien != null) {
				System.out.println("Unidades de gestion no nulas.");
				List<EXTGestorAdicionalAsunto> gestores = asunto.getGestoresAsunto();
				if(gestores != null || gestores.size() > 0){
					for(EXTGestorAdicionalAsunto gestor : gestores){
						if (EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR.compareTo( gestor.getTipoGestor().getCodigo()) == 0){
							procuradorAsunto = gestor;
							System.out.println("Procurador recuperado");
						}
						if (EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO.compareTo( gestor.getTipoGestor().getCodigo()) == 0){
							gestorAsunto = gestor;
							System.out.println("Gestor recuperado.");
						}
					}
				}
			} else {
				//return null;
			}
			
		System.out.println("Inicialización del endpoint de MidTR. Se realiza una única vez para todos los servicios. La url de MidTR debe estar parametrizada pues varía en cada entorno");
		Hashtable htInitParams = new Hashtable();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);
		WIService.init(htInitParams);
		 
		System.out.println("Instanciación del servicio");
		GMPETS07_INS servicioGMPETS07_INS = new GMPETS07_INS();
		
		System.out.println("Requeridos por el servicio");
		servicioGMPETS07_INS.setnumeroCliente(0);
		servicioGMPETS07_INS.setnumeroUsuario("");
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		servicioGMPETS07_INS.setidSesionWL(request != null ? request.getSession().getId() : "");
		
		System.out.println("Creamos cabeceras.");
		es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraTecnica();                   
		StructCabeceraAplicacionGMPETS07_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPETS07_INS();
		
		System.out.println("Seteamos cabeceras.");
		servicioGMPETS07_INS.setcabeceraAplicacion(cabeceraAplicacion);    
		servicioGMPETS07_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPETS07_INS.setcabeceraTecnica(cabeceraTecnica);
		
		System.out.println("Rellenamos peticion");
		System.out.println("PROGRAMA GMPETS07");
		System.out.println("BIE_ID --> "+bien.getId());
		
		System.out.println("*** LNUITA"); // 	"NUMERICO_9" longitud="10"	 Código de tasación	siempre 0
		servicioGMPETS07_INS.setNumeroIdentificadorDeTasacionlnuita(0000000000);
		System.out.println("*** COUSAE"); // 	longitud="8"	 Usuario SSA solicitante 
		String codigoUsuarioSolicitante = StringUtils.rightPad(gestorAsunto.getGestor().getUsuario().getUsername(),8,' ').substring(0, 8);
		servicioGMPETS07_INS.setCodigoDeUsuariocousae(codigoUsuarioSolicitante);
		System.out.println("*** LNTARI"); // 	"NUMERICO_9" longitud="10"	 Tipo de tasación	siempre 2
		servicioGMPETS07_INS.setNumeroDeTarifalntari(0000000002);
		System.out.println("*** INDIDO"); // 	longitud="1"	 Indicador documentación	siempre " " (spaces)
		servicioGMPETS07_INS.setIndicadorDocumentacionindido(' ');
		System.out.println("*** CODTAS"); // 	longitud="1"	 Código de tasadora	siempre 2
		servicioGMPETS07_INS.setCodigoTasadoracodtas('2');
		System.out.println("*** NUDNIP"); // 	longitud="10"	 Sociedad de tasación.
		/*
		“ A28806222” - TASACIONES HIPOTECARIAS, S.A.
		“ A78029774” - TINSA,TASACIONES INMOBILIARIAS, S.A.
		“ A80884372” - GESTION DE VALORACIONES Y TASACIONES, S.A.
		“ A78116324” - TECNITASA
		*/
		String nifcifProveedor = " A78029774";
		servicioGMPETS07_INS.setCifDniDelProvedornudnip(nifcifProveedor);
		System.out.println("*** CONTSI"); // 	longitud="4"	 Tipo subtipo inmueble	siempre " " (spaces)
		servicioGMPETS07_INS.setCodigoNuevoTipoSubtipoDeInmueblcontsi(StringUtils.rightPad("",4,' ').substring(0, 4));
		//LIMPOX	"CantidadDecimal15"	IMPORTE OPERACION 
		CantidadDecimal15 importeOperacion = new CantidadDecimal15(new BigDecimal(0.00));
		servicioGMPETS07_INS.setImporteOperacionlimpox(importeOperacion);
		//LIMPOP	"NUMERICO_15" longitud="16"	IMPORTE OPERACION 
		//CADC02	longitud="2"	CANTIDAD DE DECIMALES COLAB.
		//LIMVAX	"CantidadDecimal15"	IMPORTE VALOR DE LA TASACION
		CantidadDecimal15 importeValorTasacion = new CantidadDecimal15(new BigDecimal(0.00));
		servicioGMPETS07_INS.setImporteValorDeLaTasacionlimvax(importeValorTasacion);
		//LIMVAT	"NUMERICO_15" longitud="16"	IMPORTE VENTA COLABORADOR
		//CADC01	longitud="2"	CANTIDAD DE DECIMALES COLAB.	
		//LIMFIX	"CantidadDecimal15"	IMPORTE VALOR FINALIZADO 
		CantidadDecimal15 importeValorFinalizado = new CantidadDecimal15(new BigDecimal(0.00));
		servicioGMPETS07_INS.setImporteValorFinalizadolimfix(importeValorFinalizado);
		//LIMFIN	"NUMERICO_15" longitud="16"	IMPORTE VALOR FINALIZADO    	
		//CADC34	longitud="2"	CANTIDAD DE DECIMALES COLAB.	
		System.out.println("*** LCOEST"); // 	"NUMERICO_4" longitud="5"	 Código estado tasación	siempre 0
		servicioGMPETS07_INS.setCodigoDeEstadoTasacionlcoest((short) 00000);
		System.out.println("*** LCOEFA"); // 	"NUMERICO_4" longitud="5"	 Código estado factura	siempre 0
		servicioGMPETS07_INS.setCodigoDeEstadoFacturalcoefa((short) 00000);
		System.out.println("*** OBSETA"); // 	longitud="150"	 Observación de tasaciones	siempre " " (spaces)
		servicioGMPETS07_INS.setLineaDeObservacionTasacionesobseta(StringUtils.rightPad("",150,' ').substring(0, 150));
		System.out.println("*** NUMOGT"); // 	longitud="170"	 Observación de tasaciones	siempre " " (spaces)
		VectorGMPETS07_INS_NumeroDeOcurrenciasnumogt numeroOcurrencias0 = new VectorGMPETS07_INS_NumeroDeOcurrenciasnumogt();
		for (int i=0; i<5; i++) {
			StructGMPETS07_INS_NumeroDeOcurrenciasnumogt arg0 = new StructGMPETS07_INS_NumeroDeOcurrenciasnumogt() ;
			//arg0.setNombreDelDocumentonombdo("");
			arg0.setNombreDelDocumentonombdo(StringUtils.rightPad("",34,' ').substring(0, 34));
            numeroOcurrencias0.setStructGMPETS07_INS_NumeroDeOcurrenciasnumogt(arg0);
        }
		servicioGMPETS07_INS.setNumeroDeOcurrenciasnumogt(numeroOcurrencias0);
		System.out.println("*** NOMCC1"); // 	longitud="40"	 Nombre de usuario conectado.
		servicioGMPETS07_INS.setNombrePersonaContacto1nomcc1(StringUtils.rightPad("PFS",40,' ').substring(0, 40));
		if (!Checks.esNulo(gestion)) {
			if ("BANKIA".equals(gestion)) {
				servicioGMPETS07_INS.setNombrePersonaContacto1nomcc1(StringUtils.rightPad("recuperacionessubastas@bankia.com",40,' ').substring(0, 40));
			} else if ("HAYA".equals(gestion)) {
				servicioGMPETS07_INS.setNombrePersonaContacto1nomcc1(StringUtils.rightPad("subastassb@bankia.com",40,' ').substring(0, 40));
			}
		}
		
		System.out.println("*** NUTEAR"); // 	longitud="14"	 Número de teléfono de usuario conectado.
		//Ponemos bankia por defecto
		servicioGMPETS07_INS.setNumeroDeTelefononutear(StringUtils.rightPad("915966118",14,' ').substring(0, 14));
		if (!Checks.esNulo(gestion)) {
			if ("BANKIA".equals(gestion)) {
				servicioGMPETS07_INS.setNumeroDeTelefononutear(StringUtils.rightPad("915966118",14,' ').substring(0, 14));
			} else if ("HAYA".equals(gestion)) {
				servicioGMPETS07_INS.setNumeroDeTelefononutear(StringUtils.rightPad("913792210",14,' ').substring(0, 14));
			}
		}		
		
		System.out.println("*** COACCA"); // 	longitud="1"	 Código de acción	siempre " " (spaces)
		servicioGMPETS07_INS.setCodigoDeAccionConsultaModificcoacca(' ');
		System.out.println("*** COPPRE"); // 	longitud="1"	 Código de presupuesto	siempre 1
		servicioGMPETS07_INS.setCodigoPresupuestocoppre('1');
		System.out.println("*** LFETAS"); // 	"NUMERICO_9" longitud="10"	 Fecha de tasación	siempre 0
		servicioGMPETS07_INS.setFechaDeLaTasacionlfetas(0000000000);
		//NOMBDO	longitud="34"	NOMBRE DEL DOCUMENTO
		System.out.println("*** NUMOG1"); // 	Repetición veces="500"	 Tabla con números de activo.	TABLA  
		Integer numeroActivo = 0;
		if(!Checks.esNulo(bien.getNumeroActivo())){
			try{
			numeroActivo = Integer.parseInt(bien.getNumeroActivo());
			System.out.println("Numero Activo: "+ numeroActivo);
			}
			catch(NumberFormatException e){
				System.out.println("solicitarTasacion(): error al parsear a integer " + e);
			}
		}
		
        VectorGMPETS07_INS_NumeroDeOcurrenciasnumog1 numeroOcurrencias1 = new VectorGMPETS07_INS_NumeroDeOcurrenciasnumog1();
        
        // Registro 1
        StructGMPETS07_INS_NumeroDeOcurrenciasnumog1 numeroOcurrencias1Registro = new StructGMPETS07_INS_NumeroDeOcurrenciasnumog1();
        numeroOcurrencias1Registro.setCodigoDeSituacionDelInmueblelcoace(numeroActivo);
        numeroOcurrencias1.setStructGMPETS07_INS_NumeroDeOcurrenciasnumog1(numeroOcurrencias1Registro);
       
        // Registro n
        for(int i = 1;i<500;i++){
        	StructGMPETS07_INS_NumeroDeOcurrenciasnumog1 numeroOcurrencias1Registrox = new StructGMPETS07_INS_NumeroDeOcurrenciasnumog1();
        	numeroOcurrencias1Registrox.setCodigoDeSituacionDelInmueblelcoace(0);
            numeroOcurrencias1.setStructGMPETS07_INS_NumeroDeOcurrenciasnumog1(numeroOcurrencias1Registrox);
        }
        
        servicioGMPETS07_INS.setNumeroDeOcurrenciasnumog1(numeroOcurrencias1);
        
		//LCOACE	"NUMERICO_9" longitud="10"	CODIGO DE SiTUACION DEL INMUEB	
		//**LIDPRO	"NUMERICO_9" longitud="10"	IDENTIFICADOR DE PROVEEDOR  
		servicioGMPETS07_INS.setIdentificadorDeProveedorlidpro(1234567890);
		//**LNUITR	"NUMERICO_9" longitud="10"	NUMERO IDENTIFICADOR DE CER.EN	
		servicioGMPETS07_INS.setNumeroIdentificadorDeCerEnerlnuitr(1234567890);

		System.out.println("//Identificación de la aplicación que ejecuta el servicio");
		servicioGMPETS07_INS.setAlias("PFS");
		
		System.out.println("Invocamos al servicio");
		servicioGMPETS07_INS.execute();
		
		//RESPUESTA OK	
		
		//NOMBRE	TIPO	DESCRIPCION	REQUERIDO / VALOR POR DEFECTO
		//RCSLON	"NUMERICO_9" longitud="10"	LONGITUD MENSAJE DE SALIDA
		//LNUITA	"NUMERICO_9" longitud="10"	NUMERO IDENTIFICADOR DE TASACI
		System.out.println("recuperando resultado...");
		int numeroIdentificadorTasacion = -1;
		numeroIdentificadorTasacion = servicioGMPETS07_INS.getNumeroIdentificadorDeTasacionlnuita2();

		System.out.println("Devolvemos resultado.");
		List<NMBValoracionesBien> valoraciones = bien.getValoraciones();
		NMBValoracionesBienInfo valoracionActiva = bien.getValoracionActiva();
		NMBValoracionesBien nueva = new NMBValoracionesBien();
		if(valoracionActiva != null){
			for (NMBValoracionesBien val : valoraciones) {
				if (val.getId() == valoracionActiva.getId() ) 
					nueva = val;
					nueva.setCodigoNuita(numeroIdentificadorTasacion);
					nueva.setFechaSolicitudTasacion(new Date());
					Auditoria auditoria = Auditoria.getNewInstance();
					nueva.setAuditoria(auditoria);
					break;
	        }
		} else {
			nueva.setCodigoNuita(numeroIdentificadorTasacion);
			nueva.setBien(bien);
			Auditoria auditoria = Auditoria.getNewInstance();
			nueva.setAuditoria(auditoria);
		}
		valoraciones.add(nueva);
		bien.setValoraciones(valoraciones);
		genericDao.update(NMBBien.class, bien);
		
		
		
		//RESPUESTA KO	
		
		//NOMBRE	TIPO	DESCRIPCION	REQUERIDO / VALOR POR DEFECTO
		//RCSLON	"NUMERICO_9" longitud="10"	LONGITUD MENSAJE DE SALIDA    	
		//MSTXAH	longitud="80"	TEXTO EXPLICATIVO DE CODIGO RETORNO	

		
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
	}

	
	/**
	 * Método que cancela una peticion de tasacion de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	/*
	@Override
	@BusinessOperation(overrides=BO_UVEM_CANCELAR_SOLICITUD_TASACION)
	@ManagedOperation(description ="Método que cancela una peticion de tasacion de un bien a UVEM (NO IMPLEMENTADO)")
	public void cancelarTasacion(Long bienId){
		
		try {
			
		//Inicialización del endpoint de MidTR. Se realiza una única vez para todos los servicios. La url de MidTR debe estar parametrizada pues varía en cada entorno
		Hashtable htInitParams = new Hashtable();
		htInitParams.put(WIService.WORFLOW_PARAM, "http://midtr2epd.cm.es:31485/bisa/endpoint");
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);
		WIService.init(htInitParams);
		 
		//Instanciación del servicio
		//TODO  este no es el servicio falta un cliente GMPETS11
		GMPETS07_INS servicioGMPETS07_INS = new GMPETS07_INS();
		
		es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraTecnica();                   
		StructCabeceraAplicacionGMPETS07_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPETS07_INS();
		
		servicioGMPETS07_INS.setcabeceraAplicacion(cabeceraAplicacion);    
		servicioGMPETS07_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPETS07_INS.setcabeceraTecnica(cabeceraTecnica);
		
		//PROGRAMA	GMPETS11	
		
		//COACCA 	longitud="1"	 Código de acción	siempre A
		//LNUITA 	"NUMERICO_9" longitud="10"	Número de tasación	
		//LCODTA	"NUMERICO_4" longitud="5"	Código de tasación	siempre 0
		//LCODFA	"NUMERICO_4" longitud="5"	Código factura	siempre 0
		//INANUL	longitud="1"	Indicador de anulación	siempre S
		//INFAVI	longitud="1"	INDICADOR DE FACTURAR VISITA	
		
		//Identificación de la aplicación que ejecuta el servicio
		servicioGMPETS07_INS.setAlias("GM");
				 
		servicioGMPETS07_INS.execute();
				 
		//Se recuperan los datos de vuelta del servicio
		
		//RESPUESTA OK
		//PROGRAMA	GMPETS11	
		
		//RCSLON	"NUMERICO_9" longitud="10"	LONGITUD MENSAJE DE SALIDA    	
		//NUOCPR	"NUMERICO_4" longitud="5"	NUMERO DE OCURRENCIAS PROCESAD	
		//LNUITA	"NUMERICO_9" longitud="10"	NUMERO IDENTIFICADOR DE TASACI	
		//NUMOGT	Repetición veces="20"	NUMERO DE OCURRENCIAS         	TABLA
		//LCODTA	"NUMERICO_4" longitud="5"	CODIGO DE TASACION            	
		//LCODFA	"NUMERICO_4" longitud="5"	CODIGO DE FACTURA             	
		//LFEALT	"NUMERICO_9" longitud="10"	FECHA DE ALTA                 	
		//LNUFAT	"NUMERICO_9" longitud="10"	NUMERO FACTURA TASACION       	
		//NUFPRO	longitud="20"	NUMERO FACTURA PROVEEDOR      	
		//LFEFAC	"NUMERICO_9" longitud="10"	FECHA DE factura              	
		//LIMPOX	"CantidadDecimal15	IMPORTE OPERACION             	
		//LIMPOP	"NUMERICO_15" longitud="16"	IMPORTE OPERACION             	
		//CADC02	longitud="2"	CANTIDAD DE DECIMALES COLAB.  	
		
		//RESPUESTA KO
		//PROGRAMA	GMPETS11	
		
		//RCSLON	"NUMERICO_9" longitud="10"	LONGITUD MENSAJE DE SALIDA    	
		//MSTXAH	longitud="80"	TEXTO EXPLICATIVO DE CODIGO RETORNO	


		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
	};
	*/
	

	private String quitaTildes(String str) {

		
		StringBuilder sb = new StringBuilder();
		try {
			String ejemplo = str.replaceAll("Ñ", "!");	
			String proc = java.text.Normalizer.normalize(ejemplo,
					java.text.Normalizer.Form.NFD);
			//proc.replace("N~","Ñ");
			for (char c : proc.toCharArray()) {
				if (Character.UnicodeBlock.of(c) == Character.UnicodeBlock.BASIC_LATIN) {
					sb.append(c);
				}
			}
						
		} catch (Exception e) {
			logger.error("quitaTildes: " + e);
		}

		return sb.toString().replaceAll("!", "Ñ");

	}

	
	

}
