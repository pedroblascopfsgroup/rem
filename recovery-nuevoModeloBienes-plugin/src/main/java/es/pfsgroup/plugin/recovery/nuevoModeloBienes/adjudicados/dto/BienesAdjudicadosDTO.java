package es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicados.dto;

import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien;

/**
 * DTO para enviar los bienes a la pestaña de adjudicados
 * 
 * @author carlos
 *
 */
public class BienesAdjudicadosDTO  {
	Long id;
	String codigoInterno;
	String numeroActivo;
	NMBDDOrigenBien origen;
	String descripcion;
	String habitual;
	Boolean adjudicacionOK;
	Boolean saneamientoOK;
	Boolean posesionOK;
	Boolean llavesOK;
	String tareaActivaAdjudicacion;
	String tareaActivaSaneamiento;
	String tareaActivaPosesion;
	String tareaActivaLlaves;
	String numFinca;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCodigoInterno() {
		return codigoInterno;
	}
	public void setCodigoInterno(String codigoInterno) {
		this.codigoInterno = codigoInterno;
	}
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public NMBDDOrigenBien getOrigen() {
		return origen;
	}
	public void setOrigen(NMBDDOrigenBien origen) {
		this.origen = origen;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getHabitual() {
		return habitual;
	}
	public void setHabitual(String habitual) {
		this.habitual = habitual;
	}
	public Boolean getAdjudicacionOK() {
		return adjudicacionOK;
	}
	public void setAdjudicacionOK(Boolean adjudicacionOK) {
		this.adjudicacionOK = adjudicacionOK;
	}
	public Boolean getSaneamientoOK() {
		return saneamientoOK;
	}
	public void setSaneamientoOK(Boolean saneamientoOK) {
		this.saneamientoOK = saneamientoOK;
	}
	public Boolean getPosesionOK() {
		return posesionOK;
	}
	public void setPosesionOK(Boolean posesionOK) {
		this.posesionOK = posesionOK;
	}
	public Boolean getLlavesOK() {
		return llavesOK;
	}
	public void setLlavesOK(Boolean llavesOK) {
		this.llavesOK = llavesOK;
	}
	public String getTareaActivaAdjudicacion() {
		return tareaActivaAdjudicacion;
	}
	public void setTareaActivaAdjudicacion(String tareaActivaAdjudicacion) {
		this.tareaActivaAdjudicacion = tareaActivaAdjudicacion;
	}
	public String getTareaActivaSaneamiento() {
		return tareaActivaSaneamiento;
	}
	public void setTareaActivaSaneamiento(String tareaActivaSaneamiento) {
		this.tareaActivaSaneamiento = tareaActivaSaneamiento;
	}
	public String getTareaActivaPosesion() {
		return tareaActivaPosesion;
	}
	public void setTareaActivaPosesion(String tareaActivaPosesion) {
		this.tareaActivaPosesion = tareaActivaPosesion;
	}
	public String getTareaActivaLlaves() {
		return tareaActivaLlaves;
	}
	public void setTareaActivaLlaves(String tareaActivaLlaves) {
		this.tareaActivaLlaves = tareaActivaLlaves;
	}
	public String getNumFinca() {
		return numFinca;
	}
	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}
	
}
