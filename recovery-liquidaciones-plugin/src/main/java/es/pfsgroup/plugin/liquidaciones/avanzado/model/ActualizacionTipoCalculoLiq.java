package es.pfsgroup.plugin.liquidaciones.avanzado.model;

import java.io.Serializable;
import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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

@Entity
@Table(name = "ATI_ACTUALIZA_TIPO_INTERES_CAL", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ActualizacionTipoCalculoLiq implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4502479621786306745L;
	
	@Id
    @Column(name = "ATI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActualizaTipIntGenerator")
    @SequenceGenerator(name = "ActualizaTipIntGenerator", sequenceName = "S_ATI_ACTUALIZA_TIPO_INTERES_C")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "CAL_ID")
	private CalculoLiquidacion calculoLiquidacion;
	
	@Column(name = "ATI_FECHA")
	private Date fecha;
	
	@Column(name = "ATI_TIPO")
	private Float tipoInteres;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public CalculoLiquidacion getCalculoLiquidacion() {
		return calculoLiquidacion;
	}

	public void setCalculoLiquidacion(CalculoLiquidacion calculoLiquidacion) {
		this.calculoLiquidacion = calculoLiquidacion;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public Float getTipoInteres() {
		return tipoInteres;
	}

	public void setTipoInteres(Float tipoInteres) {
		this.tipoInteres = tipoInteres;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	
}
