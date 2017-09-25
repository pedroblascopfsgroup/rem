package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
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
import es.cajamadrid.servicios.GM.GMPTOE83_INS.GMPTOE83_INS;
import es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraAplicacionGMPTOE83_INS;
import es.capgemini.pfs.users.domain.Usuario;
import es.cm.arq.tda.tiposdedatosbase.CantidadDecimal15;
import es.cm.arq.tda.tiposdedatosbase.Fecha;
import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
import es.pfsgroup.plugin.rem.rest.dto.ClienteUrsusRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;

@Service("uvemManager")
public class UvemManager implements UvemManagerApi {

	private final Log logger = LogFactory.getLog(getClass());

	private final String INSTANCIA_DECISION_ALTA = "ALTA";
	private final String INSTANCIA_DECISION_CONSULTA = "CONS";
	private final String INSTANCIA_DECISION_MODIFICACION = "MODI";

	private String URL = "";
	private String ALIAS = "";

	private GMPETS07_INS servicioGMPETS07_INS;

	private GMPAJC93_INS servicioGMPAJC93_INS;

	private GMPAJC11_INS servicioGMPAJC11_INS;

	// O-RB-PTMO – servicio GMPAJC34
	private GMPAJC34_INS servicioGMPAJC34_INS;

	// O-RB-FFDD - servicio GMPDJB13
	private GMPDJB13_INS servicioGMPDJB13_INS;

	// 10. O-RB-DEVOL - servicio GMOE83
	private GMPTOE83_INS servicioGMPTOE83_INS;

	@Resource
	private Properties appProperties;

	@Autowired
	private RestLlamadaDao llamadaDao;

	private void iniciarServicio() throws WIException {
		if (appProperties == null) {
			// esto solo se ejecuta desde el jar ejecutable de pruebas. No
			// podemos usar log4j
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

		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);
	}
	
	private void registrarLlamada(WIService servicio,String errorDesc){
		this.registrarLlamada(servicio.getClass().getName(),servicio.getInParams().toXMLGeneric(true),
				servicio.getOutParams().toXMLGeneric(true),errorDesc);		
	}

	private void registrarLlamada(String endPoint, String request, String result, String errorDesc) {
		RestLlamada registro = new RestLlamada();
		registro.setMetodo("WEBSERVICE");
		registro.setEndpoint(endPoint);
		registro.setRequest(request);
		if (!Checks.esNulo(errorDesc)) {
			registro.setErrorDesc(errorDesc);
		}
		try {
			registro.setResponse(result);
			llamadaDao.guardaRegistro(registro);
		} catch (Exception e) {
			logger.error("Error al trazar la llamada al CDM", e);
		}
	}

	/**
	 * Invoca al servicio GMPETS07_INS de BANKIA para solicitar una Tasación
	 * 
	 * @param numActivoUvem
	 * @param userName
	 * @param email
	 * @param telefono
	 * @return
	 * @throws Exception
	 */
	public Integer ejecutarSolicitarTasacionTest(Long numActivoUvem, String userName, String email, String telefono)
			throws Exception {
		Usuario usuario = new Usuario();
		usuario.setUsername(userName);
		usuario.setEmail(email);
		usuario.setTelefono(telefono);
		return ejecutarSolicitarTasacion(numActivoUvem, usuario);
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
			servicioGMPETS07_INS.execute();

			// recuperando resultado...
			numeroIdentificadorTasacion = servicioGMPETS07_INS.getNumeroIdentificadorDeTasacionlnuita2();

	
		} catch (WIMetaServiceException e) {
			logger.error("error en UvemManager", e);
			errorDesc = e.getMessage();
			throw new JsonViewerException(e.getMessage());
		} catch (WIException e) {
			logger.error("error en UvemManager", e);
			errorDesc = e.getMessage();
			throw new JsonViewerException(e.getMessage());
		} catch (TipoDeDatoException e) {
			logger.error("error en UvemManager", e);
			errorDesc = e.getMessage();
			throw new JsonViewerException(e.getMessage());
		} finally {
			registrarLlamada(servicioGMPETS07_INS, errorDesc);
		}

		return numeroIdentificadorTasacion;
	}

	public GMPETS07_INS resultadoSolicitarTasacion() {
		return servicioGMPETS07_INS;
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

		ClienteUrsusRequestDto clienteUrsusRequestDto = new ClienteUrsusRequestDto();
		List<DatosClienteDto> listaClientes = null;
		List<DatosClienteDto> listaClientesFinal = new ArrayList<DatosClienteDto>();
		Boolean paginar = false;
		

		clienteUrsusRequestDto = this.ejecutarNumCliente(nDocumento, tipoDocumento, qcenre, String.valueOf(0));
		
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
					if (!Checks.esNulo(listaClientes) && listaClientes.size() > 0) {
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
			servicioGMPAJC11_INS.execute();

			
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
			logger.error("error en UvemManager", e);
			errorDesc = e.getMessage();
			throw new JsonViewerException(e.getMessage());
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
		if (clientes != null && clientes.size() > 0) {
			if (clientes.get(0).getNumeroClienteUrsus() != null && !clientes.get(0).getNumeroClienteUrsus().isEmpty()) {
				resultado = ejecutarDatosCliente(Integer.valueOf(clientes.get(0).getNumeroClienteUrsus()), qcenre);
			}

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
			servicioGMPAJC93_INS.execute();

			
			datos = new DatosClienteDto();
			datos.setNumeroClienteUrsus(numcliente.toString());
			datos.setClaseDeDocumentoIdentificador(servicioGMPAJC93_INS.getClaseDeDocumentoIdentificadorcocldo() + "");
			datos.setDniNifDelTitularDeLaOferta(servicioGMPAJC93_INS.getDniNifDelTitularDeLaOfertanudnio().toString());
			datos.setNombreYApellidosTitularDeOferta(
					servicioGMPAJC93_INS.getNombreYApellidosTitularDeOfertanotiof().toString());
			datos.setNombreDelCliente(servicioGMPAJC93_INS.getNombreDelClientenoclie().toString());
			datos.setPrimerApellido(servicioGMPAJC93_INS.getPrimerApellidonoape1().toString());
			datos.setSegundoApellido(servicioGMPAJC93_INS.getSegundoApellidonoape2().toString());
			datos.setCodigoTipoDeVia(servicioGMPAJC93_INS.getCodigoTipoDeViacotivw() + "");
			datos.setDenominacionTipoDeViaTrabajo(
					servicioGMPAJC93_INS.getDenominacionTipoDeViaTrabajoNotiv1().toString());
			datos.setNombreDeLaVia(servicioGMPAJC93_INS.getNombreDeLaVianovisa().toString());
			datos.setPORTAL(servicioGMPAJC93_INS.getPORTALNUPORO().toString());
			datos.setESCALERA(servicioGMPAJC93_INS.getESCALERANUESCL() + "");
			datos.setPISO(servicioGMPAJC93_INS.getPISONUPICL().toString());
			datos.setNumeroDePuerta(servicioGMPAJC93_INS.getNumeroDePuertanupucl() + "");
			datos.setCodigoPostal(servicioGMPAJC93_INS.getCodigoPostalcopoiw() + "");
			datos.setNombreDelMunicipio(servicioGMPAJC93_INS.getNombreDelMunicipionomusa().toString());
			datos.setNombreDeLaProvincia(servicioGMPAJC93_INS.getNombreDeLaProvincianoprsa().toString());
			datos.setCodigoDeProvincia(servicioGMPAJC93_INS.getCodigoDeProvinciacoprvw() + "");
			datos.setNombreDePaisDelDomicilio(servicioGMPAJC93_INS.getNombreDePaisDelDomicilionopado().toString());
			datos.setDatosComplementariosDelDomicilio(
					servicioGMPAJC93_INS.getDatosComplementariosDelDomicilioobdom1().toString());
			datos.setBarrioColoniaOApartado(servicioGMPAJC93_INS.getBarrioColoniaOApartadonobar2().toString());
			datos.setEdadDelCliente(servicioGMPAJC93_INS.getEdadDelClientenuedaw() + "");
			datos.setCodigoEstadoCivil(servicioGMPAJC93_INS.getCodigoEstadoCivilcoesci() + "");
			datos.setEstadoCivilActual(servicioGMPAJC93_INS.getEstadoCivilActualcoesc1().toString());
			datos.setNumeroDeHijos(servicioGMPAJC93_INS.getNumeroDeHijosnuhijw() + "");
			datos.setSEXO(servicioGMPAJC93_INS.getSEXOCOSEXO() + "");
			datos.setNombreComercialDeLaEmpresa(servicioGMPAJC93_INS.getNombreComercialDeLaEmpresanocome().toString());
			datos.setDELEGACION(servicioGMPAJC93_INS.getDELEGACIONXDELEG().toString());
			datos.setTipoDeSociedad(servicioGMPAJC93_INS.getTipoDeSociedadcodem1().toString());
			datos.setCodigoDeSituacionDelCliente(servicioGMPAJC93_INS.getCodigoDeSituacionDelClientecosicx() + "");
			datos.setNombreDeLaSituacionDelCliente(
					servicioGMPAJC93_INS.getNombreDeLaSituacionDelClientenosicl().toString());
			datos.setFechaDeNacimientoOConstitucion(
					servicioGMPAJC93_INS.getFechaDeNacimientoOConstitucionfenacw().toString());
			datos.setNombreDelPaisDeNacimiento(servicioGMPAJC93_INS.getNombreDelPaisDeNacimientonopanc().toString());
			datos.setNombreDeLaProvinciaNacimiento(
					servicioGMPAJC93_INS.getNombreDeLaProvinciaNacimientonoprnc().toString());
			datos.setNombreDePoblacionDeNacimiento(
					servicioGMPAJC93_INS.getNombreDePoblacionDeNacimientonopobn().toString());
			datos.setNombreDePaisNacionalidad(servicioGMPAJC93_INS.getNombreDePaisNacionalidadnopana().toString());
			datos.setNombreDePaisResidencia(servicioGMPAJC93_INS.getNombreDePaisResidencianopars().toString());
			datos.setSubsectorDeActividadEconomica(
					servicioGMPAJC93_INS.getSubsectorDeActividadEconomicanossec().toString());
			if (!Checks.esNulo(servicioGMPAJC93_INS.getIdentClienteConyugeOfertaidclww())) {
				datos.setNumeroClienteUrsusConyuge(
						Integer.valueOf(servicioGMPAJC93_INS.getIdentClienteConyugeOfertaidclww()).toString());
			}

		} catch (WIException e) {
			logger.error("error en UvemManager", e);
			errorDesc = e.getMessage();
			throw new JsonViewerException(e.getMessage());
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
			instancia = instanciaDecision(instanciaDecisionDto, INSTANCIA_DECISION_ALTA);
		} catch (WIException e) {
			logger.error("error en UvemManager", e);
			throw new JsonViewerException(e.getMessage());
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
			instancia = instanciaDecision(instanciaDecisionDto, INSTANCIA_DECISION_CONSULTA);
		} catch (WIException e) {
			logger.error("error en UvemManager", e);
			throw new JsonViewerException(e.getMessage());
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
		try {
			instancia = instanciaDecision(instanciaDecisionDto, INSTANCIA_DECISION_MODIFICACION);
		} catch (WIException e) {
			logger.error("error en UvemManager", e);
			throw new JsonViewerException(e.getMessage());
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
	public ResultadoInstanciaDecisionDto instanciaDecision(InstanciaDecisionDto instanciaDecisionDto, String accion)
			throws WIException {
		logger.info("------------ LLAMADA WS INSTANCIADECISION -----------------");
		String errorDesc = null;
		ResultadoInstanciaDecisionDto result = new ResultadoInstanciaDecisionDto();
		VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu numeroOcurrencias = new VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu();

		List<InstanciaDecisionDataDto> instanciaListData = instanciaDecisionDto.getData();
		if (Checks.esNulo(instanciaListData) || (!Checks.esNulo(instanciaListData) && instanciaListData.size() == 0)) {
			throw new WIException("El campo data de la instancia es obligatorio.");
		}

		// Bucle para cargar el array numOcurrencias con la info de cada
		// activo
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
				porcentajeImpuesto.setNumDecimales("BC");
				struct.setPorcentajeImpuestoBISA(porcentajeImpuesto);
			}

			// IndicadorTratamientoImpuesto

			if (Checks.esNulo(instanciaData.getTipoDeImpuesto())) {
				throw new WIException("El tipo de impuesto no puede estar vacío.");
			} else {

				if (instanciaData.getTipoDeImpuesto() == InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP
						|| instanciaData.getTipoDeImpuesto() == InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC
						|| instanciaData.getTipoDeImpuesto() == InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI) {
					// struct.setIndicadorTratamientoImpuestobitrim(vacio);
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

			// seteamos parametros
			servicioGMPDJB13_INS.setCodigoObjetoAccesocopace("PAHY0170");
			servicioGMPDJB13_INS.setCodigoDeOfertaHayacoofhx(
					StringUtils.leftPad(instanciaDecisionDto.getCodigoDeOfertaHaya(), 16, "0"));
			if (instanciaDecisionDto.isFinanciacionCliente()) {
				servicioGMPDJB13_INS
						.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_SI);
			} else {
				servicioGMPDJB13_INS
						.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_NO);
			}
			// Según llamada telefonica con Antonio Rios Muñoz(Atos Origin)
			if (accion.equals(INSTANCIA_DECISION_MODIFICACION)) {
				servicioGMPDJB13_INS.setTipoPropuestacotprw(InstanciaDecisionDataDto.PROPUESTA_CONTRAOFERTA);
			} else {
				servicioGMPDJB13_INS.setTipoPropuestacotprw(InstanciaDecisionDataDto.PROPUESTA_VENTA);
			}

			if (numeroOcurrencias != null) {
				servicioGMPDJB13_INS.setNumeroDeOcurrenciasnumocu(numeroOcurrencias);
			}
			// Requeridos por el servicio
			servicioGMPDJB13_INS.setnumeroCliente(0);
			servicioGMPDJB13_INS.setnumeroUsuario("");
			servicioGMPDJB13_INS.setidSesionWL("");

			
			servicioGMPDJB13_INS.setAlias(ALIAS);
			servicioGMPDJB13_INS.execute();

			
			result.setLongitudMensajeSalida(servicioGMPDJB13_INS.getLongitudMensajeDeSalidarcslon());
			result.setCodigoComite(servicioGMPDJB13_INS.getCodigoComitecocom7() + "");
			result.setCodigoDeOfertaHaya(servicioGMPDJB13_INS.getCodigoDeOfertaHayacoofhx2());

		} catch (WIException e) {
			logger.error("error en UvemManager", e);
			errorDesc = e.getMessage();
			throw new JsonViewerException(e.getMessage());
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

			
			// seteamos parametros
			servicioGMPAJC34_INS.setCodigoObjetoAccesocopace("PAHY0370");
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
			servicioGMPAJC34_INS.execute();

			importe = servicioGMPAJC34_INS.getImporteMonetarioConcedido();

			logger.info("ImporteMonetarioConcedido: " + servicioGMPAJC34_INS.getImporteMonetarioConcedido());

			if (importe == null) {
				throw new WIException("No se han encontrado datos con la información suministrada");
			}

		} catch (WIException wie) {
			logger.error("error en UvemManager", wie);
			errorDesc = wie.getMessage();
			throw new JsonViewerException(wie.getMessage());
		} finally {
			registrarLlamada(servicioGMPAJC34_INS, errorDesc);
		}

		return importe.getImporteComoLong();

	}

	@Override
	public List<DatosClienteDto> ejecutarNumClienteTest(String nDocumento, String tipoDocumento, String qcenre)
			throws Exception {

		List<DatosClienteDto> lista = new ArrayList<DatosClienteDto>();

		DatosClienteDto cliente1 = new DatosClienteDto();
		cliente1.setNumeroClienteUrsus("578773");
		cliente1.setDniNifDelTitularDeLaOferta("1111111A");
		cliente1.setNombreYApellidosTitularDeOferta("Primero de la Lista");
		lista.add(cliente1);

		DatosClienteDto cliente2 = new DatosClienteDto();
		cliente2.setNumeroClienteUrsus("247311");
		cliente2.setDniNifDelTitularDeLaOferta("2222222B");
		cliente2.setNombreYApellidosTitularDeOferta("Segundo de la Lista");
		lista.add(cliente2);

		return lista;
	}

	@Override
	public DatosClienteDto ejecutarDatosClienteTest(Integer numcliente, String qcenre) throws Exception {
		DatosClienteDto dto = new DatosClienteDto();

		if (numcliente == 578773) {
			dto.setBarrioColoniaOApartado("BARRIO DE LA ESTACION");
			dto.setClaseDeDocumentoIdentificador("1");
			dto.setCodigoDeProvincia("28");
			dto.setCodigoDeSituacionDelCliente("0");
			dto.setCodigoEstadoCivil("1");
			dto.setCodigoPostal("28820");
			dto.setCodigoTipoDeVia("1");
			dto.setDELEGACION("none");
			dto.setDatosComplementariosDelDomicilio("nyan nyan");
			dto.setDenominacionTipoDeViaTrabajo("CA");
			dto.setDniNifDelTitularDeLaOferta("1111111A");
			dto.setESCALERA("1");
			dto.setEdadDelCliente("51");
			dto.setEstadoCivilActual("SOLTERO");
			dto.setFechaDeNacimientoOConstitucion("1965-05-02");
			dto.setNombreComercialDeLaEmpresa("none");
			dto.setNombreDeLaProvincia("MADRID");
			dto.setNombreDeLaProvinciaNacimiento("MADRID");
			dto.setNombreDeLaSituacionDelCliente("none");
			dto.setNombreDeLaVia("ARGENTINA");
			dto.setNombreDePaisDelDomicilio("ESPAÑA");
			dto.setNombreDePaisNacionalidad("ESPAÑA");
			dto.setNombreDePaisResidencia("ESPAÑA");
			dto.setNombreDePoblacionDeNacimiento("MADRID");
			dto.setNombreDelCliente("TIN");
			dto.setNombreDelMunicipio("PARQUE DE BOADILLA");
			dto.setNombreDelPaisDeNacimiento("ESPAÑA");
			dto.setNombreYApellidosTitularDeOferta("TIN TUN CHANG");
			dto.setNumeroClienteUrsus("578773");
			dto.setNumeroClienteUrsusConyuge("0");
			dto.setNumeroDeHijos("0");
			dto.setNumeroDePuerta("A");
			dto.setPISO("03");
			dto.setPORTAL("0020");
			dto.setPrimerApellido("TUN");
			dto.setSEXO("V");
			dto.setSegundoApellido("CHANG");
			dto.setSubsectorDeActividadEconomica("HOGARES Y EMPRESARIOS INDIVIDUALES");
			dto.setTipoDeSociedad("none");
		} else if (numcliente == 247311) {
			dto.setBarrioColoniaOApartado("Un bonito lugar");
			dto.setClaseDeDocumentoIdentificador("1");
			dto.setCodigoDeProvincia("28");
			dto.setCodigoDeSituacionDelCliente("0");
			dto.setCodigoEstadoCivil("1");
			dto.setCodigoPostal("46820");
			dto.setCodigoTipoDeVia("1");
			dto.setDELEGACION("none");
			dto.setDatosComplementariosDelDomicilio("mismo");
			dto.setDenominacionTipoDeViaTrabajo("CA");
			dto.setDniNifDelTitularDeLaOferta("2222222B");
			dto.setESCALERA("3");
			dto.setEdadDelCliente("37");
			dto.setEstadoCivilActual("SOLTERO");
			dto.setFechaDeNacimientoOConstitucion("1980-05-02");
			dto.setNombreComercialDeLaEmpresa("none");
			dto.setNombreDeLaProvincia("VALENCIA");
			dto.setNombreDeLaProvinciaNacimiento("VALENCIA");
			dto.setNombreDeLaSituacionDelCliente("none");
			dto.setNombreDeLaVia("de los santos");
			dto.setNombreDePaisDelDomicilio("ESPAÑA");
			dto.setNombreDePaisNacionalidad("ESPAÑA");
			dto.setNombreDePaisResidencia("ESPAÑA");
			dto.setNombreDePoblacionDeNacimiento("VALENCIA");
			dto.setNombreDelCliente("Enrique");
			dto.setNombreDelMunicipio("paterna");
			dto.setNombreDelPaisDeNacimiento("ESPAÑA");
			dto.setNombreYApellidosTitularDeOferta("Enrique cidocon avecrem");
			dto.setNumeroClienteUrsus("247311");
			dto.setNumeroClienteUrsusConyuge("0");
			dto.setNumeroDeHijos("0");
			dto.setNumeroDePuerta("B");
			dto.setPISO("01");
			dto.setPORTAL("0020");
			dto.setPrimerApellido("cidocon");
			dto.setSEXO("V");
			dto.setSegundoApellido("avecrem");
			dto.setSubsectorDeActividadEconomica("Cocinero masterchef");
			dto.setTipoDeSociedad("none");
		}

		return dto;
	}

	@Override
	public void notificarDevolucionReserva(String codigoDeOfertaHaya, MOTIVO_ANULACION motivoAnulacionReserva,
			INDICADOR_DEVOLUCION_RESERVA indicadorDevolucionReserva,
			CODIGO_SERVICIO_MODIFICACION codigoServicioModificacion) throws Exception {
		servicioGMPTOE83_INS = new GMPTOE83_INS();
		String errorDesc = null;
		try {
			iniciarServicio();

			// Creamos cabeceras
			es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraFuncionalPeticion();
			es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPTOE83_INS.StructCabeceraTecnica();
			StructCabeceraAplicacionGMPTOE83_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPTOE83_INS();

			// campos cabecera técnica
			cabeceraTecnica.setCOAPAQ("GM");
			cabeceraTecnica.setCOSRAQ("PTOE83");
			cabeceraTecnica.setNUVEAQ("01");
			cabeceraTecnica.setCLORAQ("71");
			cabeceraTecnica.setIDORAQ("20380000000000000000");
			cabeceraTecnica.setCLIUAQ("55");
			// FEIUAQ,IDUSAQ,IDUTAQ
			cabeceraTecnica.setCOMJAQ("S");
			cabeceraTecnica.setCOPRAQ("P");
			cabeceraTecnica.setBIEMAQ("1");
			cabeceraTecnica.setCOFFAQ("0");
			cabeceraTecnica.setCOFMAQ("B");
			cabeceraTecnica.setCOFTAQ("0");
			cabeceraTecnica.setNUVSAQ("01");
			cabeceraTecnica.setCONTAQ("global:ENTORNO_OPERATIVA_J2EE");
			cabeceraTecnica.setCOAFAQ("GM");
			cabeceraTecnica.setCOMLAQ("OE83");

			// campos cabecera funcional
			cabeceraFuncional.setCOOOAQ("1");
			// FXOPAQ,PTROAQ

			// campos cabecera aplicación
			// COPACE
			cabeceraAplicacion.setCodigoObjetoAccesocopace("PAHY0770");
			// COCGUS
			cabeceraAplicacion.setCentroGestorUsuarioSsacocgus("0562");

			// Seteamos cabeceras
			servicioGMPTOE83_INS.setcabeceraAplicacion(cabeceraAplicacion);
			servicioGMPTOE83_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
			servicioGMPTOE83_INS.setcabeceraTecnica(cabeceraTecnica);

			// COUSAE
			servicioGMPTOE83_INS.setCodigoDeUsuariocousae("USRHAYA");
			// COSEM1
			if (codigoServicioModificacion.equals(CODIGO_SERVICIO_MODIFICACION.PROPUESTA_ANULACION_RESERVA_FIRMADA)) {
				servicioGMPTOE83_INS.setCodigoServicioModificacionSolicitcosem1('4');
			} else {
				servicioGMPTOE83_INS.setCodigoServicioModificacionSolicitcosem1('5');
			}

			// LCOMOA
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
			} else {
				throw new Exception("motivo anulacion no soportado");
			}
			// COOFHX
			servicioGMPTOE83_INS.setCodigoDeOfertaHayacoofhx(StringUtils.leftPad(codigoDeOfertaHaya, 16, "0"));
			// BINDRE
			if (indicadorDevolucionReserva.equals(INDICADOR_DEVOLUCION_RESERVA.DEVOLUCION_RESERVA)) {
				servicioGMPTOE83_INS.setIndicadorDevolucionReservabindre('s');
			} else {
				servicioGMPTOE83_INS.setIndicadorDevolucionReservabindre('N');
			}

			servicioGMPETS07_INS.setAlias(ALIAS);
			servicioGMPETS07_INS.execute();

		} catch (WIException wie) {
			logger.error("error en UvemManager", wie);
			errorDesc = wie.getMessage();
			throw new JsonViewerException(wie.getMessage());
		} finally {
			registrarLlamada(servicioGMPTOE83_INS, errorDesc);
		}

	}
}
