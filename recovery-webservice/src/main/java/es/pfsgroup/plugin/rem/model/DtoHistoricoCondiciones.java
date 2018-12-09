package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la informacion de los historicos de condiciones de los expedientes comerciales
 *  
 * @author Adrian Casiean
 *
 */
public class DtoHistoricoCondiciones extends WebDto {
	
	private static final long serialVersionUID = 1L;
	
	private String id;
	private Long condicionante;
	private Date fecha;
	private Double incrementoRenta;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Long getCondicionante() {
		return condicionante;
	}
	public void setCondicionante(Long condicionante) {
		this.condicionante = condicionante;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public Double getIncrementoRenta() {
		return incrementoRenta;
	}
	public void setIncrementoRenta(Double incrementoRenta) {
		this.incrementoRenta = incrementoRenta;
	}
	
	
}
