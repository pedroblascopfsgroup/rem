package es.pfsgroup.concursal.convenio.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;

public class DtoConvenioCreditos extends WebDto{
	
	private static final long serialVersionUID = -8258912402911081503L;
	
	private Convenio convenio;
	
	private List<ConvenioCredito> convenioCreditos;

	public void setConvenio(Convenio convenio) {
		this.convenio = convenio;
	}

	public Convenio getConvenio() {
		return convenio;
	}

	public void setConvenioCreditos(List<ConvenioCredito> convenioCreditos) {
		this.convenioCreditos = convenioCreditos;
	}

	public List<ConvenioCredito> getConvenioCreditos() {
		return convenioCreditos;
	}




}
