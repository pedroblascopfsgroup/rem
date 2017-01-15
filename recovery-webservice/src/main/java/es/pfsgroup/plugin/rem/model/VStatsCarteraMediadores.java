package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_STATS_CARTERA_MEDIADORES", schema = "${entity.schema}")
public class VStatsCarteraMediadores implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 101L;

	@Id
	@Column(name = "ID_MEDIADOR")
	private Long id;
	
	@Column(name = "NUM_ACTIVOS")
	private Long numActivos;	
	
	@Column(name = "NUM_VISITAS")
	private Long numVisitas; 
		
	@Column(name = "NUM_OFERTAS")
	private Long numOfertas;  
	
    @Column(name = "NUM_RESERVAS")
    private Long numReservas;
    
    @Column(name = "NUM_VENTAS")
   	private Long numVentas;

	@Column(name = "COD_CALIFICACION_VIGENTE")
	private String codigoCalificacion;
	
	@Column(name= "DES_CALIFICACION_VIGENTE")
	private String descripcionCalificacion;
	
	@Column(name = "TOP_150_VIGENTE")
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