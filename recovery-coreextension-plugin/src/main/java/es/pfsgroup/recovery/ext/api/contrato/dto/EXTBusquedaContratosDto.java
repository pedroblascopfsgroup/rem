package es.pfsgroup.recovery.ext.api.contrato.dto;

import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;

public class EXTBusquedaContratosDto extends BusquedaContratosDto{

	private static final long serialVersionUID = -7674634409225941416L;

	private String codigoEntidadOrigen;
	
	
	/****
	 * Se utiliza para la inclusi�n de contratos en el procedimiento
	 * 
	 * Si el procedimiento es concursal, se pueden incluir todos los contratos
	 * **/
	private boolean esConcursal;

	/**
	 * @param codigoEntidadOrigen the codigoEntidadOrigen to set
	 */
	public void setCodigoEntidadOrigen(String codigoEntidadOrigen) {
		this.codigoEntidadOrigen = codigoEntidadOrigen;
	}

	/**
	 * @return the codigoEntidadOrigen
	 */
	public String getCodigoEntidadOrigen() {
		return codigoEntidadOrigen;
	}

	public void setEsConcursal(boolean esConcursal) {
		this.esConcursal = esConcursal;
	}

	public boolean isEsConcursal() {
		return esConcursal;
	}
}
