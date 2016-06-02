package es.capgemini.pfs.direccion.dto;

import java.util.HashSet;
import java.util.Set;

import es.pfsgroup.commons.utils.Checks;

public class DireccionAltaDto {

	private String provincia;
	private String codigoPostal;
	private String localidad;
	private String municipio;
	private String tipoVia;
	private String domicilio;
	private String numero;
	private String portal;
	private String piso;
	private String escalera;
	private String puerta;
	private String origen;
	private String listaIdPersonas;
	private String listaIdPersonasManuales;

	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getLocalidad() {
		return localidad;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getTipoVia() {
		return tipoVia;
	}
	public void setTipoVia(String tipoVia) {
		this.tipoVia = tipoVia;
	}
	public String getDomicilio() {
		return domicilio;
	}
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getPortal() {
		return portal;
	}
	public void setPortal(String portal) {
		this.portal = portal;
	}
	public String getPiso() {
		return piso;
	}
	public void setPiso(String piso) {
		this.piso = piso;
	}
	public String getEscalera() {
		return escalera;
	}
	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}
	public String getPuerta() {
		return puerta;
	}
	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public String getListaIdPersonas() {
		return listaIdPersonas;
	}
	public void setListaIdPersonas(String listaIdPersonas) {
		this.listaIdPersonas = listaIdPersonas;
	}
	public String getListaIdPersonasManuales() {
		return listaIdPersonasManuales;
	}
	public void setListaIdPersonasManuales(String listaIdPersonasManuales) {
		this.listaIdPersonasManuales = listaIdPersonasManuales;
	}
	
	public Set<Long> getSetIdPersonas() {
		
		Set<Long> setIdPersonas = new HashSet<Long>();
		if(!Checks.esNulo(this.listaIdPersonas)){
			String[] arrayIdsPers = this.listaIdPersonas.split(",");
			for (String idPers : arrayIdsPers) {
				String strId = idPers.trim();
				if (!strId.equals("")) {
					try {
						Long id = Long.parseLong(strId);
						setIdPersonas.add(id);
					} catch (NumberFormatException e) {}
				}
			}	
		}

		return setIdPersonas;
	}
	
	public Set<Long> getSetIdPersonasManuales() {
		
		Set<Long> setIdPersonasManuales = new HashSet<Long>();
		if(!Checks.esNulo(this.listaIdPersonasManuales)){
			String[] arrayIdsPers = this.listaIdPersonasManuales.split(",");
			for (String idPers : arrayIdsPers) {
				String strId = idPers.trim();
				if (!strId.equals("")) {
					try {
						Long id = Long.parseLong(strId);
						setIdPersonasManuales.add(id);
					} catch (NumberFormatException e) {}
				}
			}
		}

		return setIdPersonasManuales;
	}
	
}
