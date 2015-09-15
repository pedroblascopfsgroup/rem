package es.pfsgroup.plugin.recovery.itinerarios.estado.web;

import java.util.List;

import es.capgemini.devon.dto.AbstractDto;
import es.capgemini.pfs.itinerario.model.Estado;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dto.ITIDtoEstado;

public class ITIFormListadoEstados extends AbstractDto{

	private static final long serialVersionUID = 4673499251566705707L;

	private List<ITIDtoEstado> dtoEstados;
	
	private List<Estado> estados;

	public void setDtoEstados(List<ITIDtoEstado> dtoEstados) {
		this.dtoEstados = dtoEstados;
	}

	public List<ITIDtoEstado> getDtoEstados() {
		return dtoEstados;
	}
	
	public List<Estado> getEstados(){
		return estados;
	}
	
	public void setEstados(List<Estado> estados){
		this.estados=estados;
	}
	
}
