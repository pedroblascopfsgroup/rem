package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoHstcoSeguroRentas extends WebDto  {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id; 
	private int idSeguro;
	private Date fechaSancion;
	private String estado;
	private String solicitud; 
	private String docSco;
	private Integer mesesFianza; 
	private Long importeFianza;
	private Long version;
	private String usuarioCrear;
	private Date fechaCrear;
	private String usuarioModificar;
	private Date fechaModificar;
	private String usuarioBorrar;
	private Date fechaBorrar;
	private int borrado;
	private String proveedor;
	private Long identificador;
	private String idActivo;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public int getIdSeguro() {
		return idSeguro;
	}
	public void setIdSeguro(int idSeguro) {
		this.idSeguro = idSeguro;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getSolicitud() {
		return solicitud;
	}
	public void setSolicitud(String solicitud) {
		this.solicitud = solicitud;
	}
	public String getDocSco() {
		return docSco;
	}
	public void setDocSco(String docSco) {
		this.docSco = docSco;
	}
	public Integer getMesesFianza() {
		return mesesFianza;
	}
	public void setMesesFianza(Integer mesesFianza) {
		this.mesesFianza = mesesFianza;
	}
	public Long getImporteFianza() {
		return importeFianza;
	}
	public void setImporteFianza(Long importeFianza) {
		this.importeFianza = importeFianza;
	}
	public Long getVersion() {
		return version;
	}
	public void setVersion(Long version) {
		this.version = version;
	}
	public String getUsuarioCrear() {
		return usuarioCrear;
	}
	public void setUsuarioCrear(String usuarioCrear) {
		this.usuarioCrear = usuarioCrear;
	}
	public Date getFechaCrear() {
		return fechaCrear;
	}
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
	public String getUsuarioModificar() {
		return usuarioModificar;
	}
	public void setUsuarioModificar(String usuarioModificar) {
		this.usuarioModificar = usuarioModificar;
	}
	public Date getFechaModificar() {
		return fechaModificar;
	}
	public void setFechaModificar(Date fechaModificar) {
		this.fechaModificar = fechaModificar;
	}
	public String getUsuarioBorrar() {
		return usuarioBorrar;
	}
	public void setUsuarioBorrar(String usuarioBorrar) {
		this.usuarioBorrar = usuarioBorrar;
	}
	public Date getFechaBorrar() {
		return fechaBorrar;
	}
	public void setFechaBorrar(Date fechaBorrar) {
		this.fechaBorrar = fechaBorrar;
	}
	public int getBorrado() {
		return borrado;
	}
	public void setBorrado(int borrado) {
		this.borrado = borrado;
	}
	public String getProveedor() {
		return proveedor;
	}
	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}
	public Long getIdentificador() {
		return identificador;
	}
	public void setIdentificador(Long identificador) {
		this.identificador = identificador;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	

}
