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
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCostes;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;

@Entity
@Table(name = "CFG_COMISION_COSTES_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ConfiguracionComisionCostesActivo implements Serializable, Auditable {

private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CFG_CCA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionComisionCostesActivoGenerator")
    @SequenceGenerator(name = "ConfiguracionComisionCostesActivoGenerator", sequenceName = "REM01.S_CFG_COMISION_COSTES_ACTIVO")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoActivo tipoActivo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCM_ID")
    private DDTipoComision tipoComision;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CLA_ID")
    private DDClaseActivoBancario claseActivo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPR_ID")
    private DDTipoProveedor tipoProveedor;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo subtipoActivo;
    
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

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDTipoComision getTipoComision() {
		return tipoComision;
	}

	public void setTipoComision(DDTipoComision tipoComision) {
		this.tipoComision = tipoComision;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}
	
	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDClaseActivoBancario getClaseActivo() {
		return claseActivo;
	}

	public void setClaseActivo(DDClaseActivoBancario claseActivo) {
		this.claseActivo = claseActivo;
	}
	
	public DDTipoProveedor getTipoProveedor() {
		return tipoProveedor;
	}

	public void setTipoProveedor(DDTipoProveedor tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
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
