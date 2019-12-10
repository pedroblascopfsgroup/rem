package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Vicente Martinez Cifre
 *
 */
@Entity
@Table(name = "V_CARTERA_TRABAJOS_PROVEEDOR", schema = "${entity.schema}")
public class VCarteraTrabajosProveedor implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID_VISTA")
	private Long idVista;
	
	@Column(name = "DD_CRA_ID")
	private Long idCartera;
	 
	@Column(name = "PVE_ID")
	private Long idProveedor;
	
	public Long getIdVista() {
		return idVista;
	}
	
	public void setIdVista(Long idVista) {
		this.idVista = idVista;
	}

	public Long getIdCartera() {
		return idCartera;
	}

	public void setIdCartera(Long idCartera) {
		this.idCartera = idCartera;
	}
	
	public Long getIdProveedor() {
		return idProveedor;
	}
	
	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

}
