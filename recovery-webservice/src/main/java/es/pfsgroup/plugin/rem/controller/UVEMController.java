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

import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;

@Controller
public class UVEMController {

	@Autowired
	private UvemManagerApi uvemManager;

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
			uvemManager.ejecutarSolicitarTasacion(bienId, nombreGestor, gestion);
			int numeroIdentificadorTasacion = uvemManager.resultadoSolicitarTasacion();
			model.put("numeroIdentificadorTasacion", numeroIdentificadorTasacion);
		} catch (WIException e) {
			logger.error(e.getMessage());
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
	 * @param nudnio:
	 *            Documento según lo expresado en COCLDO. DNI, CIF, etc
	 * @param cocldo:
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
	public ModelAndView numCliente(ModelMap model, @RequestParam(required = true) String nudnio,
			@RequestParam(required = true) String cocldo, @RequestParam(required = true) String idclow,
			@RequestParam(required = true) String qcenre) {

		uvemManager.ejecutarNumCliente(nudnio, cocldo, idclow, qcenre);
		uvemManager.resultadoNumCliente();

		return new ModelAndView("jsonView", model);
	}

	/**
	 * Servicio REM  UVEM para que a partir del nº cliente URSUS se devuelvan
	 * los datos del mismo, tanto identificativos como de cara a poder dar
	 * cumplimiento a la normativa relativa a PBC.
	 * 
	 * @param model
	 * @param copace:
	 *            Codigo Objeto Acceso
	 * @param idclow:
	 *            Identificador Cliente Oferta
	 * @param iddsfu:
	 *            Identificador Discriminador Funcion
	 * @param qcenre:
	 *            Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia
	 *            habitat 05021
	 * @return
	 */
	public ModelAndView datosCliente(ModelMap model, @RequestParam(required = true) String copace,
			@RequestParam(required = true) String idclow, String iddsfu, @RequestParam(required = true) String qcenre) {
		uvemManager.ejecutarDatosCliente(copace, idclow, iddsfu, qcenre);
		uvemManager.resultadoDatosCliente();
		return new ModelAndView("jsonView", model);
	}

}
