package es.pfsgroup.plugin.rem.model;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que representa la entidad Tarea de Activo
 * 
 * @author
 * 
 */
@Entity
@Table(name = "TAC_TAREAS_ACTIVOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name="TAR_ID")
public class TareaActivo extends EXTTareaNotificacion implements Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name = "TRA_ID")
	private ActivoTramite tramite;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
	@ManyToOne
	@JoinColumn(name = "SUP_ID")
	private Usuario supervisor;

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}
	
	public Usuario getUsuario(){
		return usuario;
	}
	
	public void setUsuario(Usuario usuario){
		this.usuario = usuario;
	}
	
	public ActivoTramite getTramite(){
		return tramite;
	}
	
	public void setTramite(ActivoTramite tramite){
		this.tramite = tramite;
	}

	public Usuario getSupervisorActivo() {
		return supervisor;
	}

	public void setSupervisorActivo(Usuario supervisor) {
		this.supervisor = supervisor;
	}
	
}
