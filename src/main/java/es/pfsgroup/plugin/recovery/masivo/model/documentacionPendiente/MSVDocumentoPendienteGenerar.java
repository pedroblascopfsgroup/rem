package es.pfsgroup.plugin.recovery.masivo.model.documentacionPendiente;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;

@Entity
@Table(name = "MSV_GDP_GENERACION_DOCS_PTES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Inheritance(strategy = InheritanceType.JOINED)
public class MSVDocumentoPendienteGenerar implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9220634845499607241L;

	@Id
    @Column(name = "GDP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDocumentoPendienteGenerarGenerator")
    @SequenceGenerator(name = "MSVDocumentoPendienteGenerarGenerator", sequenceName = "S_MSV_GDP_GENERACION_DOCS_PTES")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ASU_ID")
	private Asunto asunto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;
	
	@Column(name = "GDP_NUMERO_CASO_NOVA")
	private Long numeroCasoNova;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BPM_DD_TIN_ID")
	private RecoveryBPMfwkDDTipoInput tipoInput;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPO_ID")
	private TipoProcedimiento tipoProcedimiento;
	
	@Column(name = "GDP_PROCESO_TOKEN")
    private Long token;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPF_ID")
	private MSVDDEstadoProceso estadoProceso;
	
	@Column(name="GDP_MAIL")
	private Boolean requiereMail;
	
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

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Long getNumeroCasoNova() {
		return numeroCasoNova;
	}

	public void setNumeroCasoNova(Long numeroCasoNova) {
		this.numeroCasoNova = numeroCasoNova;
	}

	public RecoveryBPMfwkDDTipoInput getTipoInput() {
		return tipoInput;
	}

	public void setTipoInput(RecoveryBPMfwkDDTipoInput tipoInput) {
		this.tipoInput = tipoInput;
	}

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public Long getToken() {
		return token;
	}

	public void setToken(Long token) {
		this.token = token;
	}

	public Boolean getRequieraMail() {
		return requiereMail;
	}

	public void setRequieraMail(Boolean requieraMail) {
		this.requiereMail = requieraMail;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setEstadoProceso(MSVDDEstadoProceso estadoProceso) {
		this.estadoProceso = estadoProceso;
	}

	public MSVDDEstadoProceso getEstadoProceso() {
		return estadoProceso;
	}
    
    

}
