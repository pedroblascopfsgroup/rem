package es.pfsgroup.plugin.precontencioso.burofax.model;

import java.io.Serializable;
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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

@Entity
@Table(name = "PCO_BUR_BUROFAX", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BurofaxPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -5969025352573277783L;

	@Id
	@Column(name = "PCO_BUR_BUROFAX_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "BurofaxPCOGenerator")
	@SequenceGenerator(name = "BurofaxPCOGenerator", sequenceName = "S_PCO_BUR_BUROFAX_ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ProcedimientoPCO procedimientoPCO;

	@ManyToOne
	@JoinColumn(name = "PER_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Persona demandado;
	
	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Contrato contrato;
	
	@ManyToOne
	@JoinColumn(name = "DD_TIN_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoIntervencion tipoIntervencion;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_BFE_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDEstadoBurofaxPCO estadoBurofax;

	@OneToMany(mappedBy = "burofax", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<EnvioBurofaxPCO> enviosBurofax;

	@Column(name = "SYS_GUID")
	private String sysGuid;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * GETTERS & SETTERS
	 */

	public ProcedimientoPCO getProcedimientoPCO() {
		return procedimientoPCO;
	}

	public void setProcedimientoPCO(ProcedimientoPCO procedimientoPCO) {
		this.procedimientoPCO = procedimientoPCO;
	}

	public Persona getDemandado() {
		return demandado;
	}

	public void setDemandado(Persona demandado) {
		this.demandado = demandado;
	}

	public DDEstadoBurofaxPCO getEstadoBurofax() {
		return estadoBurofax;
	}

	public void setEstadoBurofax(DDEstadoBurofaxPCO estadoBurofax) {
		this.estadoBurofax = estadoBurofax;
	}

	public String getSysGuid() {
		return sysGuid;
	}

	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
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

	public Long getId() {
		return id;
	}

	public List<EnvioBurofaxPCO> getEnviosBurofax() {
		return enviosBurofax;
	}

	public void setEnviosBurofax(List<EnvioBurofaxPCO> enviosBurofax) {
		this.enviosBurofax = enviosBurofax;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public DDTipoIntervencion getTipoIntervencion() {
		return tipoIntervencion;
	}

	public void setTipoIntervencion(DDTipoIntervencion tipoIntervencion) {
		this.tipoIntervencion = tipoIntervencion;
	}

	public void setId(Long id) {
		this.id = id;
	}
}
