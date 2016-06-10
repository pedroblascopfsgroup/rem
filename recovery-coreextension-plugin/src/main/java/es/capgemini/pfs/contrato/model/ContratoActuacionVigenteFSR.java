package es.capgemini.pfs.contrato.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoActuacionFSR;


@Entity
@Table(name = "CNA_CNT_ACTUAC_VIGENT_FSR", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ContratoActuacionVigenteFSR implements  Serializable, Auditable  {
	 
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CNA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ContratoActuacionVigenteFSRGenerator")
    @SequenceGenerator(name = "ContratoActuacionVigenteFSRGenerator", sequenceName = "S_CNA_CNT_ACTUAC_VIGENT_FSR")
	private Long id; 
	
	@ManyToOne
    @JoinColumn(name = "CNT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private EXTContrato contrato;

	@ManyToOne
    @JoinColumn(name = "DD_TAF_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoActuacionFSR tipoActuacionFSR;

	@Version
    private Integer version;
    
    @Embedded
    private Auditoria auditoria;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public EXTContrato getContrato() {
		return contrato;
	}

	public void setContrato(EXTContrato contrato) {
		this.contrato = contrato;
	}

	public DDTipoActuacionFSR getTipoActuacionFSR() {
		return tipoActuacionFSR;
	}

	public void setTipoActuacionFSR(DDTipoActuacionFSR tipoActuacionFSR) {
		this.tipoActuacionFSR = tipoActuacionFSR;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
    
    
}
