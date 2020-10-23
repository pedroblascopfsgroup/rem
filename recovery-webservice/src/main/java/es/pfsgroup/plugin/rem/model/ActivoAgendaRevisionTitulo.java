package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
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

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipologiaAgenda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

/**
 * Modelo que gestiona las Revisiones en el Título de un Activo
 * 
 * @author Alberto Flores
 *
 */
@Entity
@Table(name = "ACT_ART_AGENDA_REV_TITULO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoAgendaRevisionTitulo implements Serializable, Auditable {

	private static final long serialVersionUID = -7785802535778510517L;

	@Id
	@Column(name = "ART_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgendaRevisionTitulo")
	@SequenceGenerator(name = "ActivoAgendaRevisionTitulo", sequenceName = "S_ACT_ART_AGENDA_REV_TITULO")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@ManyToOne
	@JoinColumn(name = "DD_STA_ID")
	private DDSubtipologiaAgenda subtipologiaAgenda;
	
	@Column(name = "ART_OBSERVACIONES")
	private String observaciones;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
	@Column(name = "FECHA_ALTA")
	private Date fechaAlta;
	
	@ManyToOne
    @JoinColumn(name = "AOB_ID")
    private ActivoObservacion activoObservacion;
	
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

	public DDSubtipologiaAgenda getSubtipologiaAgenda() {
		return subtipologiaAgenda;
	}

	public void setSubtipologiaAgenda(DDSubtipologiaAgenda subtipologiaAgenda) {
		this.subtipologiaAgenda = subtipologiaAgenda;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
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

	public ActivoObservacion getActivoObservacion() {
		return activoObservacion;
	}

	public void setActivoObservacion(ActivoObservacion activoObservacion) {
		this.activoObservacion = activoObservacion;
	}

}
