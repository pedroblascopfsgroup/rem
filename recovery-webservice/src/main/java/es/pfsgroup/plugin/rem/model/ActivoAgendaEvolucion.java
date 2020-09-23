package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoAdmision;

/**
 * Modelo que gestiona la información de la evolución de las agendas de los activos.
 * 
 * @author sergio gomez
 */
@Entity
@Table(name = "ACT_AEV_AGENDA_EVOLUCION", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAgendaEvolucion implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "AEV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgendaEvolucionGenerator")
	@SequenceGenerator(name = "ActivoAgendaEvolucionGenerator", sequenceName = "S_ACT_AEV_AGENDA_EVOLUCION")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@ManyToOne
	@JoinColumn(name = "DD_EAA_ID")
	private DDEstadoAdmision estadoAdmision;
	
	@ManyToOne
	@JoinColumn(name = "DD_SAA_ID")
	private DDSubestadoAdmision subEstadoAdmision;
	
	@Column(name = "AEV_FECHA")
	private Date fechaAgendaEv;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
	@Column(name = "AEV_OBSERVACIONES")
	private String observaciones;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
	//GETTERS - SETTERS
	
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

	public DDEstadoAdmision getEstadoAdmision() {
		return estadoAdmision;
	}

	public void setEstadoAdmision(DDEstadoAdmision estadoAdmision) {
		this.estadoAdmision = estadoAdmision;
	}

	public DDSubestadoAdmision getSubEstadoAdmision() {
		return subEstadoAdmision;
	}

	public void setSubEstadoAdmision(DDSubestadoAdmision subEstadoAdmision) {
		this.subEstadoAdmision = subEstadoAdmision;
	}

	public Date getFechaAgendaEv() {
		return fechaAgendaEv;
	}

	public void setFechaAgendaEv(Date fechaAgendaEv) {
		this.fechaAgendaEv = fechaAgendaEv;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuarioId(Usuario usuario) {
		this.usuario = usuario;
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
