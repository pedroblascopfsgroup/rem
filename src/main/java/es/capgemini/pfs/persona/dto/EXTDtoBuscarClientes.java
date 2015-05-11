package es.capgemini.pfs.persona.dto;

import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;

public class EXTDtoBuscarClientes  extends DtoBuscarClientes{


	private static final long serialVersionUID = 967841480891964539L;
	
	private String filtroSolvenciaRevisada;

	public EXTDtoBuscarClientes(){
		super();
	}
	public void setFiltroSolvenciaRevisada(String filtroSolvenciaRevisada) {
		this.filtroSolvenciaRevisada = filtroSolvenciaRevisada;
	}

	public String getFiltroSolvenciaRevisada() {
		return filtroSolvenciaRevisada;
	}

}
