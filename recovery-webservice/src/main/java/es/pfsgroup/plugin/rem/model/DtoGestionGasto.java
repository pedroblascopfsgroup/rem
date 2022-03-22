package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de la pestaña gestion de un gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoGestionGasto extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Integer necesariaAutorizacionPropietario;
	private String comboMotivoAutorizacionPropietario;
	private String gestoria;
	private Long numProvision;
	private String observaciones;
	private Date fechaAltaRem;
	private String gestorAltaRem;
	private String comboEstadoAutorizacionHaya;
	private Date fechaAutorizacionHaya;
	private String gestorAutorizacionHaya;
	private String comboMotivoRechazoHaya;
	private String comboEstadoAutorizacionPropietario;
	private Date fechaAutorizacionPropietario;
	private String gestorAutorizacionPropietario;
	private String motivoRechazoAutorizacionPropietario;
   	private Date fechaAnulado;
   	private String gestorAnulado;
   	private String comboMotivoAnulado;
   	private Date fechaRetenerPago;
   	private String gestorRetenerPago;
   	private String comboMotivoRetenerPago;
   	private Boolean gestionGastoRepercutido;
   	private Date fechaGestionGastoRepercusion;
   	private String motivoRechazoGestionGasto;
   	private String gestionGastoClientePagador;
   	private Date fechaEnvioPropietario;
   	private String gestionGastoClienteInformador;
   	private Date fechaEnvioInformativa;
   	

	public Integer getNecesariaAutorizacionPropietario() {
		return necesariaAutorizacionPropietario;
	}
	public void setNecesariaAutorizacionPropietario(
			Integer necesariaAutorizacionPropietario) {
		this.necesariaAutorizacionPropietario = necesariaAutorizacionPropietario;
	}
	public String getComboMotivoAutorizacionPropietario() {
		return comboMotivoAutorizacionPropietario;
	}
	public void setComboMotivoAutorizacionPropietario(
			String comboMotivoAutorizacionPropietario) {
		this.comboMotivoAutorizacionPropietario = comboMotivoAutorizacionPropietario;
	}
	public String getGestoria() {
		return gestoria;
	}
	public void setGestoria(String gestoria) {
		this.gestoria = gestoria;
	}
	public Long getNumProvision() {
		return numProvision;
	}
	public void setNumProvision(Long numProvision) {
		this.numProvision = numProvision;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Date getFechaAltaRem() {
		return fechaAltaRem;
	}
	public void setFechaAltaRem(Date fechaAltaRem) {
		this.fechaAltaRem = fechaAltaRem;
	}
	public String getGestorAltaRem() {
		return gestorAltaRem;
	}
	public void setGestorAltaRem(String gestorAltaRem) {
		this.gestorAltaRem = gestorAltaRem;
	}
	public String getComboEstadoAutorizacionHaya() {
		return comboEstadoAutorizacionHaya;
	}
	public void setComboEstadoAutorizacionHaya(String comboEstadoAutorizacionHaya) {
		this.comboEstadoAutorizacionHaya = comboEstadoAutorizacionHaya;
	}
	public Date getFechaAutorizacionHaya() {
		return fechaAutorizacionHaya;
	}
	public void setFechaAutorizacionHaya(Date fechaAutorizacionHaya) {
		this.fechaAutorizacionHaya = fechaAutorizacionHaya;
	}
	public String getGestorAutorizacionHaya() {
		return gestorAutorizacionHaya;
	}
	public void setGestorAutorizacionHaya(String gestorAutorizacionHaya) {
		this.gestorAutorizacionHaya = gestorAutorizacionHaya;
	}
	public String getComboMotivoRechazoHaya() {
		return comboMotivoRechazoHaya;
	}
	public void setComboMotivoRechazoHaya(String comboMotivoRechazoHaya) {
		this.comboMotivoRechazoHaya = comboMotivoRechazoHaya;
	}
	public String getComboEstadoAutorizacionPropietario() {
		return comboEstadoAutorizacionPropietario;
	}
	public void setComboEstadoAutorizacionPropietario(
			String comboEstadoAutorizacionPropietario) {
		this.comboEstadoAutorizacionPropietario = comboEstadoAutorizacionPropietario;
	}
	public Date getFechaAutorizacionPropietario() {
		return fechaAutorizacionPropietario;
	}
	public void setFechaAutorizacionPropietario(Date fechaAutorizacionPropietario) {
		this.fechaAutorizacionPropietario = fechaAutorizacionPropietario;
	}
	public String getGestorAutorizacionPropietario() {
		return gestorAutorizacionPropietario;
	}
	public void setGestorAutorizacionPropietario(
			String gestorAutorizacionPropietario) {
		this.gestorAutorizacionPropietario = gestorAutorizacionPropietario;
	}
	public String getMotivoRechazoAutorizacionPropietario() {
		return motivoRechazoAutorizacionPropietario;
	}
	public void setMotivoRechazoAutorizacionPropietario(
			String motivoRechazoAutorizacionPropietario) {
		this.motivoRechazoAutorizacionPropietario = motivoRechazoAutorizacionPropietario;
	}
	public Date getFechaAnulado() {
		return fechaAnulado;
	}
	public void setFechaAnulado(Date fechaAnulado) {
		this.fechaAnulado = fechaAnulado;
	}
	public String getGestorAnulado() {
		return gestorAnulado;
	}
	public void setGestorAnulado(String gestorAnulado) {
		this.gestorAnulado = gestorAnulado;
	}
	public String getComboMotivoAnulado() {
		return comboMotivoAnulado;
	}
	public void setComboMotivoAnulado(String comboMotivoAnulado) {
		this.comboMotivoAnulado = comboMotivoAnulado;
	}
	public Date getFechaRetenerPago() {
		return fechaRetenerPago;
	}
	public void setFechaRetenerPago(Date fechaRetenerPago) {
		this.fechaRetenerPago = fechaRetenerPago;
	}
	public String getGestorRetenerPago() {
		return gestorRetenerPago;
	}
	public void setGestorRetenerPago(String gestorRetenerPago) {
		this.gestorRetenerPago = gestorRetenerPago;
	}
	public String getComboMotivoRetenerPago() {
		return comboMotivoRetenerPago;
	}
	public void setComboMotivoRetenerPago(String comboMotivoRetenerPago) {
		this.comboMotivoRetenerPago = comboMotivoRetenerPago;
	}
	public Boolean getGestionGastoRepercutido() {
		return gestionGastoRepercutido;
	}
	public void setGestionGastoRepercutido(Boolean gestionGastoRepercutido) {
		this.gestionGastoRepercutido = gestionGastoRepercutido;
	}
	public Date getFechaGestionGastoRepercusion() {
		return fechaGestionGastoRepercusion;
	}
	public void setFechaGestionGastoRepercusion(Date fechaGestionGastoRepercusion) {
		this.fechaGestionGastoRepercusion = fechaGestionGastoRepercusion;
	}
	public String getMotivoRechazoGestionGasto() {
		return motivoRechazoGestionGasto;
	}
	public void setMotivoRechazoGestionGasto(String motivoRechazoGestionGasto) {
		this.motivoRechazoGestionGasto = motivoRechazoGestionGasto;
	}
	public String getGestionGastoClientePagador() {
		return gestionGastoClientePagador;
	}
	public void setGestionGastoClientePagador(String gestionGastoClientePagador) {
		this.gestionGastoClientePagador = gestionGastoClientePagador;
	}
	public Date getFechaEnvioPropietario() {
		return fechaEnvioPropietario;
	}
	public void setFechaEnvioPropietario(Date fechaEnvioPropietario) {
		this.fechaEnvioPropietario = fechaEnvioPropietario;
	}
	public String getGestionGastoClienteInformador() {
		return gestionGastoClienteInformador;
	}
	public void setGestionGastoClienteInformador(String gestionGastoClienteInformador) {
		this.gestionGastoClienteInformador = gestionGastoClienteInformador;
	}
	public Date getFechaEnvioInformativa() {
		return fechaEnvioInformativa;
	}
	public void setFechaEnvioInformativa(Date fechaEnvioInformativa) {
		this.fechaEnvioInformativa = fechaEnvioInformativa;
	}
	
}
