package es.pfsgroup.plugin.rem.model;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de Datos de Contacto > Activos Integrados de la ficha proveedor 
 * y comunidades/entidades de la ficha del activo
 */
public class DtoPlusvaliaVenta extends DtoTabActivo {
	private static final long serialVersionUID = 0L;
	
	private Long ecoId;
	private Integer exento;
	private Integer autoliquidacion;
	private Date fechaEscritoAyt;
	private String observaciones;
	
	
	
	public Long getEcoId() {
		return ecoId;
	}
	public void setEcoId(Long ecoId) {
		this.ecoId = ecoId;
	}
	public Integer getExento() {
		return exento;
	}
	public void setExento(Integer exento) {
		this.exento = exento;
	}
	public Integer getAutoliquidacion() {
		return autoliquidacion;
	}
	public void setAutoliquidacion(Integer autoliquidacion) {
		this.autoliquidacion = autoliquidacion;
	}
	public Date getFechaEscritoAyt() {
		return fechaEscritoAyt;
	}
	public void setFechaEscritoAyt(Date fechaEscritoAyt) {
		this.fechaEscritoAyt = fechaEscritoAyt;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	
	
	
	
}