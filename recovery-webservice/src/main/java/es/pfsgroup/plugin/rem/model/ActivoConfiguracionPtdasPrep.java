package es.pfsgroup.plugin.rem.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComisionado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoImporte;
import es.pfsgroup.plugin.rem.model.dd.DDTributosTerceros;

@Entity
@Table(name = "ACT_CONFIG_PTDAS_PREP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ActivoConfiguracionPtdasPrep implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "CPP_PTDAS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoConfiguracionPtdasPrepGenerator")
	@SequenceGenerator(name = "ActivoConfiguracionPtdasPrepGenerator", sequenceName = "S_ACT_CONFIG_PTDAS_PREP")
	private Long id;
	
	@Column(name="CPP_PARTIDA_PRESUPUESTARIA")
    private String partidaPresupuestaria;
	
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
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCR_ID")
    private DDSubcartera subCartera;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRO_ID")
	private ActivoPropietario activoPropietario;
	
	@Column(name="EJE_ID")
    private Long ejercicio;
	
	@Column(name="CPP_ARRENDAMIENTO")
    private Integer arrendamiento;
	
	@Column(name="CPP_REFACTURABLE")
    private Integer refacturable;

	@Column(name="CPP_PRINCIPAL")
    private Boolean gastosPartidasPresupuestariasPrincipal;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_TBE_ID")
    private DDTipoActivoBDE tipoActivoBDE;
	
	@Column(name="CPP_APARTADO")
    private String cppApartado;
	
	@Column(name="CPP_CAPITULO")
    private String cppCapitulo;
	
	@Column(name="CPP_ACTIVABLE")
    private Integer cppActivable;
	
	@Column(name="CPP_PLAN_VISITAS")
    private Integer cppPlanVisitas;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_TCH_ID")
    private DDTipoComisionado cpptipoComisionado;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_TRT_ID")
    private DDTributosTerceros tributosTerceros;
	
	@Column(name="CPP_VENDIDO")
    private Integer cppVendido;
	
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

	public String getPartidaPresupuestaria() {
		return partidaPresupuestaria;
	}

	public void setPartidaPresupuestaria(String partidaPresupuestaria) {
		this.partidaPresupuestaria = partidaPresupuestaria;
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

	public ActivoPropietario getActivoPropietario() {
		return activoPropietario;
	}

	public void setActivoPropietario(ActivoPropietario activoPropietario) {
		this.activoPropietario = activoPropietario;
	}

	public Long getEjercicio() {
		return ejercicio;
	}

	public void setEjercicio(Long ejercicio) {
		this.ejercicio = ejercicio;
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

	public Boolean getGastosPartidasPresupuestariasPrincipal() {
		return gastosPartidasPresupuestariasPrincipal;
	}

	public void setGastosPartidasPresupuestariasPrincipal(Boolean gastosPartidasPresupuestariasPrincipal) {
		this.gastosPartidasPresupuestariasPrincipal = gastosPartidasPresupuestariasPrincipal;
	}

	public DDTipoActivoBDE getTipoActivoBDE() {
		return tipoActivoBDE;
	}

	public void setTipoActivoBDE(DDTipoActivoBDE tipoActivoBDE) {
		this.tipoActivoBDE = tipoActivoBDE;
	}

	public String getCppApartado() {
		return cppApartado;
	}

	public void setCppApartado(String cppApartado) {
		this.cppApartado = cppApartado;
	}

	public String getCppCapitulo() {
		return cppCapitulo;
	}

	public void setCppCapitulo(String cppCapitulo) {
		this.cppCapitulo = cppCapitulo;
	}

	public Integer getCppActivable() {
		return cppActivable;
	}

	public void setCppActivable(Integer cppActivable) {
		this.cppActivable = cppActivable;
	}

	public Integer getCppPlanVisitas() {
		return cppPlanVisitas;
	}

	public void setCppPlanVisitas(Integer cppPlanVisitas) {
		this.cppPlanVisitas = cppPlanVisitas;
	}

	public DDTipoComisionado getCpptipoComisionado() {
		return cpptipoComisionado;
	}

	public void setCpptipoComisionado(DDTipoComisionado cpptipoComisionado) {
		this.cpptipoComisionado = cpptipoComisionado;
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

	public DDTributosTerceros getTributosTerceros() {
		return tributosTerceros;
	}

	public void setTributosTerceros(DDTributosTerceros tributosTerceros) {
		this.tributosTerceros = tributosTerceros;
	}

	public Integer getCppVendido() {
		return cppVendido;
	}

	public void setCppVendido(Integer cppVendido) {
		this.cppVendido = cppVendido;
	}

}
