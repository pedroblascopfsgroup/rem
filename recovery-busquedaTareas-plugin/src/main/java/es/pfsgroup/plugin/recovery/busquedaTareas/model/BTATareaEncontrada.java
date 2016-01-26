package es.pfsgroup.plugin.recovery.busquedaTareas.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Vista para la b�squeda de tareas
 * 
 */
@Entity
@Table(name = "V42_BUSQUEDA_TAREAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class BTATareaEncontrada implements Serializable, Auditable {
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 1328771340510030828L;


	@Id
    @Column(name = "TAR_ID", insertable = false, updatable = false)
    private Long id;
	
	@OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "TAREA", insertable = false, updatable = false)
    private EXTTareaNotificacion tarea;
	
	@JoinColumn(name = "ASUDESC", insertable = false, updatable = false)
	private String asuDesc;
	
	@JoinColumn(name = "TIPOPRCDESC", insertable = false, updatable = false)
	private String tipoPrcDesc;
	
	@JoinColumn(name = "NOMBRECLIENTE", insertable = false, updatable = false)
	private String nombreCliente;
    
    @JoinColumn(name = "DESCEXPEDIENTE", insertable = false, updatable = false)
	private String descExpediente;
    		
    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "GESTORPERFIL", insertable = false, updatable = false)
	private Perfil gestorPerfil;
    
    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "SUPERVISORPERFIL", insertable = false, updatable = false)
	private Perfil supervisorPerfil;
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}	

	public EXTTareaNotificacion getTarea() {
		return tarea;
	}

	public void setTarea(EXTTareaNotificacion tarea) {
		this.tarea = tarea;
	}
    
	public String getAsuDesc() {
		return asuDesc;
	}

	public void setAsuDesc(String asuDesc) {
		this.asuDesc = asuDesc;
	}
	
	public String getTipoPrcDesc() {
		return tipoPrcDesc;
	}

	public void setTipoPrcDesc(String tipoPrcDesc) {
		this.tipoPrcDesc = tipoPrcDesc;
	}

	public String getNombreCliente() {
		return nombreCliente;
	}

	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}

	public String getDescExpediente() {
		return descExpediente;
	}

	public void setDescExpediente(String descExpediente) {
		this.descExpediente = descExpediente;
	}

	public Perfil getGestorPerfil() {
		return gestorPerfil;
	}

	public void setGestorPerfil(Perfil gestorPerfil) {
		this.gestorPerfil = gestorPerfil;
	}

	public Perfil getSupervisorPerfil() {
		return supervisorPerfil;
	}

	public void setSupervisorPerfil(Perfil supervisorPerfil) {
		this.supervisorPerfil = supervisorPerfil;
	}

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub
		
	}
}
