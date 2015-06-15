package es.pfsgroup.plugin.recovery.arquetipos.modelos.dto;


import java.text.ParseException;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;

public class ARQDtoBusquedaModelo extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4986205484546272280L;
	
	private String nombre;
	private String descripcion;
	private String listaArquetipos;
	private String estadoModelo;
	private Date fechaInicioVigencia; 
	private Date fechaFinVigencia;
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNombre() {
		return nombre;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setListaArquetipos(String listaArquetipos) {
		this.listaArquetipos = listaArquetipos;
	}
	public String getListaArquetipos() {
		return listaArquetipos;
	}
	public void setEstadoModelo(String estadoModelo) {
		this.estadoModelo = estadoModelo;
	}
	public String getEstadoModelo() {
		return estadoModelo;
	}
	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}
	
	public void setFechaInicioVigencia(String fechaInicioVigencia) throws ParseException {
		if(!Checks.esNulo(fechaInicioVigencia)){
		this.fechaInicioVigencia = DateFormat.toDate(fechaInicioVigencia);
		}
	}
	public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}
	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}
	
	public void setFechaFinVigencia(String fechaFinVigencia) throws ParseException {
		if (!Checks.esNulo(fechaFinVigencia)){
		this.fechaFinVigencia = DateFormat.toDate(fechaFinVigencia);
		}
	}
	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}
}
