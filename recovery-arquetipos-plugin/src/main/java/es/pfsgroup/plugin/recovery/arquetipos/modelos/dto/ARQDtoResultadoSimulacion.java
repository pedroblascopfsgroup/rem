package es.pfsgroup.plugin.recovery.arquetipos.modelos.dto;

import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;

public class ARQDtoResultadoSimulacion {
	
	private ARQListaArquetipo arquetipo;
	private Long totalClientes;
	
	public ARQListaArquetipo getArquetipo() {
		return arquetipo;
	}
	public void setArquetipo(ARQListaArquetipo arquetipo) {
		this.arquetipo = arquetipo;
	}
	public Long getTotalClientes() {
		return totalClientes;
	}
	public void setTotalClientes(Long totalClientes) {
		this.totalClientes = totalClientes;
	}

}
