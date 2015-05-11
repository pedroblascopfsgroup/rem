package es.capgemini.pfs.core.api.asunto;

import java.util.Date;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

public class HistoricoAsuntoInfoImpl implements HistoricoAsuntoInfo {

	private String descripcionTarea;
	
	private String tipoRegistro;
	
	private String subtipoTarea;
	
	private Long idTarea;
	
	private Long idTraza;
	
	private String tipoTraza;
	
	private String group;
	
	private Date fechaVencReal;	
	
	private String tipoActuacion ;
	private HistoricoProcedimiento tarea;
	private Procedimiento procedimiento;
	
	private String destinatarioTarea;
	private String fechasTarea;
		
	@Override
	public String getTipoActuacion() {
		return tipoActuacion;
	}
	
	@Override
	public HistoricoProcedimiento getTarea() {
		return tarea;
	}
	
	@Override
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}
	public void setTipoActuacion(String tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	public void setTarea(HistoricoProcedimiento tarea) {
		this.tarea = tarea;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}
	
	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public Long getIdTraza() {
		return idTraza;
	}

	public void setIdTraza(Long idTraza) {
		this.idTraza = idTraza;
	}

	@Override
	public String getTipoTraza() {
		return tipoTraza;
	}

	public void setTipoTraza(String tipoTraza) {
		this.tipoTraza = tipoTraza;
	}

	public void setGroup(String group) {
		this.group = group;
	}

	@Override
	public String getGroup() {
		return group;
	}
	
	@Override
	public Date getFechaVencReal() {
		return fechaVencReal != null ? ((Date) fechaVencReal.clone()) : null;
	}

	public void setFechaVencReal(Date fechaVencReal) {
		this.fechaVencReal = fechaVencReal != null ? ((Date) fechaVencReal.clone()) : null;
	}

	@Override
	public String getDestinatarioTarea() {
		return destinatarioTarea;
	}

	public void setDestinatarioTarea(String destinatarioTarea) {
		this.destinatarioTarea = destinatarioTarea;
	}

	public String getSubtipoTarea() {
		return subtipoTarea;
	}

	public void setSubtipoTarea(String subtipoTarea) {
		this.subtipoTarea = subtipoTarea;
	}

	public String getTipoRegistro() {
		return tipoRegistro;
	}

	public void setTipoRegistro(String tipoRegistro) {
		this.tipoRegistro = tipoRegistro;
	}

	public String getDescripcionTarea() {
		return descripcionTarea;
	}

	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}

	public String getFechasTarea() {
		return fechasTarea;
	}

	public void setFechasTarea(String fechasTarea) {
		this.fechasTarea = fechasTarea;
	}
	
}
