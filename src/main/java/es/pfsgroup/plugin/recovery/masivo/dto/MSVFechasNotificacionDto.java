package es.pfsgroup.plugin.recovery.masivo.dto;

import java.io.Serializable;


public class MSVFechasNotificacionDto implements Serializable{


	private static final long serialVersionUID = 5315610699960372536L;

	private Long id;
	
	private Long idProcedimiento;
	
	private Long idPersona;
	
	private String idDireccion;
	
	private String tipoFecha;
	
	private String fechaSolicitud;

	private String fechaResultado;

	private String resultado;

	//TODO actualmente se esta utilizando la entity de las direccionesFechas 
	//para almacenar el campo excluido, se deber� cambiar a un objeto propio de demandados
	private Boolean excluido;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getFechaSolicitud() {
		return fechaSolicitud;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Long getIdPersona() {
		return idPersona;
	}

	public void setIdPersona(Long idPersona) {
		this.idPersona = idPersona;
	}

	public String getIdDireccion() {
		return idDireccion;
	}

	public void setIdDireccion(String idDireccion) {
		this.idDireccion = idDireccion;
	}
	
	public void setFechaSolicitud(String fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public String getFechaResultado() {
		return fechaResultado;
	}

	public void setFechaResultado(String fechaResultado) {
		this.fechaResultado = fechaResultado;
	}

	public String getResultado() {
		return resultado;
	}

	public void setResultado(String resultado) {
		this.resultado = resultado;
	}

	public String getTipoFecha() {
		return tipoFecha;
	}

	public void setTipoFecha(String tipoFecha) {
		this.tipoFecha = tipoFecha;
	}

	public Boolean getExcluido() {
		return excluido;
	}

	public void setExcluido(Boolean excluido) {
		this.excluido = excluido;
	}
	
}
