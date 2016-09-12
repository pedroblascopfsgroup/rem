package es.pfsgroup.plugin.rem.controller;

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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView solicitarTasacion(ModelMap model, @RequestParam(required = true) Long bienId,
			@RequestParam(required = true) String nombreGestor, @RequestParam(required = false) String gestion) {
		try {
			int numeroIdentificadorTasacion = uvemManager.solicitarTasacion(bienId, nombreGestor, gestion);

		} catch (WIException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TipoDeDatoException e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ModelAndView("jsonView", model);
	}

}
