package es.pfsgroup.procedimientos.context;

import java.util.List;

public interface HayaProjectContext {

	public List<String> getTareasInicioConcursal();

	public List<String> getTareasInicioLitigios();

	public String getTareaAceptacionLitigios();
	
	public String getTareaInicioConcurso();

}