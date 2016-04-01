package es.pfsgroup.plugin.gestorDocumental.model.documentos;

public class ArchivoFisico {

	/**
	 * Campo relativo al registro físico del documento. Nombre del proveedor que
	 * custodia el documento físico
	 */
	private String proveedorCustodia;

	/**
	 * Identificador de referencia de documento físico
	 */
	private String refCustodia;

	/**
	 * Número del contenedor donde se archiva el documento físico
	 */
	private String contenedor;

	/**
	 * Número del lote
	 */
	private String lote;

	/**
	 * Posición del lote
	 */
	private String posicion;

	/**
	 * Indica si un documento físico es Original, Copia Autorizada o Copia
	 */
	private String docOriginal;

	public String getProveedorCustodia() {
		return proveedorCustodia;
	}

	public void setProveedorCustodia(String proveedorCustodia) {
		this.proveedorCustodia = proveedorCustodia;
	}

	public String getRefCustodia() {
		return refCustodia;
	}

	public void setRefCustodia(String refCustodia) {
		this.refCustodia = refCustodia;
	}

	public String getContenedor() {
		return contenedor;
	}

	public void setContenedor(String contenedor) {
		this.contenedor = contenedor;
	}

	public String getLote() {
		return lote;
	}

	public void setLote(String lote) {
		this.lote = lote;
	}

	public String getPosicion() {
		return posicion;
	}

	public void setPosicion(String posicion) {
		this.posicion = posicion;
	}

	public String getDocOriginal() {
		return docOriginal;
	}

	public void setDocOriginal(String docOriginal) {
		this.docOriginal = docOriginal;
	}

}