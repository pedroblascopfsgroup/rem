package es.capgemini.pfs.sync.message;

import java.util.Date;

import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;

public class SyncMsgBPMTaskDto {
	
	private String tipoProcedimiento;
	private String subtipoTarea;
	private String codProcedimiento;
	private String codigoTarea;
	private String tarea;
	private String descripcion;
	private String tipoEntidad;
	private Date fechaInicio;
	private Date fechaFin;
	private Date fechaVencimiento;
	private boolean enEspera;
	private boolean esAlerta;


	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public String getCodProcedimiento() {
		return codProcedimiento;
	}
	public void setCodProcedimiento(String codProcedimiento) {
		this.codProcedimiento = codProcedimiento;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTarea() {
		return tarea;
	}
	public void setTarea(String tarea) {
		this.tarea = tarea;
	}
	public Date getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public Date getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getCodigoTarea() {
		return codigoTarea;
	}
	public void setCodigoTarea(String codigoTarea) {
		this.codigoTarea = codigoTarea;
	}
	public String getSubtipoTarea() {
		return subtipoTarea;
	}
	public void setSubtipoTarea(String subtipoTarea) {
		this.subtipoTarea = subtipoTarea;
	}
	public boolean isEnEspera() {
		return enEspera;
	}
	public void setEnEspera(boolean enEspera) {
		this.enEspera = enEspera;
	}
	public boolean isEsAlerta() {
		return esAlerta;
	}
	public void setEsAlerta(boolean esAlerta) {
		this.esAlerta = esAlerta;
	}
	public String getTipoEntidad() {
		return tipoEntidad;
	}
	public void setTipoEntidad(String tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}

    public void load(EXTTareaNotificacion tarea) {
    	this.setTipoProcedimiento(tarea.getProcedimiento().getTipoProcedimiento().getCodigo());
    	this.setCodProcedimiento(tarea.getProcedimiento().getId().toString()); // Guardar en BD un código para este procedimiento
    	this.setDescripcion(tarea.getDescripcionTarea());

    	this.setFechaInicio(tarea.getFechaInicio());
    	this.setFechaVencimiento(tarea.getFechaVenc());
    	this.setFechaFin(tarea.getFechaFin());
    	
    	this.setEnEspera(tarea.getEspera());
    	this.setEsAlerta(tarea.getAlerta());
    	
    	this.setCodigoTarea(tarea.getCodigoTarea());
    	this.setSubtipoTarea(tarea.getSubtipoTarea().getCodigoSubtarea());
    	this.setTarea(tarea.getSubtipoTarea().getDescripcion());
    	
    	this.setTipoEntidad(tarea.getTipoEntidad().getCodigo());
    }

}
