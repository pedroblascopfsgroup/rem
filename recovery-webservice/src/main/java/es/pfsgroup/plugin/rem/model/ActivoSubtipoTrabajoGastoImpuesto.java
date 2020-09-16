package es.pfsgroup.plugin.rem.model;

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
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Entity
@Table(name = "ACT_STI_STG_IMP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoSubtipoTrabajoGastoImpuesto implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "STI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoSubtipoTrabajoGastoImpuestoGenerator")
	@SequenceGenerator(name = "ActivoSubtipoTrabajoGastoImpuestoGenerator", sequenceName = "S_ACT_STI_STG_IMP")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
	private DDSubtipoGasto subtipoGasto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIT_ID")
	private DDTiposImpuesto tiposImpuesto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CCA_ID")
	private DDComunidadAutonoma comunidadAutonoma;
	
	@Column(name="STI_TIPO_IMPOSITIVO")
    private Double tipoImpositivo;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public DDTiposImpuesto getTiposImpuesto() {
		return tiposImpuesto;
	}

	public void setTiposImpuesto(DDTiposImpuesto tiposImpuesto) {
		this.tiposImpuesto = tiposImpuesto;
	}

	public DDComunidadAutonoma getComunidadAutonoma() {
		return comunidadAutonoma;
	}

	public void setComunidadAutonoma(DDComunidadAutonoma comunidadAutonoma) {
		this.comunidadAutonoma = comunidadAutonoma;
	}

	public Double getTipoImpositivo() {
		return tipoImpositivo;
	}

	public void setTipoImpositivo(Double tipoImpositivo) {
		this.tipoImpositivo = tipoImpositivo;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
}

