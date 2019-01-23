package es.pfsgroup.plugin.rem.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi.MOTIVO_ANULACION_OFERTA;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;

@Controller
public class UVEMController {

	@Autowired
	private UvemManagerApi uvemManagerApi;

	@Autowired
	private RestApi restApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericAdapter adapter;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Ejecuta instanciaDecision
	 * 
	 * @param req
	 * @param model
	 * @param idOfertaRem
	 * @param accion
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView instanciaDecision(HttpServletRequest req, ModelMap model,
			@RequestParam(required = true) Long idOfertaRem, @RequestParam(required = true) String accion) {
		try {
			restApi.simulateRestFilter(req);
			Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(idOfertaRem);
			if(oferta == null){
				throw new Exception("la oferta no existe");
			}
			ExpedienteComercial expediente = expedienteComercialApi.findOneByOferta(oferta);
			if (expediente == null) {
				throw new Exception("la oferta no tiene expediente comercial");
			}
			accion = accion.toLowerCase();
			ResultadoInstanciaDecisionDto resultadoDto = null;
			Double porcentajeImpuesto = null;
			if (!Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
				}
			}
			InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
					.expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, null);
			if (accion.equals("alta")) {
				if (porcentajeImpuesto == null) {
					throw new Exception("El % de impuesto debe estar informado");
				}

				resultadoDto = uvemManagerApi.altaInstanciaDecision(instanciaDecisionDto);

			} else if (accion.equals("consulta")) {
				resultadoDto = uvemManagerApi.consultarInstanciaDecision(instanciaDecisionDto);
			} else if (accion.equals("modificar")) {
				resultadoDto = uvemManagerApi.modificarInstanciaDecision(instanciaDecisionDto);
			} else if (accion.equals("modificar_honorarios")) {
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_HONORARIOS);
				resultadoDto = uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);
			} else if (accion.equals("modificar_titulares")) {
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_TITULARES);
				resultadoDto = uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);
			} else if (accion.equals("modificar_condicionantes")) {
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS);
				resultadoDto = uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);
			} else {
				throw new Exception("la acción no existe");
			}
			model.put("resultado", resultadoDto);

		} catch (Exception e) {
			logger.error("error en UVEMController", e);
			model.put("result", false);
			model.put("error", true);
			model.put("errorDesc", e.getMessage());
		}

		return new ModelAndView("jsonView", model);
	}

	/**
	 * Anula una oferta
	 * 
	 * @param req
	 * @param model
	 * @param bienId
	 * @param codigoDeOfertaHaya
	 * @param codigoMotivoAnulacion
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView anularOferta(HttpServletRequest req, ModelMap model,
			@RequestParam(required = true) String codigoDeOfertaHaya,
			@RequestParam(required = true) String codigoMotivoAnulacion) {
		try {
			restApi.simulateRestFilter(req);

			MOTIVO_ANULACION_OFERTA motivoAnulacionOferta = uvemManagerApi
					.obtenerMotivoAnulacionOfertaPorCodigoMotivoAnulacion(codigoMotivoAnulacion);

			if (motivoAnulacionOferta == null) {
				throw new Exception("El codigoMotivoAnulacion no existe");
			}

			uvemManagerApi.anularOferta(codigoDeOfertaHaya, motivoAnulacionOferta);
			model.put("codigoDeOfertaHaya", codigoDeOfertaHaya);
			model.put("motivoAnulacionOferta", codigoMotivoAnulacion);
		} catch (Exception e) {
			logger.error("error en UVEMController", e);
			model.put("result", false);
			model.put("error", true);
			model.put("errorDesc", e.getMessage());
		}

		return new ModelAndView("jsonView", model);
	}

	/**
	 * Solicita la tasacion de un bien
	 * 
	 * @param model
	 * @param numActivoUvem:
	 *            El id del bien
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView solicitarTasacion(HttpServletRequest req, ModelMap model,
			@RequestParam(required = true) Long numActivoUvem) {
		try {
			restApi.simulateRestFilter(req);
			Activo activo = activoApi.getByNumActivoUvem(numActivoUvem);
			if (activo == null) {
				throw new Exception("El activo no existe");
			}

			Integer tasacionID = uvemManagerApi.ejecutarSolicitarTasacion(activo.getNumActivoUvem(),
					adapter.getUsuarioLogado());
			model.put("numeroIdentificadorTasacion", tasacionID);
		} catch (Exception e) {
			logger.error("error en UVEMController", e);
			model.put("error", true);
			model.put("errorDesc", e.getMessage());
		}

		return new ModelAndView("jsonView", model);
	}

	/**
	 * Servicio que a partir del nº y tipo de documento, así como Entidad del
	 * Cliente (y tipo) devolverá el/los nº cliente/s Ursus coincidentes
	 * 
	 * @param model
	 * @param nDocumento:
	 *            Documento según lo expresado en COCLDO. DNI, CIF, etc
	 * @param tipoDocumento:
	 *            Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param idclow:
	 *            Identificador Cliente Oferta
	 * @param qcenre:
	 *            Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia
	 *            habitat 05021
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView datosCliente(HttpServletRequest req, ModelMap model,
			@RequestParam(required = true) String nDocumento, @RequestParam(required = true) String tipoDocumento,
			@RequestParam(required = false) String qcenre) {

		try {
			restApi.simulateRestFilter(req);
			// si la entidad es null asumimos bankia
			if (qcenre == null || qcenre.isEmpty()) {
				qcenre = "00000";
			}
			DtoClienteUrsus clienteUrsus = new DtoClienteUrsus();
			clienteUrsus.setNumDocumento(nDocumento);
			clienteUrsus.setTipoDocumento(tipoDocumento);
			clienteUrsus.setQcenre(qcenre);

			DatosClienteDto datosClienteIns = uvemManagerApi.ejecutarDatosClientePorDocumento(clienteUrsus);

			model.put("ClaseDeDocumentoIdentificador", datosClienteIns.getClaseDeDocumentoIdentificador());
			model.put("DniNifDelTitularDeLaOferta", datosClienteIns.getDniNifDelTitularDeLaOferta());
			model.put("NombreYApellidosTitularDeOferta", datosClienteIns.getNombreYApellidosTitularDeOferta());
			model.put("NombreDelCliente", datosClienteIns.getNombreDelCliente());
			model.put("PrimerApellido", datosClienteIns.getPrimerApellido());
			model.put("SegundoApellido", datosClienteIns.getSegundoApellido());
			model.put("CodigoTipoDeVia", datosClienteIns.getCodigoTipoDeVia());
			model.put("DenominacionTipoDeViaTrabajo", datosClienteIns.getDenominacionTipoDeViaTrabajo());
			model.put("NombreDeLaVia", datosClienteIns.getNombreDeLaVia());
			model.put("PORTAL", datosClienteIns.getPORTAL());
			model.put("ESCALERA", datosClienteIns.getESCALERA());
			model.put("PISO", datosClienteIns.getPISO());
			model.put("NumeroDePuerta", datosClienteIns.getNumeroDePuerta());
			model.put("CodigoPostal", datosClienteIns.getCodigoPostal());
			model.put("NombreDelMunicipio", datosClienteIns.getNombreDelMunicipio());
			model.put("NombreDeLaProvincia", datosClienteIns.getNombreDeLaProvincia());
			model.put("CodigoDeProvincia", datosClienteIns.getCodigoDeProvincia());
			model.put("NombreDePaisDelDomicilio", datosClienteIns.getNombreDePaisDelDomicilio());
			model.put("DatosComplementariosDelDomicilio", datosClienteIns.getDatosComplementariosDelDomicilio());
			model.put("BarrioColoniaOApartado", datosClienteIns.getBarrioColoniaOApartado());
			model.put("EdadDelCliente", datosClienteIns.getEdadDelCliente());
			model.put("CodigoEstadoCivil", datosClienteIns.getCodigoEstadoCivil());
			model.put("EstadoCivilActual", datosClienteIns.getEstadoCivilActual());
			model.put("NumeroDeHijos", datosClienteIns.getNumeroDeHijos());
			model.put("SEXO", datosClienteIns.getSEXO());
			model.put("NombreComercialDeLaEmpresa", datosClienteIns.getNombreComercialDeLaEmpresa());
			model.put("DELEGACION", datosClienteIns.getDELEGACION());
			model.put("TipoDeSociedad", datosClienteIns.getTipoDeSociedad());
			model.put("CodigoDeSituacionDelCliente", datosClienteIns.getCodigoDeSituacionDelCliente());
			model.put("NombreDeLaSituacionDelCliente", datosClienteIns.getNombreDeLaSituacionDelCliente());
			model.put("FechaDeNacimientoOConstitucion", datosClienteIns.getFechaDeNacimientoOConstitucion());
			model.put("NombreDelPaisDeNacimiento", datosClienteIns.getNombreDelPaisDeNacimiento());
			model.put("NombreDeLaProvinciaNacimiento", datosClienteIns.getNombreDeLaProvinciaNacimiento());
			model.put("NombreDePoblacionDeNacimiento", datosClienteIns.getNombreDePoblacionDeNacimiento());
			model.put("NombreDePaisNacionalidad", datosClienteIns.getNombreDePaisNacionalidad());
			model.put("NombreDePaisResidencia", datosClienteIns.getNombreDePaisResidencia());
			model.put("SubsectorDeActividadEconomica", datosClienteIns.getSubsectorDeActividadEconomica());

		} catch (Exception e) {
			logger.error("error en UVEMController", e);
			model.put("error", true);
			model.put("errorDesc", e.getMessage());
		}

		return new ModelAndView("jsonView", model);
	}

}
