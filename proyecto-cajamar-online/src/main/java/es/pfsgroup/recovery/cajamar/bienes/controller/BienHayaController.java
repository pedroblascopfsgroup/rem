package es.pfsgroup.recovery.cajamar.bienes.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.haya.bienes.api.BienHayaApi;

@Controller
public class BienHayaController {

	private static final String DEFAULT = "default";
	
	@Autowired
	private BienHayaApi hayaBienManager;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@RequestMapping
	public String solicitarTasacion(
			@RequestParam(value = "idBien", required = true) Long idBien,
			@RequestParam(value = "cuenta", required = true) Long cuenta,
			@RequestParam(value = "persona", required = true) String persona,
			@RequestParam(value = "telefono", required = true) Long telefono,
			@RequestParam(value = "observaciones", required = false) String observaciones,
			ModelMap map) 
	{
		hayaBienManager.solicitarTasacion(idBien, cuenta, persona, telefono, observaciones);
		
		return DEFAULT;
	}

	/**
	 * @return the hayaBienManager
	 */
	public BienHayaApi getHayaBienManager() {
		return hayaBienManager;
	}

	/**
	 * @param hayaBienManager the hayaBienManager to set
	 */
	public void setHayaBienManager(BienHayaApi hayaBienManager) {
		this.hayaBienManager = hayaBienManager;
	}
}
