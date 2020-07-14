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
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;

@Entity
@Table(name = "GLD_ENT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GastoLineaDetalleEntidad implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GLD_ENT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoLineaDetalleEntidadGenerator")
	@SequenceGenerator(name = "GastoLineaDetalleEntidadGenerator", sequenceName = "S_GLD_ENT")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
	private GastosLineaDetalle gastoLineaDetalle;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ENT_ID")
	private DDEntidadGasto entidadGasto;
	
	@Column(name="ENT_ID")
    private Long entidadId;
	
	@Column(name="GLD_PARTICIPACION_GASTO")
    private Double participacionGasto;
	
	@Column(name="GLD_REFERENCIA_CATASTRAL")
    private Double referenciaCatastral;
	
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

	public DDEntidadGasto getEntidadGasto() {
		return entidadGasto;
	}

	public void setEntidadGasto(DDEntidadGasto entidadGasto) {
		this.entidadGasto = entidadGasto;
	}

	public Long getEntidadId() {
		return entidadId;
	}

	public void setEntidadId(Long entidadId) {
		this.entidadId = entidadId;
	}

	public Double getParticipacionGasto() {
		return participacionGasto;
	}

	public void setParticipacionGasto(Double participacionGasto) {
		this.participacionGasto = participacionGasto;
	}

	public Double getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(Double referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
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
