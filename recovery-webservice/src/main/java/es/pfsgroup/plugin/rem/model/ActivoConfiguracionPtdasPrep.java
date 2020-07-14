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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoImporte;

@Entity
@Table(name = "ACT_CONFIG_PTDAS_PREP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
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
	
	@Column(name="DD_CRA_ID")
    private Long cra_Id;
	
	@Column(name="DD_SCR_ID")
    private Long src_Id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRO_ID")
	private ActivoPropietario activoPropietario;
	
	@Column(name="EJE_ID")
    private Long eje_Id;
	
	@Column(name="CPP_ARRENDAMIENTO")
    private Integer arrendamiento;
	
	@Column(name="CPP_REFACTURABLE")
    private Integer refacturable;
	
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

	public Long getCra_Id() {
		return cra_Id;
	}

	public void setCra_Id(Long cra_Id) {
		this.cra_Id = cra_Id;
	}

	public Long getSrc_Id() {
		return src_Id;
	}

	public void setSrc_Id(Long src_Id) {
		this.src_Id = src_Id;
	}

	public ActivoPropietario getActivoPropietario() {
		return activoPropietario;
	}

	public void setActivoPropietario(ActivoPropietario activoPropietario) {
		this.activoPropietario = activoPropietario;
	}

	public Long getEje_Id() {
		return eje_Id;
	}

	public void setEje_Id(Long eje_Id) {
		this.eje_Id = eje_Id;
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
	 
	 
	
}
