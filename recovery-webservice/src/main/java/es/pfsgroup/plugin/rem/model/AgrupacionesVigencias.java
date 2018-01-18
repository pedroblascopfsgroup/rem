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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Tabla para almacenar la vigencia de las agrupaciones
 * @author rllinares
 *
 */
@Entity
@Table(name = "ACT_VAS_VIGENCIA_ASISTIDAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public final class AgrupacionesVigencias implements Serializable,Auditable{
	
	
	private static final long serialVersionUID = -4148752289491076055L;

	@Id
    @Column(name = "ACT_VAS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AgrupacionesVigenciasGenerator")
    @SequenceGenerator(name = "AgrupacionesVigenciasGenerator", sequenceName = "S_ACT_VAS_VIGENCIA_ASISTIDAS")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_VAS_AGR_ID")
    private ActivoAgrupacion agrupacion;
	
	@Column(name = "ACT_VAS_FECHA_INICIO_VIGENCIA")
	private Date fechaInicio;
	
	@Column(name = "ACT_VAS_FECHA_FIN_VIGENCIA")
	private Date fechaFin;
	
	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	

}
