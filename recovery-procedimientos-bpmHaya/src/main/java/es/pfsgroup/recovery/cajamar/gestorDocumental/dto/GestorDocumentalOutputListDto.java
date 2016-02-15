package es.pfsgroup.recovery.cajamar.gestorDocumental.dto;

public class GestorDocumentalOutputListDto {

	// Tipo de documento (código de 5 dígitos, por ejemplo 00002 que corresponde
	// a DNI) (Campo informativo)
	private String tipoDoc;
	// El nombre del tipo de documento anterior (por ejemplo DNI) (Campo
	// informativo)
	private String nombreTipoDoc;
	// Descripción que tiene asociada (Campo informativo)
	private String descripcion;
	// Fecha en la que se dio de alta la versión devuelta en los datos de salida
	// (Campo informativo)
	private String altaVersion;
	// Versión del documento (Campo informativo)
	private String version;
	// Fecha en la que se da de alta la relación (Campo informativo)
	private String altaRelacion;
	// Entidad bancaria que dio de alta la relación (Campo informativo)
	private String entidad;
	// Centro (oficina) que dio de alta la relación (Campo informativo)
	private String centro;
	// Tipo asociación (Maestro de la clave principal por ejemplo PERS,
	// MCTA...)(Campo informativo)
	private String maestro;
	// Clave asociación (Clave principal del documento, por ejemplo el número de
	// persona, cuenta, etc...)(Campo informativo)
	private String claveRelacion;
	// Indica si el documento puede actualizarse o no. (Campo informativo)
	private String permact;
	// Fecha de vigencia o caducidad del documento (Campo informativo)
	private String fechaVig;
	// Indica si el tipo de documento graba en el histórica del gestor
	// documental (Campo informativo)
	private String hist;
	// Identificador interno de la relación (Campo informativo)
	private String idDocumento;
	// Indica si el usuario puede consultar o no el documento (Si el usuario no
	// tiene permiso, dará error la opción de descarga individual) (Campo
	// informativo)
	private String consultabilidad;
	// Indica si el documento está retenido (Si el documento está retenido, el
	// usuario no podrá descargarlo)(Campo informativo)
	private String retenido;
	// Extensión del fichero (Este campo es necesario para la descarga
	// individual)
	private String extFichero;
	// Indica si el documento está firmado digitalmente, total o parcialmente
	// por parte del cliente. (Campo informativo)
	private String estadosFd;
	// Localizador/referencia de centera (Este campo es necesario para la
	// descarga individual)
	private String refCentera;
	
	private String contentType;

	public String getTipoDoc() {
		return tipoDoc;
	}

	public void setTipoDoc(String tipoDoc) {
		this.tipoDoc = tipoDoc;
	}

	public String getNombreTipoDoc() {
		return nombreTipoDoc;
	}

	public void setNombreTipoDoc(String nombreTipoDoc) {
		this.nombreTipoDoc = nombreTipoDoc;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getAltaVersion() {
		return altaVersion;
	}

	public void setAltaVersion(String altaVersion) {
		this.altaVersion = altaVersion;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getAltaRelacion() {
		return altaRelacion;
	}

	public void setAltaRelacion(String altaRelacion) {
		this.altaRelacion = altaRelacion;
	}

	public String getEntidad() {
		return entidad;
	}

	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}

	public String getCentro() {
		return centro;
	}

	public void setCentro(String centro) {
		this.centro = centro;
	}

	public String getMaestro() {
		return maestro;
	}

	public void setMaestro(String maestro) {
		this.maestro = maestro;
	}

	public String getClaveRelacion() {
		return claveRelacion;
	}

	public void setClaveRelacion(String claveRelacion) {
		this.claveRelacion = claveRelacion;
	}

	public String getPermact() {
		return permact;
	}

	public void setPermact(String permact) {
		this.permact = permact;
	}

	public String getFechaVig() {
		return fechaVig;
	}

	public void setFechaVig(String fechaVig) {
		this.fechaVig = fechaVig;
	}

	public String getHist() {
		return hist;
	}

	public void setHist(String hist) {
		this.hist = hist;
	}

	public String getIdDocumento() {
		return idDocumento;
	}

	public void setIdDocumento(String idDocumento) {
		this.idDocumento = idDocumento;
	}

	public String getConsultabilidad() {
		return consultabilidad;
	}

	public void setConsultabilidad(String consultabilidad) {
		this.consultabilidad = consultabilidad;
	}

	public String getRetenido() {
		return retenido;
	}

	public void setRetenido(String retenido) {
		this.retenido = retenido;
	}

	public String getExtFichero() {
		return extFichero;
	}

	public void setExtFichero(String extFichero) {
		this.extFichero = extFichero;
	}

	public String getEstadosFd() {
		return estadosFd;
	}

	public void setEstadosFd(String estadosFd) {
		this.estadosFd = estadosFd;
	}

	public String getRefCentera() {
		return refCentera;
	}

	public void setRefCentera(String refCentera) {
		this.refCentera = refCentera;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

}
