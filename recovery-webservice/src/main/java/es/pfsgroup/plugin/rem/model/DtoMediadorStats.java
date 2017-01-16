package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion estadistica de cartera de mediadores.
 *  
 * @author Bender
 */
public class DtoMediadorStats extends WebDto {

	private static final long serialVersionUID = 3574101005534449106L;

	private Long id;
	private Long numActivos;	
	private Long numVisitas; 
	private Long numOfertas;  
    private Long numReservas;
   	private Long numVentas;
	private String codigoCalificacion;
	private String descripcionCalificacion;
	private Integer esTop;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumActivos() {
		return numActivos;
	}
	public void setNumActivos(Long numActivos) {
		this.numActivos = numActivos;
	}
	public Long getNumVisitas() {
		return numVisitas;
	}
	public void setNumVisitas(Long numVisitas) {
		this.numVisitas = numVisitas;
	}
	public Long getNumOfertas() {
		return numOfertas;
	}
	public void setNumOfertas(Long numOfertas) {
		this.numOfertas = numOfertas;
	}
	public Long getNumReservas() {
		return numReservas;
	}
	public void setNumReservas(Long numReservas) {
		this.numReservas = numReservas;
	}
	public Long getNumVentas() {
		return numVentas;
	}
	public void setNumVentas(Long numVentas) {
		this.numVentas = numVentas;
	}
	public String getCodigoCalificacion() {
		return codigoCalificacion;
	}
	public void setCodigoCalificacion(String codigoCalificacion) {
		this.codigoCalificacion = codigoCalificacion;
	}
	public String getDescripcionCalificacion() {
		return descripcionCalificacion;
	}
	public void setDescripcionCalificacion(String descripcionCalificacion) {
		this.descripcionCalificacion = descripcionCalificacion;
	}
	public Integer getEsTop() {
		return esTop;
	}
	public void setEsTop(Integer esTop) {
		this.esTop = esTop;
	}

}
