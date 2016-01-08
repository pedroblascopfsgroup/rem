package es.pfsgroup.plugin.recovery.arquetipos.modelos.web;

import java.util.List;

import es.capgemini.devon.dto.AbstractDto;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dto.ARQDtoEditarArqsMod;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

public class ARQFormArquetiposModelo extends AbstractDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7226463524180771586L;

	private List<ARQDtoEditarArqsMod> dtoArquetipos;
	
	private List<ARQModeloArquetipo> arquetipos;

	public void setDtoArquetipos(List<ARQDtoEditarArqsMod> dtoArquetipo) {
		this.dtoArquetipos = dtoArquetipo;
	}

	public List<ARQDtoEditarArqsMod> getDtoArquetipos() {
		return dtoArquetipos;
	}

	public void setArquetipos(List<ARQModeloArquetipo> arquetipos) {
		this.arquetipos = arquetipos;
	}

	public List<ARQModeloArquetipo> getArquetipos() {
		return arquetipos;
	}
}
