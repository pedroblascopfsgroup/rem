package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import javax.validation.constraints.Size;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;


public class OfertaTitularAdicionalDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Diccionary(clase = DDTipoDocumento.class, message = "El tipo de documento no existe", groups = { Insert.class,
			Update.class })
	private String codTipoDocumento;
	@Size(max=14,groups = { Insert.class, Update.class })
	private String documento;
	@Size(max=60,groups = { Insert.class, Update.class })
	private String nombre;
	@Size(max=120,groups = { Insert.class, Update.class })
	private String apellidos;
	@Size(max=120,groups = { Insert.class, Update.class })
	private String direccion;
	@Diccionary(clase = Localidad.class, message = "El municipio no existe", groups = { Insert.class,
			Update.class })
	private String codigoMunicipio;
	@Diccionary(clase = DDProvincia.class, message = "La provincia no existe", groups = { Insert.class,
			Update.class })
	private String codigoProvincia;
	@Size(max=20,groups = { Insert.class, Update.class })
	private String codPostal;
	@Diccionary(clase = DDEstadosCiviles.class, message = "El estado civil no existe", groups = { Insert.class,
			Update.class })
	private String codigoEstadoCivil;
	@Diccionary(clase = DDRegimenesMatrimoniales.class, message = "El regimen economico no existe", groups = { Insert.class,
			Update.class })
	private String codigoRegimenEconomico;
	
	private Boolean rechazarCesionDatosPublicidad;
	private Boolean rechazarCesionDatosPropietario;
	private Boolean rechazarCesionDatosProveedores;
	
	public Boolean getRechazarCesionDatosPublicidad() {
		return rechazarCesionDatosPublicidad;
	}
	public void setRechazarCesionDatosPublicidad(Boolean rechazarCesionDatosPublicidad) {
		this.rechazarCesionDatosPublicidad = rechazarCesionDatosPublicidad;
	}
	public Boolean getRechazarCesionDatosPropietario() {
		return rechazarCesionDatosPropietario;
	}
	public void setRechazarCesionDatosPropietario(Boolean rechazarCesionDatosPropietario) {
		this.rechazarCesionDatosPropietario = rechazarCesionDatosPropietario;
	}
	public Boolean getRechazarCesionDatosProveedores() {
		return rechazarCesionDatosProveedores;
	}
	public void setRechazarCesionDatosProveedores(Boolean rechazarCesionDatosProveedires) {
		this.rechazarCesionDatosProveedores = rechazarCesionDatosProveedires;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getCodTipoDocumento() {
		return codTipoDocumento;
	}
	public void setCodTipoDocumento(String codTipoDocumento) {
		this.codTipoDocumento = codTipoDocumento;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}
	public String getApellidos() {
		return apellidos;
	}
	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getCodigoMunicipio() {
		return codigoMunicipio;
	}
	public void setCodigoMunicipio(String codigoMunicipio) {
		this.codigoMunicipio = codigoMunicipio;
	}
	public String getCodigoProvincia() {
		return codigoProvincia;
	}
	public void setCodigoProvincia(String codigoProvincia) {
		this.codigoProvincia = codigoProvincia;
	}
	public String getCodPostal() {
		return codPostal;
	}
	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}
	public String getCodigoEstadoCivil() {
		return codigoEstadoCivil;
	}
	public void setCodigoEstadoCivil(String codigoEstadoCivil) {
		this.codigoEstadoCivil = codigoEstadoCivil;
	}
	public String getCodigoRegimenEconomico() {
		return codigoRegimenEconomico;
	}
	public void setCodigoRegimenEconomico(String codigoRegimenEconomico) {
		this.codigoRegimenEconomico = codigoRegimenEconomico;
	}
}
