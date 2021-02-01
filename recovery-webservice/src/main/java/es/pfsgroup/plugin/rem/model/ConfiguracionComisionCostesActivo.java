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
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCostes;

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
    @JoinColumn(name = "DD_TCT_ID")
    private DDTipoCostes tipoCostes;
    
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


	public DDTipoCostes getTipoCostes() {
		return tipoCostes;
	}


	public void setTipoCostes(DDTipoCostes tipoCostes) {
		this.tipoCostes = tipoCostes;
	}


	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}


	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
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
