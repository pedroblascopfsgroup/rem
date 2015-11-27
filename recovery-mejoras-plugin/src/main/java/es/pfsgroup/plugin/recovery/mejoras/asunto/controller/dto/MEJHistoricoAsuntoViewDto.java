package es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;

public class MEJHistoricoAsuntoViewDto implements Serializable {

	private static final long serialVersionUID = 3136032045262842004L;
	
	private String subtipoTarea;
	
	private String tipoRegistro;
	
	private Long tipoEntidad;

	private Long idEntidad;

	private String tarea;

	private Long idTarea;
	
	private Long idTraza;
	
	private String tipoTraza;

	private String descripcionTarea;

	private String tipoActuacion;

	private String tipoProcedimiento;

	private Long numeroProcedimiento;

	private String numeroAutos;

	private BigDecimal importe;

	private Date fechaInicio;
	
	private String fechaIni;
	
	private Boolean agenda;

	private Date fechaVencimiento;

	private Date fechaFin;

	private String nombreUsuario;
	
	private String group;

	private String descripcionCorta;

	private Date fechaVencReal;
	
	private String destinatarioTarea;

	public MEJHistoricoAsuntoViewDto(HistoricoAsuntoInfo historicoAsunto) {
		if (Checks.esNulo(historicoAsunto)){
			throw new IllegalArgumentException("'historicoAsunto' no puede ser null");
		}
		if(historicoAsunto.getTipoRegistro() != null){
			this.tipoRegistro = historicoAsunto.getTipoRegistro();
		}else{
			this.tipoRegistro = "";
		}
		if(historicoAsunto.getSubtipoTarea() != null){
			this.subtipoTarea = historicoAsunto.getSubtipoTarea();	
		}else{
			this.subtipoTarea = "";
		}		
		this.idTarea = historicoAsunto.getIdTarea();
		this.idTraza = historicoAsunto.getIdTraza();
		this.tipoTraza = historicoAsunto.getTipoTraza();
		this.tipoActuacion = historicoAsunto.getTipoActuacion();
		this.setGroup(historicoAsunto.getGroup());
		if (historicoAsunto.getProcedimiento() != null) {

			if (historicoAsunto.getProcedimiento().getTipoProcedimiento() != null)
				this.tipoProcedimiento = historicoAsunto.getProcedimiento()
						.getTipoProcedimiento().getDescripcion();
			else
				this.tipoProcedimiento = "";
			this.numeroProcedimiento = historicoAsunto.getProcedimiento()
					.getId();
			this.numeroAutos = historicoAsunto.getProcedimiento()
					.getCodigoProcedimientoEnJuzgado();
			this.importe = historicoAsunto.getProcedimiento()
					.getSaldoRecuperacion();
		} else {
			this.tipoProcedimiento = "";
			this.numeroProcedimiento = 0L;
			this.numeroAutos = "";
			this.importe = new BigDecimal(0);
		}
		if(historicoAsunto.getTarea() != null){
			this.idEntidad = historicoAsunto.getTarea().getIdEntidad();
			this.tipoEntidad = historicoAsunto.getTarea().getTipoEntidad();
			this.tarea = historicoAsunto.getTarea().getNombreTarea();
			this.fechaInicio = historicoAsunto.getTarea().getFechaIni();
			this.fechaVencimiento = historicoAsunto.getTarea()
					.getFechaVencimiento();
			this.fechaFin = historicoAsunto.getTarea().getFechaFin();
			this.nombreUsuario = historicoAsunto.getTarea().getNombreUsuario();
			String desc = historicoAsunto.getTarea().getNombreTarea();
			if(!Checks.esNulo(desc)){
				if(desc.length()>20){
					desc = desc.substring(0,20)+"...";
				}
				this.descripcionCorta = desc;
			}
			if(historicoAsunto.getTarea() instanceof EXTHistoricoProcedimiento){
				this.destinatarioTarea = ((EXTHistoricoProcedimiento) historicoAsunto.getTarea()).getUsuarioResponsable();
			}
		}
		this.fechaVencReal = historicoAsunto.getFechaVencReal();
		//this.destinatarioTarea = historicoAsunto.getDestinatarioTarea();
		this.descripcionTarea = historicoAsunto.getDescripcionTarea();
		
	}

	public MEJHistoricoAsuntoViewDto(Evento evento) {

		this.idEntidad = evento.getTarea().getIdEntidad();
		this.tipoEntidad = evento.getTarea().getTipoEntidad().getId();
		this.tarea = evento.getTarea().getTarea();
		this.descripcionTarea = evento.getTarea().getDescripcionTarea();
		this.tipoActuacion = null;
		this.tipoProcedimiento = null;
		this.numeroProcedimiento = null;
		this.numeroAutos = null;
		this.importe = null;
		this.fechaInicio = evento.getTarea().getFechaInicio();
		this.fechaVencimiento = evento.getTarea().getFechaVenc();
		this.fechaFin = evento.getTarea().getFechaFin();
		this.nombreUsuario = evento.getTarea().getEmisor();
		this.idTarea = evento.getTarea().getId();
		if( evento.getTarea().getSubtipoTarea() != null){
			this.subtipoTarea = evento.getTarea().getSubtipoTarea().getCodigoSubtarea();
		}else{
			this.subtipoTarea = "";
		}
		this.tipoRegistro = "";
		this.group = "Evento";
		this.descripcionCorta = evento.getTarea().getTarea();
		String desc = evento.getTarea().getTarea();
		if(!Checks.esNulo(desc)){
			if(desc.length()>20){
				desc = desc.substring(0,20)+"...";
			}
			this.descripcionCorta = desc;
		}
		if(evento.getTarea() instanceof EXTTareaNotificacion){
			EXTTareaNotificacion e = (EXTTareaNotificacion) evento.getTarea();
			this.fechaVencReal = e.getFechaVencReal();
		}
		else{
			this.fechaVencReal = null;
		}
	}

	public Long getTipoEntidad() {
		return tipoEntidad;
	}

	public Long getIdEntidad() {
		return idEntidad;
	}

	public String getTarea() {
		return tarea;
	}

	public String getTipoActuacion() {
		return tipoActuacion;
	}

	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public Long getNumeroProcedimiento() {
		return numeroProcedimiento;
	}

	public String getNumeroAutos() {
		return numeroAutos;
	}

	public BigDecimal getImporte() {
		return importe;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public Long getIdTarea() {
		return idTarea;
	}

	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}

	public String getDescripcionTarea() {
		return descripcionTarea;
	}

	public Long getIdTraza() {
		return idTraza;
	}

	public void setIdTraza(Long idTraza) {
		this.idTraza = idTraza;
	}

	public String getTipoTraza() {
		return tipoTraza;
	}

	public void setTipoTraza(String tipoTraza) {
		this.tipoTraza = tipoTraza;
	}

	public void setGroup(String group) {
		this.group = group;
	}

	public String getGroup() {
		return group;
	}

	public String getDescripcionCorta() {
		return descripcionCorta;
	}

	public void setDescripcionCorta(String descripcionCorta) {
		this.descripcionCorta = descripcionCorta;
	}

	public Date getFechaVencReal() {
		return fechaVencReal;
	}

	public void setFechaVencReal(Date fechaVencReal) {
		this.fechaVencReal = fechaVencReal;
	}

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

	public String getFechaIni() {
		return fechaIni;
	}

	public void setFechaIni(String fechaIni) {
		this.fechaIni = fechaIni;
	}

	public Boolean getAgenda() {
		return agenda;
	}

	public void setAgenda(Boolean agenda) {
		this.agenda = agenda;
	}	
	
}
