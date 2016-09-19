package es.pfsgroup.plugin.rem.api.impl;

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

import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraAplicacionGMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraFuncionalPeticion;
import es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraTecnica;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraAplicacionGMPAJC93_INS;
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

@Service("uvemManager")
public class UvemManager implements UvemManagerApi {

	private final Log logger = LogFactory.getLog(getClass());

	private String URL = "";
	private String ALIAS = "";

	private GMPETS07_INS servicioGMPETS07_INS;

	private GMPAJC93_INS servicioGMJC93_INS;

	private GMPAJC11_INS servicioGMJC11_INS;

	@Resource
	private Properties appProperties;

	private void leerConfiguracion() {
		this.URL = !Checks.esNulo(appProperties.getProperty("rest.client.uvem.url.base"))
				? appProperties.getProperty("rest.client.uvem.url.base") : "";
		this.ALIAS =!Checks.esNulo(appProperties.getProperty("rest.client.uvem.alias.integrador"))
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
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
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
		servicioGMJC11_INS = new GMPAJC11_INS();

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPAJC11_INS.StructCabeceraTecnica cabeceraTecnica = new StructCabeceraTecnica();
		StructCabeceraAplicacionGMPAJC11_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPAJC11_INS();

		// Seteamos cabeceras
		servicioGMJC11_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMJC11_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMJC11_INS.setcabeceraTecnica(cabeceraTecnica);

		// seteamos parametros
		logger.info("CodigoObjetoAccesocopace: CACL0000");
		servicioGMJC11_INS.setCodigoObjetoAccesocopace("CACL0000");
		logger.info("ClaseDeDocumentoIdentificadorcocldo: ".concat(cocldo));
		servicioGMJC11_INS.setClaseDeDocumentoIdentificadorcocldo(cocldo.charAt(0));
		logger.info("DniNifDelTitularDeLaOfertanudnio: ".concat(nudnio));
		servicioGMJC11_INS.setDniNifDelTitularDeLaOfertanudnio(nudnio);
		logger.info("IdentificadorClienteOfertaidclow: 1");
		servicioGMJC11_INS.setIdentificadorClienteOfertaidclow(1);// <----?????????
		logger.info("CodEntidadRepresntClienteUrsusqcenre: ".concat(qcenre));
		servicioGMJC11_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

		servicioGMJC11_INS.setAlias(ALIAS);
		servicioGMJC11_INS.execute();

	}

	@Override
	public GMPAJC11_INS resultadoNumCliente() {
		return servicioGMJC11_INS;
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
		servicioGMJC93_INS = new GMPAJC93_INS();

		// Creamos cabeceras
		es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraFuncionalPeticion cabeceraFuncional = new es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraFuncionalPeticion();
		es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraTecnica cabeceraTecnica = new es.cajamadrid.servicios.GM.GMPAJC93_INS.StructCabeceraTecnica();
		StructCabeceraAplicacionGMPAJC93_INS cabeceraAplicacion = new StructCabeceraAplicacionGMPAJC93_INS();

		// Seteamos cabeceras
		servicioGMJC93_INS.setcabeceraAplicacion(cabeceraAplicacion);
		servicioGMJC93_INS.setcabeceraFuncionalPeticion(cabeceraFuncional);
		servicioGMJC93_INS.setcabeceraTecnica(cabeceraTecnica);

		// seteamos parametros
		logger.info("CodigoObjetoAccesocopace: CACL0000");
		servicioGMJC93_INS.setCodigoObjetoAccesocopace("CACL0000");
		logger.info("IdentificadorDiscriminadorFuncioniddsfu: DF01");
		servicioGMJC93_INS.setIdentificadorDiscriminadorFuncioniddsfu("DF01");
		logger.info("CodEntidadRepresntClienteUrsusqcenre: ".concat(qcenre));
		servicioGMJC93_INS.setCodEntidadRepresntClienteUrsusqcenre(qcenre);

		servicioGMJC93_INS.setAlias(ALIAS);
		servicioGMJC93_INS.execute();

	}

	@Override
	public GMPAJC93_INS resultadoDatosCliente() {
		return servicioGMJC93_INS;

	}

}
