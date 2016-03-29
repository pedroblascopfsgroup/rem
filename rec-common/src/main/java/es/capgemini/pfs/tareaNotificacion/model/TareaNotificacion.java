package es.capgemini.pfs.tareaNotificacion.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.recurso.model.Recurso;
import es.capgemini.pfs.telecobro.model.SolicitudExclusionTelecobro;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Clase que modela una tarea, notificación o alerta.
 * @author Pablo Müller
 *
 */
@Entity
@Table(name = "TAR_TAREAS_NOTIFICACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class TareaNotificacion implements Serializable, Auditable {

    private static final long serialVersionUID = -1904964668407772502L;

    @Id
    @Column(name = "TAR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NotificacionGenerator")
    @SequenceGenerator(name = "NotificacionGenerator", sequenceName = "S_TAR_TAREAS_NOTIFICACIONES")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "CLI_ID")
    private Cliente cliente;

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "OBJ_ID")
    private Objetivo objetivo;

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TAR_TAR_ID")
    private TareaNotificacion tareaId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SPR_ID")
    private Prorroga prorroga;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SET_ID")
    private SolicitudExclusionTelecobro solicitudExclusionTelecobro;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CMB_ID")
    private ComunicacionBPM comunicacionBPM;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SCX_ID")
    private SolicitudCancelacion solicitudCancelacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_EST_ID")
    private DDEstadoItinerario estadoItinerario;

    @Column(name = "TAR_CODIGO")
    private String codigoTarea;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_STA_ID")
    private SubtipoTarea subtipoTarea;

    @Column(name = "TAR_TAREA")
    private String tarea;

    @OneToOne(mappedBy = "tareaPadre", fetch = FetchType.LAZY)
    private TareaExterna tareaExterna;

    @OneToOne(mappedBy = "tareaAsociada", fetch = FetchType.LAZY)
    private DecisionProcedimiento decisionAsociada;

    @OneToOne(mappedBy = "tareaNotificacion", fetch = FetchType.LAZY)
    private Recurso recurso;

    @OneToMany(mappedBy = "tareaAsociada", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Prorroga> prorrogasAsociada;

    @Column(name = "TAR_DESCRIPCION")
    private String descripcionTarea;

    @Column(name = "TAR_FECHA_INI")
    private Date fechaInicio;

    @Column(name = "TAR_FECHA_FIN")
    private Date fechaFin;

    @Column(name = "TAR_FECHA_VENC")
    private Date fechaVenc;

    @Column(name = "TAR_EN_ESPERA")
    private Boolean espera;

    @Column(name = "TAR_ALERTA")
    private Boolean alerta;

    @Column(name = "TAR_EMISOR")
    private String emisor;

    @Column(name = "TAR_TAREA_FINALIZADA")
    private Boolean tareaFinalizada;

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_EIN_ID")
    private DDTipoEntidad tipoEntidad;

    @Transient
    private String descGestor;

    @Transient
    private String descSupervisor;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
    private transient String categoriaTarea;
    
    public void setCategoriaTarea(String categoriaTarea) {
    	this.categoriaTarea = categoriaTarea;
    }
    
    public String getCategoriaTarea() {
    	/*if (projectContext.getTareasTipoDecision().contains(this.subtipoTareaCodigoSubtarea))
    		return projectContext.CONST_TAREA_TIPO_DECISION;
    	
    	return "";*/
    	return this.categoriaTarea;
    }    

    /**
     * Devuelve el recurso asociado a la tarea (si es que existe).
     * @return Recurso
     */
    public Recurso getRecurso() {
        return recurso;
    }

    /**
     * Setea el estado de borrado de la tarea.
     * Este mï¿½todo se utilizarï¿½ ï¿½nicamente para marcar una tarea como paralizada (no aparecerï¿½ en los listados)
     * @param borrado Si la tarea estÃ¡ o no borrada
     */
    public void setBorrado(Boolean borrado) {
        auditoria.setBorrado(borrado);
    }

    /**
     * devuelve el plazo.
     * @return plazo
     */
    public Long getPlazo() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
            if (expediente != null) { return getExpediente().getArquetipo().getItinerario().getEstado(expediente.getEstadoItinerario().getCodigo())
                    .getPlazo(); }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (cliente != null) { return getCliente().getArquetipo().getItinerario().getEstado(cliente.getEstadoItinerario().getCodigo()).getPlazo(); }
        }
        return null;
    }

    /**
     * devuelve el gestor.
     * @return gestor
     */
    public Long getGestor() {
        Perfil perfil = null;
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getAsunto().getGestor()
                .getUsuario().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getGestor().getUsuario().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
            if (getExpediente() != null) {
                perfil = getExpediente().getArquetipo().getItinerario().getEstado(expediente.getEstadoItinerario().getCodigo()).getGestorPerfil();
            }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) {
                perfil = getCliente().getArquetipo().getItinerario().getEstado(cliente.getEstadoItinerario().getCodigo()).getGestorPerfil();
            }
        }
        if (perfil != null) { return perfil.getId(); }
        return null;
    }

    /**
     * devuelve la descripcion gestor.
     * @return gestor
     */
    public String getDescGestor() {
        Perfil perfil = null;
        if (descGestor == null) {
            if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getAsunto().getGestor()
                    .getUsuario().getApellidoNombre(); }
            if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getGestor().getUsuario()
                    .getApellidoNombre(); }
            if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
                if (getExpediente() != null) { return calcularGestorExpediente(); }
            }
            if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
                if (getCliente() != null) {
                    perfil = getCliente().getArquetipo().getItinerario().getEstado(cliente.getEstadoItinerario().getCodigo()).getGestorPerfil();
                    if (perfil == null) { return ""; }
                    return perfil.getDescripcion();
                }
            }
            return "";
        }
        return descGestor;

    }

    /**
     * calcula el nombre del gestor para el espediente.
     * @return gestor
     */
    private String calcularGestorExpediente() {
        if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(expediente.getEstadoItinerario().getCodigo())) {
            if (getExpediente().getComite() != null && getExpediente().getComite().getNombre() != null) { return getExpediente().getComite()
                    .getNombre(); }
            return "";

        }
        Perfil per = getExpediente().getArquetipo().getItinerario().getEstado(expediente.getEstadoItinerario().getCodigo()).getGestorPerfil();
        if (per != null) { return per.getDescripcion(); }
        return "";

    }

    /**
     * set de descGestor.
     * @param descGestor descGestor
     */
    public void setDescGestor(String descGestor) {
        this.descGestor = descGestor;
    }

    /**
     * set de descSupervisor.
     * @param descSupervisor descSupervisor
     */
    public void setDescSupervisor(String descSupervisor) {
        this.descSupervisor = descSupervisor;
    }

    /**
     * devuelve el supervisor.
     * @return supervisor
     */
    public Long getSupervisor() {
        Perfil perfil = null;
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getAsunto().getSupervisor()
                .getUsuario().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getSupervisor().getUsuario().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
            if (getExpediente() != null) {
                perfil = getExpediente().getArquetipo().getItinerario().getEstado(expediente.getEstadoItinerario().getCodigo()).getSupervisor();
            }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) {
                perfil = getCliente().getArquetipo().getItinerario().getEstado(cliente.getEstadoItinerario().getCodigo()).getSupervisor();
            }
        }
        if (perfil != null) { return perfil.getId(); }
        return null;
    }

    /**
     * devuelve el supervisor.
     * @return supervisor
     */
    public String getDescSupervisor() {
        if (descSupervisor == null) {
            if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getAsunto().getSupervisor()
                    .getUsuario().getApellidoNombre(); }
            if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getSupervisor().getUsuario()
                    .getApellidoNombre(); }
            if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
                if (getExpediente() != null) { return calcularSupervisorExpediente(); }
            }
            if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
                if (getCliente() != null) {
                    Perfil perfil = getCliente().getArquetipo().getItinerario().getEstado(cliente.getEstadoItinerario().getCodigo()).getSupervisor();
                    if (perfil == null) { return ""; }
                    return perfil.getDescripcion();
                }
            }
            return "";
        }
        return descSupervisor;
    }

    /**
     * calcula el nombre del supervisor para el espediente.
     * @return supervisor
     */
    private String calcularSupervisorExpediente() {
        Perfil perfil = null;
        if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(expediente.getEstadoItinerario().getCodigo())) {
            if (getExpediente().getComite() != null) {
                perfil = getExpediente().getComite().getPerfiles().get(0);
            }
        } else {
            perfil = getExpediente().getArquetipo().getItinerario().getEstado(expediente.getEstadoItinerario().getCodigo()).getSupervisor();
        }

        if (perfil == null) { return ""; }
        return perfil.getDescripcion();
    }

    /**
     * devuelve el id de la entidad.
     * @return id de la entidad
     */
    public Long getIdEntidad() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(tipoEntidad.getCodigo())) { return getObjetivo().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_TAREA.equals(tipoEntidad.getCodigo())) { return getTareaId().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) { return getCliente().getId(); }
        } else {
            if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
                if (getExpediente() != null) { return getExpediente().getId(); }
            }
        }
        return null;
    }

    /**
     * devuelve el id de la entidad para la persona.
     * @return id de la entidad
     */
    public Long getIdEntidadPersona() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(tipoEntidad.getCodigo())) { return getObjetivo().getPolitica().getCicloMarcadoPolitica()
                .getPersona().getId(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) { return getCliente().getPersona().getId(); }
        }
        return null;
    }

    /**
     * devuelve la fecha de creacion de la entidad.
     * @return fecha creacion
     */
    public Date getFechaCreacionEntidad() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(tipoEntidad.getCodigo())) { return getObjetivo().getAuditoria().getFechaCrear(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) { return getExpediente().getAuditoria().getFechaCrear(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getAuditoria().getFechaCrear(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getAuditoria().getFechaCrear(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_TAREA.equals(tipoEntidad.getCodigo())) { return getTareaId().getAuditoria().getFechaCrear(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) { return getCliente().getFechaCreacion(); }
        }
        return null;
    }

    /**
     * retorna la situacion de la entidad de la tarea.
     * @return situacion
     */
    public String getSituacionEntidad() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) { return getExpediente().getEstadoItinerario().getDescripcion(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getEstadoItinerario().getDescripcion(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) { return getCliente().getEstadoItinerario().getDescripcion(); }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(tipoEntidad.getCodigo())) { return getObjetivo().getEstadoCumplimiento().getDescripcion(); }
        return "";
    }

    /**
     * retorna el tipo de itinerario de la entidad de la tarea.
     * @return situacion
     */
    public String getTipoItinerarioEntidad() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
            return getExpediente().getTipoItinerario();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) { return getCliente().getTipoItinerario(); }
        }
        return "";
    }

    /**
     * getDescripcionEntidad.
     * @return getDescripcionEntidad
     */
    public String getDescripcionEntidad() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getNombreProcedimiento(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) { return getAsunto().getNombre(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) { return getExpediente().getDescripcionExpediente(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(tipoEntidad.getCodigo())) { return getObjetivo().getPolitica().getCicloMarcadoPolitica()
                .getPersona().getApellidoNombre(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) { return getCliente().getPersona().getApellidoNombre(); }
        }
        return getDescripcionTarea();
    }

    /**
     * get codigo.
     * @return codigo
     */
    public String getCodigo() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            if (getCliente() != null) { return getCliente().getPersona().getCodClienteEntidad().toString(); }
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
            return getExpediente().getId().toString();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) {
            return getAsunto().getId().toString();
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) { return getProcedimiento().getId().toString(); }
        return "";
    }

    /**
     * @return the fechaInicio
     */
    public String getFechaCreacionEntidadFormateada() {
        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        if (getFechaCreacionEntidad() != null) { return df.format(getFechaCreacionEntidad()); }
        return null;
    }

    @Transient
    private static final long DAY_MILISECONDS = 1000 * 60 * 60 * 24;

    /**
     * obtiene los dias que ya esta vencido.
     * @return dias vencido
     */
    public String getDiasVencido() {
        if (alerta != null && alerta.booleanValue()) {
            if (getFechaVenc() != null) {
                Long dif = new Date().getTime() - getFechaVenc().getTime();
                return String.valueOf(Math.round(dif / DAY_MILISECONDS));
            }
        }
        return "";
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * @param expediente the expediente to set
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * @return the cliente
     */
    public Cliente getCliente() {
        return cliente;
    }

    /**
     * @param cliente the cliente to set
     */
    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    /**
     * @return the codigoTarea
     */
    public String getCodigoTarea() {
        return codigoTarea;
    }

    /**
     * @param codigoTarea the codigoTarea to set
     */
    public void setCodigoTarea(String codigoTarea) {
        this.codigoTarea = codigoTarea;
    }

    /**
     * @return the tarea
     */
    public String getTarea() {
        return tarea;
    }

    /**
     * @param tarea the tarea to set
     */
    public void setTarea(String tarea) {
        this.tarea = tarea;
    }

    /**
     * @return the descripcionTarea
     */
    public String getDescripcionTarea() {
        return descripcionTarea;
    }

    /**
     * @param descripcionTarea the descripcionTarea to set
     */
    public void setDescripcionTarea(String descripcionTarea) {
        this.descripcionTarea = descripcionTarea;
    }

    /**
     * @return the fechaInicio
     */
    public Date getFechaInicio() {
        return fechaInicio;
    }

    /**
     * @return the fechaInicio
     */
    public String getFechaInicioFormateada() {
        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        if (getFechaInicio() != null) { return df.format(getFechaInicio()); }
        return null;
    }

    /**
     * @param fechaInicio the fechaInicio to set
     */
    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    /**
     * @return the fechaFin
     */
    public Date getFechaFin() {
        return fechaFin;
    }

    /**
     * @param fechaFin the fechaFin to set
     */
    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    /**
     * @return the espera
     */
    public Boolean getEspera() {
        return espera;
    }

    /**
     * @param espera the espera to set
     */
    public void setEspera(Boolean espera) {
        this.espera = espera;
    }

    /**
     * @return the alerta
     */
    public Boolean getAlerta() {
        return alerta;
    }

    /**
     * @param alerta the alerta to set
     */
    public void setAlerta(Boolean alerta) {
        this.alerta = alerta;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the subtipoTarea
     */
    public SubtipoTarea getSubtipoTarea() {
        return subtipoTarea;
    }

    /**
     * @param subtipoTarea the subtipoTarea to set
     */
    public void setSubtipoTarea(SubtipoTarea subtipoTarea) {
        this.subtipoTarea = subtipoTarea;
    }

    /**
     * @return the tipoEntidad
     */
    public DDTipoEntidad getTipoEntidad() {
        return tipoEntidad;
    }

    /**
     * @param tipoEntidad the tipoEntidad to set
     */
    public void setTipoEntidad(DDTipoEntidad tipoEntidad) {
        this.tipoEntidad = tipoEntidad;
    }

    /**
     * @return the asunto
     */
    public Asunto getAsunto() {
        return asunto;
    }

    /**
     * @param asunto the asunto to set
     */
    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
    }

    /**
     * @return the tareaId
     */
    public TareaNotificacion getTareaId() {
        return tareaId;
    }

    /**
     * @param tareaId the tareaId to set
     */
    public void setTareaId(TareaNotificacion tareaId) {
        this.tareaId = tareaId;
    }

    /**
     * @return the prorroga
     */
    public Prorroga getProrroga() {
        return prorroga;
    }

    /**
     * @param prorroga the prorroga to set
     */
    public void setProrroga(Prorroga prorroga) {
        this.prorroga = prorroga;
    }

    /**
     * @return the tareaFinalizada
     */
    public Boolean getTareaFinalizada() {
        return tareaFinalizada;
    }

    /**
     * @param tareaFinalizada the tareaFinalizada to set
     */
    public void setTareaFinalizada(Boolean tareaFinalizada) {
        this.tareaFinalizada = tareaFinalizada;
    }

    /**
     * @return the estadoItinerario
     */
    public DDEstadoItinerario getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * @param estadoItinerario the estadoItinerario to set
     */
    public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the emisor
     */
    public String getEmisor() {
        return emisor;
    }

    /**
     * @param emisor the emisor to set
     */
    public void setEmisor(String emisor) {
        this.emisor = emisor;
    }

    /**
     * obtiene comunicacion o prorroga.
     * @return comunicacion o prorroga
     */
    public String getTipoSolicitud() {
        //TODO Cuando se habilite el telecobro añadir las tareas pertinentes
        //TODO i18n

        String tipoSolicitud = getSubtipoTarea().getDescripcion();
        if (SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_ENSAN.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_SANC.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO.equals(getSubtipoTarea().getCodigoSubtarea())) {
            tipoSolicitud = "Prorroga";
        } else if (SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR.equals(getSubtipoTarea().getCodigoSubtarea())) {
            tipoSolicitud = "Cancelación Expediente";
        } else if (SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL.equals(getSubtipoTarea().getCodigoSubtarea())) {
            tipoSolicitud = "Expediente Manual";
        } else if (SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR.equals(getSubtipoTarea().getCodigoSubtarea())) {
            tipoSolicitud = "Comunicacion";
        } else if (SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_MARCADO.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_OK.equals(getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_KO.equals(getSubtipoTarea().getCodigoSubtarea())) {
            tipoSolicitud = "Cumplimiento MV";
        }
        return tipoSolicitud;
    }


    /**
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }

    /**
     * @return the comunicacionBPM
     */
    public ComunicacionBPM getComunicacionBPM() {
        return comunicacionBPM;
    }

    /**
     * @param comunicacionBPM the comunicacionBPM to set
     */
    public void setComunicacionBPM(ComunicacionBPM comunicacionBPM) {
        this.comunicacionBPM = comunicacionBPM;
    }

    /**
     * @return the solicitudExclusionTelecobro
     */
    public SolicitudExclusionTelecobro getSolicitudExclusionTelecobro() {
        return solicitudExclusionTelecobro;
    }

    /**
     * @param solicitudExclusionTelecobro the solicitudExclusionTelecobro to set
     */
    public void setSolicitudExclusionTelecobro(SolicitudExclusionTelecobro solicitudExclusionTelecobro) {
        this.solicitudExclusionTelecobro = solicitudExclusionTelecobro;
    }

    /**
     * get entidad de informacion.
     * @return entidad
     */
    public String getEntidadInformacion() {
        String r = getTipoEntidad().getDescripcion();
        if (getIdEntidad() != null) {
            r += " [" + getIdEntidad() + "]";
        }
        return r;
    }

    /**
     * @return the solicitudCancelacion
     */
    public SolicitudCancelacion getSolicitudCancelacion() {
        return solicitudCancelacion;
    }

    /**
     * @param solicitudCancelacion the solicitudCancelacion to set
     */
    public void setSolicitudCancelacion(SolicitudCancelacion solicitudCancelacion) {
        this.solicitudCancelacion = solicitudCancelacion;
    }

    /**
     * @return the fechaVenc
     */
    public Date getFechaVenc() {
        return fechaVenc;
    }

    /**
     * @param fechaVenc the fechaVenc to set
     */
    public void setFechaVenc(Date fechaVenc) {
        this.fechaVenc = fechaVenc;
    }

    /**
     * @return the tareaExterna
     */
    public TareaExterna getTareaExterna() {
        return tareaExterna;
    }

    /**
     * @param tareaExterna the tareaExterna to set
     */
    public void setTareaExterna(TareaExterna tareaExterna) {
        this.tareaExterna = tareaExterna;
    }

    /**
     * @return the prorrogasAsociada
     */
    public List<Prorroga> getProrrogasAsociada() {
        return prorrogasAsociada;
    }

    /**
     * @param prorrogasAsociada the prorrogasAsociada to set
     */
    public void setProrrogasAsociada(List<Prorroga> prorrogasAsociada) {
        this.prorrogasAsociada = prorrogasAsociada;
    }

    /**
     * obtiene la prorroga activa o ninguna.
     * @return prorroga
     */
    public Prorroga getProrrogaAsociada() {
        for (Prorroga p : getProrrogasAsociada()) {
            if (!p.getAuditoria().isBorrado()) { return p; }
        }
        return null;
    }

    /**
     * @return the decisionAsociada
     */
    public DecisionProcedimiento getDecisionAsociada() {
        return decisionAsociada;
    }

    /**
     * @param decisionAsociada the decisionAsociada to set
     */
    public void setDecisionAsociada(DecisionProcedimiento decisionAsociada) {
        this.decisionAsociada = decisionAsociada;
    }

    /**
     * Volumen de Riesgo de la entidad de información asociada a la tarea (cliente, expediente, asunto o procedimiento).
     * @return el volumen de riesgo
     */
    public Float getVolumenRiesgo() {
        Float vr = null;

        if (this.tipoEntidad.getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO)) {
            vr = this.asunto.getVolumenRiesgo();
        }
        if (this.tipoEntidad.getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE)) {
            if (this.cliente.getPersona() != null) {
                vr = this.cliente.getPersona().getRiesgoDirecto();
            }
        }
        if (this.tipoEntidad.getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE) && this.expediente.getVolumenRiesgo() != null) {
            vr = this.expediente.getVolumenRiesgo().floatValue();
        }
        if (this.tipoEntidad.getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO)) {
            vr = this.procedimiento.getSaldoRecuperacion().floatValue();
        }
        return vr;
    }

    /**
     * Volumen de Riesgo Vencido de la entidad de información asociada a la tarea (cliente, expediente, asunto o procedimiento).
     * @return el volumen de riesgo vencido
     */
    public Float getVolumenRiesgoVencido() {
        Float vr = null;

        if (this.tipoEntidad.getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE)) {
            vr = this.cliente.getPersona().getRiesgoTotal();
        }
        if (this.tipoEntidad.getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE) && this.expediente.getVolumenRiesgoVencido() != null) {
            vr = this.expediente.getVolumenRiesgoVencido().floatValue();
        }
        return vr;
    }

    /**
     * @return the objetivo
     */
    public Objetivo getObjetivo() {
        return objetivo;
    }

    /**
     * @param objetivo the objetivo to set
     */
    public void setObjetivo(Objetivo objetivo) {
        this.objetivo = objetivo;
    }

}
