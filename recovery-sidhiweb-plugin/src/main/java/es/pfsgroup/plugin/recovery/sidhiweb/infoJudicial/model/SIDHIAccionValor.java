package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIAccionValorInfo;
import es.pfsgroup.plugin.recovery.sidhiweb.engine.model.SIDHITipoAccionValor;

@Entity
@Table(name = "SIDHI_DAT_ACV_VALORES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHIAccionValor implements SIDHIAccionValorInfo, Serializable,Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8657574881797115357L;

	@Id
	@Column(name = "ACV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIAccionValorGenerator")
	@SequenceGenerator(name = "SIDHIAccionValorGenerator", sequenceName = "S_SIDHI_DAT_ACJ_ACCIONES")
	private Long id;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ACJ_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private SIDHIAccionJudicial accion;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "TVA_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private SIDHITipoAccionValor tipo;
	
	@Column (name = "ACV_OBSERVACIONES")
	private String valor;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.santander.batch.sidhi.infoJudicial.model.SIDHIAccionValorInfo#getTipo()
	 */
	public SIDHITipoAccionValor getTipo() {
		return this.tipo;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.santander.batch.sidhi.infoJudicial.model.SIDHIAccionValorInfo#getValor()
	 */
	public String getValor() {
		return this.valor;
	}

	public Long getId() {
		return id;
	}

	public SIDHIAccionJudicial getAccion() {
		return accion;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}

	@Override
	public String toString() {
		return "SIDHIAccionValor [accion=" + accion + ", id=" + id + ", tipo="
				+ tipo + ", valor=" + valor + "]";
	}


}
