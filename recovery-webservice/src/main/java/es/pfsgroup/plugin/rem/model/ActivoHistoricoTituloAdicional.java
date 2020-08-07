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
@Table(name = "ACT_HTA_HISTORICO_TITULO_AD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoHistoricoTituloAdicional implements Serializable, Auditable{

	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "HTA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoHistoricoTituloAdicionalGenerator")
    @SequenceGenerator(name = "ActivoHistoricoTituloAdicionalGenerator", sequenceName = "S_ACT_HTA_HISTORICO_TITULO_AD")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIA_ID")
	private ActivoTituloAdicional tituloAdicional;
	
	@Column(name = "HTA_FECHA_PRES_REGISTRO")
	private Date fechaPresentacionRegistro;
	
	@Column(name = "HTA_FECHA_CALIFICACION")
	private Date fechaCalificacion;
	
	@Column(name = "HTA_FECHA_INSCRIPCION")
	private Date fechaInscripcion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ESP_ID")
	private DDEstadoPresentacion estadoPresentacion;
	
	@Column(name = "HTA_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "HTA_MATRICULA_PROP")
	private Long matriculaPropagacion; //
	
	@Column(name = "HTA_PRINCIPAL")
	private Long historicoPrincipal;

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

	public ActivoTituloAdicional getTituloAdicional() {
		return tituloAdicional;
	}

	public void setTituloAdicional(ActivoTituloAdicional tituloAdicional) {
		this.tituloAdicional = tituloAdicional;
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

	public Long getMatriculaPropagacion() {
		return matriculaPropagacion;
	}

	public void setMatriculaPropagacion(Long matriculaPropagacion) {
		this.matriculaPropagacion = matriculaPropagacion;
	}

	public Long getHistoricoPrincipal() {
		return historicoPrincipal;
	}

	public void setHistoricoPrincipal(Long historicoPrincipal) {
		this.historicoPrincipal = historicoPrincipal;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


	
	
	
	
	

}
