package es.pfsgroup.plugin.rem.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.gfi.webIntegrator.WIException;

import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;

@Controller
public class UVEMController {

	@Autowired
	private UvemManagerApi uvemManagerApi;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Solicita la tasacion de un bien
	 * 
	 * @param model
	 * @param bienId:
	 *            El id del bien
	 * @param nombreGestor:
	 *            El nombre del gestor. Usuario conectado
	 * @param gestion:
	 *            Bankia o haya o null
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView solicitarTasacion(ModelMap model, @RequestParam(required = true) Long bienId,
			@RequestParam(required = true) String nombreGestor, @RequestParam(required = false) String gestion) {
		try {
			uvemManagerApi.ejecutarSolicitarTasacion(bienId, nombreGestor, gestion);
			int numeroIdentificadorTasacion = uvemManagerApi.resultadoSolicitarTasacion()
					.getNumeroIdentificadorDeTasacionlnuita2();
			model.put("numeroIdentificadorTasacion", numeroIdentificadorTasacion);
		} catch (WIException e) {
			logger.error(e.getMessage());
			model.put("error", true);
			model.put("errorDesc", e.getMessage());
		} catch (TipoDeDatoException e) {
			logger.error(e.getMessage());
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
	public ModelAndView datosCliente(ModelMap model, @RequestParam(required = true) String nDocumento,
			@RequestParam(required = true) String tipoDocumento, @RequestParam(required = false) String qcenre) {

		try {

			// si la entidad es null asumimos bankia
			if (qcenre == null || qcenre.isEmpty()) {
				qcenre = "00000";
			}
			
			DatosClienteDto datosClienteIns = uvemManagerApi.ejecutarDatosClientePorDocumento(nDocumento, tipoDocumento, qcenre);
			
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
			logger.error(e.getMessage());
			model.put("error", true);
			model.put("errorDesc", e.getMessage());
		}

		return new ModelAndView("jsonView", model);
	}	

}
