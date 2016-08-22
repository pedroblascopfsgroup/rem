package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import javax.persistence.Column;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoInformacionAdministrativa extends WebDto {

	private static final long serialVersionUID = 0L;

	private String numeroActivo;
	/*private String refCatastral;
	private String poligono;
	private String parcela;
	private String titularCatastral;
	private String superficieConstruida;
	private String superficieUtil;
	private String superficieReperComun;
	private String superficieParcela;
	private String superficieSuelo;
	private String valorCatastralConst;	
	private String valorCatastralSuelo;
	private Date fechaRevValorCat;*/
	private String sueloVpo;
	private String promocionVpo;
	private String numExpediente;
	private Date fechaCalificacion;
	private Integer obligatorioSolDevAyuda;
	private Integer obligatorioAutAdmVenta;
	private Integer descalificado;
	private Integer sujetoAExpediente;
	private String organismoExpropiante;
	private Date fechaInicioExpediente;
	private String refExpedienteAdmin;
	private String refExpedienteInterno;
	private String observacionesExpropiacion;
	private String maxPrecioVenta;
	private String observaciones;
	
	private String tipoVpoId;
	private String tipoVpoCodigo;    
	private String tipoVpoDescripcion;
	private String tipoVpoDescripcionLarga;	
	private Integer vpo;
	
	
	
	
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	
	public String getSueloVpo() {
		return sueloVpo;
	}
	public void setSueloVpo(String sueloVpo) {
		this.sueloVpo = sueloVpo;
	}
	public String getPromocionVpo() {
		return promocionVpo;
	}
	public void setPromocionVpo(String promocionVpo) {
		this.promocionVpo = promocionVpo;
	}
	public String getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}
	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}
	public Integer getObligatorioSolDevAyuda() {
		return obligatorioSolDevAyuda;
	}
	public void setObligatorioSolDevAyuda(Integer obligatorioSolDevAyuda) {
		this.obligatorioSolDevAyuda = obligatorioSolDevAyuda;
	}
	public Integer getObligatorioAutAdmVenta() {
		return obligatorioAutAdmVenta;
	}
	public void setObligatorioAutAdmVenta(Integer obligatorioAutAdmVenta) {
		this.obligatorioAutAdmVenta = obligatorioAutAdmVenta;
	}
	public Integer getDescalificado() {
		return descalificado;
	}
	public void setDescalificado(Integer descalificado) {
		this.descalificado = descalificado;
	}
	public String getMaxPrecioVenta() {
		return maxPrecioVenta;
	}
	public void setMaxPrecioVenta(String maxPrecioVenta) {
		this.maxPrecioVenta = maxPrecioVenta;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getTipoVpoCodigo() {
		return tipoVpoCodigo;
	}
	public void setTipoVpoCodigo(String tipoVpoCodigo) {
		this.tipoVpoCodigo = tipoVpoCodigo;
	}
	public String getTipoVpoDescripcion() {
		return tipoVpoDescripcion;
	}
	public void setTipoVpoDescripcion(String tipoVpoDescripcion) {
		this.tipoVpoDescripcion = tipoVpoDescripcion;
	}
	public String getTipoVpoDescripcionLarga() {
		return tipoVpoDescripcionLarga;
	}
	public void setTipoVpoDescripcionLarga(String tipoVpoDescripcionLarga) {
		this.tipoVpoDescripcionLarga = tipoVpoDescripcionLarga;
	}
	public String getTipoVpoId() {
		return tipoVpoId;
	}
	public void setTipoVpoId(String tipoVpoId) {
		this.tipoVpoId = tipoVpoId;
	}
	public Integer getVpo() {
		return vpo;
	}
	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}
	public Integer getSujetoAExpediente() {
		return sujetoAExpediente;
	}
	public void setSujetoAExpediente(Integer sujetoAExpediente) {
		this.sujetoAExpediente = sujetoAExpediente;
	}
	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}
	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}
	public String getOrganismoExpropiante() {
		return organismoExpropiante;
	}
	public void setOrganismoExpropiante(String organismoExpropiante) {
		this.organismoExpropiante = organismoExpropiante;
	}
	public String getRefExpedienteAdmin() {
		return refExpedienteAdmin;
	}
	public void setRefExpedienteAdmin(String refExperienciaAdmin) {
		this.refExpedienteAdmin = refExperienciaAdmin;
	}
	public String getRefExpedienteInterno() {
		return refExpedienteInterno;
	}
	public void setRefExpedienteInterno(String refExpedienteInterno) {
		this.refExpedienteInterno = refExpedienteInterno;
	}
	public String getObservacionesExpropiacion() {
		return observacionesExpropiacion;
	}
	public void setObservacionesExpropiacion(String observacionesExpropiacion) {
		this.observacionesExpropiacion = observacionesExpropiacion;
	}

	
}