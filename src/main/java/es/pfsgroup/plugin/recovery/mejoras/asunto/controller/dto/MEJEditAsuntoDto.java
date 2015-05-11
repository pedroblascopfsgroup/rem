package es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto;

import es.capgemini.pfs.asunto.EditAsuntoDtoInfo;

public class MEJEditAsuntoDto implements EditAsuntoDtoInfo{

	private Long id;
	
	private String nombre;
	
	
	@Override
	public Long getId() {
		return id;
	}

	@Override
	public String getNombre() {
		return nombre;
	}
	
	

}
