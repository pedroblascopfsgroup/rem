package es.pfsgroup.recovery.cajamar.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.cajamar.serviciosonline.ServiciosOnlineCajamarApi;

@Controller
public class ServiciosOnlineCajamarController {

	private static final String SOLICITAR_TASACION_JSON = "plugin/cajamarhre/bienes/solicitarTasacionJSON";
	private static final String VENTANA_SOLICITAR_TASACION = "plugin/cajamarhre/bienes/solicitarTasacion";
	
	@Autowired
	private ServiciosOnlineCajamarApi serviciosOnlineCajamar;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@RequestMapping
	public String ventanaSolicitudTasacion() {
		return VENTANA_SOLICITAR_TASACION;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String solicitarTasacion(
			@RequestParam(value = "idBien", required = true) Long idBien,
			@RequestParam(value = "cuenta", required = true) Long cuenta,
			@RequestParam(value = "persona", required = true) String persona,
			@RequestParam(value = "telefono", required = true) Long telefono,
			@RequestParam(value = "observaciones", required = false) String observaciones,
			ModelMap map) 
	{
		Boolean res = serviciosOnlineCajamar.solicitarTasacion(idBien, cuenta, persona, telefono, observaciones);
		map.put("solicitudRealizada", res);
		return SOLICITAR_TASACION_JSON;
	}

	@RequestMapping
	public void consultaDeSaldos(String numContrato) {
		serviciosOnlineCajamar.consultaDeSaldos(numContrato);
		return;
	}
	
}
