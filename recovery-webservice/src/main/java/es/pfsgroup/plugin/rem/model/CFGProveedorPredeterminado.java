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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

@Entity
@Table(name = "CFG_PVE_PREDETERMINADO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CFGProveedorPredeterminado implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "CPP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProveedorPredeterminadoGenerator")
    @SequenceGenerator(name = "ProveedorPredeterminadoGenerator", sequenceName = "S_CFG_PVE_PREDETERMINADO")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCR_ID")
    private DDSubcartera subcartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTR_ID")
    private DDTipoTrabajo tipoTrabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STR_ID")
    private DDSubtipoTrabajo subtipoTrabajo;

    @Column(name = "PROVEEDOR_DEFECTO")
    private Integer proveedorDefecto;

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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public DDTipoTrabajo getTipoTrabajo() {
		return tipoTrabajo;
	}

	public void setTipoTrabajo(DDTipoTrabajo tipoTrabajo) {
		this.tipoTrabajo = tipoTrabajo;
	}

	public DDSubtipoTrabajo getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(DDSubtipoTrabajo subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public Integer getProveedorDefecto() {
		return proveedorDefecto;
	}

	public void setProveedorDefecto(Integer proveedorDefecto) {
		this.proveedorDefecto = proveedorDefecto;
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
