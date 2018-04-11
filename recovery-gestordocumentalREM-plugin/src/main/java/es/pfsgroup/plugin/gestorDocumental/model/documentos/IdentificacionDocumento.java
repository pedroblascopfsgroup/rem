package es.pfsgroup.plugin.gestorDocumental.model.documentos;

public class IdentificacionDocumento {

	/**
	 * Tipo de expediente
	 */
	private String tipoExpediente;

	/**
	 * Clase de expediente
	 */
	private String claseExpediente;

	/**
	 * Identificador interno de Haya del expediente
	 */
	@Deprecated
	private String idExpedienteHaya;

	/**
	 * Código Serie documental
	 */
	private String serieDocumental;

	/**
	 * Código TDN1
	 */
	private String tdn1;

	/**
	 * Código TDN2
	 */
	private String tdn2;

	/**
	 * Identificador del documento (DataID)
	 */
	private Integer identificadorNodo;

	/**
	 * Nombre del nodo
	 */
	private String nombreNodo;
	
	/**
	 * Fecha del documento (si el campo fecha documento de la categoría está relleno se utiliza ese, sino la fecha de creación del documento).
	 */
	private String fechaDocumento;
	
	/**
	 * Descripción del documento
	 */
	private String descripcionDocumento;
	
	/**
	 * Mymetype del documento
	 */
	private String contentType;
	
	/**
	 * Fecha de creación del documento
	 */
	private String createdate;
	
	/**
	 * Tamaño del fichero en kb
	 */
	private String fileSize;
	
	/**
	 * Indica si es un elemento relacionado o no
	 */
	private Boolean rel;
	
	/**
	 * Descripción del tdn2 del documento
	 */
	private String tdn2_desc;
	
	/**
	 * Nombre del activo donde está el documento (equivale a idExpedienteHaya)
	 */
	private String id_activo;

	public String getTipoExpediente() {
		return tipoExpediente;
	}

	public void setTipoExpediente(String tipoExpediente) {
		this.tipoExpediente = tipoExpediente;
	}

	public String getClaseExpediente() {
		return claseExpediente;
	}

	public void setClaseExpediente(String claseExpediente) {
		this.claseExpediente = claseExpediente;
	}

	public String getIdExpedienteHaya() {
		return idExpedienteHaya;
	}

	public void setIdExpedienteHaya(String idExpedienteHaya) {
		this.idExpedienteHaya = idExpedienteHaya;
	}

	public String getSerieDocumental() {
		return serieDocumental;
	}

	public void setSerieDocumental(String serieDocumental) {
		this.serieDocumental = serieDocumental;
	}

	public String getTdn1() {
		return tdn1;
	}

	public void setTdn1(String tdn1) {
		this.tdn1 = tdn1;
	}

	public String getTdn2() {
		return tdn2;
	}

	public void setTdn2(String tdn2) {
		this.tdn2 = tdn2;
	}

	public Integer getIdentificadorNodo() {
		return identificadorNodo;
	}

	public void setIdentificadorNodo(Integer identificadorNodo) {
		this.identificadorNodo = identificadorNodo;
	}

	public String getNombreNodo() {
		return nombreNodo;
	}

	public void setNombreNodo(String nombreNodo) {
		this.nombreNodo = nombreNodo;
	}
	
	public String getFechaDocumento() {
		return fechaDocumento;
	}
	
	public void setFechaDocumento(String fechaDocumento) {
		this.fechaDocumento = fechaDocumento;
	}
		
	public String getDescripcionDocumento() {
		return descripcionDocumento;
	}
	
	public void setDescripcionDocumento(String descripcionDocumento) {
		this.descripcionDocumento = descripcionDocumento;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getCreatedate() {
		return createdate;
	}

	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public Boolean getRel() {
		return rel;
	}

	public void setRel(Boolean rel) {
		this.rel = rel;
	}

	public String getTdn2_desc() {
		return tdn2_desc;
	}

	public void setTdn2_desc(String tdn2_desc) {
		this.tdn2_desc = tdn2_desc;
	}

	public String getId_activo() {
		return id_activo;
	}

	public void setId_activo(String id_activo) {
		this.id_activo = id_activo;
	}

}