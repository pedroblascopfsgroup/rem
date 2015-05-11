package es.pfsgroup.recovery.ext.impl.contrato.model;

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
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.recovery.ext.api.contrato.model.EXTInfoAdicionalContratoInfo;

@Entity
@Table(name = "EXT_IAC_INFO_ADD_CONTRATO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EXTInfoAdicionalContrato implements EXTInfoAdicionalContratoInfo, Auditable,Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1327419320777513196L;
	
	@Id
	@Column(name = "IAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTInfoAdicionalContratoGenerator")
	@SequenceGenerator(name = "EXTInfoAdicionalContratoGenerator", sequenceName = "S_EXT_IAC_INFO_ADD_CONTRATO")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "CNT_ID")
	private Contrato contrato;
	
	@ManyToOne
    @JoinColumn(name = "DD_IFC_ID")
	private EXTDDTipoInfoContrato tipoInfoContrato;
	
	@Column(name="IAC_VALUE")
	private String value;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;
	

	@Override
	public Contrato getContrato() {
		return contrato;
	}

	@Override
	public Long getId() {
		return id;
	}

	@Override
	public EXTDDTipoInfoContrato getTipoInfoContrato() {
		return tipoInfoContrato;
	}

	@Override
	public String getValue() {
		return value;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public void setTipoInfoContrato(EXTDDTipoInfoContrato tipoInfoContrato) {
		this.tipoInfoContrato = tipoInfoContrato;
	}

	public void setValue(String value) {
		this.value = value;
	}

	
}
