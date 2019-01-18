package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para recoger los datos de generar documento en los wizard alta oferta y compradores
 * @author Ivan Rubio
 *
 */
public class DtoGenerarDocGDPR extends WebDto {

	private static final long serialVersionUID = 0L;
	
	//DATOS WIZARD COMUNES
	
	private Boolean cesionDatos;
	private Boolean transIntern;
	private Boolean comTerceros;
	private Long codPrescriptor;
	private String nombre;
	private String documento;
	private String telefono;
	private String direccion;
	private String email;
	private String url;
	private String data;
	
	//DATOS WIZARD COMPRADORES	

	private Long idExpediente;

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}
	
	public Boolean getCesionDatos() {
		return cesionDatos;
	}

	public void setCesionDatos(Boolean cesionDatos) {
		this.cesionDatos = cesionDatos;
	}

	public Boolean getTransIntern() {
		return transIntern;
	}

	public void setTransIntern(Boolean transIntern) {
		this.transIntern = transIntern;
	}

	public Boolean getComTerceros() {
		return comTerceros;
	}

	public void setComTerceros(Boolean comTerceros) {
		this.comTerceros = comTerceros;
	}

	public Long getCodPrescriptor() {
		return codPrescriptor;
	}

	public void setCodPrescriptor(Long codPrescriptor) {
		this.codPrescriptor = codPrescriptor;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDocumento() {
		return documento;
	}

	public void setDocumento(String documento) {
		this.documento = documento;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	
	
}