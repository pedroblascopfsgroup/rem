package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_COUNT_TAREAS", schema = "${entity.schema}")
public class VTareaActivoCount implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "USUARIO")
	private Long usuario;
	
	@Column(name = "TAREAS")
	private Long tareas;	
	
	@Column(name = "ALERTAS")
	private Long alertas;

	@Column(name = "AVISOS")
	private Long avisos;
	
	public Long getUsuario() {
		return usuario;
	}

	public void setUsuario(Long usuario) {
		this.usuario = usuario;
	}

	public Long getTareas() {
		return tareas;
	}

	public void setTareas(Long tareas) {
		this.tareas = tareas;
	}

	public Long getAlertas() {
		return alertas;
	}

	public void setAlertas(Long alertas) {
		this.alertas = alertas;
	}

	public Long getAvisos() {
		return avisos;
	}

	public void setAvisos(Long avisos) {
		this.avisos = avisos;
	}
	
}