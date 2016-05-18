package es.pfsgroup.procedimientos.context;

import java.util.List;

public class HayaProjectContextImpl implements HayaProjectContext {
	
	private List<String> tareasInicioConcursal;
	private List<String> tareasInicioLitigios;
	private String tareaAceptacionLitigios;
	private String tareaInicioConcurso;
	
	private String codigoHipotecario;
	private String codigoMonitorio;
	private String codigoOrdinario;
	
	private String codigoTareaDemandaHipotecario;
	private String codigoTareaDemandaMonitorio;
	private String codigoTareaDemandaOrdinario;
	
	private String fechaDemandaHipotecario;
	private String fechaDemandaMonitorio;
	private String fechaDemandaOrdinario;
	
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
	public String getCodigoHipotecario() {
		return codigoHipotecario;
	}

	public void setCodigoHipotecario(String codigoHipotecario) {
		this.codigoHipotecario = codigoHipotecario;
	}

	@Override
	public String getCodigoMonitorio() {
		return codigoMonitorio;
	}

	public void setCodigoMonitorio(String codigoMonitorio) {
		this.codigoMonitorio = codigoMonitorio;
	}

	@Override
	public String getCodigoOrdinario() {
		return codigoOrdinario;
	}

	public void setCodigoOrdinario(String codigoOrdinario) {
		this.codigoOrdinario = codigoOrdinario;
	}

	@Override
	public String getCodigoTareaDemandaHipotecario() {
		return codigoTareaDemandaHipotecario;
	}

	public void setCodigoTareaDemandaHipotecario(
			String codigoTareaDemandaHipotecario) {
		this.codigoTareaDemandaHipotecario = codigoTareaDemandaHipotecario;
	}

	@Override
	public String getCodigoTareaDemandaMonitorio() {
		return codigoTareaDemandaMonitorio;
	}

	public void setCodigoTareaDemandaMonitorio(
			String codigoTareaDemandaMonitorio) {
		this.codigoTareaDemandaMonitorio = codigoTareaDemandaMonitorio;
	}

	@Override
	public String getCodigoTareaDemandaOrdinario() {
		return codigoTareaDemandaOrdinario;
	}

	public void setCodigoTareaDemandaOrdinario(
			String codigoTareaDemandaOrdinario) {
		this.codigoTareaDemandaOrdinario = codigoTareaDemandaOrdinario;
	}

	@Override
	public String getFechaDemandaHipotecario() {
		return fechaDemandaHipotecario;
	}

	public void setFechaDemandaHipotecario(String fechaDemandaHipotecario) {
		this.fechaDemandaHipotecario = fechaDemandaHipotecario;
	}

	@Override
	public String getFechaDemandaMonitorio() {
		return fechaDemandaMonitorio;
	}

	public void setFechaDemandaMonitorio(String fechaDemandaMonitorio) {
		this.fechaDemandaMonitorio = fechaDemandaMonitorio;
	}

	@Override
	public String getFechaDemandaOrdinario() {
		return fechaDemandaOrdinario;
	}

	public void setFechaDemandaOrdinario(String fechaDemandaOrdinario) {
		this.fechaDemandaOrdinario = fechaDemandaOrdinario;
	}

	@Override
	public String getTareaInicioConcurso() {
		return this.tareaInicioConcurso;
	}
	
	public void setTareaInicioConcurso(String tareaInicioConcurso) {
		this.tareaInicioConcurso = tareaInicioConcurso;
	}
	
}
