package es.pfsgroup.recovery.cajamar.gestorDocumental.dto;

import java.util.Date;

public class GestorDocumentalInputDto {

	// (Clave principal del documento, por ejemplo el número de persona, cuenta,
	// etc...)(Campo informativo)
	private String claveAsociacion;
	// (Clave principal del documento, por ejemplo el número de persona, cuenta,
	// etc...)(Campo informativo)
	private String claveAsociacion2;
	// (Clave principal del documento, por ejemplo el número de persona, cuenta,
	// etc...)(Campo informativo)
	private String claveAsociacion3;

	private String descripcion;
	// Extensión del fichero (Este campo es necesario para la descarga
	// individual)
	private String extensionFichero;
	// Fecha de vigencia o caducidad del documento (Campo informativo)
	private Date fechaVigencia;
	private String ficheroBase64;
	private String localizador;
	// El servicio dispone de todas las opciones A - Alta, M - Modificación, C -
	// Descarga documento y L - Consulta listado.
	private String operacion;
	private String origen;
	private String rutaFicheroRemoto;
	// Tipo asociación (Maestro de la clave principal por ejemplo PERS,
	// MCTA...)(Campo informativo)
	private String tipoAsociacion;
	private String tipoAsociacion2;
	private String tipoAsociacion3;
	// Tipo de documento (código de 5 dígitos, por ejemplo 00002 que corresponde
	// a DNI) (Campo informativo)
	private String tipoDocumento;
	// Id de la entidad de recovery
	private Long idEntidad;
	
	public static final String APLICACION = "05";

	public String getClaveAsociacion() {
		return claveAsociacion;
	}

	public void setClaveAsociacion(String claveAsociacion) {
		this.claveAsociacion = claveAsociacion;
	}

	public String getClaveAsociacion2() {
		return claveAsociacion2;
	}

	public void setClaveAsociacion2(String claveAsociacion2) {
		this.claveAsociacion2 = claveAsociacion2;
	}

	public String getClaveAsociacion3() {
		return claveAsociacion3;
	}

	public void setClaveAsociacion3(String claveAsociacion3) {
		this.claveAsociacion3 = claveAsociacion3;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getExtensionFichero() {
		return extensionFichero;
	}

	public void setExtensionFichero(String extensionFichero) {
		this.extensionFichero = extensionFichero;
	}

	public Date getFechaVigencia() {
		return fechaVigencia;
	}

	public void setFechaVigencia(Date fechaVigencia) {
		this.fechaVigencia = fechaVigencia;
	}

	public String getFicheroBase64() {
		return ficheroBase64;
	}

	public void setFicheroBase64(String ficheroBase64) {
		this.ficheroBase64 = ficheroBase64;
	}

	public String getLocalizador() {
		return localizador;
	}

	public void setLocalizador(String localizador) {
		this.localizador = localizador;
	}

	public String getOperacion() {
		return operacion;
	}

	public void setOperacion(String operacion) {
		this.operacion = operacion;
	}

	public String getOrigen() {
		return origen;
	}

	public void setOrigen(String origen) {
		this.origen = origen;
	}

	public String getRutaFicheroRemoto() {
		return rutaFicheroRemoto;
	}

	public void setRutaFicheroRemoto(String rutaFicheroRemoto) {
		this.rutaFicheroRemoto = rutaFicheroRemoto;
	}

	public String getTipoAsociacion() {
		return tipoAsociacion;
	}

	public void setTipoAsociacion(String tipoAsociacion) {
		this.tipoAsociacion = tipoAsociacion;
	}

	public String getTipoAsociacion2() {
		return tipoAsociacion2;
	}

	public void setTipoAsociacion2(String tipoAsociacion2) {
		this.tipoAsociacion2 = tipoAsociacion2;
	}

	public String getTipoAsociacion3() {
		return tipoAsociacion3;
	}

	public void setTipoAsociacion3(String tipoAsociacion3) {
		this.tipoAsociacion3 = tipoAsociacion3;
	}

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

}
