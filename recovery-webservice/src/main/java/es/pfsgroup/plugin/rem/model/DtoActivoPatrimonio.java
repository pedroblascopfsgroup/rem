package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el tab de patrimonio
 * @author Ivan Rubio
 *
 */
public class DtoActivoPatrimonio extends DtoTabActivo {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7429602301888781560L;

	private String idPatrimonio;
	private String idActivo;
	private String codigoAdecuacion;
	private String descripcionAdecuacion;
	private String descripcionAdecuacionLarga;
	private Boolean checkPerimetroAlquiler;
	private Boolean chkPerimetroAlquiler;
	private Boolean chkSubrogado;
	private String tipoAlquilerCodigo;
	private Boolean chkRentaAntigua;
	private String tipoInquilino;
	private String estadoAlquiler;
	private int ocupacion;
	private int conTitulo;
	
	//Grid historico adecuaciones patrimonio activo
	private Date fechaInicioAdecuacion;
	private Date fechaFinAdecuacion;
	private Date fechaInicioPerimetroAlquiler;
	private Date fechaFinPerimetroAlquiler;
	
	public Boolean getChkSubrogado() {
		return chkSubrogado;
	}
	public void setChkSubrogado(Boolean chkSubrogado) {
		this.chkSubrogado = chkSubrogado;
	}
	public String getTipoInquilino() {
		return tipoInquilino;
	}
	public void setTipoInquilino(String tipoInquilino) {
		this.tipoInquilino = tipoInquilino;
	}
	public String getEstadoAlquiler() {
		return estadoAlquiler;
	}
	public void setEstadoAlquiler(String estadoAlquiler) {
		this.estadoAlquiler = estadoAlquiler;
	}
	public int getOcupacion() {
		return ocupacion;
	}
	public void setOcupacion(int ocupacion) {
		this.ocupacion = ocupacion;
	}
	public int getConTitulo() {
		return conTitulo;
	}
	public void setConTitulo(int conTitulo) {
		this.conTitulo = conTitulo;
	}	
	public String getIdPatrimonio() {
		return idPatrimonio;
	}
	public void setIdPatrimonio(String idPatrimonio) {
		this.idPatrimonio = idPatrimonio;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}	
	public Boolean getCheckPerimetroAlquiler() {
		return checkPerimetroAlquiler;
	}
	public void setCheckPerimetroAlquiler(Boolean checkPerimetroAlquiler) {
		this.checkPerimetroAlquiler = checkPerimetroAlquiler;
	}
	public Date getFechaInicioAdecuacion() {
		return fechaInicioAdecuacion;
	}
	public void setFechaInicioAdecuacion(Date fechaInicioAdecuacion) {
		this.fechaInicioAdecuacion = fechaInicioAdecuacion;
	}
	public Date getFechaFinAdecuacion() {
		return fechaFinAdecuacion;
	}
	public void setFechaFinAdecuacion(Date fechaFinAdecuacion) {
		this.fechaFinAdecuacion = fechaFinAdecuacion;
	}
	public Date getFechaInicioPerimetroAlquiler() {
		return fechaInicioPerimetroAlquiler;
	}
	public void setFechaInicioPerimetroAlquiler(Date fechaInicioPerimetroAlquiler) {
		this.fechaInicioPerimetroAlquiler = fechaInicioPerimetroAlquiler;
	}
	public Date getFechaFinPerimetroAlquiler() {
		return fechaFinPerimetroAlquiler;
	}
	public void setFechaFinPerimetroAlquiler(Date fechaFinPerimetroAlquiler) {
		this.fechaFinPerimetroAlquiler = fechaFinPerimetroAlquiler;
	}
	public String getCodigoAdecuacion() {
		return codigoAdecuacion;
	}
	public void setCodigoAdecuacion(String codigoAdecuacion) {
		this.codigoAdecuacion = codigoAdecuacion;
	}
	public String getDescripcionAdecuacion() {
		return descripcionAdecuacion;
	}
	public void setDescripcionAdecuacion(String descripcionAdecuacion) {
		this.descripcionAdecuacion = descripcionAdecuacion;
	}
	public String getDescripcionAdecuacionLarga() {
		return descripcionAdecuacionLarga;
	}
	public void setDescripcionAdecuacionLarga(String descripcionAdecuacionLarga) {
		this.descripcionAdecuacionLarga = descripcionAdecuacionLarga;
	}
	public Boolean getChkPerimetroAlquiler() {
		return chkPerimetroAlquiler;
	}
	public void setChkPerimetroAlquiler(Boolean chkPerimetroAlquiler) {
		this.chkPerimetroAlquiler = chkPerimetroAlquiler;
	}
	public String getTipoAlquilerCodigo() {
		return tipoAlquilerCodigo;
	}
	public void setTipoAlquilerCodigo(String tipoAlquilerCodigo) {
		this.tipoAlquilerCodigo = tipoAlquilerCodigo;
	}
	public Boolean getChkRentaAntigua() {
		return chkRentaAntigua;
	}
	public void setChkRentaAntigua(Boolean chkRentaAntigua) {
		this.chkRentaAntigua = chkRentaAntigua;
	}
   
    
    
}