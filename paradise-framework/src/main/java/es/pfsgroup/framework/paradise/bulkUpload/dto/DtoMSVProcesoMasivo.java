package es.pfsgroup.framework.paradise.bulkUpload.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoMSVProcesoMasivo extends WebDto{

	private static final long serialVersionUID = 1L;

	private String id;
	private String tipoOperacion;
	private Long tipoOperacionId;
	private String estadoProceso;
	private String nombre;
	private String usuario;
	private Date fechaCrear;
	private int totalCount;
	private boolean sePuedeProcesar;
	private boolean conErrores;
	private boolean validable;
	private boolean conResultados;
	private Long totalFilas;
	private Long totalFilasOk;
	private Long totalFilasKo;


	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public Long getTipoOperacionId() {
		return tipoOperacionId;
	}
	public void setTipoOperacionId(Long tipoOperacionId) {
		this.tipoOperacionId = tipoOperacionId;
	}
	public String getEstadoProceso() {
		return estadoProceso;
	}
	public void setEstadoProceso(String estadoProceso) {
		this.estadoProceso = estadoProceso;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public Date getFechaCrear() {
		return fechaCrear;
	}
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public boolean getSePuedeProcesar() {
		return sePuedeProcesar;
	}
	public void setSePuedeProcesar(boolean sePuedeProcesar) {
		this.sePuedeProcesar = sePuedeProcesar;
	}
	public boolean getConErrores() {
		return conErrores;
	}
	public void setConErrores(boolean conErrores) {
		this.conErrores = conErrores;
	}
	public boolean getValidable(){
		return validable;
	}
	public void setValidable(boolean validable){
		this.validable = validable;
	}
	public Long getTotalFilas() {
		return totalFilas;
	}
	public void setTotalFilas(Long totalFilas) {
		this.totalFilas = totalFilas;
	}
	public Long getTotalFilasOk() {
		return totalFilasOk;
	}
	public void setTotalFilasOk(Long totalFilasOk) {
		this.totalFilasOk = totalFilasOk;
	}
	public Long getTotalFilasKo() {
		return totalFilasKo;
	}
	public void setTotalFilasKo(Long totalFilasKo) {
		this.totalFilasKo = totalFilasKo;
	}
	public boolean getConResultados() {
		return conResultados;
	}
	public void setConResultados(boolean conResultados) {
		this.conResultados = conResultados;
	}
	
	
}
