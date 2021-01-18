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
import es.pfsgroup.plugin.rem.model.dd.DDTipoEmisorGLD;

@Entity
@Table(name = "GLD_TBJ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class GastoLineaDetalleTrabajo implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GLD_TBJ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoLineaDetalleTrabajoGenerator")
	@SequenceGenerator(name = "GastoLineaDetalleTrabajoGenerator", sequenceName = "S_GLD_TBJ")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
	private GastoLineaDetalle gastoLineaDetalle;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TBJ_ID")
	private Trabajo trabajo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TEG_ID")
	private DDTipoEmisorGLD tipoEmisorGLD;
	
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

	public GastoLineaDetalle getGastoLineaDetalle() {
		return gastoLineaDetalle;
	}

	public void setGastoLineaDetalle(GastoLineaDetalle gastoLineaDetalle) {
		this.gastoLineaDetalle = gastoLineaDetalle;
	}

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public DDTipoEmisorGLD getTipoEmisor() {
		return tipoEmisorGLD;
	}

	public void setTipoEmisor(DDTipoEmisorGLD tipoEmisorGLD) {
		this.tipoEmisorGLD = tipoEmisorGLD;
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
