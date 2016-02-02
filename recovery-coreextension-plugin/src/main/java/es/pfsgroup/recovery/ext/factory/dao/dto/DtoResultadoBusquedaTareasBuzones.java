package es.pfsgroup.recovery.ext.factory.dao.dto;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Transient;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.GroupTareasDataInfo;

public class DtoResultadoBusquedaTareasBuzones implements Serializable {

	private static final long serialVersionUID = -6477801982496400028L;
	
	private Long id;

    private Long usuarioEnEspera;

    private Long usuarioAlerta;

    private Long usuarioPendiente;

    private Date fechaVenc;

    private Date fechaInicio;

    private String descripcionTarea;

    private String nombreTarea;

    private Integer tareaFinalizada;

    private Integer borrado;

    private String codigoTipoTarea;

    private Integer alerta;

    private Integer espera;

    private String subtipoTareaDescripcion;

    private String subtipoTareaCodigoSubtarea;

    private String tipo;

    private String tipoEntidadCodigo;

    private String emisor;

    private Date fechaVencReal;

    private Integer revisada;

    private Date fechaRevisionAlerta;

    private Long plazo;

    private String entidadInformacion;

    private String codEntidad;

    private String gestor;

    private String tipoSolicitudSQL;

    private Long idEntidad;

    private String fCreacionEntidad;

    private String codigoSituacion;

    private String idTareaAsociada;

    private String descripcionTareaAsociada;

    private String supervisor;

    private String diasVencidoSQL;

    private String descripcionEntidad;

    private String subtipoTareaTipoTareaCodigoTarea;

    private String fechaCreacionEntidadFormateada;

    private String situacionEntidad;

    private String descripcionExpediente;

    private String descripcionContrato;

    private String idEntidadPersona;

    private Float volumenRiesgoSQL;

    private String tipoItinerarioEntidad;

    private String prorrogaFechaPropuesta;

    private String prorrogaCausaProrrogaDescripcion;

    private String codigoContrato;

    private String contrato;

    private transient String descGestor;

    private transient String descSupervisor;
    
    private transient String categoriaTarea;
    
    private Long idProrroga;
    

	public void setCategoriaTarea(String categoriaTarea) {
    	this.categoriaTarea = categoriaTarea;
    }
    
    public String getCategoriaTarea() {
    	/*if (projectContext.getTareasTipoDecision().contains(this.subtipoTareaCodigoSubtarea))
    		return projectContext.CONST_TAREA_TIPO_DECISION;
    	
    	return "";*/
    	return this.categoriaTarea;
    }
    
	public GroupTareasDataInfo getGroupTareasDataInfo() {
		GroupTareasDataInfo gt = new GroupTareasDataInfo();
		gt.setAlerta(this.alerta);
		gt.setCodigoTarea(this.subtipoTareaTipoTareaCodigoTarea);
		gt.setFechaInicio(this.fechaInicio);
		gt.setFechaVenc(this.fechaVenc);
		return gt;
	}


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Long getUsuarioEnEspera() {
        return usuarioEnEspera;
    }


    public void setUsuarioEnEspera(Long usuarioEnEspera) {
        this.usuarioEnEspera = usuarioEnEspera;
    }


    public Long getUsuarioAlerta() {
        return usuarioAlerta;
    }


    public void setUsuarioAlerta(Long usuarioAlerta) {
        this.usuarioAlerta = usuarioAlerta;
    }


    public Long getUsuarioPendiente() {
        return usuarioPendiente;
    }


    public void setUsuarioPendiente(Long usuarioPendiente) {
        this.usuarioPendiente = usuarioPendiente;
    }


    public Date getFechaVenc() {
        return fechaVenc;
    }


    public void setFechaVenc(Date fechaVenc) {
        this.fechaVenc = fechaVenc;
    }


    public Date getFechaInicio() {
        return fechaInicio;
    }


    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }


    public String getDescripcionTarea() {
        return descripcionTarea;
    }


    public void setDescripcionTarea(String descripcionTarea) {
        this.descripcionTarea = descripcionTarea;
    }


    public String getNombreTarea() {
        return nombreTarea;
    }


    public void setNombreTarea(String nombreTarea) {
        this.nombreTarea = nombreTarea;
    }


    public Integer getTareaFinalizada() {
        return tareaFinalizada;
    }


    public void setTareaFinalizada(Integer tareaFinalizada) {
        this.tareaFinalizada = tareaFinalizada;
    }


    public Integer getBorrado() {
        return borrado;
    }


    public void setBorrado(Integer borrado) {
        this.borrado = borrado;
    }


    public String getCodigoTipoTarea() {
        return codigoTipoTarea;
    }


    public void setCodigoTipoTarea(String codigoTipoTarea) {
        this.codigoTipoTarea = codigoTipoTarea;
    }


    public Integer getAlerta() {
        return alerta;
    }


    public void setAlerta(Integer alerta) {
        this.alerta = alerta;
    }


    public Integer getEspera() {
        return espera;
    }


    public void setEspera(Integer espera) {
        this.espera = espera;
    }


    public String getSubtipoTareaDescripcion() {
        return subtipoTareaDescripcion;
    }


    public void setSubtipoTareaDescripcion(String subtipoTareaDescripcion) {
        this.subtipoTareaDescripcion = subtipoTareaDescripcion;
    }


    public String getSubtipoTareaCodigoSubtarea() {
        return subtipoTareaCodigoSubtarea;
    }


    public void setSubtipoTareaCodigoSubtarea(String subtipoTareaCodigoSubtarea) {
        this.subtipoTareaCodigoSubtarea = subtipoTareaCodigoSubtarea;
    }


    public String getTipo() {
        return tipo;
    }


    public void setTipo(String tipo) {
        this.tipo = tipo;
    }


    public String getTipoEntidadCodigo() {
        return tipoEntidadCodigo;
    }


    public void setTipoEntidadCodigo(String tipoEntidadCodigo) {
        this.tipoEntidadCodigo = tipoEntidadCodigo;
    }


    public String getEmisor() {
        return emisor;
    }


    public void setEmisor(String emisor) {
        this.emisor = emisor;
    }


    public Date getFechaVencReal() {
        return fechaVencReal;
    }


    public void setFechaVencReal(Date fechaVencReal) {
        this.fechaVencReal = fechaVencReal;
    }


    public Integer getRevisada() {
        return revisada;
    }


    public void setRevisada(Integer revisada) {
        this.revisada = revisada;
    }


    public Date getFechaRevisionAlerta() {
        return fechaRevisionAlerta;
    }


    public void setFechaRevisionAlerta(Date fechaRevisionAlerta) {
        this.fechaRevisionAlerta = fechaRevisionAlerta;
    }


    public Long getPlazo() {
        return plazo;
    }


    public void setPlazo(Long plazo) {
        this.plazo = plazo;
    }


    public String getEntidadInformacion() {
        return entidadInformacion;
    }


    public void setEntidadInformacion(String entidadInformacion) {
        this.entidadInformacion = entidadInformacion;
    }


    public String getCodEntidad() {
        return codEntidad;
    }


    public void setCodEntidad(String codEntidad) {
        this.codEntidad = codEntidad;
    }


    public String getGestor() {
        return gestor;
    }


    public void setGestor(String gestor) {
        this.gestor = gestor;
    }


    public String getTipoSolicitudSQL() {
        return tipoSolicitudSQL;
    }


    public void setTipoSolicitudSQL(String tipoSolicitudSQL) {
        this.tipoSolicitudSQL = tipoSolicitudSQL;
    }


    public Long getIdEntidad() {
        return idEntidad;
    }


    public void setIdEntidad(Long idEntidad) {
        this.idEntidad = idEntidad;
    }


    public String getfCreacionEntidad() {
        return fCreacionEntidad;
    }


    public void setfCreacionEntidad(String fCreacionEntidad) {
        this.fCreacionEntidad = fCreacionEntidad;
    }


    public String getCodigoSituacion() {
        return codigoSituacion;
    }


    public void setCodigoSituacion(String codigoSituacion) {
        this.codigoSituacion = codigoSituacion;
    }


    public String getIdTareaAsociada() {
        return idTareaAsociada;
    }


    public void setIdTareaAsociada(String idTareaAsociada) {
        this.idTareaAsociada = idTareaAsociada;
    }


    public String getDescripcionTareaAsociada() {
        return descripcionTareaAsociada;
    }


    public void setDescripcionTareaAsociada(String descripcionTareaAsociada) {
        this.descripcionTareaAsociada = descripcionTareaAsociada;
    }


    public String getSupervisor() {
        return supervisor;
    }


    public void setSupervisor(String supervisor) {
        this.supervisor = supervisor;
    }


    public String getDiasVencidoSQL() {
        return diasVencidoSQL;
    }


    public void setDiasVencidoSQL(String diasVencidoSQL) {
        this.diasVencidoSQL = diasVencidoSQL;
    }


    public String getDescripcionEntidad() {
        return descripcionEntidad;
    }


    public void setDescripcionEntidad(String descripcionEntidad) {
        this.descripcionEntidad = descripcionEntidad;
    }


    public String getSubtipoTareaTipoTareaCodigoTarea() {
        return subtipoTareaTipoTareaCodigoTarea;
    }


    public void setSubtipoTareaTipoTareaCodigoTarea(String subtipoTareaTipoTareaCodigoTarea) {
        this.subtipoTareaTipoTareaCodigoTarea = subtipoTareaTipoTareaCodigoTarea;
    }


    public String getFechaCreacionEntidadFormateada() {
        return fechaCreacionEntidadFormateada;
    }


    public void setFechaCreacionEntidadFormateada(String fechaCreacionEntidadFormateada) {
        this.fechaCreacionEntidadFormateada = fechaCreacionEntidadFormateada;
    }


    public String getSituacionEntidad() {
        return situacionEntidad;
    }


    public void setSituacionEntidad(String situacionEntidad) {
        this.situacionEntidad = situacionEntidad;
    }


    public String getDescripcionExpediente() {
        return descripcionExpediente;
    }


    public void setDescripcionExpediente(String descripcionExpediente) {
        this.descripcionExpediente = descripcionExpediente;
    }


    public String getDescripcionContrato() {
        return descripcionContrato;
    }


    public void setDescripcionContrato(String descripcionContrato) {
        this.descripcionContrato = descripcionContrato;
    }


    public String getIdEntidadPersona() {
        return idEntidadPersona;
    }


    public void setIdEntidadPersona(String idEntidadPersona) {
        this.idEntidadPersona = idEntidadPersona;
    }


    public Float getVolumenRiesgoSQL() {
        return volumenRiesgoSQL;
    }


    public void setVolumenRiesgoSQL(Float volumenRiesgoSQL) {
        this.volumenRiesgoSQL = volumenRiesgoSQL;
    }


    public String getTipoItinerarioEntidad() {
        return tipoItinerarioEntidad;
    }


    public void setTipoItinerarioEntidad(String tipoItinerarioEntidad) {
        this.tipoItinerarioEntidad = tipoItinerarioEntidad;
    }


    public String getProrrogaFechaPropuesta() {
        return prorrogaFechaPropuesta;
    }


    public void setProrrogaFechaPropuesta(String prorrogaFechaPropuesta) {
        this.prorrogaFechaPropuesta = prorrogaFechaPropuesta;
    }


    public String getProrrogaCausaProrrogaDescripcion() {
        return prorrogaCausaProrrogaDescripcion;
    }


    public void setProrrogaCausaProrrogaDescripcion(String prorrogaCausaProrrogaDescripcion) {
        this.prorrogaCausaProrrogaDescripcion = prorrogaCausaProrrogaDescripcion;
    }


    public String getCodigoContrato() {
        return codigoContrato;
    }


    public void setCodigoContrato(String codigoContrato) {
        this.codigoContrato = codigoContrato;
    }


    public String getContrato() {
        return contrato;
    }


    public void setContrato(String contrato) {
        this.contrato = contrato;
    }


    public String getDescGestor() {
        return descGestor;
    }


    public void setDescGestor(String descGestor) {
        this.descGestor = descGestor;
    }


    public String getDescSupervisor() {
        return descSupervisor;
    }


    public void setDescSupervisor(String descSupervisor) {
        this.descSupervisor = descSupervisor;
    }
    
    public Long getIdProrroga() {
		return idProrroga;
	}

	public void setIdProrroga(Long idProrroga) {
		this.idProrroga = idProrroga;
	}

}
