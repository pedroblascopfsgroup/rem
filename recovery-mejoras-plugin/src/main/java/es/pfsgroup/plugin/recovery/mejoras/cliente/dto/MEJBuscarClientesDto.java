package es.pfsgroup.plugin.recovery.mejoras.cliente.dto;

import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;

public class MEJBuscarClientesDto extends DtoBuscarClientes{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String concurso;
	private Boolean filtroClientesCarterizados;
	private String codigoColectivoSingular;
	private String propietario;
	private String nominaPension;
	private String apellidos;
    private Boolean miCartera;
    private String origen;

	public String getConcurso() {
		return concurso;
	}

	public void setConcurso(String concurso) {
		this.concurso = concurso;
	}

	public Boolean getFiltroClientesCarterizados() {
		return filtroClientesCarterizados;
	}

	public void setFiltroClientesCarterizados(Boolean filtroClientesCarterizados) {
		this.filtroClientesCarterizados = filtroClientesCarterizados;
	}

	public String getCodigoColectivoSingular() {
		return codigoColectivoSingular;
	}

	public void setCodigoColectivoSingular(String codigoColectivoSingular) {
		this.codigoColectivoSingular = codigoColectivoSingular;
	}

	public String getPropietario() {
		return propietario;
	}

	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getNominaPension() {
		return nominaPension;
	}

	public void setNominaPension(String nominaPension) {
		this.nominaPension = nominaPension;
	}

	public String getApellidos() {
		return apellidos;
	}

	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	public Boolean getMiCartera() {
		return miCartera;
	}

	public void setMiCartera(Boolean miCartera) {
		this.miCartera = miCartera;
	}

	public String getOrigen() {
		return origen;
	}

	public void setOrigen(String origen) {
		this.origen = origen;
	}

	
}
