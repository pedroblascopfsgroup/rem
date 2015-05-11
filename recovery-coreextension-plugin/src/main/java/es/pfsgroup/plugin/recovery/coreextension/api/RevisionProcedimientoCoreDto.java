package es.pfsgroup.plugin.recovery.coreextension.api;

public class RevisionProcedimientoCoreDto {

	private Long idActuacion;
	private Long idTipoProcedimiento;
	private Long idTarea;
	private String instrucciones;
	private Long idAsunto;
	private Long idProcedimiento;
	private String nombreAsunto;

	public Long getIdActuacion() {
		return idActuacion;
	}

	public void setIdActuacion(Long idActuacion) {
		this.idActuacion = idActuacion;
	}

	public Long getIdTipoProcedimiento() {
		return idTipoProcedimiento;
	}

	public void setIdTipoProcedimiento(Long idTipoProcedimiento) {
		this.idTipoProcedimiento = idTipoProcedimiento;
	}

	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public String getInstrucciones() {
		return instrucciones;
	}

	public void setInstrucciones(String instrucciones) {
		this.instrucciones = instrucciones;
	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public String getNombreAsunto() {
		return nombreAsunto;
	}

	public void setNombreAsunto(String nombreAsunto) {
		this.nombreAsunto = nombreAsunto;
	}
}
