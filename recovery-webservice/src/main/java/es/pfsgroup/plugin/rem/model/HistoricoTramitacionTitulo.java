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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;

@Entity
@Table(name = "ACT_AHT_HIST_TRAM_TITULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoTramitacionTitulo implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6888318348494911601L;

	@Id
    @Column(name = "AHT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoTramitacionTituloGenerator")
    @SequenceGenerator(name = "HistoricoTramitacionTituloGenerator", sequenceName = "S_ACT_AHT_HIST_TRAM_TITULO")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIT_ID")
	ActivoTitulo titulo;
	
	@Column(name = "AHT_FECHA_PRES_REGISTRO")
	Date fechaPresentacionRegistro;
	
	@Column(name = "AHT_FECHA_CALIFICACION")
	Date fechaCalificacion;
	
	@Column(name = "AHT_FECHA_INSCRIPCION")
	Date fechaInscripcion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ESP_ID")
	DDEstadoPresentacion estadoPresentacion;
	
	@Column(name = "AHT_OBSERVACIONES")
	String observaciones;
	
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

	public ActivoTitulo getTitulo() {
		return titulo;
	}

	public void setTitulo(ActivoTitulo titulo) {
		this.titulo = titulo;
	}

	public Date getFechaPresentacionRegistro() {
		return fechaPresentacionRegistro;
	}

	public void setFechaPresentacionRegistro(Date fechaPresentacionRegistro) {
		this.fechaPresentacionRegistro = fechaPresentacionRegistro;
	}

	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}

	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}

	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}

	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}

	public DDEstadoPresentacion getEstadoPresentacion() {
		return estadoPresentacion;
	}

	public void setEstadoPresentacion(DDEstadoPresentacion estadoPresentacion) {
		this.estadoPresentacion = estadoPresentacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
