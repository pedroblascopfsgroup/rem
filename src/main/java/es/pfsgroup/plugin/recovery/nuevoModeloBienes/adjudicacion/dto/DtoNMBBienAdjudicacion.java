package es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.dto;

import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;

public class DtoNMBBienAdjudicacion {
	
	NMBBien bien;
	TareaNotificacion tareaNotificacion;
	
	public NMBBien getBien() {
		return bien;
	}
	public void setBien(NMBBien bien) {
		this.bien = bien;
	}
	public TareaNotificacion getTareaNotificacion() {
		return tareaNotificacion;
	}
	public void setTareaNotificacion(TareaNotificacion tareaNotificacion) {
		this.tareaNotificacion = tareaNotificacion;
	}
	
	
	
	/*Long id;
	Long idBien;
	String codigoInterno;
	String numeroActivo;
	NMBDDOrigenBien origen;
	String descripcionBien;
	Boolean viviendaHabitual;
	NMBAdjudicacionBien adjudicacion;
	TareaExterna tareaExterna;

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdBien() {
		return idBien;
	}
	public void setIdBien(Long idBien) {
		this.idBien = idBien;
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
	public String getDescripcionBien() {
		return descripcionBien;
	}
	public void setDescripcionBien(String descripcionBien) {
		this.descripcionBien = descripcionBien;
	}
	public Boolean getViviendaHabitual() {
		return viviendaHabitual;
	}
	public void setViviendaHabitual(Boolean viviendaHabitual) {
		this.viviendaHabitual = viviendaHabitual;
	}
	public NMBAdjudicacionBien getAdjudicacion() {
		return adjudicacion;
	}
	public void setAdjudicacion(NMBAdjudicacionBien adjudicacion) {
		this.adjudicacion = adjudicacion;
	}
	public TareaExterna getTareaExterna() {
		return tareaExterna;
	}
	public void setTareaExterna(TareaExterna tareaExterna) {
		this.tareaExterna = tareaExterna;
	}
*/
}