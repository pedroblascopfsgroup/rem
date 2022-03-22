package es.pfsgroup.plugin.rem.model;

import java.util.List;

import javax.persistence.Column;

/**
 * Dto que gestiona la disponibilidad de la publicación de un activo.
 *
 */
public class DtoCondicionantesDisponibilidad extends DtoTabActivo {
	private static final long serialVersionUID = 1L;
	
	private String idActivo;
	private Boolean ruina;
	private Boolean pendienteInscripcion;
	private Boolean obraNuevaSinDeclarar;
	private Boolean sinTomaPosesionInicial;
	private Boolean proindiviso;
	private Boolean obraNuevaEnConstruccion;
	private Boolean ocupadoConTitulo;
	private Boolean tapiado;
	private Boolean vandalizado;
	private String otro;
	private Boolean ocupadoSinTitulo;
	private Boolean divHorizontalNoInscrita;
	private Boolean sinInformeAprobado;
	private Boolean sinInformeAprobadoREM;
	private Boolean portalesExternos;
	private String estadoCondicionadoCodigo;
	private Boolean conCargas;
	private Boolean isCondicionado;
	private List<?> activosPropagables;
	private Integer comboOtro;
	
	//Condiciones Disponibilidad Caixa
    private Boolean publicacionPortalPublicoVenta;
    private Boolean publicacionPortalPublicoAlquiler;
    private Boolean publicacionPortalInversorVenta;
    private Boolean publicacionPortalInversorAlquiler;
    private Boolean publicacionPortalApiVenta;
    private Boolean publicacionPortalApiAlquiler;

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public Boolean getRuina() {
		return ruina;
	}

	public void setRuina(Boolean ruina) {
		this.ruina = ruina;
	}

	public Boolean getPendienteInscripcion() {
		return pendienteInscripcion;
	}

	public void setPendienteInscripcion(Boolean pendienteInscripcion) {
		this.pendienteInscripcion = pendienteInscripcion;
	}

	public Boolean getObraNuevaSinDeclarar() {
		return obraNuevaSinDeclarar;
	}

	public void setObraNuevaSinDeclarar(Boolean obraNuevaSinDeclarar) {
		this.obraNuevaSinDeclarar = obraNuevaSinDeclarar;
	}

	public Boolean getSinTomaPosesionInicial() {
		return sinTomaPosesionInicial;
	}

	public void setSinTomaPosesionInicial(Boolean sinTomaPosesionInicial) {
		this.sinTomaPosesionInicial = sinTomaPosesionInicial;
	}

	public Boolean getProindiviso() {
		return proindiviso;
	}

	public void setProindiviso(Boolean proindiviso) {
		this.proindiviso = proindiviso;
	}

	public Boolean getObraNuevaEnConstruccion() {
		return obraNuevaEnConstruccion;
	}

	public void setObraNuevaEnConstruccion(Boolean obraNuevaEnConstruccion) {
		this.obraNuevaEnConstruccion = obraNuevaEnConstruccion;
	}

	public Boolean getOcupadoConTitulo() {
		return ocupadoConTitulo;
	}

	public void setOcupadoConTitulo(Boolean ocupadoConTitulo) {
		this.ocupadoConTitulo = ocupadoConTitulo;
	}

	public Boolean getTapiado() {
		return tapiado;
	}

	public void setTapiado(Boolean tapiado) {
		this.tapiado = tapiado;
	}
	
	public Boolean getVandalizado() {
		return vandalizado;
	}

	public void setVandalizado(Boolean vandalizado) {
		this.vandalizado = vandalizado;
	}

	public String getOtro() {
		return otro;
	}

	public void setOtro(String otro) {
		this.otro = otro;
	}

	public Boolean getOcupadoSinTitulo() {
		return ocupadoSinTitulo;
	}

	public void setOcupadoSinTitulo(Boolean ocupadoSinTitulo) {
		this.ocupadoSinTitulo = ocupadoSinTitulo;
	}

	public Boolean getDivHorizontalNoInscrita() {
		return divHorizontalNoInscrita;
	}

	public void setDivHorizontalNoInscrita(Boolean divHorizontalNoInscrita) {
		this.divHorizontalNoInscrita = divHorizontalNoInscrita;
	}

	public List<?> getActivosPropagables() {
		return activosPropagables;
	}

	public void setActivosPropagables(List<?> activosPropagables) {
		this.activosPropagables = activosPropagables;
	}

	public Boolean getSinInformeAprobado() {
		return sinInformeAprobado;
	}

	public void setSinInformeAprobado(Boolean sinInformeAprobado) {
		this.sinInformeAprobado = sinInformeAprobado;
	}
	
	public Boolean getSinInformeAprobadoREM() {
		return sinInformeAprobadoREM;
	}

	public void setSinInformeAprobadoREM(Boolean sinInformeAprobadoREM) {
		this.sinInformeAprobadoREM = sinInformeAprobadoREM;
	}

	public Boolean getPortalesExternos() {
		return portalesExternos;
	}

	public void setPortalesExternos(Boolean portalesExternos) {
		this.portalesExternos = portalesExternos;
	}

	public String getEstadoCondicionadoCodigo() {
		return estadoCondicionadoCodigo;
	}

	public void setEstadoCondicionadoCodigo(String estadoCondicionadoCodigo) {
		this.estadoCondicionadoCodigo = estadoCondicionadoCodigo;
	}

	public Boolean getConCargas() {
		return conCargas;
	}

	public void setConCargas(Boolean conCargas) {
		this.conCargas = conCargas;
	}

	public Boolean getIsCondicionado() {
		return isCondicionado;
	}

	public void setIsCondicionado(Boolean isCondicionado) {
		this.isCondicionado = isCondicionado;
	}

	public Integer getComboOtro() {
		return comboOtro;
	}

	public void setComboOtro(Integer comboOtro) {
		this.comboOtro = comboOtro;
	}

	public Boolean getPublicacionPortalPublicoVenta() {
		return publicacionPortalPublicoVenta;
	}

	public void setPublicacionPortalPublicoVenta(Boolean publicacionPortalPublicoVenta) {
		this.publicacionPortalPublicoVenta = publicacionPortalPublicoVenta;
	}

	public Boolean getPublicacionPortalPublicoAlquiler() {
		return publicacionPortalPublicoAlquiler;
	}

	public void setPublicacionPortalPublicoAlquiler(Boolean publicacionPortalPublicoAlquiler) {
		this.publicacionPortalPublicoAlquiler = publicacionPortalPublicoAlquiler;
	}

	public Boolean getPublicacionPortalInversorVenta() {
		return publicacionPortalInversorVenta;
	}

	public void setPublicacionPortalInversorVenta(Boolean publicacionPortalInversorVenta) {
		this.publicacionPortalInversorVenta = publicacionPortalInversorVenta;
	}

	public Boolean getPublicacionPortalInversorAlquiler() {
		return publicacionPortalInversorAlquiler;
	}

	public void setPublicacionPortalInversorAlquiler(Boolean publicacionPortalInversorAlquiler) {
		this.publicacionPortalInversorAlquiler = publicacionPortalInversorAlquiler;
	}

	public Boolean getPublicacionPortalApiVenta() {
		return publicacionPortalApiVenta;
	}

	public void setPublicacionPortalApiVenta(Boolean publicacionPortalApiVenta) {
		this.publicacionPortalApiVenta = publicacionPortalApiVenta;
	}

	public Boolean getPublicacionPortalApiAlquiler() {
		return publicacionPortalApiAlquiler;
	}

	public void setPublicacionPortalApiAlquiler(Boolean publicacionPortalApiAlquiler) {
		this.publicacionPortalApiAlquiler = publicacionPortalApiAlquiler;
	}
	
	
}
