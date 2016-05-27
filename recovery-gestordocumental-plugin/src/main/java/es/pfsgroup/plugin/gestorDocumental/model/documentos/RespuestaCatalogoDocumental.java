package es.pfsgroup.plugin.gestorDocumental.model.documentos;

public class RespuestaCatalogoDocumental {
	
	/**
	 * Código del error
	 */
	private String codigoError;

	/**
	 * Mensaje del error
	 */
	private String mensajeError;
	
	/**
	 * Listado de los documentos del expediente
	 */
	private CatalogosDocumentales[] catalogosDocumentales;


	public String getCodigoError() {
		return codigoError;
	}

	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}

	public String getMensajeError() {
		return mensajeError;
	}

	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}

	public CatalogosDocumentales[] getCatalogosDocumentales() {
		return catalogosDocumentales;
	}

	public void setCatalogosDocumentales(CatalogosDocumentales[] catalogosDocumentales) {
		this.catalogosDocumentales = catalogosDocumentales;
	}



}