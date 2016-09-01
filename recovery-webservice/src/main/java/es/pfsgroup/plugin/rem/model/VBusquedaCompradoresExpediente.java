package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_COMPRADORES_EXP", schema = "${entity.schema}")
public class VBusquedaCompradoresExpediente implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "COM_ID")
	private String id;
	
	@Column(name="ECO_ID")
	private String idExpediente;
	
	@Column(name="NOMBRE_COMPRADOR")
	private String nombreComprador;
	
	@Column(name="DOC_COMPRADOR")
	private String numDocumentoComprador;
	
	@Column(name="NOMBRE_REPRESENTANTE")
	private String nombreRepresentante;
	
	@Column(name="DOC_REPRESENTANTE")
	private String numDocumentoRepresentante;
	
	@Column(name="PORCENTAJE_COMPRA")
	private String porcentajeCompra;
	
	@Column(name="TELEFONO")
	private String telefono;
	
	@Column(name="COM_EMAIL")
	private String email;
	
	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(String idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getNombreComprador() {
		return nombreComprador;
	}

	public void setNombreComprador(String nombreComprador) {
		this.nombreComprador = nombreComprador;
	}

	public String getNumDocumentoComprador() {
		return numDocumentoComprador;
	}

	public void setNumDocumentoComprador(String numDocumentoComprador) {
		this.numDocumentoComprador = numDocumentoComprador;
	}

	public String getNombreRepresentante() {
		return nombreRepresentante;
	}

	public void setNombreRepresentante(String nombreRepresentante) {
		this.nombreRepresentante = nombreRepresentante;
	}

	public String getNumDocumentoRepresentante() {
		return numDocumentoRepresentante;
	}

	public void setNumDocumentoRepresentante(String numDocumentoRepresentante) {
		this.numDocumentoRepresentante = numDocumentoRepresentante;
	}

	public String getPorcentajeCompra() {
		return porcentajeCompra;
	}

	public void setPorcentajeCompra(String porcentajeCompra) {
		this.porcentajeCompra = porcentajeCompra;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}


}
