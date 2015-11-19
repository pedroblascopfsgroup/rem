package es.capgemini.pfs.decisionProcedimiento.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * poner javadoc FO.
 * @author fo
 *
 */
@Entity
@Table(name = "DPR_DECISIONES_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class DecisionProcedimiento implements Serializable, Auditable {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = 5367097082574924021L;

    @Id
    @Column(name = "DPR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DecisionProcedimientoGenerator")
    @SequenceGenerator(name = "DecisionProcedimientoGenerator", sequenceName = "S_DPR_DEC_PROCEDIMIENTOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @OneToOne
    @JoinColumn(name = "TAR_ID")
    private TareaNotificacion tareaAsociada;

    @Column(name = "DPR_FINALIZA")
    private Boolean finalizada;

    @Column(name = "DPR_PARALIZA")
    private Boolean paralizada;

    @OneToOne
    @JoinColumn(name = "DD_CDE_ID")
    private DDCausaDecision causaDecision;

    @OneToOne
    @JoinColumn(name = "DD_DFI_ID")
    private DDCausaDecisionFinalizar causaDecisionFinalizar;
    
    @OneToOne
    @JoinColumn(name = "DD_DPA_ID")
    private DDCausaDecisionParalizar causaDecisionParalizar;
    
    @Column(name = "DPR_ENTIDAD")
    private String entidad;
    
    @Column(name="SYS_GUID")
	private String guid;

    public DDCausaDecisionFinalizar getCausaDecisionFinalizar() {
		return causaDecisionFinalizar;
	}

	public void setCausaDecisionFinalizar(
			DDCausaDecisionFinalizar causaDecisionFinalizar) {
		this.causaDecisionFinalizar = causaDecisionFinalizar;
	}

	public DDCausaDecisionParalizar getCausaDecisionParalizar() {
		return causaDecisionParalizar;
	}

	public void setCausaDecisionParalizar(
			DDCausaDecisionParalizar causaDecisionParalizar) {
		this.causaDecisionParalizar = causaDecisionParalizar;
	}

	@OneToOne
    @JoinColumn(name = "DD_EDE_ID")
    private DDEstadoDecision estadoDecision;

    @Column(name = "DPR_FECHA_PARA")
    private Date fechaParalizacion;

    @Column(name = "DPR_COMENTARIOS")
    private String comentarios;

    @OneToMany(mappedBy = "decisionProcedimiento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DPR_ID")
    @LazyCollection(LazyCollectionOption.FALSE)
    @Cascade({org.hibernate.annotations.CascadeType.ALL})
    private List<ProcedimientoDerivado> procedimientosDerivados;

    @Column(name = "DPR_PROCESS_BPM")
    private Long processBPM;

    @Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

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
     * @return the finalizada
     */
    public Boolean getFinalizada() {
        return finalizada;
    }

    /**
     * @param finalizada the finalizada to set
     */
    public void setFinalizada(Boolean finalizada) {
        this.finalizada = finalizada;
    }

    /**
     * @return the paralizada
     */
    public Boolean getParalizada() {
        return paralizada;
    }

    /**
     * @param paralizada the paralizada to set
     */
    public void setParalizada(Boolean paralizada) {
        this.paralizada = paralizada;
    }

    /**
     * @return the causaDecision
     */
    public DDCausaDecision getCausaDecision() {
        return causaDecision;
    }

    /**
     * @param causaDecision the causaDecision to set
     */
    public void setCausaDecision(DDCausaDecision causaDecision) {
        this.causaDecision = causaDecision;
    }

    /**
     * @return the estadoDecision
     */
    public DDEstadoDecision getEstadoDecision() {
        return estadoDecision;
    }

    /**
     * @param estadoDecision the estadoDecision to set
     */
    public void setEstadoDecision(DDEstadoDecision estadoDecision) {
        this.estadoDecision = estadoDecision;
    }

    /**
     * @return the fechaParalizacion
     */
    public Date getFechaParalizacion() {
        return fechaParalizacion;
    }

    /**
     * @param fechaParalizacion the fechaParalizacion to set
     */
    public void setFechaParalizacion(Date fechaParalizacion) {
        this.fechaParalizacion = fechaParalizacion;
    }

    /**
     * @return the comentarios
     */
    public String getComentarios() {
        return comentarios;
    }

    /**
     * @param comentarios the comentarios to set
     */
    public void setComentarios(String comentarios) {
        this.comentarios = comentarios;
    }

    /**
     * @return the procedimientosDerivados
     */
    public List<ProcedimientoDerivado> getProcedimientosDerivados() {
        return procedimientosDerivados;
    }

    /**
     * @param procedimientosDerivados the procedimientosDerivados to set
     */
    public void setProcedimientosDerivados(List<ProcedimientoDerivado> procedimientosDerivados) {
        this.procedimientosDerivados = procedimientosDerivados;
    }

    /**
     * @return the processBPM
     */
    public Long getProcessBPM() {
        return processBPM;
    }

    /**
     * @param processBPM the processBPM to set
     */
    public void setProcessBPM(Long processBPM) {
        this.processBPM = processBPM;
    }

    /**
     * @return the version
     */
    public Long getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Long version) {
        this.version = version;
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
     * Setea la tarea de decision asociada.
     * @param tareaAsociada TareaNotificacion
     */
    public void setTareaAsociada(TareaNotificacion tareaAsociada) {
        this.tareaAsociada = tareaAsociada;
    }

    /**
     * Recupera la tarea de decision asociada.
     * @return Tarea de decision asociada
     */
    public TareaNotificacion getTareaAsociada() {
        return tareaAsociada;
    }

	/**
	 * @return the entidad
	 */
	public String getEntidad() {
		return entidad;
	}

	/**
	 * @param entidad the entidad to set
	 */
	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}
	
	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
	public ProcedimientoDerivado getProcedimientoDerivadoById(Long id) {
		if (this.procedimientosDerivados==null) {
			return null;
		}
		for (ProcedimientoDerivado pd : this.procedimientosDerivados) {
			if (pd.getId()!=null && pd.getId().equals(id)) {
				return pd;
			}
		}
		return null;
	}
	
}
