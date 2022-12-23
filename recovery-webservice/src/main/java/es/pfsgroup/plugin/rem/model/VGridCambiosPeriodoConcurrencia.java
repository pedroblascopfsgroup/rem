package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_CPC_CMB_PER_CONCURRENCIA", schema = "${entity.schema}")
public class VGridCambiosPeriodoConcurrencia implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID")  
	private Long id;
	
	@Column(name = "CON_ID")  
	private Long idConcurrencia;
	
	@Column(name = "ACCION")  
	private String accionConcurrencia;
	
	@Column(name = "FECHAINICIO")
	private Date fechaInicio;
	
	@Column(name = "FECHAFIN")
	private Date fechaFin;

	public Long getIdConcurrencia() {
		return id;
	}

	public void setIdConcurrencia(Long id) {
		this.id = id;
	}

	public String getAccionConcurrencia() {
		return accionConcurrencia;
	}

	public void setAccionConcurrencia(String accionConcurrencia) {
		this.accionConcurrencia = accionConcurrencia;
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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	



	
	
}