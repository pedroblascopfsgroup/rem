package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Hashtable;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.gfi.webIntegrator.WIException;
import com.gfi.webIntegrator.WIMetaServiceException;
import com.gfi.webIntegrator.WIService;

import es.cajamadrid.servicios.ARQ.ImporteMonetario;
import es.cajamadrid.servicios.ARQ.Porcentaje9;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraAplicacionGMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraFuncionalPeticion;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraTecnica;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructGMPAJC11_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.VectorGMPAJC11_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPAJC34_INS.GMPAJC34_INS;
import es.cajamadrid.servicios.GM.GMPAJC34_INS.StructCabeceraAplicacionGMPAJC34_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraAplicacionGMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.GMPDJB13_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraAplicacionGMPDJB13_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPETS07_INS.GMPETS07_INS;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraAplicacionGMPETS07_INS;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructGMPETS07_INS_NumeroDeOcurrenciasnumog1;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructGMPETS07_INS_NumeroDeOcurrenciasnumogt;
import es.cajamadrid.servicios.GM.GMPETS07_INS.VectorGMPETS07_INS_NumeroDeOcurrenciasnumog1;
import es.cajamadrid.servicios.GM.GMPETS07_INS.VectorGMPETS07_INS_NumeroDeOcurrenciasnumogt;
import es.cm.arq.tda.tiposdedatosbase.CantidadDecimal15;
import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;

@Service("uvemManager")
public class UvemManager implements UvemManagerApi {

	private final Log logger = LogFactory.getLog(getClass());

	private String URL = "";
	private String ALIAS = "";

	private GMPETS07_INS servicioGMPETS07_INS;

	private GMPAJC93_INS servicioGMPAJC93_INS;

	private GMPAJC11_INS servicioGMPAJC11_INS;

	// O-RB-PTMO – servicio GMPAJC34
	private GMPAJC34_INS servicioGMPAJC34_INS;

	// O-RB-FFDD - servicio GMPDJB13
	private GMPDJB13_INS servicioGMPDJB13_INS;


	@Resource
	private Properties appProperties;

	private void leerConfiguracion() {
		if (appProperties == null) {
			appProperties = new Properties();
			try {
				appProperties
						.load(new FileInputStream(new File(new File(".").getCanonicalPath() + "/devon.properties")));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		this.URL = !Checks.esNulo(appProperties.getProperty("rest.client.uvem.url.base"))
				? appProperties.getProperty("rest.client.uvem.url.base") : "";
		this.ALIAS = !Checks.esNulo(appProperties.getProperty("rest.client.uvem.alias.integrador"))
				? appProperties.getProperty("rest.client.uvem.alias.integrador") : "";
	}


	/**
	 * Invoca al servicio GMPETS07_INS de BANKIA para solicitar una Tasación
	 * 
	 * @param bienId
	 * @param nombreGestor
	 * @param gestion
	 * @return
	 */
	public Integer ejecutarSolicitarTasacion(Long bienId, String nombreGestor, String gestion)
			throws WIMetaServiceException, WIException, TipoDeDatoException {

		leerConfiguracion();

		int numeroIdentificadorTasacion = -1;

		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);

		// instanciamos el servicio
		servicioGMPETS07_INS = new GMPETS07_INS();

		// Requeridos por el servicio;
		servicioGMPETS07_INS.setnumeroCliente(0);
		servicioGMPETS07_INS.setnumeroUsuario("");

		HttpServletRequest request = null;
		if (RequestContextHolder.getRequestAttributes() != null) {
			request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		}
		servicioGMPETS07_INS.setidSesionWL(request != null ? request.getSession().getId() : "");

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraTecnica();
		StructCabeceraAplicacionGMPETS07_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPETS07_INS();
		
		// Seteamos cabeceras
		servicioGMPETS07_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPETS07_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPETS07_INS.setcabeceraTecnica(cabeceraTecnica);

		servicioGMPETS07_INS.setNumeroIdentificadorDeTasacionlnuita(0000000000);
		String codigoUsuarioSolicitante = StringUtils.rightPad(nombreGestor, 8, ' ').substring(0, 8);
		servicioGMPETS07_INS.setCodigoDeUsuariocousae(codigoUsuarioSolicitante);
		servicioGMPETS07_INS.setNumeroDeTarifalntari(0000000002);
		servicioGMPETS07_INS.setIndicadorDocumentacionindido(' ');
		servicioGMPETS07_INS.setCodigoTasadoracodtas('2');
		String nifcifProveedor = " A78029774";
		servicioGMPETS07_INS.setCifDniDelProvedornudnip(nifcifProveedor);
		servicioGMPETS07_INS.setCodigoNuevoTipoSubtipoDeInmueblcontsi(StringUtils.rightPad("", 4, ' ').substring(0, 4));
		// LIMPOX "CantidadDecimal15" IMPORTE OPERACION
		CantidadDecimal15 importeOperacion = new CantidadDecimal15(BigDecimal.valueOf(0.00));
		servicioGMPETS07_INS.setImporteOperacionlimpox(importeOperacion);
		CantidadDecimal15 importeValorTasacion = new CantidadDecimal15(BigDecimal.valueOf(0.00));
		servicioGMPETS07_INS.setImporteValorDeLaTasacionlimvax(importeValorTasacion);
		CantidadDecimal15 importeValorFinalizado = new CantidadDecimal15(BigDecimal.valueOf(0.00));
		servicioGMPETS07_INS.setImporteValorFinalizadolimfix(importeValorFinalizado);
		servicioGMPETS07_INS.setCodigoDeEstadoTasacionlcoest((short) 00000);
		servicioGMPETS07_INS.setCodigoDeEstadoFacturalcoefa((short) 00000);
		servicioGMPETS07_INS
				.setLineaDeObservacionTasacionesobseta(StringUtils.rightPad("", 150, ' ').substring(0, 150));
		VectorGMPETS07_INS_NumeroDeOcurrenciasnumogt numeroOcurrencias0 = new VectorGMPETS07_INS_NumeroDeOcurrenciasnumogt();
		for (int i = 0; i < 5; i++) {
			StructGMPETS07_INS_NumeroDeOcurrenciasnumogt arg0 = new StructGMPETS07_INS_NumeroDeOcurrenciasnumogt();
			arg0.setNombreDelDocumentonombdo(StringUtils.rightPad("", 34, ' ').substring(0, 34));
			numeroOcurrencias0.setStructGMPETS07_INS_NumeroDeOcurrenciasnumogt(arg0);
		}
		servicioGMPETS07_INS.setNumeroDeOcurrenciasnumogt(numeroOcurrencias0);
		servicioGMPETS07_INS.setNombrePersonaContacto1nomcc1(StringUtils.rightPad("PFS", 40, ' ').substring(0, 40));
		if (!Checks.esNulo(gestion)) {
			if ("BANKIA".equals(gestion)) {
				servicioGMPETS07_INS.setNombrePersonaContacto1nomcc1(
						StringUtils.rightPad("recuperacionessubastas@bankia.com", 40, ' ').substring(0, 40));
			} else if ("HAYA".equals(gestion)) {
				servicioGMPETS07_INS.setNombrePersonaContacto1nomcc1(
						StringUtils.rightPad("subastassb@bankia.com", 40, ' ').substring(0, 40));
			}
		}

		// Ponemos bankia por defecto
		servicioGMPETS07_INS.setNumeroDeTelefononutear(StringUtils.rightPad("915966118", 14, ' ').substring(0, 14));
		if (!Checks.esNulo(gestion)) {
			if ("BANKIA".equals(gestion)) {
				servicioGMPETS07_INS
						.setNumeroDeTelefononutear(StringUtils.rightPad("915966118", 14, ' ').substring(0, 14));
			} else if ("HAYA".equals(gestion)) {
				servicioGMPETS07_INS
						.setNumeroDeTelefononutear(StringUtils.rightPad("913792210", 14, ' ').substring(0, 14));
			}
		}

		servicioGMPETS07_INS.setCodigoDeAccionConsultaModificcoacca(' ');
		servicioGMPETS07_INS.setCodigoPresupuestocoppre('1');
		servicioGMPETS07_INS.setFechaDeLaTasacionlfetas(0000000000);
		Integer numeroActivo = 0;
		if (!Checks.esNulo(bienId)) {
			numeroActivo = bienId != null ? bienId.intValue() : null;
		}

		VectorGMPETS07_INS_NumeroDeOcurrenciasnumog1 numeroOcurrencias1 = new VectorGMPETS07_INS_NumeroDeOcurrenciasnumog1();

		// Registro 1
		StructGMPETS07_INS_NumeroDeOcurrenciasnumog1 numeroOcurrencias1Registro = new StructGMPETS07_INS_NumeroDeOcurrenciasnumog1();
		numeroOcurrencias1Registro.setCodigoDeSituacionDelInmueblelcoace(numeroActivo);
		numeroOcurrencias1.setStructGMPETS07_INS_NumeroDeOcurrenciasnumog1(numeroOcurrencias1Registro);

		// Registro n
		for (int i = 1; i < 500; i++) {
			StructGMPETS07_INS_NumeroDeOcurrenciasnumog1 numeroOcurrencias1Registrox = new StructGMPETS07_INS_NumeroDeOcurrenciasnumog1();
			numeroOcurrencias1Registrox.setCodigoDeSituacionDelInmueblelcoace(0);
			numeroOcurrencias1.setStructGMPETS07_INS_NumeroDeOcurrenciasnumog1(numeroOcurrencias1Registrox);
		}

		servicioGMPETS07_INS.setNumeroDeOcurrenciasnumog1(numeroOcurrencias1);

		servicioGMPETS07_INS.setIdentificadorDeProveedorlidpro(1234567890);
		servicioGMPETS07_INS.setNumeroIdentificadorDeCerEnerlnuitr(1234567890);

		servicioGMPETS07_INS.setAlias(ALIAS);
		servicioGMPETS07_INS.execute();

		// recuperando resultado...
		numeroIdentificadorTasacion = servicioGMPETS07_INS.getNumeroIdentificadorDeTasacionlnuita2();

		return numeroIdentificadorTasacion;
	}

	public GMPETS07_INS resultadoSolicitarTasacion() {
		return servicioGMPETS07_INS;
	}

	
	
	
	
	/**
	 * Devuelve los clientes Ursus a partir de los datos pasados por parámetro
	 * 
	 * @param nDocumento: documento identificativo del cliente a consultar
	 * @param tipoDocumento:Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	@Override
	public Integer obtenerNumClienteUrsus(String nDocumento, String tipoDocumento, String qcenre)  throws WIException{
		logger.info("------------ LLAMADA WS NUMCLIENTE  -----------------");
		
		Integer numcliente = ejecutarNumCliente(nDocumento, tipoDocumento, qcenre);
		
		//GMPAJC11_INS
		
		return numcliente;
		
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Devuelve los datos de un cliente Ursus a partir de los datos pasados por parámetro
	 * 
	 * @param nDocumento: documento identificativo del cliente a consultar
	 * @param tipoDocumento:Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	@Override
	public GMPAJC93_INS obtenerDatosClienteUrsus(String nDocumento, String tipoDocumento, String qcenre)  throws WIException{
		logger.info("------------ LLAMADA WS NUMCLIENTE Y DATOSCLIENTE -----------------");
		
		Integer numcliente = null;
		GMPAJC93_INS datosClienteIns = null;
		
		numcliente = ejecutarNumCliente(nDocumento, tipoDocumento, qcenre);
		
		if(!Checks.esNulo(numcliente)){
			datosClienteIns = ejecutarDatosCliente(numcliente, qcenre);
			
		}
		
		return datosClienteIns;
		
	}
	

	
	
	
	/**
	 * Invoca al servicio GMPAJC11_INS de BANKIA para solicitar los datos de un cliente
	 * 
	 * @param nudnio
	 * @param cocldo
	 * @param qcenre
	 * @return
	 */
	@Override
	public Integer ejecutarNumCliente(String nDocumento, String tipoDocumento, String qcenre) throws WIException {

		logger.info("------------ LLAMADA WS NUMCLIENTE -----------------");
		StructGMPAJC11_INS_NumeroDeOcurrenciasnumocu struct = null;
		Integer numCliente = null;
				
		leerConfiguracion();
		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);

		// instanciamos el servicio
		servicioGMPAJC11_INS = new GMPAJC11_INS();

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraTecnica cabeceraTecnica = new StructCabeceraTecnica();
		StructCabeceraAplicacionGMPAJC11_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPAJC11_INS();
		
		cabeceraFuncional.setIDDSAQ("CLDC");
		cabeceraFuncional.setCOFRAQ("168"); 
		cabeceraFuncional.setCOSFAQ("00");
		cabeceraFuncional.setCOAQAQ("AQ");	
		cabeceraFuncional.setCORPAQ("WW0071");
		cabeceraFuncional.setCLCDAQ("0370");
		cabeceraFuncional.setCOENAQ("0000");
		cabeceraFuncional.setCOCDAQ("0551");	
		cabeceraFuncional.setCOSBAQ("00");
		cabeceraFuncional.setNUPUAQ("00");
		cabeceraTecnica.setCLORAQ("71");
			
		//logueamos parametros cabecera
		logger.info("\nParámetros NUMCLIENTE:");
		logger.info("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());
		logger.info("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		logger.info("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		logger.info("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		logger.info("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		logger.info("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		logger.info("COENAQ: " + cabeceraFuncional.getCOENAQ());
		logger.info("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		logger.info("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		logger.info("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		logger.info("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		
		System.out.println("\nParámetros NUMCLIENTE:");
		System.out.println("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());	
		System.out.println("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		System.out.println("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		System.out.println("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		System.out.println("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		System.out.println("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		System.out.println("COENAQ: " + cabeceraFuncional.getCOENAQ());
		System.out.println("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		System.out.println("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		System.out.println("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		System.out.println("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		
		
		
		// Seteamos cabeceras
		servicioGMPAJC11_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPAJC11_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPAJC11_INS.setcabeceraTecnica(cabeceraTecnica);

		// seteamos parametros
		servicioGMPAJC11_INS.setCodigoObjetoAccesocopace("CACL0000");
		servicioGMPAJC11_INS.setClaseDeDocumentoIdentificadorcocldo(tipoDocumento.charAt(0));
		servicioGMPAJC11_INS.setDniNifDelTitularDeLaOfertanudnio(nDocumento);
		servicioGMPAJC11_INS.setnumeroCliente(0);
		servicioGMPAJC11_INS.setnumeroUsuario("");
		HttpServletRequest request = null;
		if (RequestContextHolder.getRequestAttributes() != null) {
			request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		}
		servicioGMPAJC11_INS.setidSesionWL(request != null ? request.getSession().getId() : "");
		servicioGMPAJC11_INS.setIdentificadorClienteOfertaidclow(0);// <----?????????
		servicioGMPAJC11_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

		
		
		
		//logueamos parametros enviados
		logger.info("CodigoObjetoAccesocopace: " + servicioGMPAJC11_INS.getCodigoObjetoAccesocopace());
		logger.info("ClaseDeDocumentoIdentificadorcocldo: " + servicioGMPAJC11_INS.getClaseDeDocumentoIdentificadorcocldo());
		logger.info("DniNifDelTitularDeLaOfertanudnio: " + servicioGMPAJC11_INS.getDniNifDelTitularDeLaOfertanudnio());
		logger.info("NumeroCliente: " + servicioGMPAJC11_INS.getnumeroCliente());
		logger.info("NumeroUsuario: " + servicioGMPAJC11_INS.getnumeroUsuario());
		logger.info("idSesionWL: " + servicioGMPAJC11_INS.getidSesionWL());
		logger.info("IdentificadorClienteOfertaidclow: " + servicioGMPAJC11_INS.getIdentificadorClienteOfertaidclow());
		logger.info("CodEntidadRepresntClienteUrsusqcenre: " + servicioGMPAJC11_INS.getCodEntidadRepresntClienteUrsusqcenre());
		
		System.out.println("CodigoObjetoAccesocopace: " + servicioGMPAJC11_INS.getCodigoObjetoAccesocopace());
		System.out.println("ClaseDeDocumentoIdentificadorcocldo: " + servicioGMPAJC11_INS.getClaseDeDocumentoIdentificadorcocldo());
		System.out.println("DniNifDelTitularDeLaOfertanudnio: " + servicioGMPAJC11_INS.getDniNifDelTitularDeLaOfertanudnio());
		System.out.println("NumeroCliente: " + servicioGMPAJC11_INS.getnumeroCliente());
		System.out.println("NumeroUsuario: " + servicioGMPAJC11_INS.getnumeroUsuario());
		System.out.println("idSesionWL: " + servicioGMPAJC11_INS.getidSesionWL());
		System.out.println("IdentificadorClienteOfertaidclow: " + servicioGMPAJC11_INS.getIdentificadorClienteOfertaidclow());
		System.out.println("CodEntidadRepresntClienteUrsusqcenre: " + servicioGMPAJC11_INS.getCodEntidadRepresntClienteUrsusqcenre());

		
		servicioGMPAJC11_INS.setAlias(ALIAS);
		servicioGMPAJC11_INS.execute();
		
		
			
		if(servicioGMPAJC11_INS.getIndicadorDePaginacionindipg() =='0'){
			struct = servicioGMPAJC11_INS.getNumeroDeOcurrenciasnumocu().getStructGMPAJC11_INS_NumeroDeOcurrenciasnumocuAt(0);
		}else{
			struct = servicioGMPAJC11_INS.getNumeroDeOcurrenciasnumocu().getStructGMPAJC11_INS_NumeroDeOcurrenciasnumocuAt(servicioGMPAJC11_INS.getNumeroDeOcurrenciasnumocu().size());
		}
		
		
		//logueamos la respuesta
		logger.info("\nRespuesta NUMCLIENTE:");	
		System.out.println("\nRespuesta NUMCLIENTE:");
		
		if(!Checks.esNulo(struct)){
			logger.info("DniNifDelTitularDeLaOfertanudnio2: " + struct.getDniNifDelTitularDeLaOfertanudnio2());	
			logger.info("ClaseDeDocumentoIdentificadorcocldo2: " + struct.getClaseDeDocumentoIdentificadorcocldo2());	
			logger.info("NombreYApellidosTitularDeOfertanotiof: " + struct.getNombreYApellidosTitularDeOfertanotiof());	
			logger.info("IdentificadorClienteOfertaidclow2: " + struct.getIdentificadorClienteOfertaidclow2());	

			System.out.println("DniNifDelTitularDeLaOfertanudnio2: " + struct.getDniNifDelTitularDeLaOfertanudnio2());	
			System.out.println("ClaseDeDocumentoIdentificadorcocldo2: " + struct.getClaseDeDocumentoIdentificadorcocldo2());	
			System.out.println("NombreYApellidosTitularDeOfertanotiof: " + struct.getNombreYApellidosTitularDeOfertanotiof());	
			System.out.println("IdentificadorClienteOfertaidclow2: " + struct.getIdentificadorClienteOfertaidclow2());	
		}

		
		if(!Checks.esNulo(struct) && !Checks.esNulo(struct.getIdentificadorClienteOfertaidclow2())){
			numCliente = Integer.valueOf(struct.getIdentificadorClienteOfertaidclow2());
		}

		return numCliente;

	}

	
	
	

	
	
	
	/**
	 * Invoca al servicio GMPAJC93_INS de BANKIA para obtener un cliente a partir de un clienteUrsus
	 * 
	 * @param numclienteIns
	 * @param qcenre
	 * @return
	 */
	@Override
	public GMPAJC93_INS ejecutarDatosCliente(Integer numcliente, String qcenre) throws WIException {
		logger.info("------------ LLAMADA WS DATOSCLIENTE -----------------");
		
		leerConfiguracion();
		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);

		// instanciamos el servicio
		servicioGMPAJC93_INS = new GMPAJC93_INS();

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraTecnica();
		StructCabeceraAplicacionGMPAJC93_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPAJC93_INS();
		
		cabeceraFuncional.setIDDSAQ("CONS");
		cabeceraFuncional.setCOFRAQ("168"); 
		cabeceraFuncional.setCOSFAQ("00");
		cabeceraFuncional.setCOAQAQ("AQ");
		cabeceraFuncional.setCORPAQ("WW0071");
		cabeceraFuncional.setCLCDAQ("0370");
		cabeceraFuncional.setCOENAQ("0000");
		cabeceraFuncional.setCOCDAQ("0551");
		cabeceraFuncional.setCOSBAQ("00");
		cabeceraFuncional.setNUPUAQ("00");
		cabeceraTecnica.setCLORAQ("71");
		
		//logueamos parametros cabecera
		logger.info("\nParámetros DATOSCLIENTE:");
		logger.info("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());
		logger.info("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		logger.info("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		logger.info("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		logger.info("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		logger.info("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		logger.info("COENAQ: " + cabeceraFuncional.getCOENAQ());
		logger.info("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		logger.info("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		logger.info("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		logger.info("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		
		System.out.println("\nParámetros DATOSCLIENTE:");
		System.out.println("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());	
		System.out.println("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		System.out.println("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		System.out.println("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		System.out.println("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		System.out.println("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		System.out.println("COENAQ: " + cabeceraFuncional.getCOENAQ());
		System.out.println("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		System.out.println("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		System.out.println("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		System.out.println("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		
		
		
		
		// Seteamos cabeceras
		servicioGMPAJC93_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPAJC93_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPAJC93_INS.setcabeceraTecnica(cabeceraTecnica);

		// seteamos parametros
		servicioGMPAJC93_INS.setCodigoObjetoAccesocopace("CACL0000");
		servicioGMPAJC93_INS.setIdentificadorClienteOfertaidclow(numcliente);//<--------?????
		servicioGMPAJC93_INS.setnumeroUsuario("");//<--------????? Nos lo piden obligatorio
		servicioGMPAJC93_INS.setidSesionWL("");//<--------????? Nos lo piden obligatorio
		servicioGMPAJC93_INS.setnumeroCliente(0);
		servicioGMPAJC93_INS.setIdentificadorDiscriminadorFuncioniddsfu("DF01");
		servicioGMPAJC93_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

		
		
		
		
		//logueamos parametros enviados
		logger.info("CodigoObjetoAccesocopace: " + servicioGMPAJC93_INS.getCodigoObjetoAccesocopace());
		logger.info("IdentificadorClienteOfertaidclow: " + servicioGMPAJC93_INS.getIdentificadorClienteOfertaidclow());
		logger.info("NumeroUsuario: " + servicioGMPAJC93_INS.getnumeroUsuario());
		logger.info("IdSesionWL: " + servicioGMPAJC93_INS.getidSesionWL());
		logger.info("NumeroCliente: " + servicioGMPAJC93_INS.getnumeroCliente());
		logger.info("IdentificadorDiscriminadorFuncioniddsfu: " + servicioGMPAJC93_INS.getIdentificadorDiscriminadorFuncioniddsfu());
		logger.info("CodEntidadRepresntClienteUrsusqcenre: "+ servicioGMPAJC93_INS.getCodEntidadRepresntClienteUrsusqcenre());
		
		System.out.println("CodigoObjetoAccesocopace: " + servicioGMPAJC93_INS.getCodigoObjetoAccesocopace());
		System.out.println("IdentificadorClienteOfertaidclow: " + servicioGMPAJC93_INS.getIdentificadorClienteOfertaidclow());
		System.out.println("NumeroUsuario: " + servicioGMPAJC93_INS.getnumeroUsuario());
		System.out.println("IdSesionWL: " + servicioGMPAJC93_INS.getidSesionWL());
		System.out.println("NumeroCliente: " + servicioGMPAJC93_INS.getnumeroCliente());
		System.out.println("IdentificadorDiscriminadorFuncioniddsfu: " + servicioGMPAJC93_INS.getIdentificadorDiscriminadorFuncioniddsfu());
		System.out.println("CodEntidadRepresntClienteUrsusqcenre: "+ servicioGMPAJC93_INS.getCodEntidadRepresntClienteUrsusqcenre());

		
		servicioGMPAJC93_INS.setAlias(ALIAS);
		servicioGMPAJC93_INS.execute();
		
		
		//logueamos la respuesta
		logger.info("\nRespuesta NUMCLIENTE:");	
		logger.info("getDniNifDelTitularDeLaOfertanudnio: " + servicioGMPAJC93_INS.getDniNifDelTitularDeLaOfertanudnio());	
		logger.info("getNombreYApellidosTitularnotio1: " + servicioGMPAJC93_INS.getNombreYApellidosTitularnotio1());	
		logger.info("getNombreYApellidosTitularDeOfertanotiof: " + servicioGMPAJC93_INS.getNombreYApellidosTitularDeOfertanotiof());	
		logger.info("getNombreDelClientenoclie: " + servicioGMPAJC93_INS.getNombreDelClientenoclie());	

		System.out.println("\nRespuesta NUMCLIENTE:");
		System.out.println("getDniNifDelTitularDeLaOfertanudnio: " + servicioGMPAJC93_INS.getDniNifDelTitularDeLaOfertanudnio());	
		System.out.println("getNombreYApellidosTitularnotio1: " + servicioGMPAJC93_INS.getNombreYApellidosTitularnotio1());	
		System.out.println("getNombreYApellidosTitularDeOfertanotiof: " + servicioGMPAJC93_INS.getNombreYApellidosTitularDeOfertanotiof());	
		System.out.println("getNombreDelClientenoclie: " + servicioGMPAJC93_INS.getNombreDelClientenoclie());	
		

		return servicioGMPAJC93_INS;

	}

	
	
	
	
	
	
	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para dar de alta un instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	@Override
	public GMPDJB13_INS altaInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws WIException {
		GMPDJB13_INS instancia = null;
		instancia = instanciaDecision(instanciaDecisionDto, "ALTA");
		return instancia;
	}

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para consultar una instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	@Override
	public GMPDJB13_INS consultarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws WIException {
		GMPDJB13_INS instancia = null;
		instancia = instanciaDecision(instanciaDecisionDto, "CONS");
		return instancia;
	}

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para modificar una instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	@Override
	public GMPDJB13_INS modificarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws WIException {
		GMPDJB13_INS instancia = null;
		instancia = instanciaDecision(instanciaDecisionDto, "MODI");
		return instancia;
	}

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para realizar la accion pasada por parametros sobre una instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @param accion: ALTA/CONS/MODI
	 * @return
	 */
	public GMPDJB13_INS instanciaDecision(InstanciaDecisionDto instanciaDecisionDto, String accion) throws WIException {

		VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu numeroOcurrencias = new VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu();
		StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu struct = new StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu();

		// IdentificadorActivoEspecial
		if (instanciaDecisionDto.getIdentificadorActivoEspecial() != null) {
			struct.setIdentificadorActivoEspecialcoacew(instanciaDecisionDto.getIdentificadorActivoEspecial());
		}

		// ImporteMonetarioOfertaBISA
		if (instanciaDecisionDto.getImporteConSigno() == null) {
			throw new WIException("El importe con signo no puede estar vacio.");
		} else {
			ImporteMonetario importeMonetario = new ImporteMonetario();
			importeMonetario.setImporteConSigno(instanciaDecisionDto.getImporteConSigno());
			es.cajamadrid.servicios.ARQ.Moneda moneda = new es.cajamadrid.servicios.ARQ.Moneda();
			moneda.setDivisa("D");
			moneda.setDigitoControlDivisa('-');
			importeMonetario.setMonedaBISA(moneda);
			importeMonetario.setNumeroDecimalesImporte('-');
			struct.setImporteMonetarioOfertaBISA(importeMonetario);
		}

		// TipoDeImpuesto
		struct.setTipoDeImpuestocotimw(instanciaDecisionDto.getTipoDeImpuesto());

		// PorcentajeImpuestoBISA
		Porcentaje9 porcentajeImpuesto = null;
		porcentajeImpuesto = new Porcentaje9();
		if (instanciaDecisionDto.getTipoDeImpuesto() == instanciaDecisionDto.TIPO_IMPUESTO_IVA) {
			porcentajeImpuesto.setPorcentaje(21);
		} else {
			porcentajeImpuesto.setPorcentaje(0);
		}
		porcentajeImpuesto.setNumDecimales("BC");
		struct.setPorcentajeImpuestoBISA(porcentajeImpuesto);

		// IndicadorTratamientoImpuesto
		struct.setIndicadorTratamientoImpuestobitrim('A'); // 'A' or 'B' or '\'
															// or '-'
															// <----?????????

		// Aunque es un array solo usamos el 1er campo
		numeroOcurrencias.setStructGMPDJB13_INS_NumeroDeOcurrenciasnumocu(struct);

		logger.info("------------ LLAMADA WS INSTANCIADECISION (" + accion + ") -----------------");
		leerConfiguracion();
		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraFuncionalPeticion();		
		es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraTecnica();
		StructCabeceraAplicacionGMPDJB13_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPDJB13_INS();

		servicioGMPDJB13_INS = new GMPDJB13_INS();		
		
		// Seteamos cabeceras
		servicioGMPDJB13_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPDJB13_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPDJB13_INS.setcabeceraTecnica(cabeceraTecnica);
		
		cabeceraFuncional.setIDDSAQ(accion);
		cabeceraFuncional.setCOFRAQ("168"); 
		cabeceraFuncional.setCOSFAQ("00");
		cabeceraFuncional.setCOAQAQ("AQ");
		cabeceraFuncional.setCORPAQ("WW0071");
		cabeceraFuncional.setCLCDAQ("0370");
		cabeceraFuncional.setCOENAQ("0000");
		cabeceraFuncional.setCOCDAQ("0551");
		cabeceraFuncional.setCOSBAQ("00");
		cabeceraFuncional.setNUPUAQ("00");
		cabeceraTecnica.setCLORAQ("71");
		
		//logueamos parametros cabecera
		logger.info("\nParámetros INSTANCIADECISION:");
		logger.info("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());
		logger.info("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		logger.info("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		logger.info("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		logger.info("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		logger.info("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		logger.info("COENAQ: " + cabeceraFuncional.getCOENAQ());
		logger.info("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		logger.info("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		logger.info("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		logger.info("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		
		System.out.println("\nParámetros INSTANCIADECISION:");
		System.out.println("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());	
		System.out.println("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		System.out.println("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		System.out.println("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		System.out.println("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		System.out.println("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		System.out.println("COENAQ: " + cabeceraFuncional.getCOENAQ());
		System.out.println("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		System.out.println("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		System.out.println("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		System.out.println("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		


		// seteamos parametros
		servicioGMPDJB13_INS.setCodigoObjetoAccesocopace("PRAC0170");
		servicioGMPDJB13_INS.setCodigoDeOfertaHayacoofhx(instanciaDecisionDto.getCodigoDeOfertaHaya());
		if (instanciaDecisionDto.isFinanciacionCliente()) {
			servicioGMPDJB13_INS.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_SI);
		} else {
			servicioGMPDJB13_INS.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_NO);
		}
		if (instanciaDecisionDto.isFinanciacionCliente()) {		
			servicioGMPDJB13_INS.setTipoPropuestacotprw(instanciaDecisionDto.PROPUESTA_VENTA);
		} else {
			servicioGMPDJB13_INS.setTipoPropuestacotprw(instanciaDecisionDto.PROPUESTA_CONTRAOFERTA);
		}
		
		if (numeroOcurrencias!=null) {			
			servicioGMPDJB13_INS.setNumeroDeOcurrenciasnumocu(numeroOcurrencias);
		}
		// Requeridos por el servicio
		servicioGMPDJB13_INS.setnumeroCliente(0);
		servicioGMPDJB13_INS.setnumeroUsuario("");
		servicioGMPDJB13_INS.setidSesionWL("");

		//logueamos parametros enviados
		logger.info("CodigoObjetoAccesocopace: " + servicioGMPDJB13_INS.getCodigoObjetoAccesocopace());
		logger.info("CodigoDeOfertaHayacoofhx: " + servicioGMPDJB13_INS.getCodigoDeOfertaHayacoofhx());
		logger.info("IndicadorDeFinanciacionClientebificl: " + servicioGMPDJB13_INS.getIndicadorDeFinanciacionClientebificl());
		logger.info("TipoPropuestacotprw: " + servicioGMPDJB13_INS.getTipoPropuestacotprw());
		logger.info("NumeroDeOcurrenciasnumocu :" + servicioGMPDJB13_INS.getNumeroDeOcurrenciasnumocu());
		logger.info("NumeroCliente: " + servicioGMPDJB13_INS.getnumeroCliente());
		logger.info("NumeroUsuario: " + servicioGMPDJB13_INS.getnumeroUsuario());
		logger.info("IdSesionWL: " + servicioGMPDJB13_INS.getidSesionWL());
		
		System.out.println("CodigoObjetoAccesocopace: " + servicioGMPDJB13_INS.getCodigoObjetoAccesocopace());
		System.out.println("CodigoDeOfertaHayacoofhx: " + servicioGMPDJB13_INS.getCodigoDeOfertaHayacoofhx());
		System.out.println("IndicadorDeFinanciacionClientebificl: " + servicioGMPDJB13_INS.getIndicadorDeFinanciacionClientebificl());
		System.out.println("TipoPropuestacotprw: " + servicioGMPDJB13_INS.getTipoPropuestacotprw());
		System.out.println("NumeroDeOcurrenciasnumocu :" + servicioGMPDJB13_INS.getNumeroDeOcurrenciasnumocu());
		System.out.println("NumeroCliente: " + servicioGMPDJB13_INS.getnumeroCliente());
		System.out.println("NumeroUsuario: " + servicioGMPDJB13_INS.getnumeroUsuario());
		System.out.println("IdSesionWL: " + servicioGMPDJB13_INS.getidSesionWL());
		
		
		servicioGMPDJB13_INS.setAlias(ALIAS);
		servicioGMPDJB13_INS.execute();

		return servicioGMPDJB13_INS;
	}
	
	
	


	
	/**
	 * Invoca al servicio GMPAJC34_INS de BANKIA para consultar los datos de un prestamo
	 * 
	 * @param numExpedienteRiesgo
	 * @param tipoRiesgo
	 * @return
	 */
	@Override
	public GMPAJC34_INS consultaDatosPrestamo(String numExpedienteRiesgo, int tipoRiesgo) throws WIException {
		
		logger.info("------------ LLAMADA WS ConsultaDatosPrestamo -----------------");
		leerConfiguracion();
		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);

		// instanciamos el servicio
		servicioGMPAJC34_INS = new GMPAJC34_INS();

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPAJC34_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPAJC34_INS.StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPAJC34_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPAJC34_INS.StructCabeceraTecnica();
		StructCabeceraAplicacionGMPAJC34_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPAJC34_INS();

		// Seteamos cabeceras
		servicioGMPAJC34_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPAJC34_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPAJC34_INS.setcabeceraTecnica(cabeceraTecnica);
		
		cabeceraFuncional.setIDDSAQ("CONX");
		cabeceraFuncional.setCOFRAQ("168"); 
		cabeceraFuncional.setCOSFAQ("00");
		cabeceraFuncional.setCOAQAQ("AQ");
		cabeceraFuncional.setCORPAQ("WW0071");
		cabeceraFuncional.setCLCDAQ("0370");
		cabeceraFuncional.setCOENAQ("0000");
		cabeceraFuncional.setCOCDAQ("0551");
		cabeceraFuncional.setCOSBAQ("00");
		cabeceraFuncional.setNUPUAQ("00");
		cabeceraTecnica.setCLORAQ("71");
		
		//logueamos parametros cabecera
		logger.info("\nParámetros INSTANCIADECISION:");
		logger.info("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());
		logger.info("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		logger.info("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		logger.info("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		logger.info("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		logger.info("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		logger.info("COENAQ: " + cabeceraFuncional.getCOENAQ());
		logger.info("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		logger.info("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		logger.info("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		logger.info("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		
		System.out.println("\nParámetros INSTANCIADECISION:");
		System.out.println("IDDSAQ: " + cabeceraFuncional.getIDDSAQ());	
		System.out.println("COFRAQ: " + cabeceraFuncional.getCOFRAQ());
		System.out.println("COSFAQ: " + cabeceraFuncional.getCOSFAQ());
		System.out.println("COAQAQ: " + cabeceraFuncional.getCOAQAQ());
		System.out.println("CORPAQ: " + cabeceraFuncional.getCORPAQ());
		System.out.println("CLCDAQ: " + cabeceraFuncional.getCLCDAQ());
		System.out.println("COENAQ: " + cabeceraFuncional.getCOENAQ());
		System.out.println("COCDAQ: " + cabeceraFuncional.getCOCDAQ());
		System.out.println("COSBAQ: " + cabeceraFuncional.getCOSBAQ());
		System.out.println("NUPUAQ: " + cabeceraFuncional.getNUPUAQ());
		System.out.println("CLORAQ: " + cabeceraTecnica.getCLORAQ());
		
		
		
		
		// seteamos parametros
		servicioGMPAJC34_INS.setCodigoObjetoAccesocopace("CACL0000");
		servicioGMPAJC34_INS.setNumeroExpedienteDeRiesgoNumericonuidow(numExpedienteRiesgo);	
		servicioGMPAJC34_INS.setTipoRiesgoClaseProductoUrsusCotirx(tipoRiesgo);
		
		
		
		
		
		//logueamos parametros entrada
		logger.info("CodigoObjetoAccesocopace: " + servicioGMPAJC34_INS.getCodigoObjetoAccesocopace());
		logger.info("NumeroExpedienteDeRiesgoNumericonuidow: "+ servicioGMPAJC34_INS.getNumeroExpedienteDeRiesgoNumericonuidow());
		logger.info("TipoRiesgoClaseProductoUrsusCotirx: "+ servicioGMPAJC34_INS.getTipoRiesgoClaseProductoUrsusCotirx());
		
		System.out.println("CodigoObjetoAccesocopace: " + servicioGMPAJC34_INS.getCodigoObjetoAccesocopace());
		System.out.println("NumeroExpedienteDeRiesgoNumericonuidow: "+ servicioGMPAJC34_INS.getNumeroExpedienteDeRiesgoNumericonuidow());
		System.out.println("TipoRiesgoClaseProductoUrsusCotirx: "+ servicioGMPAJC34_INS.getTipoRiesgoClaseProductoUrsusCotirx());
		
		
		servicioGMPAJC34_INS.setAlias(ALIAS);
		servicioGMPAJC34_INS.execute();
		
		return servicioGMPAJC34_INS;
		
	}
	

}
