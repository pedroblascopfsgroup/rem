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
import es.pfsgroup.plugin.rem.model.dd.DDMotivoReagendacion;

/**
 * Modelo que gestiona la tabla de cuentas virtuales 
 * 
 * 
 * @author IRF
 */
@Entity
@Table(name = "HRE_HISTORICO_REAGENDACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoReagendacion implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "HRE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoReagendacionGenerator")
	@SequenceGenerator(name = "HistoricoReagendacionGenerator", sequenceName = "S_HRE_HISTORICO_REAGENDACIONES")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "FIA_ID")
	private Fianzas fianza;
	
	@Column(name = "HRE_FECHA_REAGENDACION_INGRESO")
	private Date fechaReagendacionIngreso;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MRA_ID")
	private DDMotivoReagendacion motivoReagendacion;
	
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

	public Fianzas getFianza() {
		return fianza;
	}

	public void setFianza(Fianzas fianza) {
		this.fianza = fianza;
	}

	public Date getFechaReagendacionIngreso() {
		return fechaReagendacionIngreso;
	}

	public void setFechaReagendacionIngreso(Date fechaReagendacionIngreso) {
		this.fechaReagendacionIngreso = fechaReagendacionIngreso;
	}
	
	public DDMotivoReagendacion getMotivoReagendacion() {
		return motivoReagendacion;
	}

	public void setMotivoReagendacion(DDMotivoReagendacion motivoReagendacion) {
		this.motivoReagendacion = motivoReagendacion;
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
