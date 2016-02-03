package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.DiscriminatorType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Vista que obtiene las tareas que debe realizar un determinado usuario. Esta
 * vista est� pensada para optimizar los buzones de tareas
 * 
 * @author bruno
 * 
 */
@Entity
@Table(name = "VTAR_TAREA_VS_USUARIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Inheritance(strategy= InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "CLASS",discriminatorType = DiscriminatorType.STRING)
public class VTARTareaVsUsuario {

    @Id
    @Column(name = "TAR_ID", insertable = false, updatable = false)
    private Long id;

    @Column(name = "USU_ESPERA", insertable = false, updatable = false)
    private Long usuarioEnEspera;

    @Column(name = "USU_ALERTA", insertable = false, updatable = false)
    private Long usuarioAlerta;

    @Column(name = "USU_PENDIENTES", insertable = false, updatable = false)
    private Long usuarioPendiente;

    @Column(name = "TAR_FECHA_VENC", insertable = false, updatable = false)
    private Date fechaVenc;

    @Column(name = "TAR_FECHA_INI", insertable = false, updatable = false)
    private Date fechaInicio;

    @Column(name = "TAR_DESCRIPCION", insertable = false, updatable = false)
    private String descripcionTarea;

    @Column(name = "TAR_TAREA", insertable = false, updatable = false)
    private String nombreTarea;

    @Column(name = "TAR_TAREA_FINALIZADA", insertable = false, updatable = false)
    private Integer tareaFinalizada;

    @Column(name = "BORRADO", insertable = false, updatable = false)
    private Integer borrado;

    @Column(name = "TAR_CODIGO", insertable = false, updatable = false)
    private String codigoTipoTarea;

    @Column(name = "TAR_ALERTA", insertable = false, updatable = false)
    private Integer alerta;

    @Column(name = "TAR_EN_ESPERA", insertable = false, updatable = false)
    private Integer espera;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "TAR_ID", insertable = false, updatable = false)
    private TareaNotificacion tarea;

    @Column(name = "TAR_SUBTIPO_DESC", insertable = false, updatable = false)
    private String subtipoTareaDescripcion;

    @Column(name = "TAR_SUBTIPO_COD", insertable = false, updatable = false)
    private String subtipoTareaCodigoSubtarea;

    @Column(name = "TAR_DTYPE", insertable = false, updatable = false)
    private String tipo;

    @Column(name = "TAR_TIPO_ENT_COD", insertable = false, updatable = false)
    private String tipoEntidadCodigo;

    @Column(name = "TAR_EMISOR", insertable = false, updatable = false)
    private String emisor;

    @Column(name = "TAR_FECHA_VENC_REAL", insertable = false, updatable = false)
    private Date fechaVencReal;

    @Column(name = "NFA_TAR_REVISADA", insertable = false, updatable = false)
    private Integer revisada;

    @Column(name = "NFA_TAR_FECHA_REVIS_ALER", insertable = false, updatable = false)
    private Date fechaRevisionAlerta;

    @Column(name = "PLAZO", insertable = false, updatable = false)
    private Long plazo;

    @Column(name = "ENTIDADINFORMACION", insertable = false, updatable = false)
    private String entidadInformacion;

    @Column(name = "CODENTIDAD", insertable = false, updatable = false)
    private String codEntidad;

    @Column(name = "GESTOR", insertable = false, updatable = false)
    private String gestor;

    @Column(name = "TIPOSOLICITUDSQL", insertable = false, updatable = false)
    private String tipoSolicitudSQL;

    @Column(name = "IDENTIDAD", insertable = false, updatable = false)
    private Long idEntidad;

    @Column(name = "FCREACIONENTIDAD", insertable = false, updatable = false)
    private String fCreacionEntidad;

    @Column(name = "CODIGOSITUACION", insertable = false, updatable = false)
    private String codigoSituacion;

    @Column(name = "IDTAREAASOCIADA", insertable = false, updatable = false)
    private String idTareaAsociada;

    @Column(name = "DESCRIPCIONTAREAASOCIADA", insertable = false, updatable = false)
    private String descripcionTareaAsociada;

    @Column(name = "SUPERVISOR", insertable = false, updatable = false)
    private String supervisor;

    @Column(name = "DIASVENCIDOSQL", insertable = false, updatable = false)
    private String diasVencidoSQL;

    @Column(name = "DESCRIPCIONENTIDAD", insertable = false, updatable = false)
    private String descripcionEntidad;

    @Column(name = "SUBTIPOTARCODTAREA", insertable = false, updatable = false)
    private String subtipoTareaTipoTareaCodigoTarea;

    @Column(name = "FECHACREACIONENTIDADFORMATEADA", insertable = false, updatable = false)
    private String fechaCreacionEntidadFormateada;

    @Column(name = "CODIGOSITUACION", insertable = false, updatable = false)
    private String situacionEntidad;

    @Column(name = "DESCRIPCIONEXPEDIENTE", insertable = false, updatable = false)
    private String descripcionExpediente;

    @Column(name = "DESCRIPCIONCONTRATO", insertable = false, updatable = false)
    private String descripcionContrato;

    @Column(name = "IDENTIDADPERSONA", insertable = false, updatable = false)
    private String idEntidadPersona;

    @Column(name = "VOLUMENRIESGOSQL", insertable = false, updatable = false)
    private Float volumenRiesgoSQL;

    @Column(name = "TIPOITINERARIOENTIDAD", insertable = false, updatable = false)
    private String tipoItinerarioEntidad;

    @Column(name = "PRORROGAFECHAPROPUESTA", insertable = false, updatable = false)
    private String prorrogaFechaPropuesta;

    @Column(name = "PRORROGACAUSADESCRIPCION", insertable = false, updatable = false)
    private String prorrogaCausaProrrogaDescripcion;

    @Column(name = "CODIGOCONTRATO", insertable = false, updatable = false)
    private String codigoContrato;

    @Column(name = "CONTRATO", insertable = false, updatable = false)
    private String contrato;
    
    @Column(name="ZON_COD", insertable=false, updatable = false)
    private String zonCodigo;
    
    @Column(name="PEF_ID", insertable=false, updatable = false)
    private Long idPerfil;
    
    @Column(name="SPR_ID", insertable=false, updatable = false)
    private Long idProrroga;
    

	@ManyToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;    

    public String getContrato() {
        return contrato;
    }

    public void setContrato(String contrato) {
        this.contrato = contrato;
    }

    public String getCodigoContrato() {
        return codigoContrato;
    }

    public void setCodigoContrato(String codigoContrato) {
        this.codigoContrato = codigoContrato;
    }

    public String getSubtipoTareaDescripcion() {
        return subtipoTareaDescripcion;
    }

    public String getSubtipoTareaCodigoSubtarea() {
        return subtipoTareaCodigoSubtarea;
    }

    public String getTipo() {
        return tipo;
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

    public String getTipoEntidadCodigo() {
        return tipoEntidadCodigo;
    }

    public String getEmisior() {
        return emisor;
    }

    public Date getFechaVencReal() {
        return fechaVencReal;
    }

    public Integer getRevisada() {
        return revisada;
    }

    public Date getFechaRevisionAlerta() {
        return fechaRevisionAlerta;
    }

    public Long getId() {
        return id;
    }

    public Long getUsuarioEnEspera() {
        return usuarioEnEspera;
    }

    public Long getUsuarioAlerta() {
        return usuarioAlerta;
    }

    public Long getUsuarioPendiente() {
        return usuarioPendiente;
    }

    public Date getFechaVenc() {
        return fechaVenc;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public String getDescripcionTarea() {
        return descripcionTarea;
    }

    public String getNombreTarea() {
        return nombreTarea;
    }

    public Integer getTareaFinalizada() {
        return tareaFinalizada;
    }

    public Integer getBorrado() {
        return borrado;
    }

    public String getCodigoTipoTarea() {
        return codigoTipoTarea;
    }

    public Integer getAlerta() {
        return alerta;
    }

    public Integer getEspera() {
        return espera;
    }

    public TareaNotificacion getTarea() {
        return tarea;
    }

    public String getEmisor() {
        return emisor;
    }

    public void setEmisor(String emisor) {
        this.emisor = emisor;
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

    public void setId(Long id) {
        this.id = id;
    }

    public void setUsuarioEnEspera(Long usuarioEnEspera) {
        this.usuarioEnEspera = usuarioEnEspera;
    }

    public void setUsuarioAlerta(Long usuarioAlerta) {
        this.usuarioAlerta = usuarioAlerta;
    }

    public void setUsuarioPendiente(Long usuarioPendiente) {
        this.usuarioPendiente = usuarioPendiente;
    }

    public void setFechaVenc(Date fechaVenc) {
        this.fechaVenc = fechaVenc;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public void setDescripcionTarea(String descripcionTarea) {
        this.descripcionTarea = descripcionTarea;
    }

    public void setNombreTarea(String nombreTarea) {
        this.nombreTarea = nombreTarea;
    }

    public void setTareaFinalizada(Integer tareaFinalizada) {
        this.tareaFinalizada = tareaFinalizada;
    }

    public void setBorrado(Integer borrado) {
        this.borrado = borrado;
    }

    public void setCodigoTipoTarea(String codigoTipoTarea) {
        this.codigoTipoTarea = codigoTipoTarea;
    }

    public void setAlerta(Integer alerta) {
        this.alerta = alerta;
    }

    public void setEspera(Integer espera) {
        this.espera = espera;
    }

    public void setTarea(TareaNotificacion tarea) {
        this.tarea = tarea;
    }

    public void setSubtipoTareaDescripcion(String subtipoTareaDescripcion) {
        this.subtipoTareaDescripcion = subtipoTareaDescripcion;
    }

    public void setSubtipoTareaCodigoSubtarea(String subtipoTareaCodigoSubtarea) {
        this.subtipoTareaCodigoSubtarea = subtipoTareaCodigoSubtarea;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setTipoEntidadCodigo(String tipoEntidadCodigo) {
        this.tipoEntidadCodigo = tipoEntidadCodigo;
    }

    public void setFechaVencReal(Date fechaVencReal) {
        this.fechaVencReal = fechaVencReal;
    }

    public void setRevisada(Integer revisada) {
        this.revisada = revisada;
    }

    public void setFechaRevisionAlerta(Date fechaRevisionAlerta) {
        this.fechaRevisionAlerta = fechaRevisionAlerta;
    }

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public String getZonCodigo() {
		return zonCodigo;
	}

	public void setZonCodigo(String zonCodigo) {
		this.zonCodigo = zonCodigo;
	}

	public Long getIdPerfil() {
		return idPerfil;
	}

	public void setIdPerfil(Long idPerfil) {
		this.idPerfil = idPerfil;
	} 
	
    public Long getIdProrroga() {
		return idProrroga;
	}

	public void setIdProrroga(Long idProrroga) {
		this.idProrroga = idProrroga;
	}
    
}
