package es.capgemini.pfs.prorroga.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * entidad de la tabla SPR_SOLICITUD_PRORROGA.
 * @author jbosnjak
 *
 */
@Entity
@Table(name = "SPR_SOLICITUD_PRORROGA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Prorroga implements Serializable, Auditable {

    private static final long serialVersionUID = -1904964668407772502L;

    @Id
    @Column(name = "SPR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProrrogaGenerator")
    @SequenceGenerator(name = "ProrrogaGenerator", sequenceName = "S_SPR_SOLICITUD_PRORROGA")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_RPR_ID")
    private RespuestaProrroga respuestaProrroga;

    @ManyToOne
    @JoinColumn(name = "DD_CPR_ID")
    private CausaProrroga causaProrroga;

    @OneToMany(mappedBy = "prorroga")
    @OrderBy("id ASC")
    private List<TareaNotificacion> tarea;

    @ManyToOne
    @JoinColumn(name = "TAR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private TareaNotificacion tareaAsociada;

    @Column(name = "SPR_PROCESS_BPM")
    private Long bpmProcess;

    @Column(name = "SPR_FECHA_PROPUESTA")
    private Date fechaPropuesta;
    
    @Column(name = "SPR_OBSERVACIONES_RESPUESTA")
    private String observacionesRespuesta;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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
     * @return the respuestaProrroga
     */
    public RespuestaProrroga getRespuestaProrroga() {
        return respuestaProrroga;
    }

    /**
     * @param respuestaProrroga the respuestaProrroga to set
     */
    public void setRespuestaProrroga(RespuestaProrroga respuestaProrroga) {
        this.respuestaProrroga = respuestaProrroga;
    }

    /**
     * @return the causaProrroga
     */
    public CausaProrroga getCausaProrroga() {
        return causaProrroga;
    }

    /**
     * @param causaProrroga the causaProrroga to set
     */
    public void setCausaProrroga(CausaProrroga causaProrroga) {
        this.causaProrroga = causaProrroga;
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
     * @return the tarea
     */
    public TareaNotificacion getTarea() {
        return tarea != null && tarea.size() > 0 ? tarea.get(0) : null;
    }

    /**
     * @return the bpmProcess
     */
    public Long getBpmProcess() {
        return bpmProcess;
    }

    /**
     * @param bpmProcess the bpmProcess to set
     */
    public void setBpmProcess(Long bpmProcess) {
        this.bpmProcess = bpmProcess;
    }

    /**
     * @return the fechaPropuesta
     */
    public Date getFechaPropuesta() {
        return fechaPropuesta;
    }

    /**
     * @param fechaPropuesta the fechaPropuesta to set
     */
    public void setFechaPropuesta(Date fechaPropuesta) {
        this.fechaPropuesta = fechaPropuesta;
    }

    /**
     * @return the tareaAsociada
     */
    public TareaNotificacion getTareaAsociada() {
        return tareaAsociada;
    }

    /**
     * @param tareaAsociada the tareaAsociada to set
     */
    public void setTareaAsociada(TareaNotificacion tareaAsociada) {
        this.tareaAsociada = tareaAsociada;
    }

	public String getObservacionesRespuesta() {
		return observacionesRespuesta;
	}

	public void setObservacionesRespuesta(String observacionesRespuesta) {
		this.observacionesRespuesta = observacionesRespuesta;
	}
    
    
}
