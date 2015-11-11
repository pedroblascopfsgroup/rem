package es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.dto;

import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;

public class DtoNMBBienAdjudicacion {

	NMBBien bien;
	TareaNotificacion tareaNotificacion;
	Boolean tareaActiva;
	String descripcionTarea;
	ProcedimientoBien procedimientoBien;

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

	public Boolean getTareaActiva() {
		return tareaActiva;
	}

	public void setTareaActiva(Boolean tareaActiva) {
		this.tareaActiva = tareaActiva;
	}

	public String getDescripcionTarea() {
		return descripcionTarea;
	}

	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}

	public ProcedimientoBien getProcedimientoBien() {
		return procedimientoBien;
	}

	public void setProcedimientoBien(ProcedimientoBien procedimientoBien) {
		this.procedimientoBien = procedimientoBien;
	}

}