package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.List;

public class ClienteUrsusRequestDto implements Serializable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int indicadorPaginacion;
	private List<DatosClienteDto> data;

	public int getIndicadorPaginacion() {
		return indicadorPaginacion;
	}
	
	public void setIndicadorPaginacion(int indicadorPaginacion) {
		this.indicadorPaginacion = indicadorPaginacion;
	}
	
	public List<DatosClienteDto> getData() {
		return data;
	}
	
	public void setData(List<DatosClienteDto> data) {
		this.data = data;
	}



	
	
}
