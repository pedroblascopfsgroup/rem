package es.pfsgroup.concursal.convenio.dto;

import java.util.List;


import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.concursal.convenio.model.Convenio;

public class DtoConvenio extends WebDto{
	
	private static final long serialVersionUID = -3746399692512887715L;

	private String numeroAuto;
	private long idProcedimientoGenerador;
	
	private List<Convenio> convenios;
	
	public List<Convenio> getConvenios() {
		return convenios;
	}

	public void setConvenios(List<Convenio> convenios) {
		this.convenios = convenios;
	}
	
	public String getNumeroAuto() {
		return numeroAuto;
	}

	public void setNumeroAuto(String numeroAuto) {
		this.numeroAuto = numeroAuto;
	}

	public void setIdProcedimientoGenerador(Long long1) {
		this.idProcedimientoGenerador = long1;
	}

	public long getIdProcedimientoGenerador() {
		return idProcedimientoGenerador;
	}

}
