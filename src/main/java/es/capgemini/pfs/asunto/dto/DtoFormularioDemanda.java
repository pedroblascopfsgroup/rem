package es.capgemini.pfs.asunto.dto;

import java.io.Serializable;

/**
 * DTO para el reporte del formulario de demanda judicial.
 * @author marruiz
 */
public class DtoFormularioDemanda implements Serializable {

	private static final long serialVersionUID = -9122379785889206927L;

	private String idProcedimiento;
	private String nombreAbogado;
	private String montoPrincipal;
	private String nombresDemandados;
	private String nombresDomiciliosDemandados;
	private String listaFincas;
	private String fecha;


	/**
	 * @return the idProcedimiento
	 */
	public String getIdProcedimiento() {
		return idProcedimiento;
	}
	/**
	 * @param idProcedimiento the idProcedimiento to set
	 */
	public void setIdProcedimiento(String idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	/**
	 * @return the nombreAbogado
	 */
	public String getNombreAbogado() {
		return nombreAbogado;
	}
	/**
	 * @param nombreAbogado the nombreAbogado to set
	 */
	public void setNombreAbogado(String nombreAbogado) {
		this.nombreAbogado = nombreAbogado;
	}
	/**
	 * @return the montoPrincipal
	 */
	public String getMontoPrincipal() {
		return montoPrincipal;
	}
	/**
	 * @param montoPrincipal the montoPrincipal to set
	 */
	public void setMontoPrincipal(String montoPrincipal) {
		this.montoPrincipal = montoPrincipal;
	}
	/**
	 * @return the nombresDemandados
	 */
	public String getNombresDemandados() {
		return nombresDemandados;
	}
	/**
	 * @param nombresDemandados the nombresDemandados to set
	 */
	public void setNombresDemandados(String nombresDemandados) {
		this.nombresDemandados = nombresDemandados;
	}
	/**
	 * @return the nombresDomiciliosDemandados
	 */
	public String getNombresDomiciliosDemandados() {
		return nombresDomiciliosDemandados;
	}
	/**
	 * @param nombresDomiciliosDemandados the nombresDomiciliosDemandados to set
	 */
	public void setNombresDomiciliosDemandados(String nombresDomiciliosDemandados) {
		this.nombresDomiciliosDemandados = nombresDomiciliosDemandados;
	}
	/**
	 * @return the listaFincas
	 */
	public String getListaFincas() {
		return listaFincas;
	}
	/**
	 * @param listaFincas the listaFincas to set
	 */
	public void setListaFincas(String listaFincas) {
		this.listaFincas = listaFincas;
	}
	/**
	 * @return the fecha
	 */
	public String getFecha() {
		return fecha;
	}
	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
}
