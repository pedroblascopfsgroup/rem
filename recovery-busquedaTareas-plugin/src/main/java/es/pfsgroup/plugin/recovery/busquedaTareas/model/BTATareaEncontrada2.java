package es.pfsgroup.plugin.recovery.busquedaTareas.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;


@Entity
@Table(name = "V42_BUSQUEDA_TAREAS", schema = "${entity.schema}")
public class BTATareaEncontrada2 {
	
	@Id
    @Column(name = "TAR_ID", insertable = false, updatable = false)
    private Long id;
	
	private TareaNotificacion tareaNotificacion;
	
//	private String campoPrueba;
//
//	public String getCampoPrueba() {
//		return campoPrueba;
//	}
//
//	public void setCampoPrueba(String campoPrueba) {
//		this.campoPrueba = campoPrueba;
//	}
	

	public TareaNotificacion getTareaNotificacion() {
		return tareaNotificacion;
	}

	public void setTareaNotificacion(TareaNotificacion tareaNotificacion) {
		this.tareaNotificacion = tareaNotificacion;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
}
