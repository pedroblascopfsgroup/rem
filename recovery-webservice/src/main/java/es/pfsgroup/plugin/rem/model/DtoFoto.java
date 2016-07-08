package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;



/**
 * Dto para la pestaña de fotos del activo
 * @author Benjamín Guerrero
 *
 */
public class DtoFoto extends WebDto {

	private static final long serialVersionUID = 0L;

	
    
    /*private DDTipoFoto tipoFoto;
    private Integer tamanyo;
    private Boolean principal;
	private Boolean interiorExterior;*/


	private Long id;
    private String nombre;
	private String descripcion;
	private String subdivisionDescripcion;
	private Date fechaDocumento;
	private Integer orden;
	private String path;
	private String tituloFoto;
	private boolean principal;
	private boolean interiorExterior;
	private String numeroActivo;
	
	
	// Mapeados a mano
	//private Adjunto adjunto; 
	private FileItem fileItem;


	public String getNombre() {
		return nombre;
	}


	public void setNombre(String nombre) {
		this.nombre = nombre;
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


	public Integer getOrden() {
		return orden;
	}


	public void setOrden(Integer orden) {
		this.orden = orden;
	}


	public FileItem getFileItem() {
		return fileItem;
	}


	public void setFileItem(FileItem fileItem) {
		this.fileItem = fileItem;
	}


	public String getPath() {
		return path;
	}


	public void setPath(String path) {
		this.path = path;
	}


	public String getSubdivisionDescripcion() {
		return subdivisionDescripcion;
	}


	public void setSubdivisionDescripcion(String subdivisionDescripcion) {
		this.subdivisionDescripcion = subdivisionDescripcion;
	}


	public Long getId() {
		return id;
	}


	public void setId(Long id) {
		this.id = id;
	}


	public String getTituloFoto() {
		return tituloFoto;
	}


	public void setTituloFoto(String tituloFoto) {
		this.tituloFoto = tituloFoto;
	}


	public boolean isPrincipal() {
		return principal;
	}

	public boolean isInteriorExterior() {
		return interiorExterior;
	}
	
	public boolean getPrincipal() {
		return principal;
	}

	public boolean getInteriorExterior() {
		return interiorExterior;
	}


	public void setInteriorExterior(boolean interiorExterior) {
		this.interiorExterior = interiorExterior;
	}


	public void setPrincipal(boolean principal) {
		this.principal = principal;
	}


	public String getNumeroActivo() {
		return numeroActivo;
	}


	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}

	
}