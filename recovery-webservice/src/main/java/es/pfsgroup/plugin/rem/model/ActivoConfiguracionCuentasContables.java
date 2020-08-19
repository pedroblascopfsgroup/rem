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
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoImporte;

@Entity
@Table(name = "ACT_CONFIG_CTAS_CONTABLES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoConfiguracionCuentasContables implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "CCC_CTAS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoConfiguracionCuentasContablesGenerator")
	@SequenceGenerator(name = "ActivoConfiguracionCuentasContablesGenerator", sequenceName = "S_ACT_CONFIG_CTAS_CONTABLES")
	private Long id;
	
	@Column(name="CCC_CUENTA_CONTABLE")
    private String cuentaContable;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TGA_ID")
	private DDTipoGasto tipoGasto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
	private DDSubtipoGasto subtipoGasto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIM_ID")
	private DDTipoImporte tipoImporte;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_CRA_ID")
    private DDCartera cartera;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_SCR_ID")
    private DDSubcartera subCartera;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRO_ID")
	private ActivoPropietario activoPropietario;
	
	@Column(name="EJE_ID")
    private Long ejercicio;
	
	@Column(name="CCC_ARRENDAMIENTO")
    private Integer arrendamiento;
	
	@Column(name="CCC_REFACTURABLE")
    private Integer refacturable;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SGT_ID")
	private ActivoSubtipoGastoProveedorTrabajo activoSubtivoGastoProveedorTrabajo;
	
	@Column(name="CCC_PRINCIPAL")
    private Boolean gastosCuentasPrincipal;
	
	@Column(name="CPP_PRINCIPAL")
    private Boolean gastosPartidasPrincipal;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_TBE_ID")
    private DDTipoActivoBDE tipoActivoBDE;
	
	@Column(name="CCC_SUBCUENTA_CONTABLE")
    private String subcuentaContable;
	
	@Column(name="CCC_ACTIVABLE")
	private Boolean cccActivable;
	
	@Column(name="CCC_PLAN_VISITAS")
	private Boolean cccPlanVisitas;
	
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

	public String getCuentaContable() {
		return cuentaContable;
	}

	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}

	public DDTipoGasto getTipoGasto() {
		return tipoGasto;
	}

	public void setTipoGasto(DDTipoGasto tipoGasto) {
		this.tipoGasto = tipoGasto;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public DDTipoImporte getTipoImporte() {
		return tipoImporte;
	}

	public void setTipoImporte(DDTipoImporte tipoImporte) {
		this.tipoImporte = tipoImporte;
	}

	public ActivoPropietario getActivoPropietario() {
		return activoPropietario;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(DDSubcartera subCartera) {
		this.subCartera = subCartera;
	}

	public Long getEjercicio() {
		return ejercicio;
	}

	public void setEjercicio(Long ejercicio) {
		this.ejercicio = ejercicio;
	}

	public void setActivoPropietario(ActivoPropietario activoPropietario) {
		this.activoPropietario = activoPropietario;
	}

	public Integer getArrendamiento() {
		return arrendamiento;
	}

	public void setArrendamiento(Integer arrendamiento) {
		this.arrendamiento = arrendamiento;
	}

	public Integer getRefacturable() {
		return refacturable;
	}

	public void setRefacturable(Integer refacturable) {
		this.refacturable = refacturable;
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

	public ActivoSubtipoGastoProveedorTrabajo getActivoSubtivoGastoProveedorTrabajo() {
		return activoSubtivoGastoProveedorTrabajo;
	}

	public void setActivoSubtivoGastoProveedorTrabajo(
			ActivoSubtipoGastoProveedorTrabajo activoSubtivoGastoProveedorTrabajo) {
		this.activoSubtivoGastoProveedorTrabajo = activoSubtivoGastoProveedorTrabajo;
	}

	public Boolean getGastosCuentasPrincipal() {
		return gastosCuentasPrincipal;
	}

	public void setGastosCuentasPrincipal(Boolean gastosCuentasPrincipal) {
		this.gastosCuentasPrincipal = gastosCuentasPrincipal;
	}
	
	public Boolean getGastosPartidasPrincipal() {
		return gastosPartidasPrincipal;
	}

	public void setGastosPartidasPrincipal(Boolean gastosPartidasPrincipal) {
		this.gastosPartidasPrincipal = gastosPartidasPrincipal;
	}

	public DDTipoActivoBDE getTipoActivoBDE() {
		return tipoActivoBDE;
	}

	public void setTipoActivoBDE(DDTipoActivoBDE tipoActivoBDE) {
		this.tipoActivoBDE = tipoActivoBDE;
	}

	public String getSubcuentaContable() {
		return subcuentaContable;
	}

	public void setSubcuentaContable(String subcuentaContable) {
		this.subcuentaContable = subcuentaContable;
	}

	public Boolean getCccActivable() {
		return cccActivable;
	}

	public void setCccActivable(Boolean cccActivable) {
		this.cccActivable = cccActivable;
	}

	public Boolean getCccPlanVisitas() {
		return cccPlanVisitas;
	}

	public void setCccPlanVisitas(Boolean cccPlanVisitas) {
		this.cccPlanVisitas = cccPlanVisitas;
	}
}
