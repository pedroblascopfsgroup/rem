package es.pfsgroup.recovery.bpmframework.batch.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Entidad persitible para las peticiones al batch
 * 
 * @author bruno
 *
 */
@Entity
@Table(name = "BPM_PET_PETICIONES_BATCH", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkPeticionBatch implements Auditable, Serializable {

    public static final long serialVersionUID = -1099101408360632611L;
    
    public static final int NO_PROCESADO = 0;
    
    public static final int PROCESADO_OK = 1;
    
    public static final int PROCESADO_ERROR = -1;
    
    @Id
    @Column(name = "BPM_PET_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkPeticionBatchGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkPeticionBatchGenerator", sequenceName = "S_BPM_PET_PETICIONES_BATCH")
    private Long id;

    @Column(name = "BPM_PET_TOKEN_ID")
    private Long idToken;
    
    @OneToOne
    @JoinColumn(name = "BPM_IPT_ID", nullable = false)
    private RecoveryBPMfwkInput input;
    
    @Column(name = "BPM_PET_PROCESADO")
    private Integer procesado;
    
    @Column(name = "BPM_PET_FECHA_PROCESADO")
    private Date fechaProcesado;    
    
    @Column(name = "BPM_PET_START_BO")
    private String onStartBo;
    
    @Column(name = "BPM_PET_END_BO")
    private String onEndBo;
    
    @Column(name = "BPM_PET_SUCCESS_BO")
    private String onSuccessBo;
    
    @Column(name = "BPM_PET_ERROR_BO")
    private String onErrorBo;

    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
    public Long getIdToken() {
        return idToken;
    }

    public RecoveryBPMfwkInput getInput() {
        return input;
    }

    public String getOnStartBo() {
        return onStartBo;
    }

    public String getOnEndBo() {
        return onEndBo;
    }

    public String getOnSuccessBo() {
        return onSuccessBo;
    }

    public String getOnErrorBo() {
        return onErrorBo;
    }

    public void setIdToken(final Long idToken) {
        this.idToken = idToken;
    }

    public void setInput(final RecoveryBPMfwkInput input) {
        this.input = input;
    }

    public void setOnStartBo(final String onStartBo) {
        this.onStartBo = onStartBo;
    }

    public void setOnEndBo(final String onEndBo) {
        this.onEndBo = onEndBo;
    }

    public void setOnSuccessBo(final String onSuccessBo) {
        this.onSuccessBo = onSuccessBo;
    }

    public void setOnErrorBo(final String onErrorBo) {
        this.onErrorBo = onErrorBo;
    }

    public Auditoria getAuditoria() {
        return auditoria;
    }

    public void setAuditoria(final Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(final Integer version) {
        this.version = version;
    }
    
    public Integer getProcesado() {
		return procesado;
	}

	public void setProcesado(Integer procesdado) {
		this.procesado = procesdado;
	}

	public Date getFechaProcesado() {
		return fechaProcesado == null ? null : ((Date) fechaProcesado.clone());
	}

	public void setFechaProcesado(Date fechaProcesado) {
		this.fechaProcesado = fechaProcesado == null ? null : ((Date) fechaProcesado.clone());
	}
}
