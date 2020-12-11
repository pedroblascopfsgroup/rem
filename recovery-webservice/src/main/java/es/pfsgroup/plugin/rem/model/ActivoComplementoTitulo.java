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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloComplemento;

@Entity
@Table(name = "ACT_COT_COMPLEMENTO_TITULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoComplementoTitulo implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ACT_COT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoComplementoTituloGenerator")
    @SequenceGenerator(name = "ActivoComplementoTituloGenerator", sequenceName = "S_ACT_COT_COMPLEMENTO_TITULO")
	private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@Column(name = "COT_FECHA_ALTA")
	private Date fechaAlta;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COT_GESTOR_ALTA")
	private Usuario gestorAlta;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTC_ID")
	private DDTipoTituloComplemento tituloComplemento;
	
	@Column(name = "COT_FECHA_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name = "COT_FECHA_TITULO")
	private Date fechaComplementoTitulo;
	
	@Column(name = "COT_FECHA_RECEPCION")
	private Date fechaRecepcion;
	
	@Column(name = "COT_FECHA_INSCRIPCION")
	private Date fechaInscripcion;
	
	@Column(name = "COT_OBSERVACIONES")
	private String observaciones;
	
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
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Usuario getGestorAlta() {
		return gestorAlta;
	}
	public void setGestorAlta(Usuario gestorAlta) {
		this.gestorAlta = gestorAlta;
	}
	public DDTipoTituloComplemento getTituloComplemento() {
		return tituloComplemento;
	}
	public void setTituloComplemento(DDTipoTituloComplemento tituloComplemento) {
		this.tituloComplemento = tituloComplemento;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public Date getFechaComplementoTitulo() {
		return fechaComplementoTitulo;
	}
	public void setFechaComplementoTitulo(Date fechaComplementoTitulo) {
		this.fechaComplementoTitulo = fechaComplementoTitulo;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
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
