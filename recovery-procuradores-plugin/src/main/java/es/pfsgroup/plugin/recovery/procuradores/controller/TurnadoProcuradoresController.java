package es.pfsgroup.plugin.recovery.procuradores.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author Sergio
 *
 * Controlador para el turnado de procuradores
 */
@Controller
public class TurnadoProcuradoresController {
	
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_BUSCADOR = "plugin/procuradores/turnado/buscadorEsquemasProcuradores";
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_PLAZA = "plugin/procuradores/turnado/seleccionarPlaza";
	
	@RequestMapping
	public String ventanaBusquedaEsquemasProcuradores(ModelMap map) {
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_BUSCADOR;
	}
	
	@RequestMapping
	public String seleccionarPlaza(ModelMap map) {
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_PLAZA;
	}


}
