package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name="VINFSUBLET_BIENES", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class InformeSubastaLetradoBienesBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Column(name="SUB_ID")
	private Long idSubasta;
	
	@Id
	@Column(name="BIE_ID")
	private Long idBien;
	
	@Column(name="DOMICILIO")
	private String domicilio;
	
	@Column(name="DESCRIPCION")
	private String descripcion;
	
	@Column(name="DATOS_REGISTRALES")
	private String datosRegistrales;
	
	@Column(name="CARGAS_ANTERIORES")
	private String cargasAnteriores;
	
	@Column(name="CARGAS_POSTERIORES")
	private String cargasPosteriores;
	
	@Column(name="VIVIENDA_HABITUAL")
	private String viviendaHabitual;
	
	@Column(name="SITUACION_POSESORIA")
	private String situacionPosesoria;
	
	@Column(name="TPO_SUBASTA")
	private String tpoSubasta;

	public Long getIdSubasta() {
		return idSubasta;
	}

	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}

	public Long getIdBien() {
		return idBien;
	}

	public void setIdBien(Long idBien) {
		this.idBien = idBien;
	}

	public String getDomicilio() {
		return domicilio;
	}

	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDatosRegistrales() {
		return datosRegistrales;
	}

	public void setDatosRegistrales(String datosRegistrales) {
		this.datosRegistrales = datosRegistrales;
	}

	public String getCargasAnteriores() {
		return cargasAnteriores;
	}

	public void setCargasAnteriores(String cargasAnteriores) {
		this.cargasAnteriores = cargasAnteriores;
	}

	public String getCargasPosteriores() {
		return cargasPosteriores;
	}

	public void setCargasPosteriores(String cargasPosteriores) {
		this.cargasPosteriores = cargasPosteriores;
	}

	public String getViviendaHabitual() {
		return viviendaHabitual;
	}

	public void setViviendaHabitual(String viviendaHabitual) {
		this.viviendaHabitual = viviendaHabitual;
	}

	public String getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(String situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}

	public String getTpoSubasta() {
		return tpoSubasta;
	}

	public void setTpoSubasta(String tpoSubasta) {
		this.tpoSubasta = tpoSubasta;
	}

}
