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
import com.gfi.webIntegrator.datatypes.BindElement;

import es.cajamadrid.servicios.ARQ.ImporteMonetario;
import es.cajamadrid.servicios.ARQ.Porcentaje9;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraAplicacionGMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraFuncionalPeticion;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraTecnica;
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
import es.cm.arq.tda.tiposdedatosbase.Moneda;
import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import net.sf.json.JSONObject;

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

	@Override
	public void ejecutarNumCliente(String nudnio, String cocldo, String qcenre) throws WIException {

		logger.info("------------ LLAMADA WS NUMCLIENTE -----------------");
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

		// Seteamos cabeceras
		servicioGMPAJC11_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPAJC11_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPAJC11_INS.setcabeceraTecnica(cabeceraTecnica);

		// seteamos parametros
		logger.info("CodigoObjetoAccesocopace: CACL0000");
		servicioGMPAJC11_INS.setCodigoObjetoAccesocopace("CACL0000");
		logger.info("ClaseDeDocumentoIdentificadorcocldo: ".concat(cocldo));
		servicioGMPAJC11_INS.setClaseDeDocumentoIdentificadorcocldo(cocldo.charAt(0));
		logger.info("DniNifDelTitularDeLaOfertanudnio: ".concat(nudnio));
		servicioGMPAJC11_INS.setDniNifDelTitularDeLaOfertanudnio(nudnio);
		
		servicioGMPAJC11_INS.setnumeroCliente(0);
		servicioGMPAJC11_INS.setnumeroUsuario("");
		HttpServletRequest request = null;
		if (RequestContextHolder.getRequestAttributes() != null) {
			request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		}
		servicioGMPAJC11_INS.setidSesionWL(request != null ? request.getSession().getId() : "");
		
		logger.info("IdentificadorClienteOfertaidclow: 1");
		servicioGMPAJC11_INS.setIdentificadorClienteOfertaidclow(1);// <----?????????
		logger.info("CodEntidadRepresntClienteUrsusqcenre: ".concat(qcenre));
		servicioGMPAJC11_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

		servicioGMPAJC11_INS.setAlias(ALIAS);
		servicioGMPAJC11_INS.execute();

	}

	@Override
	public GMPAJC11_INS resultadoNumCliente() {
		return servicioGMPAJC11_INS;
	}

	@Override
	public void altaInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws WIException {
		instanciaDecision(instanciaDecisionDto, "ALTA");
	}

	@Override
	public void consultarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws WIException {
		instanciaDecision(instanciaDecisionDto, "CONS");
	}

	@Override
	public void modificarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws WIException {
		instanciaDecision(instanciaDecisionDto, "MODI");
	}

	public void instanciaDecision(InstanciaDecisionDto instanciaDecisionDto, String accion) throws WIException {

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

		logger.info("------------ LLAMADA WS InstanciaDecision (" + accion + ") -----------------");
		leerConfiguracion();
		// parametros iniciales
		Hashtable<String, String> htInitParams = new Hashtable<String, String>();
		htInitParams.put(WIService.WORFLOW_PARAM, URL);
		htInitParams.put(WIService.TRANSPORT_TYPE, WIService.TRANSPORT_HTTP);

		WIService.init(htInitParams);

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraFuncionalPeticion();
		cabeceraFuncional.setIDDSAQ(accion);
		es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPDJB13_INS.StructCabeceraTecnica();
		StructCabeceraAplicacionGMPDJB13_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPDJB13_INS();

		// Seteamos cabeceras
		servicioGMPDJB13_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPDJB13_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPDJB13_INS.setcabeceraTecnica(cabeceraTecnica);

		// seteamos parametros
		logger.info("CodigoObjetoAccesocopace: PRAC0170");
		servicioGMPDJB13_INS.setCodigoObjetoAccesocopace("PRAC0170");
		logger.info("CodigoDeOfertaHayacoofhx: " + instanciaDecisionDto.getCodigoDeOfertaHaya());
		servicioGMPDJB13_INS.setCodigoDeOfertaHayacoofhx(instanciaDecisionDto.getCodigoDeOfertaHaya());
		if (instanciaDecisionDto.isFinanciacionCliente()) {
			logger.info("IndicadorDeFinanciacionClientebificl: " + instanciaDecisionDto.FINANCIACION_CLIENTE_SI);
			servicioGMPDJB13_INS.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_SI);
		} else {
			logger.info("IndicadorDeFinanciacionClientebificl: " + instanciaDecisionDto.FINANCIACION_CLIENTE_NO);
			servicioGMPDJB13_INS.setIndicadorDeFinanciacionClientebificl(instanciaDecisionDto.FINANCIACION_CLIENTE_NO);
		}
		if (instanciaDecisionDto.isFinanciacionCliente()) {
			logger.info("TipoPropuestacotprw: " + instanciaDecisionDto.PROPUESTA_VENTA);
			servicioGMPDJB13_INS.setTipoPropuestacotprw(instanciaDecisionDto.PROPUESTA_VENTA);
		} else {
			logger.info("TipoPropuestacotprw: " + instanciaDecisionDto.PROPUESTA_CONTRAOFERTA);
			servicioGMPDJB13_INS.setTipoPropuestacotprw(instanciaDecisionDto.PROPUESTA_CONTRAOFERTA);
		}

		logger.info("NumeroDeOcurrenciasnumocu :" + JSONObject.fromObject(numeroOcurrencias));
		servicioGMPDJB13_INS.setNumeroDeOcurrenciasnumocu(numeroOcurrencias);

		servicioGMPDJB13_INS.setAlias(ALIAS);
		servicioGMPDJB13_INS.execute();

	}
	
	@Override
	public GMPDJB13_INS resultadoInstanciaDecision(){
		return servicioGMPDJB13_INS;
	}

	@Override
	public void ejecutarDatosCliente(Long idclow, String qcenre) throws WIException {
		logger.info("------------ LLAMADA WS DatosCliente -----------------");
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

		// Seteamos cabeceras
		servicioGMPAJC93_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMPAJC93_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMPAJC93_INS.setcabeceraTecnica(cabeceraTecnica);

		// seteamos parametros
		logger.info("CodigoObjetoAccesocopace: CACL0000");
		servicioGMPAJC93_INS.setCodigoObjetoAccesocopace("CACL0000");
		logger.info("IdentificadorDiscriminadorFuncioniddsfu: DF01");
		servicioGMPAJC93_INS.setIdentificadorDiscriminadorFuncioniddsfu("DF01");
		logger.info("CodEntidadRepresntClienteUrsusqcenre: ".concat(qcenre));
		servicioGMPAJC93_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

		servicioGMPAJC93_INS.setAlias(ALIAS);
		servicioGMPAJC93_INS.execute();

	}

	@Override
	public GMPAJC93_INS resultadoDatosCliente() {
		return servicioGMPAJC93_INS;

	}

	@Override
	public void consultaDatosPrestamo(String numExpedienteRiesgo, int tipoRiesgo) throws WIException {
		
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
		
		// seteamos parametros
		logger.info("CodigoObjetoAccesocopace: CACL0000");
		servicioGMPAJC34_INS.setCodigoObjetoAccesocopace("CACL0000");
		logger.info("numExpedienteRiesgo: "+numExpedienteRiesgo);
		servicioGMPAJC34_INS.setNumeroExpedienteDeRiesgoNumericonuidow(numExpedienteRiesgo);
		logger.info("tipoRiesgo: "+tipoRiesgo);
		servicioGMPAJC34_INS.setTipoRiesgoClaseProductoUrsusCotirx(tipoRiesgo);
		servicioGMPAJC34_INS.setAlias(ALIAS);
		servicioGMPAJC34_INS.execute();
		
	}
	
	@Override
	public GMPAJC34_INS resultadoConsultaDatosPrestamo() {
		return servicioGMPAJC34_INS;
	}

}
