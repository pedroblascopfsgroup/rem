package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "GPV_TAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class GastoTasacionActivo implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GPV_TAS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoTasacionActivoGenerator")
	@SequenceGenerator(name = "GastoTasacionActivoGenerator", sequenceName = "S_GPV_TAS")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
	private GastoProveedor gastoProveedor;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TAS_ID")
	private ActivoTasacion tasacion;
	
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

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public ActivoTasacion getTasacion() {
		return tasacion;
	}

	public void setTasacion(ActivoTasacion tasacion) {
		this.tasacion = tasacion;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
