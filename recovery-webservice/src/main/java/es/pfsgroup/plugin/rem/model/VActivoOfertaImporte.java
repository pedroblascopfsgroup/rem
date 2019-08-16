package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Viorel Remus
 *
 */
@Entity
@Table(name = "V_ACTIVO_OFERTA_IMPORTE", schema = "${entity.schema}")
public class VActivoOfertaImporte implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	 @Id
	 @Column(name = "ID_VISTA")
	 private Long id_vista;

	@Column(name = "ACT_ID")
	 private Long activo;

     @Column(name = "OFR_ID")
     private Long oferta;

	 @Column(name="ACT_OFR_IMPORTE")
	 private Double importeActivoOferta;
	
	 @Column(name="OFR_ACT_PORCEN_PARTICIPACION")
	 private Double porcentajeParticipacion;

	 public Long getActivo() {
			return activo;
	}
	
	public void setActivo(Long activo) {
		this.activo = activo;
	}

	public Long getOferta() {
		return oferta;
	}

	public void setOferta(Long oferta) {
		this.oferta = oferta;
	}

	public Double getImporteActivoOferta() {
		return importeActivoOferta;
	}

	public void setImporteActivoOferta(Double importeActivoOferta) {
		this.importeActivoOferta = importeActivoOferta;
	}

	public Double getPorcentajeParticipacion() {
		return porcentajeParticipacion;
	}

	public void setPorcentajeParticipacion(Double porcentajeParticipacion) {
		this.porcentajeParticipacion = porcentajeParticipacion;
	}
	
	 public Long getId_vista() {
			return id_vista;
	}

	public void setId_vista(Long id_vista) {
		this.id_vista = id_vista;
	}

}
