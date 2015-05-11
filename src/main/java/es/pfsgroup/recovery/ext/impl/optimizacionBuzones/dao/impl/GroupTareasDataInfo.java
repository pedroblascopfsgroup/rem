package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl;

import java.util.Date;

public class GroupTareasDataInfo {
	
	
	private String codigoTarea;
	private Integer alerta;
	private Date fechaInicio;
	private Date fechaVenc;
	
	public String getCodigoTarea() {
		return codigoTarea;
	}

	public void setCodigoTarea(String codigoTarea) {
		this.codigoTarea = codigoTarea;
	}

	public Integer getAlerta() {
		return alerta;
	}

	public void setAlerta(Integer alerta) {
		this.alerta = alerta;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaVenc() {
		return fechaVenc;
	}

	public void setFechaVenc(Date fechaVenc) {
		this.fechaVenc = fechaVenc;
	}

}
