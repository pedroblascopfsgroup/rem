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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona las concurrencias.
 */
@Entity
@Table(name = "CON_CONCURRENCIA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Concurrencia implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CON_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConcurrenciaGenerator")
    @SequenceGenerator(name = "ConcurrenciaGenerator", sequenceName = "S_CON_CONCURRENCIA")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
	private ActivoAgrupacion agrupacion;

	@Column(name = "CON_IMPORTE_MIN_OFR")
	private Double importeMinOferta;

	@Column(name = "CON_IMPORTE_DEPOSITO")
	private Double importeDeposito;

	@Column(name = "CON_FECHA_INI")
	private Date fechaInicio;

	@Column(name = "CON_FECHA_FIN")
	private Date fechaFin;
    
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public Double getImporteMinOferta() {
		return importeMinOferta;
	}

	public void setImporteMinOferta(Double importeMinOferta) {
		this.importeMinOferta = importeMinOferta;
	}

	public Double getImporteDeposito() {
		return importeDeposito;
	}

	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
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