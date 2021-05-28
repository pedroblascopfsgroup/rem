package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;



public class DtoRechazosPropietario extends WebDto {
	

	private static final long serialVersionUID = 1L;
	

	 private Long id;  //Id de rechazos propietario gasto
	
	 private Long idGasto;
	 
	 private Long numeroGasto;
	 
	 private String listadoErroresDesc;
	 
	 private String listadoErroresCod;
	 
	 private String mensajeError;
	 
	 private Date fechaProcesado;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

	public Long getNumeroGasto() {
		return numeroGasto;
	}

	public void setNumeroGasto(Long numeroGasto) {
		this.numeroGasto = numeroGasto;
	}

	public String getListadoErroresDesc() {
		return listadoErroresDesc;
	}

	public void setListadoErroresDesc(String listadoErroresDesc) {
		this.listadoErroresDesc = listadoErroresDesc;
	}

	public String getListadoErroresCod() {
		return listadoErroresCod;
	}

	public void setListadoErroresCod(String listadoErroresCod) {
		this.listadoErroresCod = listadoErroresCod;
	}

	public String getMensajeError() {
		return mensajeError;
	}

	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}

	public Date getFechaProcesado() {
		return fechaProcesado;
	}

	public void setFechaProcesado(Date fechaProcesado) {
		this.fechaProcesado = fechaProcesado;
	}
	 
	 
	 
	 
	 
}
