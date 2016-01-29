package es.pfsgroup.plugin.recovery.sidhiweb.engine.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHITipoAccionValorInfo;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIInterfaz;

@Entity
@Table(name = "SIDHI_DAT_TVA_TIPO_VALOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHITipoAccionValor implements SIDHITipoAccionValorInfo,
Serializable, Auditable{
	
	private static final long serialVersionUID = 3872970768079816783L;

	@Id
	@Column(name = "TVA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHITipoAccionValoGenerator")
	@SequenceGenerator(name = "SIDHITipoAccionValoGenerator", sequenceName = "S_SIDHI_DAT_TVA_TIPO_VALOR")
	private Long id;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ITF_ID")
	private SIDHIInterfaz interfaz;

	@Column(name = "TVA_CODIGO")
	private String codigo;

	@Column(name = "TVA_DESCRIPCION")
	private String descripcion;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	@Override
	public String getCodigo() {
		return this.codigo;
	}

	@Override
	public String getDescripcion() {
		return this.descripcion;
	}

	public Long getId() {
		return id;
	}

	public SIDHIInterfaz getInterfaz() {
		return interfaz;
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
		return "SIDHITipoAccionValor [codigo=" + codigo + ", descripcion="
				+ descripcion + ", id=" + id + ", interfaz=" + interfaz + "]";
	}


}
