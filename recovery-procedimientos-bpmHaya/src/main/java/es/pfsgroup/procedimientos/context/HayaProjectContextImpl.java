package es.pfsgroup.procedimientos.context;

import java.util.List;

public class HayaProjectContextImpl implements HayaProjectContext {
	
	private List<String> tareasInicioConcursal;
	private List<String> tareasInicioLitigios;
	private String tareaAceptacionLitigios;
	private String tareaInicioConcurso;
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.procedimientos.context.HayaProjectContext#getTareasInicioConcursal()
	 */
	@Override
	public List<String> getTareasInicioConcursal() {
		return tareasInicioConcursal;
	}
	
	public void setTareasInicioConcursal(List<String> tareasInicioConcursal) {
		this.tareasInicioConcursal = tareasInicioConcursal;
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.procedimientos.context.HayaProjectContext#getTareasInicioLitigios()
	 */
	@Override
	public List<String> getTareasInicioLitigios() {
		return tareasInicioLitigios;
	}
	
	public void setTareasInicioLitigios(List<String> tareasInicioLitigios) {
		this.tareasInicioLitigios = tareasInicioLitigios;
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.procedimientos.context.HayaProjectContext#getTareaAceptacionLitigios()
	 */
	@Override
	public String getTareaAceptacionLitigios() {
		return tareaAceptacionLitigios;
	}
	
	public void setTareaAceptacionLitigios(String tareaAceptacionLitigios) {
		this.tareaAceptacionLitigios = tareaAceptacionLitigios;
	}

	@Override
	public String getTareaInicioConcurso() {
		return this.tareaInicioConcurso;
	}
	
	public void setTareaInicioConcurso(String tareaInicioConcurso) {
		this.tareaInicioConcurso = tareaInicioConcurso;
	}
	
	
}
