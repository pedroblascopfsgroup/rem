package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

public class DtoAdjuntoPromocion implements Serializable {

	private static final long serialVersionUID = -7785802535778510517L;

    private Long id;
    
    private String idEntidad;    
   
    private String codigoTipo;

    private String descripcionTipo;

	private String nombre;

	private String contentType;

	private Long tamanyo;
	
	private String descripcion;

	private Date fechaDocumento;
	
	private String gestor;
	
	private String matricula;
	
	private Date createDate;
	
	private String fileSize;
	
	private Long idActivo;
	
	private String codPromo; 
	
	private Boolean rel;
	
	private String tdn2_desc;
	
	private String tipoExpediente;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(String idEntidad) {
		this.idEntidad = idEntidad;
	}

	public String getCodigoTipo() {
		return codigoTipo;
	}

	public void setCodigoTipo(String codigoTipo) {
		this.codigoTipo = codigoTipo;
	}

	public String getDescripcionTipo() {
		return descripcionTipo;
	}

	public void setDescripcionTipo(String descripcionTipo) {
		this.descripcionTipo = descripcionTipo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public Long getTamanyo() {
		return tamanyo;
	}

	public void setTamanyo(Long tamanyo) {
		this.tamanyo = tamanyo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaDocumento() {
		return fechaDocumento;
	}

	public void setFechaDocumento(Date fechaDocumento) {
		this.fechaDocumento = fechaDocumento;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}


	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getCodPromo() {
		return codPromo;
	}

	public void setCodPromo(String codPromo) {
		this.codPromo = codPromo;
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

	public String getTipoExpediente() {
		return tipoExpediente;
	}

	public void setTipoExpediente(String tipoExpediente) {
		this.tipoExpediente = tipoExpediente;
	}
	
}
