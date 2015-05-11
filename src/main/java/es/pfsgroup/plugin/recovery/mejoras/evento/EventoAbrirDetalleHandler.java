package es.pfsgroup.plugin.recovery.mejoras.evento;

public interface EventoAbrirDetalleHandler {
	
	Object getViewData(Long idTarea, Long idTraza, Long idEntidad);

	
	String getJspName();

	
	boolean isValid(String tipoTarea, String codUg);
}
