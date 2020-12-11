package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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

@Entity
@Table(name = "H_ACT_RFV_REQ_FASE_VENTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class HistoricoRequisitosFaseVenta implements Serializable, Auditable {

	private static final long serialVersionUID = 5910940035703021446L;
	
	@Id
	@Column(name = "RFV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoRequisitosFaseVenta")
	@SequenceGenerator(name = "HistoricoRequisitosFaseVenta", sequenceName = "S_H_ACT_RFV_REQ_FASE_VENTA")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ADM_ID")
	private ActivoInfAdministrativa activoInfAdministrativa;
	
	@Column(name = "RFV_FECHA_SOLICITUD_PRECIO_MAX")
	private Date fechaSolicitudPrecioMax;
	
	@Column(name = "RFV_FECHA_RESPUESTA_ORGANISMO")
	private Date fechaRespuestaOrganismo;
	
	@Column(name = "RFV_PRECIO_MAX_VENTA")
	private Double precioMaxVenta;
	
	@Column(name = "RFV_FECHA_VENCIMIENTO")
	private Date fechaVencimiento;
	
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

	public ActivoInfAdministrativa getActivoInfAdministrativa() {
		return activoInfAdministrativa;
	}

	public void setActivoInfAdministrativa(ActivoInfAdministrativa activoInfAdministrativa) {
		this.activoInfAdministrativa = activoInfAdministrativa;
	}

	public Date getFechaSolicitudPrecioMax() {
		return fechaSolicitudPrecioMax;
	}

	public void setFechaSolicitudPrecioMax(Date fechaSolicitudPrecioMax) {
		this.fechaSolicitudPrecioMax = fechaSolicitudPrecioMax;
	}

	public Date getFechaRespuestaOrganismo() {
		return fechaRespuestaOrganismo;
	}

	public void setFechaRespuestaOrganismo(Date fechaRespuestaOrganismo) {
		this.fechaRespuestaOrganismo = fechaRespuestaOrganismo;
	}

	public Double getPrecioMaxVenta() {
		return precioMaxVenta;
	}

	public void setPrecioMaxVenta(Double precioMaxVenta) {
		this.precioMaxVenta = precioMaxVenta;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
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
