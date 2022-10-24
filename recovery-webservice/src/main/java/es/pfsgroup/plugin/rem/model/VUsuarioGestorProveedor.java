package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Javier Ebri
 *
 */
@Entity
@Table(name = "VI_USUARIO_GESTOR_PROVEEDOR", schema = "${entity.schema}")
public class VUsuarioGestorProveedor implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "USU_ID")
	private Long id;
	
	@Column(name = "USU_USERNAME")
	private String nombreUsuario;
	
	@Column(name = "GESTOR")
	private Boolean isGestor;
	
	@Column(name = "PROVEEDOR")
	private Boolean isProveedor;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public Boolean getIsGestor() {
		return isGestor;
	}

	public void setIsGestor(Boolean isGestor) {
		this.isGestor = isGestor;
	}

	public Boolean getIsProveedor() {
		return isProveedor;
	}

	public void setIsProveedor(Boolean isProveedor) {
		this.isProveedor = isProveedor;
	}
	
}
