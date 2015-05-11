package es.pfsgroup.recovery.recobroConfig.metasVolantes.web;

import java.util.List;

import es.capgemini.devon.dto.AbstractDto;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoMetaVolante;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroMetaVolante;

public class RecobroFormMetasVolantesItinerarios extends AbstractDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2200865361615805006L;
	
	private List<RecobroMetaVolante> listaMetas;
	private List<RecobroDtoMetaVolante> listaDtoMetas;
	
	public List<RecobroMetaVolante> getListaMetas() {
		return listaMetas;
	}
	public void setListaMetas(List<RecobroMetaVolante> listaMetas) {
		this.listaMetas = listaMetas;
	}
	public List<RecobroDtoMetaVolante> getListaDtoMetas() {
		return listaDtoMetas;
	}
	public void setListaDtoMetas(List<RecobroDtoMetaVolante> listaDtoMetas) {
		this.listaDtoMetas = listaDtoMetas;
	}
	
	

}
