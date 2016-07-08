package es.pfsgroup.plugin.rem.model;

import java.util.Date;


/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoCarga {

	private static final long serialVersionUID = 0L;

	private Long id;
	private String importeEconomico;
	private String importeRegistral;
	private String titular;
	private String estadoDescripcion;
	private String estadoEconomicaDescripcion;
	private String tipoCargaDescripcion;
	private String subtipoCargaDescripcion;
	private Date fechaCancelacion;
	
	public String getImporteEconomico() {
		return importeEconomico;
	}
	public void setImporteEconomico(String importeEconomico) {
		this.importeEconomico = importeEconomico;
	}
	public String getImporteRegistral() {
		return importeRegistral;
	}
	public void setImporteRegistral(String importeRegistral) {
		this.importeRegistral = importeRegistral;
	}
	public String getTitular() {
		return titular;
	}
	public void setTitular(String titular) {
		this.titular = titular;
	}
	public String getEstadoDescripcion() {
		return estadoDescripcion;
	}
	public void setEstadoDescripcion(String estadoDescripcion) {
		this.estadoDescripcion = estadoDescripcion;
	}
	public String getEstadoEconomicaDescripcion() {
		return estadoEconomicaDescripcion;
	}
	public void setEstadoEconomicaDescripcion(String estadoEconomicaDescripcion) {
		this.estadoEconomicaDescripcion = estadoEconomicaDescripcion;
	}
	public String getTipoCargaDescripcion() {
		return tipoCargaDescripcion;
	}
	public void setTipoCargaDescripcion(String tipoCargaDescripcion) {
		this.tipoCargaDescripcion = tipoCargaDescripcion;
	}
	public String getSubtipoCargaDescripcion() {
		return subtipoCargaDescripcion;
	}
	public void setSubtipoCargaDescripcion(String subtipoCargaDescripcion) {
		this.subtipoCargaDescripcion = subtipoCargaDescripcion;
	}
	public Date getFechaCancelacion() {
		return fechaCancelacion;
	}
	public void setFechaCancelacion(Date fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
}