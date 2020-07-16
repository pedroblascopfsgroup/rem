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

@Entity
@Table(name = "ACT_SCP_SGT_CC_PP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoSubtipoGastoCuentaContablePartidaPresupuestaria implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "SCP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoSubtipoGastoCuentaContablePartidaPresupuestariaGenerator")
	@SequenceGenerator(name = "ActivoSubtipoGastoCuentaContablePartidaPresupuestariaGenerator", sequenceName = "S_ACT_SCP_SGT_CC_PP")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SGT_ID")
	private ActivoSubtipoGastoProveedorTrabajo activoSubtipoGastoProveedorTrabajo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CCC_CTAS_ID")
	private ActivoConfiguracionCuentasContables configuracionCuentasContables;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CPP_PTDAS_ID")
	private ActivoConfiguracionPtdasPrep configuracionPartidasPresupuestarias;
	
	@Column(name="SGT_PRINCIPAL")
    private Boolean subtipoGastoPrincipal;

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

	public ActivoSubtipoGastoProveedorTrabajo getActivoSubtipoGastoProveedorTrabajo() {
		return activoSubtipoGastoProveedorTrabajo;
	}

	public void setActivoSubtipoGastoProveedorTrabajo(
			ActivoSubtipoGastoProveedorTrabajo activoSubtipoGastoProveedorTrabajo) {
		this.activoSubtipoGastoProveedorTrabajo = activoSubtipoGastoProveedorTrabajo;
	}

	public Boolean getSubtipoGastoPrincipal() {
		return subtipoGastoPrincipal;
	}

	public void setSubtipoGastoPrincipal(Boolean subtipoGastoPrincipal) {
		this.subtipoGastoPrincipal = subtipoGastoPrincipal;
	}
	
	public ActivoConfiguracionCuentasContables getConfiguracionCuentasContables() {
		return configuracionCuentasContables;
	}

	public void setConfiguracionCuentasContables(ActivoConfiguracionCuentasContables configuracionCuentasContables) {
		this.configuracionCuentasContables = configuracionCuentasContables;
	}

	public ActivoConfiguracionPtdasPrep getConfiguracionPartidasPresupuestarias() {
		return configuracionPartidasPresupuestarias;
	}

	public void setConfiguracionPartidasPresupuestarias(ActivoConfiguracionPtdasPrep configuracionPartidasPresupuestarias) {
		this.configuracionPartidasPresupuestarias = configuracionPartidasPresupuestarias;
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

