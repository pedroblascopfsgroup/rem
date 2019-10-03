package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_BUSQUEDA_ACTIVOS_GESTORIAS", schema = "${entity.schema}")
public class VBusquedaActivosGestorias implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long id;

    @Column(name = "GESTORIA_ADMISION")
    private String gestoriaAdmision;

    @Column(name = "GESTORIA_ADMINISTRACION")
    private String gestoriaAdministracion;
    
    @Column(name = "GESTORIA_FORMALIZACION")
    private String gestoriaFormalizacion;
		
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getGestoriaAdmision() {
		return gestoriaAdmision;
	}

	public void setGestoriaAdmision(String gestoriaAdmision) {
		this.gestoriaAdmision = gestoriaAdmision;
	}

	public String getGestoriaAdministracion() {
		return gestoriaAdministracion;
	}

	public void setGestoriaAdministracion(String gestoriaAdministracion) {
		this.gestoriaAdministracion = gestoriaAdministracion;
	}

	public String getGestoriaFormalizacion() {
		return gestoriaFormalizacion;
	}

	public void setGestoriaFormalizacion(String gestoriaFormalizacion) {
		this.gestoriaFormalizacion = gestoriaFormalizacion;
	}

}