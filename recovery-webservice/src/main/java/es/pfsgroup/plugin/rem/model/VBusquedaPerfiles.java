package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_PERFILES", schema = "${entity.schema}")
public class VBusquedaPerfiles implements Serializable {

	private static final long serialVersionUID = 9034022760124141496L;

	
	@Column(name = "ID")
	private String id;
	
	@Id
	@Column(name = "PEF_ID")
	private Long pefId;
	
	@Column(name = "PEF_DESCRIPCION")
	private String perfilDescripcion;
	
	@Column(name = "PEF_DESCRIPCION_LARGA")
	private String perfilDescripcionLarga;
	
	@Column(name = "PEF_CODIGO")
	private String perfilCodigo;
	
	@Column(name = "FUN_DESCRIPCION")
	private String funcionDescripcion;
	
	@Column(name = "FUN_DESCRIPCION_LARGA")
	private String funcionDescripcionLarga;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Long getPefId() {
		return pefId;
	}

	public void setPefId(Long pefId) {
		this.pefId = pefId;
	}

	public String getPerfilDescripcion() {
		return perfilDescripcion;
	}

	public void setPerfilDescripcion(String perfilDescripcion) {
		this.perfilDescripcion = perfilDescripcion;
	}

	public String getPerfilDescripcionLarga() {
		return perfilDescripcionLarga;
	}

	public void setPerfilDescripcionLarga(String perfilDescripcionLarga) {
		this.perfilDescripcionLarga = perfilDescripcionLarga;
	}

	public String getPerfilCodigo() {
		return perfilCodigo;
	}

	public void setPerfilCodigo(String perfilCodigo) {
		this.perfilCodigo = perfilCodigo;
	}

	public String getFuncionDescripcion() {
		return funcionDescripcion;
	}

	public void setFuncionDescripcion(String funcionDescripcion) {
		this.funcionDescripcion = funcionDescripcion;
	}

	public String getFuncionDescripcionLarga() {
		return funcionDescripcionLarga;
	}

	public void setFuncionDescripcionLarga(String funcionDescripcionLarga) {
		this.funcionDescripcionLarga = funcionDescripcionLarga;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
}
