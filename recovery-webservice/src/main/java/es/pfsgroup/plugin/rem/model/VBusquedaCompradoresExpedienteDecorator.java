package es.pfsgroup.plugin.rem.model;

import org.apache.commons.beanutils.BeanUtils;

public class VBusquedaCompradoresExpedienteDecorator extends VBusquedaCompradoresExpediente{
	
	public static VBusquedaCompradoresExpedienteDecorator  buildFrom(Object[] item) throws VBusquedaCompradoresExpedienteDecoratorException {
		try {
			VBusquedaCompradoresExpedienteDecorator decorador= new VBusquedaCompradoresExpedienteDecorator();
			VBusquedaCompradoresExpediente bce= (VBusquedaCompradoresExpediente) item[0];
			VBusquedaDatosCompradorExpediente bdc = (VBusquedaDatosCompradorExpediente) item[1];
			BeanUtils.copyProperties(decorador, bce);
			decorador.setNumeroClienteUrsus(bdc.getNumeroClienteUrsus());
			
			return decorador;
		} catch (Throwable e) {
			throw new VBusquedaCompradoresExpedienteDecoratorException(e);
		}
	}
	
	private Long numeroClienteUrsus;

	public Long getNumeroClienteUrsus() {
		return numeroClienteUrsus;
	}

	public void setNumeroClienteUrsus(Long numeroClienteUrsus) {
		this.numeroClienteUrsus = numeroClienteUrsus;
	}
	
	

}
