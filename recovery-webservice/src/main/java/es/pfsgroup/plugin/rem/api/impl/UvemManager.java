package es.pfsgroup.plugin.rem.api.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import es.cajamadrid.servicios.GM.GMPAJC29_INS.GMPAJC29_INS;
import es.cajamadrid.servicios.GM.GMPAJC29_INS.StructCabeceraAplicacionGMPAJC29_INS;
import es.cajamadrid.servicios.GM.GMPAJC34_INS.GMPAJC34_INS;
import es.cajamadrid.servicios.GM.GMPAJC34_INS.StructCabeceraAplicacionGMPAJC34_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraAplicacionGMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.StructGMPAJC93_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.VectorGMPAJC93_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.GMPDJB13_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraAplicacionGMPDJB13_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.StructGMPDJB13_INS_NumeroDeOcurrenciasnumocx;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocx;
import es.cajamadrid.servicios.GM.GMPETS07_INS.GMPETS07_INS;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructCabeceraAplicacionGMPETS07_INS;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructGMPETS07_INS_NumeroDeOcurrenciasnumog1;
import es.cajamadrid.servicios.GM.GMPETS07_INS.StructGMPETS07_INS_NumeroDeOcurrenciasnumogt;
import es.cajamadrid.servicios.GM.GMPETS07_INS.VectorGMPETS07_INS_NumeroDeOcurrenciasnumog1;
import es.cajamadrid.servicios.GM.GMPETS07_INS.VectorGMPETS07_INS_NumeroDeOcurrenciasnumogt;
import es.cajamadrid.servicios.GM.GMPTOE83_INS.GMPTOE83_INS;
import es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraAplicacionGMPTOE83_INS;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.cm.arq.tda.tiposdedatosbase.CantidadDecimal15;
import es.cm.arq.tda.tiposdedatosbase.Fecha;
import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.impl.UpdaterServiceSancionOfertaInstruccionesReserva;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.impl.UpdaterServiceSancionOfertaResultadoPBC;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.rest.dto.ClienteUrsusRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteProblemasVentaDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularDto;
import es.pfsgroup.plugin.rem.rest.dto.WSDevolBankiaDto;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;

@Service("uvemManager")
public class UvemManager implements UvemManagerApi {

	private final Log logger = LogFactory.getLog(getClass());

	private static final String INSTANCIA_DECISION_ALTA = "ALTA";
	private static final String INSTANCIA_DECISION_CONSULTA = "CONS";
	private static final String INSTANCIA_DECISION_MODIFICACION = "MODI";
	private static final String COCGUS = "0562";
	private static final String INSTANCIA_DECISION_MODIFICACION_3 = "MOD3";

	private static final String ERROR_UVEM_OFERTA_YA_ANULADA = "YA ESTA ANULADA";
	
	private String URL = "";
	private String ALIAS = "";

	//Códigos COTLAV - 8 caracteres
	private static final String COTLAV_CLVAAPCO = "CLVAAPCO";
	private static final String COTLAV_CLCDC4   = "CLCDC4";
	private static final String COTLAV_CLCDB4   = "CLCDB4";
	
	//Códigos COMEAV - 8 caracteres
	private static final String COMEAV_0413 = "0413";
	private static final String COMEAV_0414 = "0414";
	private static final String COMEAV_80   = "80";
	
	//Códigos LIAVI1 para construir ejemplos - 80 caracteres
	private static final String LIAVI1_CLVAAPCO_CL00024E = "Cliente en situación de bloqueo.                                                ";
	private static final String LIAVI1_CLVAAPCO_CL00027E = "Cliente carece de documento fiscal válido y producto.                           ";
	private static final String LIAVI1_CLVAAPCO_CL00108E = "Cliente bloqueado debe justificar actividad.                                    ";
	private static final String LIAVI1_CLCDC4_0414 	  = "Cliente precaución operativa blanqueo capitales (Cancelar).                     ";
	private static final String LIAVI1_CLCDB4_80		  = "Cliente bloqueado                                                               ";
	
	private final Random RANDOM = new Random();
	
	private GMPETS07_INS servicioGMPETS07_INS;

	private GMPAJC93_INS servicioGMPAJC93_INS;

	private GMPAJC11_INS servicioGMPAJC11_INS;

	// O-RB-PTMO – servicio GMPAJC34
	private GMPAJC34_INS servicioGMPAJC34_INS;

	// O-RB-FFDD - servicio GMPDJB13
	private GMPDJB13_INS servicioGMPDJB13_INS;

	// 10. O-RB-DEVOL - servicio GMOE83
	private GMPTOE83_INS servicioGMPTOE83_INS;

	// 11. 11. O-RB-ANULOF
	private GMPAJC29_INS servicioGMPAJC29_INS;

	@Resource
	private Properties appProperties;

	@Autowired
	private RestLlamadaDao llamadaDao;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private LogTrustWebService trustMe;
	

	private static final int MASK = (-1) >>> 1; // all ones except the sign bit

	private void iniciarServicio() throws WIException {
		this.URL = !Checks.esNulo(appProperties.getProperty("rest.client.uvem.url.base"))
				? appProperties.getProperty("rest.client.uvem.url.base") : "";
		this.ALIAS = !Checks.esNulo(appProperties.getProperty("rest.client.uvem.alias.integrador"))
				? appProperties.getProperty("rest.client.uvem.alias.integrador") : "";

		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);
	}

	private void registrarLlamada(WIService servicio, String errorDesc) {
		String llamada = "";
		String respuesta = "";
		try {
			llamada = servicio.getInParams().toXMLGeneric(true);
			respuesta = servicio.getOutParams().toXMLGeneric(true);
		} catch (Exception e) {
			logger.info("Error obteniendo los datos del ws", e);
		}
		this.registrarLlamada(servicio.getClass().getName(), llamada, respuesta, errorDesc);
	}

	private void registrarLlamada(String endPoint, String request, String result, String errorDesc) {
		RestLlamada registro = new RestLlamada();
		registro.setMetodo("WEBSERVICE");
		registro.setEndpoint(endPoint);
		registro.setRequest(request);
		logger.debug(request);
		logger.debug("-------------------");
		logger.debug(result);
		if (!Checks.esNulo(errorDesc)) {
			registro.setErrorDesc(errorDesc);
		}
		try {
			registro.setResponse(result);
			llamadaDao.guardaRegistro(registro);
			trustMe.registrarLlamadaServicioWeb(registro);
		} catch (Exception e) {
			logger.error("Error al trazar la llamada al WS", e);
		}
	}

	/**
	 * Ejecuta un servicio dado
	 * 
	 * @param servicio
	 * @return
	 * @throws WIException
	 */
	private WIService executeService(WIService servicio) throws WIException {

		boolean activo = !Checks.esNulo(appProperties.getProperty("rest.client.uvem.activo"))
				? Boolean.valueOf(appProperties.getProperty("rest.client.uvem.activo")) : false;
		if (activo && !Checks.esNulo(this.URL) && !Checks.esNulo(this.ALIAS)) {
			servicio.execute();
		} else {
			logger.error("UVEM: Servicios desactividos");
			
			if (servicio instanceof GMPETS07_INS) {
				((GMPETS07_INS) servicio).setNumeroIdentificadorDeTasacionlnuita2(this.RANDOM.nextInt() & MASK);
			} else if (servicio instanceof GMPAJC11_INS) {
				VectorGMPAJC11_INS_NumeroDeOcurrenciasnumocu vector = new VectorGMPAJC11_INS_NumeroDeOcurrenciasnumocu();
				StructGMPAJC11_INS_NumeroDeOcurrenciasnumocu struct = new StructGMPAJC11_INS_NumeroDeOcurrenciasnumocu();
				struct.setIdentificadorClienteOfertaidclow2(this.RANDOM.nextInt() & MASK);
				struct.setDniNifDelTitularDeLaOfertanudnio2("00000000X");
				struct.setNombreYApellidosTitularDeOfertanotiof("Dummy Dummy Dummy");
				vector.add(struct);

				((GMPAJC11_INS) servicio).setNumeroDeOcurrenciasnumocu(vector);

			} else if (servicio instanceof GMPAJC93_INS) {
				((GMPAJC93_INS) servicio).setClaseDeDocumentoIdentificadorcocldo('1');
				((GMPAJC93_INS) servicio).setDniNifDelTitularDeLaOfertanudnio("00000000X");
				((GMPAJC93_INS) servicio).setNombreYApellidosTitularDeOfertanotiof("Dummy Dummy Dummy");
				((GMPAJC93_INS) servicio).setNombreDelClientenoclie("Dummy");
				((GMPAJC93_INS) servicio).setPrimerApellidonoape1("Dummy");
				((GMPAJC93_INS) servicio).setSegundoApellidonoape2("Dummy");
				((GMPAJC93_INS) servicio).setCodigoTipoDeViacotivw((short) 1);
				((GMPAJC93_INS) servicio).setDenominacionTipoDeViaTrabajoNotiv1("cl");
				((GMPAJC93_INS) servicio).setNombreDeLaVianovisa("dummy");
				//Ejemplo Grid para Problemas con la venta en Cliente Ursus:
				//Rellenaremos 'iter' ocurrencias (estructuras) de un máximo de 10 para almacenarlas en el vector VectorGMPAJC93_INS_NumeroDeOcurrenciasnumocu.
				Short iter = 2;
				((GMPAJC93_INS) servicio).setNumeroDeOcurrenciasDeAvisonuocav(iter);
				VectorGMPAJC93_INS_NumeroDeOcurrenciasnumocu vector = new VectorGMPAJC93_INS_NumeroDeOcurrenciasnumocu();
				StructGMPAJC93_INS_NumeroDeOcurrenciasnumocu estructura = new StructGMPAJC93_INS_NumeroDeOcurrenciasnumocu();
				//Cada estructura llevará un código cotlav, un código comeav y un liavi1 correspondiente con los dos primeros:
				String[] cod_cotlav = {COTLAV_CLVAAPCO,          COTLAV_CLVAAPCO,          COTLAV_CLVAAPCO,          COTLAV_CLCDC4,      COTLAV_CLCDB4};
				String[] cod_comeav = {"CL00024E",               "CL00027E",               "CL00108E",               COMEAV_0413,        COMEAV_80};
				String[] cod_liavi1 = {LIAVI1_CLVAAPCO_CL00024E, LIAVI1_CLVAAPCO_CL00027E, LIAVI1_CLVAAPCO_CL00108E, LIAVI1_CLCDC4_0414, LIAVI1_CLCDB4_80};
				//Rellenamos el vector de estructuras
				int i = 0;
				for(i=0; i<iter; i++) {
					estructura.setCodigoDeServiciocotlav(cod_cotlav[i]);
					estructura.setCodigoMensajeDeErrorcomeav(cod_comeav[i]);
					estructura.setLiteralAvisoEnPantallaliavi1(cod_liavi1[i]);
					vector.add(estructura);
				}
				
				//Lo almacenamos en el servicio para hacer pruebas:
				((GMPAJC93_INS) servicio).setNumeroDeOcurrenciasnumocu(vector);
				((GMPAJC93_INS) servicio).setCodigoEstadoCivilcoesci('2');
				((GMPAJC93_INS) servicio).setIdentClienteConyugeOfertaidclww(800830277);
				((GMPAJC93_INS) servicio).setNombreYApellidosTitularnotio1("Ana Checa Soler");

			} else if (servicio instanceof GMPDJB13_INS) {
				((GMPDJB13_INS) servicio).setLongitudMensajeDeSalidarcslon(2);
				((GMPDJB13_INS) servicio).setCodigoComitecocom7(Short.valueOf(DDComiteSancion.CODIGO_PLATAFORMA));
				((GMPDJB13_INS) servicio).setCodigoDeOfertaHayacoofhx2("9");
				if (((GMPDJB13_INS) servicio).getCodigoDeAgrupacionDeInmueblecoagiw() > 0) {
					((GMPDJB13_INS) servicio).setCodigoDeAgrupacionDeInmueblecoagiw2(
							((GMPDJB13_INS) servicio).getCodigoDeAgrupacionDeInmueblecoagiw());
				} else {
					((GMPDJB13_INS) servicio).setCodigoDeAgrupacionDeInmueblecoagiw2(this.RANDOM.nextInt() & MASK);
				}

			} else if (servicio instanceof GMPAJC34_INS) {
				ImporteMonetario importe = new ImporteMonetario();
				((GMPAJC34_INS) servicio).setImporteMonetarioConcedido(importe);
			}
		}
		return servicio;
	}
	

	/**
	 * Invoca al servicio GMPETS07_INS de BANKIA para solicitar una Tasación
	 * 
	 * @param numActivoUvem
	 * @param nombreGestor
	 * @param gestion
	 * @return
	 */
	public Integer ejecutarSolicitarTasacion(Long numActivoUvem, Usuario usuarioGestor) throws Exception {
		logger.info("------------ LLAMADA WS SOLICITAR TASACION -----------------");
		int numeroIdentificadorTasacion = -1;
		Integer numeroActivo = 0;
		String errorDesc = null;

		try {

			iniciarServicio();

			// instanciamos el servicio
			servicioGMPETS07_INS = new GMPETS07_INS();

			// Requeridos por el servicio
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
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);
			servicioGMPETS07_INS.setcabeceraAplicacion(cabeceraAplicacion);
			servicioGMPETS07_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMPETS07_INS.setcabeceraTecnica(cabeceraTecnica);

			servicioGMPETS07_INS.setNumeroIdentificadorDeTasacionlnuita(0000000000);
			String codigoUsuarioSolicitante = StringUtils.rightPad(usuarioGestor.getUsername(), 8, ' ').substring(0, 8);
			servicioGMPETS07_INS.setCodigoDeUsuariocousae(codigoUsuarioSolicitante);
			servicioGMPETS07_INS.setNumeroDeTarifalntari(0000000005);
			servicioGMPETS07_INS.setIndicadorDocumentacionindido(' ');
			servicioGMPETS07_INS.setCodigoTasadoracodtas('2');
			String nifcifProveedor = " A78029774";
			servicioGMPETS07_INS.setCifDniDelProvedornudnip(nifcifProveedor);
			servicioGMPETS07_INS
					.setCodigoNuevoTipoSubtipoDeInmueblcontsi(StringUtils.rightPad("", 4, ' ').substring(0, 4));
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

			String email = null;
			if (usuarioGestor.getEmail() != null) {
				email = usuarioGestor.getEmail();
			} else {
				email = !Checks.esNulo(appProperties.getProperty("agendaMultifuncion.mail.from"))
						? appProperties.getProperty("agendaMultifuncion.mail.from") : "";
			}
			servicioGMPETS07_INS.setNombrePersonaContacto1nomcc1(StringUtils.rightPad(email, 40, ' ').substring(0, 40));

			String telefono = null;
			if (usuarioGestor.getTelefono() != null) {
				telefono = usuarioGestor.getTelefono();
			} else {
				telefono = "";
			}
			servicioGMPETS07_INS.setNumeroDeTelefononutear(StringUtils.rightPad(telefono, 14, ' ').substring(0, 14));

			servicioGMPETS07_INS.setCodigoDeAccionConsultaModificcoacca(' ');
			servicioGMPETS07_INS.setCodigoPresupuestocoppre('1');
			servicioGMPETS07_INS.setFechaDeLaTasacionlfetas(0000000000);

			if (!Checks.esNulo(numActivoUvem)) {
				numeroActivo = numActivoUvem != null ? numActivoUvem.intValue() : null;
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
			executeService(servicioGMPETS07_INS);
			// recuperando resultado...
			numeroIdentificadorTasacion = servicioGMPETS07_INS.getNumeroIdentificadorDeTasacionlnuita2();

		} catch (WIMetaServiceException e) {
			errorDesc = e.getMessage();
			throw new JsonViewerException("Error solicitud tasaciones (UVEM): " + e.getMessage());
		} catch (WIException e) {
			errorDesc = e.getMessage();
			throw new JsonViewerException("Error solicitud tasaciones (UVEM): " + e.getMessage());
		} catch (TipoDeDatoException e) {
			errorDesc = e.getMessage();
			throw new JsonViewerException(e.getMessage());
		} finally {
			registrarLlamada(servicioGMPETS07_INS, errorDesc);
		}

		return numeroIdentificadorTasacion;
	}

	/**
	 * Invoca al servicio GMPAJC11_INS de BANKIA para solicitar los datos de un
	 * cliente
	 * 
	 * @param nDocumento
	 * @param tipoDocumento
	 *            1 D.N.I. 2 C.I.F. 3 Tarjeta Residente. 4 Pasaporte 5 C.I.F
	 *            país extranjero. 7 D.N.I país extranjero. 8 Tarj. identif.
	 *            diplomática 9 Menor. F Otros persona física. J Otros persona
	 *            jurídica.
	 *
	 * @param qcenre
	 * @return
	 */
	@Override
	public List<DatosClienteDto> ejecutarNumCliente(String nDocumento, String tipoDocumento, String qcenre)
			throws Exception {

		List<DatosClienteDto> listaClientes = null;
		List<DatosClienteDto> listaClientesFinal = new ArrayList<DatosClienteDto>();
		Boolean paginar = false;

		ClienteUrsusRequestDto clienteUrsusRequestDto = this.ejecutarNumCliente(nDocumento, tipoDocumento, qcenre, String.valueOf(0));

		if (!Checks.esNulo(clienteUrsusRequestDto) && !Checks.esNulo(clienteUrsusRequestDto.getData())) {
			listaClientes = clienteUrsusRequestDto.getData();
			// Añadimos los clientes de la primera llamada
			listaClientesFinal.addAll(listaClientes);

			if (!Checks.esNulo(clienteUrsusRequestDto.getIndicadorPaginacion())
					&& clienteUrsusRequestDto.getIndicadorPaginacion() > 0) {
				paginar = true;
			}

			while (paginar) {

				// Por defecto no paginamos para evitar bucles infinitos
				paginar = false;
				if (!Checks.esNulo(clienteUrsusRequestDto) && !Checks.esNulo(clienteUrsusRequestDto.getData())) {

					listaClientes = clienteUrsusRequestDto.getData();
					if (!Checks.esNulo(listaClientes) && !listaClientes.isEmpty()) {
						String ultimoNumCliente = listaClientes.get(listaClientes.size() - 1).getNumeroClienteUrsus();

						clienteUrsusRequestDto = this.ejecutarNumCliente(nDocumento, tipoDocumento, qcenre,
								String.valueOf(ultimoNumCliente));

						if (!Checks.esNulo(clienteUrsusRequestDto)
								&& !Checks.esNulo(clienteUrsusRequestDto.getData())) {
							listaClientes = clienteUrsusRequestDto.getData();
							// Añadimos los clientes de las sucesivas llamadas
							listaClientesFinal.addAll(listaClientes);

							if (!Checks.esNulo(clienteUrsusRequestDto.getIndicadorPaginacion())
									&& clienteUrsusRequestDto.getIndicadorPaginacion() > 0) {
								paginar = true;
							}
						}
					}
				}
			}
		}

		return listaClientesFinal;
	}

	/**
	 * Invoca al servicio GMPAJC11_INS de BANKIA para solicitar los datos de un
	 * cliente
	 * 
	 * @param nDocumento
	 * @param tipoDocumento
	 * @param qcenre
	 * @param idClienteClow
	 *            0 para la primera llamada. Último idClienteClow si tiene
	 *            paginación
	 * @return
	 */
	private ClienteUrsusRequestDto ejecutarNumCliente(String nDocumento, String tipoDocumento, String qcenre,
			String idClienteClow) throws Exception {
		ArrayList<DatosClienteDto> resultado = new ArrayList<DatosClienteDto>();
		ClienteUrsusRequestDto clienteUrsusDto = new ClienteUrsusRequestDto();
		String errorDesc = null;

		try {

			iniciarServicio();

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

			// Seteamos cabeceras
			servicioGMPAJC11_INS.setcabeceraAplicacion(cabeceraAplicacion);
			servicioGMPAJC11_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMPAJC11_INS.setcabeceraTecnica(cabeceraTecnica);

			// seteamos parametros
			servicioGMPAJC11_INS.setCodigoObjetoAccesocopace("PAHY0270");
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);
			servicioGMPAJC11_INS.setClaseDeDocumentoIdentificadorcocldo(tipoDocumento.charAt(0));
			servicioGMPAJC11_INS.setDniNifDelTitularDeLaOfertanudnio(nDocumento);
			servicioGMPAJC11_INS.setnumeroCliente(0);
			servicioGMPAJC11_INS.setnumeroUsuario("");
			HttpServletRequest request = null;
			if (RequestContextHolder.getRequestAttributes() != null) {
				request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
			}
			servicioGMPAJC11_INS.setidSesionWL(request != null ? request.getSession().getId() : "");
			// Para la primera pagina se pone el idClow = 0.
			// Para consultar el resto de paginas, hay que pasar el último
			// idClow de cada página
			servicioGMPAJC11_INS.setIdentificadorClienteOfertaidclow(Integer.parseInt(idClienteClow));
			servicioGMPAJC11_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

			servicioGMPAJC11_INS.setAlias(ALIAS);
			executeService(servicioGMPAJC11_INS);
			
			if (servicioGMPAJC11_INS.getNumeroDeOcurrenciasnumocu().size() > 0) {
				for (int i = 0; i < servicioGMPAJC11_INS.getNumeroDeOcurrenciasnumocu().size(); i++) {
					StructGMPAJC11_INS_NumeroDeOcurrenciasnumocu struct = servicioGMPAJC11_INS
							.getNumeroDeOcurrenciasnumocu().getStructGMPAJC11_INS_NumeroDeOcurrenciasnumocuAt(i);

					if (struct.getIdentificadorClienteOfertaidclow2() > 0) {
						DatosClienteDto aux = new DatosClienteDto();
						aux.setNumeroClienteUrsus(String.valueOf(struct.getIdentificadorClienteOfertaidclow2()));
						if (struct.getDniNifDelTitularDeLaOfertanudnio2() != null) {
							aux.setDniNifDelTitularDeLaOferta(struct.getDniNifDelTitularDeLaOfertanudnio2());
						}
						if (struct.getNombreYApellidosTitularDeOfertanotiof() != null) {
							aux.setNombreYApellidosTitularDeOferta(struct.getNombreYApellidosTitularDeOfertanotiof());
						}
						resultado.add(aux);
					}
				}
			}

			if (!Checks.esNulo(servicioGMPAJC11_INS.getIndicadorDePaginacionindipg())) {
				clienteUrsusDto.setIndicadorPaginacion(servicioGMPAJC11_INS.getIndicadorDePaginacionindipg());
			} else {
				clienteUrsusDto.setIndicadorPaginacion(0);
			}
			clienteUrsusDto.setData(resultado);

		} catch (WIException e) {
			errorDesc = e.getMessage();
			throw new JsonViewerException("Error consulta URSUS (UVEM): " + e.getMessage());
		} finally {
			registrarLlamada(servicioGMPAJC11_INS, errorDesc);
		}
		return clienteUrsusDto;

	}

	@Override
	public DatosClienteDto ejecutarDatosClientePorDocumento(DtoClienteUrsus dtoCliente) throws Exception {

		DatosClienteDto resultado = null;

		String nDocumento = dtoCliente.getNumDocumento();
		String tipoDocumento = dtoCliente.getTipoDocumento();
		String qcenre = dtoCliente.getQcenre();

		List<DatosClienteDto> clientes = ejecutarNumCliente(nDocumento, tipoDocumento, qcenre);
		if (clientes != null && clientes.isEmpty() && clientes.get(0).getNumeroClienteUrsus() != null
				&& !clientes.get(0).getNumeroClienteUrsus().isEmpty()) {
			resultado = ejecutarDatosCliente(Integer.valueOf(clientes.get(0).getNumeroClienteUrsus()), qcenre);
		}

		return resultado;

	}

	/**
	 * Invoca al servicio GMPAJC93_INS de BANKIA para obtener un cliente a
	 * partir de un clienteUrsus
	 * 
	 * @param numclienteIns
	 * @param qcenre
	 * @return
	 */
	@Override
	public DatosClienteDto ejecutarDatosCliente(Integer numcliente, String qcenre) throws Exception {
		DatosClienteDto datos = null;
		String errorDesc = null;

		try {

			iniciarServicio();

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

			// Seteamos cabeceras
			servicioGMPAJC93_INS.setcabeceraAplicacion(cabeceraAplicacion);
			servicioGMPAJC93_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMPAJC93_INS.setcabeceraTecnica(cabeceraTecnica);

			// seteamos parametros
			servicioGMPAJC93_INS.setCodigoObjetoAccesocopace("PAHY0272");
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);
			servicioGMPAJC93_INS.setIdentificadorClienteOfertaidclow(numcliente);// <--------?????
			servicioGMPAJC93_INS.setnumeroUsuario("");// <--------????? Nos lo
														// piden
														// obligatorio
			servicioGMPAJC93_INS.setidSesionWL("");// <--------????? Nos lo
													// piden
													// obligatorio
			servicioGMPAJC93_INS.setnumeroCliente(0);
			servicioGMPAJC93_INS.setIdentificadorDiscriminadorFuncioniddsfu("DF01");
			servicioGMPAJC93_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

			servicioGMPAJC93_INS.setAlias(ALIAS);
			executeService(servicioGMPAJC93_INS);

			datos = new DatosClienteDto();
			datos.setNumeroClienteUrsus(numcliente.toString());
			datos.setClaseDeDocumentoIdentificador(servicioGMPAJC93_INS.getClaseDeDocumentoIdentificadorcocldo() + "");
			datos.setDniNifDelTitularDeLaOferta(servicioGMPAJC93_INS.getDniNifDelTitularDeLaOfertanudnio());
			datos.setNombreYApellidosTitularDeOferta(servicioGMPAJC93_INS.getNombreYApellidosTitularDeOfertanotiof());
			datos.setNombreDelCliente(servicioGMPAJC93_INS.getNombreDelClientenoclie());
			datos.setPrimerApellido(servicioGMPAJC93_INS.getPrimerApellidonoape1());
			datos.setSegundoApellido(servicioGMPAJC93_INS.getSegundoApellidonoape2());
			datos.setCodigoTipoDeVia(servicioGMPAJC93_INS.getCodigoTipoDeViacotivw() + "");
			datos.setDenominacionTipoDeViaTrabajo(servicioGMPAJC93_INS.getDenominacionTipoDeViaTrabajoNotiv1());
			datos.setNombreDeLaVia(servicioGMPAJC93_INS.getNombreDeLaVianovisa());
			if (servicioGMPAJC93_INS.getPORTALNUPORO() != null)
				datos.setPORTAL(servicioGMPAJC93_INS.getPORTALNUPORO());
			datos.setESCALERA(servicioGMPAJC93_INS.getESCALERANUESCL() + "");
			datos.setPISO(servicioGMPAJC93_INS.getPISONUPICL());
			datos.setNumeroDePuerta(servicioGMPAJC93_INS.getNumeroDePuertanupucl() + "");
			datos.setCodigoPostal(servicioGMPAJC93_INS.getCodigoPostalcopoiw() + "");
			datos.setNombreDelMunicipio(servicioGMPAJC93_INS.getNombreDelMunicipionomusa());
			datos.setNombreDeLaProvincia(servicioGMPAJC93_INS.getNombreDeLaProvincianoprsa());
			datos.setCodigoDeProvincia(servicioGMPAJC93_INS.getCodigoDeProvinciacoprvw() + "");
			datos.setNombreDePaisDelDomicilio(servicioGMPAJC93_INS.getNombreDePaisDelDomicilionopado());
			datos.setDatosComplementariosDelDomicilio(servicioGMPAJC93_INS.getDatosComplementariosDelDomicilioobdom1());
			datos.setBarrioColoniaOApartado(servicioGMPAJC93_INS.getBarrioColoniaOApartadonobar2());
			datos.setEdadDelCliente(servicioGMPAJC93_INS.getEdadDelClientenuedaw() + "");
			datos.setCodigoEstadoCivil(servicioGMPAJC93_INS.getCodigoEstadoCivilcoesci());
			datos.setEstadoCivilActual(servicioGMPAJC93_INS.getEstadoCivilActualcoesc1());
			datos.setNumeroDeHijos(servicioGMPAJC93_INS.getNumeroDeHijosnuhijw() + "");
			datos.setSEXO(servicioGMPAJC93_INS.getSEXOCOSEXO() + "");
			datos.setNombreComercialDeLaEmpresa(servicioGMPAJC93_INS.getNombreComercialDeLaEmpresanocome());
			datos.setDELEGACION(servicioGMPAJC93_INS.getDELEGACIONXDELEG());
			datos.setTipoDeSociedad(servicioGMPAJC93_INS.getTipoDeSociedadcodem1());
			datos.setCodigoDeSituacionDelCliente(servicioGMPAJC93_INS.getCodigoDeSituacionDelClientecosicx() + "");
			datos.setNombreDeLaSituacionDelCliente(servicioGMPAJC93_INS.getNombreDeLaSituacionDelClientenosicl());
			try {
				if (servicioGMPAJC93_INS.getFechaDeNacimientoOConstitucionfenacw() != null
						&& !Checks.esNulo(servicioGMPAJC93_INS.getFechaDeNacimientoOConstitucionfenacw()))
					datos.setFechaDeNacimientoOConstitucion(
							servicioGMPAJC93_INS.getFechaDeNacimientoOConstitucionfenacw().toString());
			} catch (Exception e) {
				datos.setFechaDeNacimientoOConstitucion(null);
			}
			datos.setNombreDelPaisDeNacimiento(servicioGMPAJC93_INS.getNombreDelPaisDeNacimientonopanc());
			datos.setNombreDeLaProvinciaNacimiento(servicioGMPAJC93_INS.getNombreDeLaProvinciaNacimientonoprnc());
			datos.setNombreDePoblacionDeNacimiento(servicioGMPAJC93_INS.getNombreDePoblacionDeNacimientonopobn());
			datos.setNombreDePaisNacionalidad(servicioGMPAJC93_INS.getNombreDePaisNacionalidadnopana());
			datos.setNombreDePaisResidencia(servicioGMPAJC93_INS.getNombreDePaisResidencianopars());
			datos.setSubsectorDeActividadEconomica(servicioGMPAJC93_INS.getSubsectorDeActividadEconomicanossec());
			if (!Checks.esNulo(servicioGMPAJC93_INS.getIdentClienteConyugeOfertaidclww())) {
				datos.setNumeroClienteUrsusConyuge(
						Integer.valueOf(servicioGMPAJC93_INS.getIdentClienteConyugeOfertaidclww()).toString());
			}
			if(!Checks.esNulo(servicioGMPAJC93_INS.getNumeroDeOcurrenciasDeAvisonuocav())){
				datos.setHayOcurrencias(servicioGMPAJC93_INS.getNumeroDeOcurrenciasDeAvisonuocav() > 0);
			}
			if (!Checks.esNulo(servicioGMPAJC93_INS))
				datos.setNombreYApellidosConyuge(servicioGMPAJC93_INS.getNombreYApellidosTitularnotio1());

		} catch (WIException e) {
			errorDesc = e.getMessage();
			throw new JsonViewerException("Error consulta URSUS (UVEM): " + e.getMessage());
		} finally {
			registrarLlamada(servicioGMPAJC93_INS, errorDesc);

		}
		return datos;

	}

	
	/**
	 * Servicio GMPAJC93_INS que a partir del nº cliente URSUS se devuelvan los datos de 'Problemas con la venta'.
	 * 
	 * @param numcliente: numero cliente Ursus (idclow)
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	@Override
	public List <DatosClienteProblemasVentaDto> ejecutarDatosClienteProblemasVenta(Integer numcliente, String qcenre) throws Exception {
		List <DatosClienteProblemasVentaDto> datos = new ArrayList<DatosClienteProblemasVentaDto>();
		DatosClienteProblemasVentaDto dto = new DatosClienteProblemasVentaDto();
		String errorDesc = null;

		try {

			iniciarServicio();

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

			// Seteamos cabeceras
			servicioGMPAJC93_INS.setcabeceraAplicacion(cabeceraAplicacion);
			servicioGMPAJC93_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMPAJC93_INS.setcabeceraTecnica(cabeceraTecnica);

			// seteamos parametros
			servicioGMPAJC93_INS.setCodigoObjetoAccesocopace("PAHY0272");
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);
			servicioGMPAJC93_INS.setIdentificadorClienteOfertaidclow(numcliente);// <--------?????
			servicioGMPAJC93_INS.setnumeroUsuario("");// <--------????? Nos lo piden obligatorio
			servicioGMPAJC93_INS.setidSesionWL("");// <--------????? Nos lo piden obligatorio
			servicioGMPAJC93_INS.setnumeroCliente(0);
			servicioGMPAJC93_INS.setIdentificadorDiscriminadorFuncioniddsfu("DF01");
			servicioGMPAJC93_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

			servicioGMPAJC93_INS.setAlias(ALIAS);
			executeService(servicioGMPAJC93_INS);
			
			dto = new DatosClienteProblemasVentaDto();
			//Datos que mostraremos en el grid de 'Problemas con la venta'
			Short iter = servicioGMPAJC93_INS.getNumeroDeOcurrenciasDeAvisonuocav();
			Short i = 0;
			VectorGMPAJC93_INS_NumeroDeOcurrenciasnumocu vector = new VectorGMPAJC93_INS_NumeroDeOcurrenciasnumocu();
			StructGMPAJC93_INS_NumeroDeOcurrenciasnumocu estructura = new StructGMPAJC93_INS_NumeroDeOcurrenciasnumocu();
			vector = servicioGMPAJC93_INS.getNumeroDeOcurrenciasnumocu();
			
			for(i=0; i<iter; i++) {
				estructura = vector.getStructGMPAJC93_INS_NumeroDeOcurrenciasnumocuAt(i);
				
				if(COTLAV_CLVAAPCO.equals(estructura.getCodigoDeServiciocotlav())) {
					dto.setTipoMensaje("Problema");
					dto.setLiavi1(estructura.getLiteralAvisoEnPantallaliavi1());
				}else if(COTLAV_CLCDC4.equals(estructura.getCodigoDeServiciocotlav())) {
					if(COMEAV_0414.equals(estructura.getCodigoMensajeDeErrorcomeav())) {
						dto.setTipoMensaje("Problema");
					}else{
						dto.setTipoMensaje("Aviso");
					}
					dto.setLiavi1(estructura.getLiteralAvisoEnPantallaliavi1());
				}else if(COTLAV_CLCDB4.equals(estructura.getCodigoDeServiciocotlav())) {
					if(COMEAV_80.equals(estructura.getCodigoMensajeDeErrorcomeav())) {
						dto.setTipoMensaje("Problema");
						dto.setLiavi1(estructura.getLiteralAvisoEnPantallaliavi1());
					}else{
						dto.setTipoMensaje("Aviso");
						dto.setLiavi1(estructura.getLiteralAvisoEnPantallaliavi1());
					}
				}else{
					dto.setTipoMensaje("Aviso");
					dto.setLiavi1(estructura.getLiteralAvisoEnPantallaliavi1());
				}
				datos.add(i, dto);
			}
			
		} catch (WIException e) {
			errorDesc = e.getMessage();
			throw new JsonViewerException("Error consulta URSUS (UVEM): " + e.getMessage());
		} finally {
			registrarLlamada(servicioGMPAJC93_INS, errorDesc);
		}
		return datos;
	}
	
	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para dar de alta un instancia
	 * de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	@Override
	public ResultadoInstanciaDecisionDto altaInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception {
		ResultadoInstanciaDecisionDto instancia = new ResultadoInstanciaDecisionDto();
		try {
			/**
			 * Si hay más de un titular informamos solo uno. Elegimos el titular
			 * de la contratación
			 */
			if (instanciaDecisionDto.getTitulares() != null && instanciaDecisionDto.getTitulares().size() > 1) {
				TitularDto titularAux = null;
				for (TitularDto titular : instanciaDecisionDto.getTitulares()) {
					if (titular.getTitularContratacion().equals(Integer.valueOf(1))) {
						titularAux = titular;
						titularAux.setPorcentajeCompra(Double.valueOf(100));
						break;
					}
				}
				if (titularAux != null) {
					ArrayList<TitularDto> titulares = new ArrayList<TitularDto>();
					titulares.add(titularAux);
					instanciaDecisionDto.setTitulares(titulares);
				} else {
					throw new WIException("Al menos debe existir un titular de la contratación ");
				}
			}
			instancia = instanciaDecision(instanciaDecisionDto, INSTANCIA_DECISION_ALTA);
		} catch (WIException e) {
			throw new JsonViewerException("Error alta comité (UVEM): " + e.getMessage());
		}
		return instancia;
	}

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para consultar una instancia de
	 * decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	@Override
	public ResultadoInstanciaDecisionDto consultarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception {
		ResultadoInstanciaDecisionDto instancia = new ResultadoInstanciaDecisionDto();
		try {
			// HREOS-1888 -NO se especifica código de oferta HAYA,
			// se consulta las facultades con los activos e importe que se
			// alimentan al servicio de consulta,
			// obteniendo el comité con los datos facilitados en la entrada al
			// servicio.
			instanciaDecisionDto.setCodigoDeOfertaHaya("0");
			instanciaDecisionDto.setImporteReserva(null);
			instanciaDecisionDto.setCodTipoArras(null);
			instancia = instanciaDecision(instanciaDecisionDto, INSTANCIA_DECISION_CONSULTA);
		} catch (WIException e) {
			logger.error("error en UvemManager", e);
			throw new JsonViewerException("Error consulta comité (UVEM): " + e.getMessage());
		}
		return instancia;
	}

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para modificar una instancia de
	 * decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	@Override
	public ResultadoInstanciaDecisionDto modificarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception {
		ResultadoInstanciaDecisionDto instancia = new ResultadoInstanciaDecisionDto();
		instanciaDecisionDto.setImporteReserva(null);
		instanciaDecisionDto.setCodTipoArras(null);
		try {
			instancia = instanciaDecision(instanciaDecisionDto, INSTANCIA_DECISION_MODIFICACION);
		} catch (WIException e) {
			throw new JsonViewerException("Error ratificación comité (UVEM): " + e.getMessage());
		}
		return instancia;
	}

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para modificar una instancia de
	 * decisión de una oferta (MOD3) Necesita pasarle el parametro codigoCOTPRA
	 * al dto.
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	@Override
	public ResultadoInstanciaDecisionDto modificarInstanciaDecisionTres(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception {
		BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
		ResultadoInstanciaDecisionDto instancia = new ResultadoInstanciaDecisionDto();
		InstanciaDecisionDto instanciaDecisionDtoCopia = new InstanciaDecisionDto();
		beanUtilNotNull.copyProperties(instanciaDecisionDtoCopia, instanciaDecisionDto);
		try {
			if (instanciaDecisionDtoCopia
					.getCodigoCOTPRA() != InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS) {
				instanciaDecisionDtoCopia.setImporteReserva(null);
				instanciaDecisionDtoCopia.setCodTipoArras(null);
			}
			if (instanciaDecisionDtoCopia
					.getCodigoCOTPRA() == InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS) {
				for (InstanciaDecisionDataDto dto : instanciaDecisionDtoCopia.getData()) {
					dto.setImporteConSigno(0L);
				}
			}
			if (instanciaDecisionDtoCopia.getCodigoCOTPRA() != InstanciaDecisionDataDto.PROPUESTA_TITULARES) {
				instanciaDecisionDtoCopia.setTitulares(null);
			}

			instancia = instanciaDecision(instanciaDecisionDtoCopia, INSTANCIA_DECISION_MODIFICACION_3);
		} catch (WIException e) {
			throw new JsonViewerException("Error servicio de facultades (UVEM): " + e.getMessage());
		}
		return instancia;
	}

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para realizar la accion pasada
	 * por parametros sobre una instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @param accion:
	 *            ALTA/CONS/MODI
	 * @return
	 * @throws WIException
	 */
	private ResultadoInstanciaDecisionDto instanciaDecision(InstanciaDecisionDto instanciaDecisionDto, String accion)
			throws WIException {
		logger.info("------------ LLAMADA WS INSTANCIADECISION -----------------");
		String errorDesc = null;
		ResultadoInstanciaDecisionDto result = new ResultadoInstanciaDecisionDto();
		servicioGMPDJB13_INS = new GMPDJB13_INS();
		VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu numeroOcurrencias = new VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu();
		VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocx vectorTitulares = new VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocx();

		List<InstanciaDecisionDataDto> instanciaListData = instanciaDecisionDto.getData();
		if (Checks.esNulo(instanciaListData) || (!Checks.esNulo(instanciaListData) && instanciaListData.size() == 0)) {
			throw new WIException("El campo data de la instancia es obligatorio.");
		}

		if (instanciaDecisionDto.getTitulares() != null) {
			servicioGMPDJB13_INS
					.setNumeroDeOcurrenciasEntrada1nuoce1((short) instanciaDecisionDto.getTitulares().size());
			if (instanciaDecisionDto.getTitulares() != null) {
				for (TitularDto titular : instanciaDecisionDto.getTitulares()) {
					StructGMPDJB13_INS_NumeroDeOcurrenciasnumocx structTitular = new StructGMPDJB13_INS_NumeroDeOcurrenciasnumocx();
					// n ursus
					if (titular.getNumeroUrsus() != null) {
						structTitular.setIdentificadorClienteOfertaidclow((int) (long) titular.getNumeroUrsus());
					} else {
						// tipo doc
						structTitular.setClaseDeDocumentoIdentificadorcocldo(titular.getTipoDocumentoCliente());
						// n documento
						structTitular.setDniNifDelTitularDeLaOfertanudnio(titular.getNumeroDocumento());
						// nombre completo titular
						structTitular.setNombreYApellidosTitularDeOfertanotiof(titular.getNombreCompletoCliente());
					}

					// el conyuge
					if (titular.getConyugeNumeroUrsus() != null) {
						structTitular.setIdentClienteConyugeOfertaidclww((int) (long) titular.getConyugeNumeroUrsus());
					}

					// % de participación en la compra
					Double porcentajeCompraValor = titular.getPorcentajeCompra();
					if (porcentajeCompraValor != null) {
						porcentajeCompraValor = porcentajeCompraValor * 100;
					} else {
						porcentajeCompraValor = 0.0;
					}
					Porcentaje9 porcentajeCompra = new Porcentaje9();
					porcentajeCompra.setPorcentaje((int) porcentajeCompraValor.longValue());
					porcentajeCompra.setNumDecimales("02");
					structTitular.setPorcentajeCompraBISA(porcentajeCompra);

					vectorTitulares.add(structTitular);
				}
			}
		} else {
			servicioGMPDJB13_INS.setNumeroDeOcurrenciasEntrada1nuoce1((short) 0);
		}
		servicioGMPDJB13_INS.setNumeroDeOcurrenciasnumocx(vectorTitulares);

		// Bucle para cargar el array numOcurrencias con la info de cada
		// activo
		servicioGMPDJB13_INS.setNumeroDeOcurrenciasEntrada2nuoce2((short) instanciaListData.size());
		for (int i = 0; i < instanciaListData.size(); i++) {
			InstanciaDecisionDataDto instanciaData = instanciaListData.get(i);
			StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu struct = new StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu();

			// IdentificadorActivoEspecial
			if (instanciaData.getIdentificadorActivoEspecial() != null) {
				struct.setIdentificadorActivoEspecialcoacew(instanciaData.getIdentificadorActivoEspecial());
			}

			// TipoDeImpuesto
			struct.setTipoDeImpuestocotimw(instanciaData.getTipoDeImpuesto());

			// ImporteMonetarioOfertaBISA
			if (instanciaData.getImporteConSigno() == null) {
				throw new WIException("El importe con signo no puede estar vacio.");
			} else {
				ImporteMonetario importeMonetario = new ImporteMonetario();
				importeMonetario.setImporteConSigno(instanciaData.getImporteConSigno());
				es.cajamadrid.servicios.ARQ.Moneda moneda = new es.cajamadrid.servicios.ARQ.Moneda();
				moneda.setDivisa("D");
				moneda.setDigitoControlDivisa('-');
				importeMonetario.setMonedaBISA(moneda);
				importeMonetario.setNumeroDecimalesImporte('-');
				struct.setImporteMonetarioOfertaBISA(importeMonetario);
			}

			// PorcentajeImpuestoBISA
			Porcentaje9 porcentajeImpuesto = null;
			porcentajeImpuesto = new Porcentaje9();
			if (!Checks.esNulo(instanciaData.getPorcentajeImpuesto())) {
				porcentajeImpuesto.setPorcentaje(instanciaData.getPorcentajeImpuesto());
				porcentajeImpuesto.setNumDecimales("02");
				struct.setPorcentajeImpuestoBISA(porcentajeImpuesto);
			}

			// IndicadorTratamientoImpuesto

			if (Checks.esNulo(instanciaData.getTipoDeImpuesto())) {
				throw new WIException("El tipo de impuesto no puede estar vacío.");
			} else {

				if (instanciaData.getTipoDeImpuesto() == InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP
						|| instanciaData.getTipoDeImpuesto() == InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC
						|| instanciaData.getTipoDeImpuesto() == InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI) {
					struct.setIndicadorTratamientoImpuestobitrim(' ');
				} else if (instanciaData.getTipoDeImpuesto() == InstanciaDecisionDataDto.TIPO_IMPUESTO_IVA) {

					if (Checks.esNulo(instanciaData.getRenunciaExencion())
							|| (!Checks.esNulo(instanciaData.getRenunciaExencion())
									&& !instanciaData.getRenunciaExencion())) {
						// RenunciaExencion a null o a false
						struct.setIndicadorTratamientoImpuestobitrim('B');
					} else {
						struct.setIndicadorTratamientoImpuestobitrim('A');
					}
				}
			}

			// struct.setIndicadorTratamientoImpuestobitrim('A'); // 'A' or 'B'
			// or '\'

			// Es un array al que se le meteran cada activo de la oferta
			numeroOcurrencias.setStructGMPDJB13_INS_NumeroDeOcurrenciasnumocu(struct);
		}

		// Este codigo de BANKIA aunque parezca setear una variable, esta
		// haciendo una add a un Array.
		// El vector numeroOcurrencias debe tener 40 elementos si o si. Para
		// ello, rellenamos el resto de ocurrencias con structuras vacías.
		StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu structEmpty = new StructGMPDJB13_INS_NumeroDeOcurrenciasnumocu();
		for (int i = 0; i < 40 - instanciaListData.size(); i++) {
			numeroOcurrencias.setStructGMPDJB13_INS_NumeroDeOcurrenciasnumocu(structEmpty);
		}

		try {
			logger.info("------------ LLAMADA WS INSTANCIADECISION (" + accion + ") -----------------");
			iniciarServicio();

			// Creamos cabeceras
			es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraFuncionalPeticion();
			es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraTecnica();
			StructCabeceraAplicacionGMPDJB13_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPDJB13_INS();

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

			// seteamos parametros
			servicioGMPDJB13_INS.setCodigoObjetoAccesocopace("PAHY0170");
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);

			servicioGMPDJB13_INS.setCodigoDeOfertaHayacoofhx(
					StringUtils.leftPad(instanciaDecisionDto.getCodigoDeOfertaHaya(), 16, "0"));
			if (instanciaDecisionDto.isFinanciacionCliente()) {
				servicioGMPDJB13_INS
						.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_SI);
			} else {
				servicioGMPDJB13_INS
						.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_NO);
			}
			
			servicioGMPDJB13_INS.setTipoPropuestacotprw(InstanciaDecisionDataDto.PROPUESTA_VENTA);

			if (accion.equals(INSTANCIA_DECISION_MODIFICACION_3)) {
				// Modificacion de honorarios prescriptor
				if (instanciaDecisionDto.getCodigoCOTPRA() == InstanciaDecisionDataDto.PROPUESTA_HONORARIOS) {
					servicioGMPDJB13_INS.setTipoPropuestacotprw(InstanciaDecisionDataDto.PROPUESTA_HONORARIOS);
				}
				// Modificación de titulares
				if (instanciaDecisionDto.getCodigoCOTPRA() == InstanciaDecisionDataDto.PROPUESTA_TITULARES) {
					servicioGMPDJB13_INS.setTipoPropuestacotprw(InstanciaDecisionDataDto.PROPUESTA_TITULARES);
				}
				// Modificación condicionantes económicos
				if (instanciaDecisionDto
						.getCodigoCOTPRA() == InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS) {
					servicioGMPDJB13_INS
							.setTipoPropuestacotprw(InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS);
				}

			}

			if (Boolean.TRUE.equals(instanciaDecisionDto.getOfertaAgrupacion())
					&& INSTANCIA_DECISION_ALTA.equals(accion) && Boolean.FALSE.equals(instanciaDecisionDto.getOfertaVentaCartera())) {
				if (instanciaDecisionDto.getCodigoAgrupacionInmueble() != null
						&& instanciaDecisionDto.getCodigoAgrupacionInmueble() > 0) {
					servicioGMPDJB13_INS
							.setCodigoDeAgrupacionDeInmueblecoagiw(instanciaDecisionDto.getCodigoAgrupacionInmueble());
				} else {
					servicioGMPDJB13_INS.setCodigoDeAgrupacionDeInmueblecoagiw(0);
				}
			} else {
				servicioGMPDJB13_INS.setCodigoDeAgrupacionDeInmueblecoagiw(0);
			}

			if (numeroOcurrencias != null) {
				servicioGMPDJB13_INS.setNumeroDeOcurrenciasnumocu(numeroOcurrencias);
			}

			// Importe de la reserva
			ImporteMonetario importeMonetarioReserva = new ImporteMonetario();
			if (instanciaDecisionDto.getImporteReserva() != null) {
				BigDecimal importe = BigDecimal.valueOf(instanciaDecisionDto.getImporteReserva());
				importeMonetarioReserva.setImporteConSigno(importe.multiply(new BigDecimal(100)).longValue());
				
			} else {
				importeMonetarioReserva.setImporteConSigno(new Long(0));
			}
			es.cajamadrid.servicios.ARQ.Moneda moneda = new es.cajamadrid.servicios.ARQ.Moneda();
			moneda.setDivisa("D");
			moneda.setDigitoControlDivisa('-');
			importeMonetarioReserva.setMonedaBISA(moneda);
			importeMonetarioReserva.setNumeroDecimalesImporte('-');

			servicioGMPDJB13_INS.setImporteMonetarioDeLaReservaBISA(importeMonetarioReserva);
			if (instanciaDecisionDto.getImporteReserva() == null
					|| instanciaDecisionDto.getImporteReserva().compareTo(Double.valueOf(0)) == 0
					|| Checks.esNulo(instanciaListData.get(0).getPorcentajeImpuesto())
					|| instanciaListData.get(0).getPorcentajeImpuesto() == 0) {
				servicioGMPDJB13_INS.setIndicadorCobroImpuestosReservabicirv(' ');
			} else {
				if (instanciaDecisionDto.getImporteReserva().compareTo(Double.valueOf(0)) > 0
						&& instanciaListData.get(0).getPorcentajeImpuesto() > 0
						&& instanciaDecisionDto.getImpuestosReserva()) {
					servicioGMPDJB13_INS.setIndicadorCobroImpuestosReservabicirv('S');
				} else {
					servicioGMPDJB13_INS.setIndicadorCobroImpuestosReservabicirv('N');
				}
			}

			// tipo de arras
			if (instanciaDecisionDto.getCodTipoArras() != null) {
				if (instanciaDecisionDto.getCodTipoArras().equals(DDTiposArras.CONFIRMATORIAS)) {
					servicioGMPDJB13_INS.setIndicadorTipoArrasReservabithrv('A');
				} else {
					servicioGMPDJB13_INS.setIndicadorTipoArrasReservabithrv('B');
				}
			} else {
				servicioGMPDJB13_INS.setIndicadorTipoArrasReservabithrv(' ');
			}

			servicioGMPDJB13_INS.setCodEntidadRepresntClienteUrsusqcenre(instanciaDecisionDto.getQcenre());

			if (!Checks.esNulo(instanciaDecisionDto.getCodComiteSuperior())) {
				servicioGMPDJB13_INS
						.setCodigoComiteSuperiorcocom3(Short.valueOf(instanciaDecisionDto.getCodComiteSuperior()));
				result.setComiteSuperior(instanciaDecisionDto.getCodComiteSuperior());
			} else {
				// el comite superior para el alta siempre es 0
				servicioGMPDJB13_INS.setCodigoComiteSuperiorcocom3((short) 0);
				result.setComiteSuperior(null);
			}

			// codigo uvem de la ofician prescriptora
			if (Boolean.TRUE.equals(instanciaDecisionDto.getOfertaVentaCartera())) {
				servicioGMPDJB13_INS.setIdentificadorDelColaboradoridcola("D666");
			} else {
				if (Checks.esNulo(instanciaDecisionDto.getCodigoProveedorUvem())) {
					servicioGMPDJB13_INS.setIdentificadorDelColaboradoridcola("C000");
				} else {
					servicioGMPDJB13_INS
							.setIdentificadorDelColaboradoridcola(instanciaDecisionDto.getCodigoProveedorUvem());
				}
			}

			// venta cartera
			if (INSTANCIA_DECISION_ALTA.equals(accion)) {

				if (Boolean.TRUE.equals(instanciaDecisionDto.getOfertaVentaCartera())) {
					// 0 :no es venta cartera
					if (instanciaDecisionDto.getCodigoAgrupacionInmueble() != null) {
						servicioGMPDJB13_INS
								.setCodigoVentaCarteracovecw(instanciaDecisionDto.getCodigoAgrupacionInmueble());
					}

					// 0 Para ofertas tipo venta
					// 6 Oferta preventa cartera
					// 7 Oferta venta cierre definitivo cartera
					// Obligatorio distinto 0 para venta cartera
					servicioGMPDJB13_INS.setTipoDeOfertacotofw((short) 7);

					// ‘ ‘ : para tipo de oferta sea 0
					// ‘S’: si es una oferta de tipo 7 y no es de BH
					// ‘N’ : no es venta cartera automática y tipo oferta 7
					// Obligatorio distinto ‘ ‘ para venta cartera
					
					//Dani nos confirma que para activos BH hay que pasar N, aunque la Doc no es clara
					if(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT.equals(instanciaDecisionDto.getQcenre())){
						servicioGMPDJB13_INS.setIndicadorDeVentaInmediatabivein('N');
					}else{
						servicioGMPDJB13_INS.setIndicadorDeVentaInmediatabivein('S');
					}
					
				}else{
					//es una alta pero no es de venta cartera
					servicioGMPDJB13_INS.setCodigoVentaCarteracovecw(0);
					servicioGMPDJB13_INS.setTipoDeOfertacotofw((short) 0);
					servicioGMPDJB13_INS.setIndicadorDeVentaInmediatabivein(' ');
				}

			}else{
				servicioGMPDJB13_INS.setCodigoVentaCarteracovecw(0);
				servicioGMPDJB13_INS.setTipoDeOfertacotofw((short) 0);
				servicioGMPDJB13_INS.setIndicadorDeVentaInmediatabivein(' ');
			}

			// Requeridos por el servicio
			servicioGMPDJB13_INS.setnumeroCliente(0);
			servicioGMPDJB13_INS.setnumeroUsuario("");
			servicioGMPDJB13_INS.setidSesionWL("");

			servicioGMPDJB13_INS.setAlias(ALIAS);

			executeService(servicioGMPDJB13_INS);

			result.setLongitudMensajeSalida(servicioGMPDJB13_INS.getLongitudMensajeDeSalidarcslon());
			result.setCodigoComite(servicioGMPDJB13_INS.getCodigoComitecocom7() + "");
			result.setCodigoDeOfertaHaya(servicioGMPDJB13_INS.getCodigoDeOfertaHayacoofhx2());
			// HREOS-3844: Postacordado Bankia 2: Añadir código de la oferta en
			// FFDD
			result.setCodigoAgrupacionInmueble(servicioGMPDJB13_INS.getCodigoDeAgrupacionDeInmueblecoagiw2());
			result.setCodigoOfertaUvem(servicioGMPDJB13_INS.getCodigoDeOfertacoofew());
		} catch (WIException e) {
			errorDesc = e.getMessage();
			throw new JsonViewerException("Error servicio de facultades (UVEM): " + e.getMessage());
		} finally {
			registrarLlamada(servicioGMPDJB13_INS, errorDesc);
		}

		return result;
	}

	/**
	 * Invoca al servicio GMPAJC34_INS de BANKIA para consultar los datos de un
	 * prestamo
	 * 
	 * @param numExpedienteRiesgo
	 * @param tipoRiesgo
	 * @return
	 */
	@Override
	public Long consultaDatosPrestamo(String numExpedienteRiesgo12, int tipoRiesgo) {
		logger.info("------------ LLAMADA WS CONSULTA_DATOS_PRESTAMO -----------------");
		es.cm.arq.tda.tiposdedatosbase.ImporteMonetario importe = null;
		String errorDesc = null;
		try {

			iniciarServicio();

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
			cabeceraTecnica.setCOMLAQ("JC33");

			// seteamos parametros
			servicioGMPAJC34_INS.setCodigoObjetoAccesocopace("PAHY0370");
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);
			numExpedienteRiesgo12 = StringUtils.leftPad(numExpedienteRiesgo12, 18, "0");
			servicioGMPAJC34_INS.setNumeroExpedienteDeRiesgoNumericonuidow(numExpedienteRiesgo12);
			servicioGMPAJC34_INS.setTipoRiesgoClaseProductoUrsusCotirx(tipoRiesgo);
			long numeroCliente = 0;
			servicioGMPAJC34_INS.setnumeroCliente(numeroCliente);
			String numeroUsuario = "";
			servicioGMPAJC34_INS.setnumeroUsuario(numeroUsuario);
			String idSesionWL = "";
			servicioGMPAJC34_INS.setidSesionWL(idSesionWL);
			int codigoDeOferta = 0;
			servicioGMPAJC34_INS.setCodigoDeOfertacoofew(codigoDeOferta);
			char indicadorDeFinanciacionCliente = 'N';
			servicioGMPAJC34_INS.setIndicadorDeFinanciacionClientebificl(indicadorDeFinanciacionCliente);
			short tipoRiesgoClaseProductoUrsusCotig4 = 0;
			servicioGMPAJC34_INS.setTipoRiesgoClaseProductoUrsusCotig4(tipoRiesgoClaseProductoUrsusCotig4);
			String datosFinanciacionOtraEntidad = "";
			servicioGMPAJC34_INS.setDatosFinanciacionOtraEntidadobfine(datosFinanciacionOtraEntidad);
			short codigoDeResolucionDePrestamo = 0;
			servicioGMPAJC34_INS.setCodigoDeResolucionDePrestamocorepw(codigoDeResolucionDePrestamo);
			Fecha fecha = new Fecha();
			servicioGMPAJC34_INS.setFechaResolucionPrestamosferep4(fecha);
			Fecha fecha2 = new Fecha();
			servicioGMPAJC34_INS.setFechaSolicitudPrestamofesop2(fecha2);

			servicioGMPAJC34_INS.setAlias(ALIAS);
			executeService(servicioGMPAJC34_INS);

			importe = servicioGMPAJC34_INS.getImporteMonetarioConcedido();

			logger.info("ImporteMonetarioConcedido: " + servicioGMPAJC34_INS.getImporteMonetarioConcedido());

			if (importe == null) {
				throw new WIException("No se han encontrado datos con la información suministrada");
			}

		} catch (WIException wie) {
			logger.error("error en UvemManager", wie);
			errorDesc = wie.getMessage();
			throw new JsonViewerException("Error consulta préstamo (UVEM): " + wie.getMessage());
		} finally {
			registrarLlamada(servicioGMPAJC34_INS, errorDesc);
		}

		return importe.getImporteComoLong();

	}

	@Override
	public WSDevolBankiaDto notificarDevolucionReserva(String codigoDeOfertaHaya, MOTIVO_ANULACION motivoAnulacionReserva,
			INDICADOR_DEVOLUCION_RESERVA indicadorDevolucionReserva,
			CODIGO_SERVICIO_MODIFICACION codigoServicioModificacion) throws Exception {

		logger.info("------------ LLAMADA WS NOTIFICAR DEV RESERVA -----------------");
		servicioGMPTOE83_INS = new GMPTOE83_INS();
		String errorDesc = null;
		try {
			iniciarServicio();

			// Creamos cabeceras
			es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraFuncionalPeticion();
			es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraTecnica();
			StructCabeceraAplicacionGMPTOE83_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPTOE83_INS();

			cabeceraFuncional.setCOFRAQ("168");
			cabeceraFuncional.setCOSFAQ("00");
			cabeceraFuncional.setCOAQAQ("AQ");
			cabeceraFuncional.setCORPAQ("WW0071");
			cabeceraFuncional.setCLCDAQ("0370");
			cabeceraFuncional.setCOENAQ("0000");
			cabeceraFuncional.setCOCDAQ("0551");
			cabeceraFuncional.setCOSBAQ("00");
			cabeceraFuncional.setNUPUAQ("00");
			cabeceraFuncional.setIDDSAQ("");
			cabeceraTecnica.setCLORAQ("71");

			// COPACE
			cabeceraAplicacion.setCodigoObjetoAccesocopace("PAHY0770");
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);

			// Seteamos cabeceras
			servicioGMPTOE83_INS.setcabeceraAplicacion(cabeceraAplicacion);
			servicioGMPTOE83_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMPTOE83_INS.setcabeceraTecnica(cabeceraTecnica);

			servicioGMPTOE83_INS.setnumeroUsuario("");
			servicioGMPTOE83_INS.setidSesionWL("");
			servicioGMPTOE83_INS.setnumeroCliente(0);

			HttpServletRequest request = null;
			if (RequestContextHolder.getRequestAttributes() != null) {
				request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
			}
			servicioGMPTOE83_INS.setidSesionWL(request != null ? request.getSession().getId() : "");

			// COUSAE
			servicioGMPTOE83_INS.setCodigoDeUsuariocousae("USRHAYA");
			// COSEM1
			if (CODIGO_SERVICIO_MODIFICACION.PROPUESTA_ANULACION_RESERVA_FIRMADA.equals(codigoServicioModificacion)) {
				servicioGMPTOE83_INS.setCodigoServicioModificacionSolicitcosem1('4');
			} else if (CODIGO_SERVICIO_MODIFICACION.ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA
					.equals(codigoServicioModificacion)) {
				servicioGMPTOE83_INS.setCodigoServicioModificacionSolicitcosem1('5');
			} else if (CODIGO_SERVICIO_MODIFICACION.SOLICITUD_ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA
					.equals(codigoServicioModificacion)) {
				servicioGMPTOE83_INS.setCodigoServicioModificacionSolicitcosem1('6');
			} else if (CODIGO_SERVICIO_MODIFICACION.ANULAR_SOLICITUD_ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA
					.equals(codigoServicioModificacion)) {
				servicioGMPTOE83_INS.setCodigoServicioModificacionSolicitcosem1('7');
			} else {
				throw new JsonViewerException("Error, opción no soportada");
			}

			// LCOMOA
			if (!Checks.esNulo(motivoAnulacionReserva)) {
				if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.COMPRADOR_NO_INTERESADO)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("1"));
				} else if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.DECISION_AREA)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("2"));
				} else if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.DECISION_HAYA)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("9"));
				} else if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.NO_CUMPLEN_CONDICIONANTES)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("5"));
				} else if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.NO_DESEAN_ESCRITURAR)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("6"));
				} else if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.NO_DISPONE_DINERO_FINANCIACION)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("3"));
				} else if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.CIRCUSTANCIAS_DISTINTAS_PACTADAS)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("4"));
				} else if (motivoAnulacionReserva.equals(MOTIVO_ANULACION.NO_APLICA)) {
					servicioGMPTOE83_INS.setCodigoMotivoAnulacionReservalcomoa(new Short("0"));
				} else {
					throw new Exception("motivo anulacion no soportado");
				}
			}
			// COOFHX
			servicioGMPTOE83_INS.setCodigoDeOfertaHayacoofhx(StringUtils.leftPad(codigoDeOfertaHaya, 16, "0"));
			// BINDRE
			if (INDICADOR_DEVOLUCION_RESERVA.DEVOLUCION_RESERVA.equals(indicadorDevolucionReserva)) {
				servicioGMPTOE83_INS.setIndicadorDevolucionReservabindre('S');
			} else if (INDICADOR_DEVOLUCION_RESERVA.NO_DEVOLUCION_RESERVA.equals(indicadorDevolucionReserva)) {
				servicioGMPTOE83_INS.setIndicadorDevolucionReservabindre('N');
			} else if (INDICADOR_DEVOLUCION_RESERVA.NO_APLICA.equals(indicadorDevolucionReserva)) {
				servicioGMPTOE83_INS.setIndicadorDevolucionReservabindre(' ');
			} else {
				throw new Exception("indicador devolución no soportado");
			}

			servicioGMPTOE83_INS.setCodigoDeOfertalcoofe(0);
			servicioGMPTOE83_INS.setNumeroDeMovimientoCondicioneslnumvc((short) 0);
			servicioGMPTOE83_INS.setFechaEmisionAmpliacionlfeema(0);
			servicioGMPTOE83_INS.setFechaAmplizacionFirmalfefam(0);
			servicioGMPTOE83_INS.setFechaEnvioReservalfeenr(0);
			servicioGMPTOE83_INS.setFechaRecepcionReservalferer(0);
			servicioGMPTOE83_INS.setFechaFirmaReservalfefir(0);
			servicioGMPTOE83_INS.setFechaLimiteReservalfemxr(0);
			servicioGMPTOE83_INS.setFechaAnulacionReservalfeanr(0);
			servicioGMPTOE83_INS.setFechaSubastalfesub(0);
			servicioGMPTOE83_INS.setFechaNuevoVencimientolfecvt(0);
			servicioGMPTOE83_INS.setIndicadorContratoReservaFirmadobioprf(' ');
			servicioGMPTOE83_INS.setCodigoDeEntidadlcoett((short) 0);

			servicioGMPTOE83_INS.setAlias(ALIAS);
			executeService(servicioGMPTOE83_INS);
			
			WSDevolBankiaDto dto = new WSDevolBankiaDto();
			
			dto.setCorrecw((long) servicioGMPTOE83_INS.getCodigoResolucionComitecorecw());
			dto.setComoa3((long) servicioGMPTOE83_INS.getCodigoMotivoAnulacionPropuestacomoa3());	
			
			return dto;

		} catch (WIException wie) {
			logger.error("error en UvemManager", wie);
			errorDesc = wie.getMessage();
			throw new JsonViewerException("Error notificación reserva (UVEM): " + wie.getMessage());
		} finally {
			registrarLlamada(servicioGMPTOE83_INS, errorDesc);
			
			
		}

	}

	@Override
	public MOTIVO_ANULACION obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(String codigoMotivoAnulacionReserva) {
		if (DDMotivoAnulacionReserva.CODIGO_COMPRADOR_NO_INTERESADO_OPERACION.equals(codigoMotivoAnulacionReserva)) {
			return MOTIVO_ANULACION.COMPRADOR_NO_INTERESADO;
		} else if (DDMotivoAnulacionReserva.CODIGO_DECISION_DEL_AREA.equals(codigoMotivoAnulacionReserva)) {
			return MOTIVO_ANULACION.DECISION_AREA;
		} else if (DDMotivoAnulacionReserva.CODIGO_NO_DISPONE_DINERO_FINANCIACION
				.equals(codigoMotivoAnulacionReserva)) {
			return MOTIVO_ANULACION.NO_DISPONE_DINERO_FINANCIACION;
		} else if (DDMotivoAnulacionReserva.CODIGO_CIRCUNSTANCIAS_DISTINTAS_A_LAS_PACTADAS
				.equals(codigoMotivoAnulacionReserva)) {
			return MOTIVO_ANULACION.CIRCUSTANCIAS_DISTINTAS_PACTADAS;
		} else if (DDMotivoAnulacionReserva.CODIGO_NO_SE_CUMPLEN_CONDICIONANTES.equals(codigoMotivoAnulacionReserva)) {
			return MOTIVO_ANULACION.NO_CUMPLEN_CONDICIONANTES;
		} else if (DDMotivoAnulacionReserva.CODIGO_NO_DESEAN_ESCRITURAR.equals(codigoMotivoAnulacionReserva)) {
			return MOTIVO_ANULACION.NO_DESEAN_ESCRITURAR;
		} else if (DDMotivoAnulacionReserva.CODIGO_DECISION_HAYA.equals(codigoMotivoAnulacionReserva)) {
			return MOTIVO_ANULACION.DECISION_HAYA;
		} else {
			return MOTIVO_ANULACION.NO_APLICA;
		}
	}

	@Override
	public void anularOferta(String codigoDeOfertaHaya, MOTIVO_ANULACION_OFERTA motivoAnulacionOferta)
			throws Exception {
		logger.info("------------ LLAMADA WS ANULAR RESERVA -----------------");
		servicioGMPAJC29_INS = new GMPAJC29_INS();
		String errorDesc = null;

		try {
			iniciarServicio();

			// Creamos cabeceras
			es.cajamadrid.servicios.GM.GMPAJC29_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPAJC29_INS.StructCabeceraFuncionalPeticion();
			es.cajamadrid.servicios.GM.GMPAJC29_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPAJC29_INS.StructCabeceraTecnica();
			StructCabeceraAplicacionGMPAJC29_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPAJC29_INS();

			// Seteamos cabeceras
			servicioGMPAJC29_INS.setcabeceraAplicacion(cabeceraAplicacion);
			servicioGMPAJC29_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMPAJC29_INS.setcabeceraTecnica(cabeceraTecnica);

			cabeceraFuncional.setCOFRAQ("168");
			cabeceraFuncional.setCOSFAQ("00");
			cabeceraFuncional.setCOAQAQ("AQ");
			cabeceraFuncional.setCORPAQ("WW0071");
			cabeceraFuncional.setCLCDAQ("0370");
			cabeceraFuncional.setCOENAQ("0000");
			cabeceraFuncional.setCOCDAQ("0551");
			cabeceraFuncional.setCOSBAQ("00");
			cabeceraFuncional.setNUPUAQ("00");
			cabeceraFuncional.setIDDSAQ("BAJA");
			cabeceraTecnica.setCLORAQ("71");

			cabeceraAplicacion.setCodigoObjetoAccesocopace("PAHY0150");
			servicioGMPAJC29_INS.setCOPACE("PAHY0150");
			servicioGMPAJC29_INS.setBISEGU(' ');
			servicioGMPAJC29_INS.setLIRESE("");
			servicioGMPAJC29_INS.setRCSLON(0);

			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus(COCGUS);

			servicioGMPAJC29_INS.setCOOFHX(StringUtils.leftPad(codigoDeOfertaHaya, 16, "0"));

			if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_OPERACION)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("100"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.INTERESADO_OTRO_INMUEBLE_AREA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("101"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.INTERESADO_OTRO_INMUEBLE_OTRO_AREA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("102"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_NADA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("103"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.EXCESIVO_TIEMPO_FIRMA_RESERVA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("200"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.NO_LOCALIZADO_CLIENTE)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("201"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.LOCALIZADO_SIN_INTERES_FIRMAR)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("202"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.FALTA_FINANCIACION)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("300"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.MAS_1_MES_FIRMAR_RESERVA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("301"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.NO_TIENE_DINERO_SIN_FINANCIACION)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("302"));
			} else if (motivoAnulacionOferta
					.equals(MOTIVO_ANULACION_OFERTA.CIRCURNSTANCIA_DISTINTAS_PACTADAS_DPT_COMERCIAL)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("400"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.NO_FIRMA_RESERVA_SIN_VISITA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("401"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.CAUSAS_FISCALES)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("402"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.CAUSAS_RELATIVAS_GASTOS)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("403"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.CAUSAS_RELATIVAS_ESTADO_FISICO)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("404"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.CARGAS_NO_PLANTEADAS)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("405"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.NO_CUMPLE_CONDICION_BANKIA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("500"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.CLIENTE_NO_AMPLIACION_VALIDEZ)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("501"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.NO_CUMPLE_CONDICION)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("502"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.FUTURO_CUMPLIMIENTO_CONDICION)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("503"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.SOLICITADA_AREA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("600"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.DETECTADO_IRREGULARIDADES_DPTO_COMERCIAL)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("601"));
			} else if (motivoAnulacionOferta
					.equals(MOTIVO_ANULACION_OFERTA.DETECTADO_IRREGULARIDADES_DPTO_ADM_TECNICO)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("602"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.DETECTADO_IRREGULARIDADES_DIRECCION)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("603"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.NO_RATIFICADA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("604"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.MEJOR_OFERTA_POSTERIOR)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("605"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.VENTA_SKY)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("607"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.VENTA_EXTERNA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("608"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.ANULADAS_ESCRITURACION)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("700"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.NO_PRESENTADOS_FIRMA_REQUERIDOS)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("701"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.INCUMPLIMIENTO_PLAZOS_FORMA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("702"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.VENTA_ACTIVO)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("705"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.TRASPASADO_SOLVIA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("706"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.ERROR_USUARIO_1)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("800"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.ERROR_USUARIO_2)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("801"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.VENCIDAS_POR_TIEMPO)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("601"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.ANULADA_POR_VENCIMIENTO)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("601"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.ANULADA_ALTA_NUEVA_FACULTAD_HAYA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("601"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.FINANCIACION_DENEGADA)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("601"));
			} else if (motivoAnulacionOferta.equals(MOTIVO_ANULACION_OFERTA.PBC_DENEGADO)) {
				servicioGMPAJC29_INS.setCOSANOW(new Short("601"));
			}

			servicioGMPAJC29_INS.setnumeroUsuario("");
			servicioGMPAJC29_INS.setidSesionWL("");
			servicioGMPAJC29_INS.setnumeroCliente(0);

			servicioGMPAJC29_INS.setAlias(ALIAS);
			
			executeService(servicioGMPAJC29_INS);

		} catch (WIException wie) {
			errorDesc = wie.getMessage();
			if(errorDesc == null){
				errorDesc = "Error desconocido";
			}
			
			// Si el error que devuelve UVEM es que la oferta ya está anulada en Bankia, no devolvemos el throw para poder avanzar
			// la tarea de Resolución Expediente en REM y anular la oferta.
			if(!errorDesc.contains(ERROR_UVEM_OFERTA_YA_ANULADA)) {
				throw new JsonViewerException("Error anulación oferta (UVEM): " + errorDesc);								
			}
			
		} finally {
			registrarLlamada(servicioGMPAJC29_INS, errorDesc);
		}
	}

	@Override
	public MOTIVO_ANULACION_OFERTA obtenerMotivoAnulacionOfertaPorCodigoMotivoAnulacion(String codigoMotivoAnulacion) {
		if (DDMotivoAnulacionExpediente.CODIGO_COMPRADOR_NO_INTERESADO_OPERACION.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_OPERACION;
		} else if (DDMotivoAnulacionExpediente.CODIGO_INTERESADO_OTRO_INMUEBLE_AREA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.INTERESADO_OTRO_INMUEBLE_AREA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_INTERESADO_OTRO_INMUEBLE_OTRO_AREA
				.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.INTERESADO_OTRO_INMUEBLE_OTRO_AREA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_COMPRADOR_NO_INTERESADO_NADA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_NADA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_EXCESIVO_TIEMPO_FIRMA_RESERVA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.EXCESIVO_TIEMPO_FIRMA_RESERVA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_NO_LOCALIZADO_CLIENTE.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_LOCALIZADO_CLIENTE;
		} else if (DDMotivoAnulacionExpediente.CODIGO_LOCALIZADO_SIN_INTERES_FIRMAR.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.LOCALIZADO_SIN_INTERES_FIRMAR;
		} else if (DDMotivoAnulacionExpediente.CODIGO_FALTA_FINANCIACION.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.FALTA_FINANCIACION;
		} else if (DDMotivoAnulacionExpediente.CODIGO_MAS_1_MES_FIRMAR_RESERVA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.MAS_1_MES_FIRMAR_RESERVA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_NO_TIENE_DINERO_SIN_FINANCIACION.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_TIENE_DINERO_SIN_FINANCIACION;
		} else if (DDMotivoAnulacionExpediente.CODIGO_CIRCUNSTANCIAS_DISTINTAS_PACTADAS_DPT_COMERCIAL
				.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.CIRCURNSTANCIA_DISTINTAS_PACTADAS_DPT_COMERCIAL;
		} else if (DDMotivoAnulacionExpediente.CODIGO_NO_FIRMA_RESERVA_SIN_VISITA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_FIRMA_RESERVA_SIN_VISITA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_CAUSAS_FISCALES.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.CAUSAS_FISCALES;
		} else if (DDMotivoAnulacionExpediente.CODIGO_CAUSAS_RELATIVAS_GASTOS.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.CAUSAS_RELATIVAS_GASTOS;
		} else if (DDMotivoAnulacionExpediente.CODIGO_CAUSAS_RELATIVAS_ESTADO_FISICO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.CAUSAS_RELATIVAS_ESTADO_FISICO;
		} else if (DDMotivoAnulacionExpediente.CODIGO_CARGAS_NO_PLANTEADAS.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.CARGAS_NO_PLANTEADAS;
		} else if (DDMotivoAnulacionExpediente.CODIGO_NO_CUMPLE_CONDICION_BANKIA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_CUMPLE_CONDICION_BANKIA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_CLIENTE_NO_AMPLIACION_VALIDEZ.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.CLIENTE_NO_AMPLIACION_VALIDEZ;
		} else if (DDMotivoAnulacionExpediente.CODIGO_NO_CUMPLE_CONDICION.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_CUMPLE_CONDICION;
		} else if (DDMotivoAnulacionExpediente.CODIGO_FUTURO_CUMPLIMIENTO_CONDICION.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.FUTURO_CUMPLIMIENTO_CONDICION;
		} else if (DDMotivoAnulacionExpediente.CODIGO_SOLICITADA_AREA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.SOLICITADA_AREA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_DETECTADO_IRREGULARIDADES_DPTO_COMERCIAL
				.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.DETECTADO_IRREGULARIDADES_DPTO_COMERCIAL;
		} else if (DDMotivoAnulacionExpediente.CODIGO_DETECTADO_IRREGULARIDADES_DPTO_ADM_TECNICO
				.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.DETECTADO_IRREGULARIDADES_DPTO_ADM_TECNICO;
		} else if (DDMotivoAnulacionExpediente.CODIGO_DETECTADO_IRREGULARIDADES_DIRECCION
				.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.DETECTADO_IRREGULARIDADES_DIRECCION;
		} else if (DDMotivoAnulacionExpediente.CODIGO_NO_RATIFICADA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_RATIFICADA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_MEJOR_OFERTA_POSTERIOR.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.MEJOR_OFERTA_POSTERIOR;
		} else if (DDMotivoAnulacionExpediente.CODIGO_SAREB_RETIRADA_OBRA_CURSO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.SAREB_RETIRADA_OBRA_CURSO;
		} else if (DDMotivoAnulacionExpediente.CODIGO_VENTA_SKY.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.VENTA_SKY;
		} else if (DDMotivoAnulacionExpediente.CODIGO_VENTA_EXTERNA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.VENTA_EXTERNA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_ANULADAS_ESCRITURACION.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.ANULADAS_ESCRITURACION;
		} else if (DDMotivoAnulacionExpediente.CODIGO_NO_PRESENTADOS_FIRMA_REQUERIDOS.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_PRESENTADOS_FIRMA_REQUERIDOS;
		} else if (DDMotivoAnulacionExpediente.CODIGO_INCUMPLIMIENTO_PLAZOS_FORMA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.INCUMPLIMIENTO_PLAZOS_FORMA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_VENTA_ACTIVO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.VENTA_ACTIVO;
		} else if (DDMotivoAnulacionExpediente.CODIGO_TRASPASADO_SOLVIA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.TRASPASADO_SOLVIA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_ERROR_USUARIO_1.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.ERROR_USUARIO_1;
		} else if (DDMotivoAnulacionExpediente.CODIGO_ERROR_USUARIO_2.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.ERROR_USUARIO_2;
		} else if (DDMotivoAnulacionExpediente.CODIGO_VENCIDAS_POR_TIEMPO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.VENCIDAS_POR_TIEMPO;
		} else if (DDMotivoAnulacionExpediente.CODIGO_ANULADA_POR_VENCIMIENTO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.ANULADA_POR_VENCIMIENTO;
		} else if (DDMotivoAnulacionExpediente.CODIGO_ANULADA_ALTA_NUEVA_FACULTAD_HAYA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.ANULADA_ALTA_NUEVA_FACULTAD_HAYA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_FINANCIACION_DENEGADA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.FINANCIACION_DENEGADA;
		} else if (DDMotivoAnulacionExpediente.CODIGO_PBC_DENEGADO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.PBC_DENEGADO;
		} else if (DDMotivoAnulacionExpediente.CODIGO_INCUMPLIMIENTO_PLAZO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.EXCESIVO_TIEMPO_FIRMA_RESERVA;
		}else if (DDMotivoAnulacionExpediente.CODIGO_ORDEN_PROPIEDAD.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.SOLICITADA_AREA;
		}else if (DDMotivoAnulacionExpediente.CODIGO_DESESTIMIENTO_COMPRADOR.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_OPERACION;
		}else if (DDMotivoAnulacionExpediente.CODIGO_3_MESES_SIN_FORMALIZAR.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.EXCESIVO_TIEMPO_FIRMA_RESERVA;
		}else if (DDMotivoAnulacionExpediente.CODIGO_SIN_NOTICIAS_COMPRADOR.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_LOCALIZADO_CLIENTE;
		}else if (DDMotivoAnulacionExpediente.CODIGO_FINANCIACION_RECHAZADA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.FALTA_FINANCIACION;
		}else if (DDMotivoAnulacionExpediente.CODIGO_SIN_DOC_PBC.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.LOCALIZADO_SIN_INTERES_FIRMAR;
		}else if (DDMotivoAnulacionExpediente.CODIGO_PBC_RECHAZADO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.PBC_DENEGADO;
		}else if (DDMotivoAnulacionExpediente.CODIGO_EJERCE_TANTEO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_CUMPLE_CONDICION;
		}else if (DDMotivoAnulacionExpediente.CODIGO_VPO_DENEGADA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.NO_CUMPLE_CONDICION;
		}else if (DDMotivoAnulacionExpediente.CODIGO_INCIDENCIA_JURIDICA_TECNICA.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.CIRCURNSTANCIA_DISTINTAS_PACTADAS_DPT_COMERCIAL;
		}else if (DDMotivoAnulacionExpediente.CODIGO_ALTA_OFERTA_ESPEJO.equals(codigoMotivoAnulacion)) {
			return MOTIVO_ANULACION_OFERTA.ERROR_USUARIO_1;
		}else {
			return null;
		}
	}

	@Override
	public void modificacionesSegunPropuesta(TareaExterna tareaExterna) {

		Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Double porcentajeImpuesto = null;
		if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
			porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
		}

		try {
			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
					.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, null);
			instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_HONORARIOS);
			logger.info("------------ LLAMADA WS MOD3(HONORARIOS) -----------------");
			this.modificarInstanciaDecisionTres(instanciaDecisionDto);
			instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_TITULARES);
			logger.info("------------ LLAMADA WS MOD3(TITULARES) -----------------");
			this.modificarInstanciaDecisionTres(instanciaDecisionDto);
			logger.info("------------ LLAMADA WS MOD3(CONDICIONANTES ECONOMICOS) -----------------");
			instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS);
			this.modificarInstanciaDecisionTres(instanciaDecisionDto);
			logger.info("------------ LLAMADA WS MOD3(FIN) -----------------");
		} catch (JsonViewerException jve) {
			throw new UserException(jve.getMessage());
		} catch (Exception e) {
			logger.error("error en OfertasManager", e);
			throw new UserException(e.getMessage());
		}

	}

	@Override
	public boolean esTramiteOffline(String codigoTarea, ExpedienteComercial expediente) {
		boolean esOffline = false;
		boolean tieneFechaFirmaReserva = false;
		if (!Checks.esNulo(expediente.getReserva()) && !Checks.esNulo(expediente.getReserva().getFechaFirma())) {
			tieneFechaFirmaReserva = true;
		}
		boolean tieneFechaIngresoChequeVenta = false;
		if (!Checks.esNulo(expediente.getFechaContabilizacionPropietario())) {
			tieneFechaIngresoChequeVenta = true;
		}
		if (codigoTarea.equals(UpdaterServiceSancionOfertaInstruccionesReserva.CODIGO_T013_INSTRUCCIONES_RESERVA) 
			|| codigoTarea.equals(UpdaterServiceSancionOfertaInstruccionesReserva.CODIGO_T017_INSTRUCCIONES_RESERVA)) {
			esOffline = tieneFechaFirmaReserva || tieneFechaIngresoChequeVenta;
		} else if (codigoTarea.equals(UpdaterServiceSancionOfertaResultadoPBC.CODIGO_T013_RESULTADO_PBC) || 
				codigoTarea.equals(UpdaterServiceSancionOfertaResultadoPBC.CODIGO_T017_PBC_VENTA)) {
			esOffline = tieneFechaIngresoChequeVenta;
		}
		return esOffline;
	}

}
