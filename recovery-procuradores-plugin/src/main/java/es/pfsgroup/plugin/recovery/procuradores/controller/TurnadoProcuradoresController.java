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
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_TPO = "plugin/procuradores/turnado/seleccionarTpo";
	private static final String VIEW_ESQUEMA_TURNADO_PROCURADORES_CONFIGURAR_PLAZA_TPO = "plugin/procuradores/turnado/configurarPlazaTpo";
	
	@RequestMapping
	public String ventanaBusquedaEsquemasProcuradores(ModelMap map) {
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_BUSCADOR;
	}
	
	@RequestMapping
	public String seleccionarPlaza(ModelMap map) {
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_PLAZA;
	}
	
	@RequestMapping
	public String seleccionarTpo(ModelMap map) {
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_SELECCIONAR_TPO;
	}

	@RequestMapping
	public String configurarPlazaTpo(ModelMap map) {
		return VIEW_ESQUEMA_TURNADO_PROCURADORES_CONFIGURAR_PLAZA_TPO;
	}


}
