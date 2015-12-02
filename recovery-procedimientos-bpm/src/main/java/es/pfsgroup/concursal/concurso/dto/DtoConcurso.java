package es.pfsgroup.concursal.concurso.dto;

import java.util.ArrayList;
import java.util.List;


import es.capgemini.devon.dto.WebDto;

public class DtoConcurso extends WebDto{
	

	private static final long serialVersionUID = -3746399692512887715L;

	private String numeroAuto;
	
	private List<DtoContratoConcurso> contratos;
	
	public DtoConcurso() {
		super();
		contratos = new ArrayList<DtoContratoConcurso>();
	}

	public String getNumeroAuto() {
		return numeroAuto;
	}

	public void setNumeroAuto(String numeroAuto) {
		this.numeroAuto = numeroAuto;
	}

	public List<DtoContratoConcurso> getContratos() {
		return contratos;
	}

	public void setContratos(List<DtoContratoConcurso> contratos) {
		this.contratos = contratos;
	}

}
