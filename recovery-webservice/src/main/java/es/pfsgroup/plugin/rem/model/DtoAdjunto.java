package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

/**
 * Modelo que gestiona la informacion de los adjuntos.
 */

public class DtoAdjunto implements Serializable, Comparable<DtoAdjunto>{

	private static final long serialVersionUID = -7785802535778510517L;

    private Long id;
    
    private Long idEntidad;    
   
    private String codigoTipo;

    private String descripcionTipo;
    
    private String descripcionSubtipo;   

	private String nombre;

	private String contentType;

	private Long tamanyo;
	
	private String descripcion;

	private Date fechaDocumento;
	
	private String gestor;
	
	private String matricula;
	
	private Date createDate;
	
	private String fileSize;
	
	private String id_activo;
	
	private Boolean rel;
	
	private String tdn2_desc;
	
	private String tipoExpediente;	
	
	private String cartera;
	
	private String subcartera;
	
	private Date fechaDocumentoCategoria;
	
	private String aplica;
	
	private String fechaEmision;
	
	private String fechaCaducidad;
	
	private Boolean fechaObtencion;
	
	private String fechaEtiqueta;
	
	private String registro;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
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

	public String getDescripcionSubtipo() {
		return descripcionSubtipo;
	}

	public void setDescripcionSubtipo(String descripcionSubtipo) {
		this.descripcionSubtipo = descripcionSubtipo;
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

	public String getId_activo() {
		return id_activo;
	}

	public void setId_activo(String id_activo) {
		this.id_activo = id_activo;
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
	
	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(String subcartera) {
		this.subcartera = subcartera;
	}

	public Date getFechaDocumentoCategoria() {
		return fechaDocumentoCategoria;
	}

	public void setFechaDocumentoCategoria(Date fechaDocumentoCategoria) {
		this.fechaDocumentoCategoria = fechaDocumentoCategoria;
	}

	@Override
	public int compareTo(DtoAdjunto o) {
		if(DDTipoDocumentoActivo.MATRICULA_INFORME_OCUPACION_DESOCUPACION
				.equals(this.matricula)) {
			return o.getFechaDocumento().compareTo(this.fechaDocumento);
		}
		if(this.getCreateDate() == null ){
			return 1;
		}
		if(o.getCreateDate() == null){
			return -1;
		}
		return o.getCreateDate().compareTo(this.createDate);
	}

	public String getAplica() {
		return aplica;
	}

	public void setAplica(String aplica) {
		this.aplica = aplica;
	}

	public String getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public String getFechaCaducidad() {
		return fechaCaducidad;
	}

	public void setFechaCaducidad(String fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}

	public Boolean getFechaObtencion() {
		return fechaObtencion;
	}

	public void setFechaObtencion(Boolean fechaObtencion) {
		this.fechaObtencion = fechaObtencion;
	}

	public String getFechaEtiqueta() {
		return fechaEtiqueta;
	}

	public void setFechaEtiqueta(String fechaEtiqueta) {
		this.fechaEtiqueta = fechaEtiqueta;
	}

	public String getRegistro() {
		return registro;
	}

	public void setRegistro(String registro) {
		this.registro = registro;
	}
	
	
}
