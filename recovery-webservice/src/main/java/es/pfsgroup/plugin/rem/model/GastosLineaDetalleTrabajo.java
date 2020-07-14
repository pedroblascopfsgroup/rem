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
import es.pfsgroup.plugin.rem.model.dd.DDTipoEmisorGLD;

@Entity
@Table(name = "GLD_ENT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GastosLineaDetalleTrabajo implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GLD_TBJ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoLineaDetalleEntidadGenerator")
	@SequenceGenerator(name = "GastoLineaDetalleEntidadGenerator", sequenceName = "S_GLD_ENT")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
	private GastosLineaDetalle gastoLineaDetalle;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TBJ_ID")
	private Trabajo trabajo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TEG_ID")
	private DDTipoEmisorGLD tipoEmisor;
	
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

	public GastosLineaDetalle getGastoLineaDetalle() {
		return gastoLineaDetalle;
	}

	public void setGastoLineaDetalle(GastosLineaDetalle gastoLineaDetalle) {
		this.gastoLineaDetalle = gastoLineaDetalle;
	}

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public DDTipoEmisorGLD getTipoEmisor() {
		return tipoEmisor;
	}

	public void setTipoEmisor(DDTipoEmisorGLD tipoEmisor) {
		this.tipoEmisor = tipoEmisor;
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
