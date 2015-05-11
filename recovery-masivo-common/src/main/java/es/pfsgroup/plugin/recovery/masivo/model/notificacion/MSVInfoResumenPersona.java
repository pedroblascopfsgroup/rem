package es.pfsgroup.plugin.recovery.masivo.model.notificacion;

import java.io.Serializable;
import java.util.Date;

/**
 * Objeto que representa una fila del resumen de notificaci�n de demandados.
 * @author manuel
 *
 */
public class MSVInfoResumenPersona implements Serializable{

	private static final long serialVersionUID = 8753492240240005536L;

	private Long idProcedimiento;
	
	private Long idDemandado;
	
	private String idDireccion;
	
	private String direccion;
	
	private Date fechaRequerimiento;
	
	private String resultadoRequerimiento;
	
	private Date fechaHorarioNocturno;
	
	private String resultadoHorarioNocturno;
	
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Long getIdDemandado() {
		return idDemandado;
	}

	public void setIdDemandado(Long idDemandado) {
		this.idDemandado = idDemandado;
	}

	public Date getFechaRequerimiento() {
		return fechaRequerimiento;
	}

	public void setFechaRequerimiento(Date fechaRequerimiento) {
		this.fechaRequerimiento = fechaRequerimiento;
	}

	public String getResultadoRequerimiento() {
		return resultadoRequerimiento;
	}

	public void setResultadoRequerimiento(String resultadoRequerimiento) {
		this.resultadoRequerimiento = resultadoRequerimiento;
	}

	public Date getFechaHorarioNocturno() {
		return fechaHorarioNocturno;
	}

	public void setFechaHorarioNocturno(Date fechaHorarioNocturno) {
		this.fechaHorarioNocturno = fechaHorarioNocturno;
	}

	public String getResultadoHorarioNocturno() {
		return resultadoHorarioNocturno;
	}

	public void setResultadoHorarioNocturno(String resultadoHorarioNocturno) {
		this.resultadoHorarioNocturno = resultadoHorarioNocturno;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getIdDireccion() {
		return idDireccion;
	}

	public void setIdDireccion(String idDireccion) {
		this.idDireccion = idDireccion;
	}

}
