package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GESTORES_ACTIVO", schema = "${entity.schema}")
public class VGestoresActivo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long activoId;
	
	@Column(name = "DD_CRA_CODIGO")
	private Long carteraCodigo;
	
	@Column(name = "DD_EAC_CODIGO")
	private String estadoActivoCodigo;
	
	@Column(name = "DD_TCR_CODIGO")
	private String tipoComercializarCodigo;
	
	@Column(name = "DD_PRV_CODIGO")
	private String provinciaCodigo;	
	
	@Column(name = "DD_LOC_CODIGO")
	private Long localidadCodigo;	
	
	@Column(name = "COD_POSTAL")
	private String codigoPostal;	
	
	@Column(name = "TIPO_GESTOR")
	private String tipoGestorCodigo;
	
	@Column(name = "USERNAME")
	private String username;
	
	@Column(name = "NOMBRE")
	private String nombreUsuario;

	@Column(name = "DD_SCR_CODIGO")
	private Long subCarteraCodigo;
	
	public Long getActivoId() {
		return activoId;
	}

	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}

	public Long getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(Long carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}

	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}

	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}

	public String getTipoComercializarCodigo() {
		return tipoComercializarCodigo;
	}

	public void setTipoComercializarCodigo(String tipoComercializarCodigo) {
		this.tipoComercializarCodigo = tipoComercializarCodigo;
	}

	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}

	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}

	public Long getLocalidadCodigo() {
		return localidadCodigo;
	}

	public void setLocalidadCodigo(Long localidadCodigo) {
		this.localidadCodigo = localidadCodigo;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getTipoGestorCodigo() {
		return tipoGestorCodigo;
	}

	public void setTipoGestorCodigo(String tipoGestorCodigo) {
		this.tipoGestorCodigo = tipoGestorCodigo;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public Long getSubCarteraCodigo() {
		return subCarteraCodigo;
	}

	public void setSubCarteraCodigo(Long subCarteraCodigo) {
		this.subCarteraCodigo = subCarteraCodigo;
	}
	
	
	
}