package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.validate.ActivoPublicacionValidatorApi;

@Component
public class ActivoPublicacionValidator implements ActivoPublicacionValidatorApi {

	@Autowired
    private ActivoApi activoApi;
    
	private Activo activo;
	
	private boolean validarOKGestion;
	private boolean validarOKAdmision;
	private boolean validarOKPrecio;
	private boolean validarInfComercialTiposIguales;
	private boolean validarInfComercialAceptado;

	@Override
	public ActivoPublicacionValidator initPublicacionValidator(Activo activo) {
		this.activo = activo;
		this.validarOKGestion = true;
		this.validarOKAdmision = true;
		this.validarOKPrecio = true;
		this.validarInfComercialTiposIguales = true;
		this.validarInfComercialAceptado = true;
		
		return this;
	}
	
	@Override
	public ActivoPublicacionValidator initPublicacionValidator(Activo activo, 
			boolean validarOKGestion,
			boolean validarOKAdmision,
			boolean validarOKPrecio,
			boolean validarInfComercialTiposIguales,
			boolean validarInfComercialAceptado){
		
		this.activo = activo;
		this.validarOKGestion = true;
		this.validarOKAdmision = true;
		this.validarOKPrecio = true;
		this.validarInfComercialTiposIguales = true;
		this.validarInfComercialAceptado = true;
		
		return this;
	}
	
	@Override
	public boolean cumpleValidaciones() {
		return ejecutaValidaciones();
	}

	
	private boolean tieneOkAdmision(){
		return activo.getAdmision(); // Tiene OK de admision
	}
	
	private boolean tieneOkGestion(){
		return activo.getGestion(); // Tiene OK de gestion
	}
	
	private boolean tieneOkPrecios(){
		return activoApi.getDptoPrecio(activo); // Tiene OK de precios
	}
	
	private boolean tieneInfComercialTiposIguales(){
		return !activoApi.checkTiposDistintos(activo); // Tipos activo Inf. comercial iguales
	}
	
	private boolean tieneInfComercialAceptado(){
		return activoApi.isInformeComercialAceptado(activo); // Tiene Inf. comercial aceptado
	}
	
	private boolean ejecutaValidaciones(){
		return 
				(validarOKGestion ? tieneOkGestion() : true) &&
				(validarOKAdmision ? tieneOkAdmision() : true) &&
				(validarOKPrecio ? tieneOkPrecios() : true) &&
				(validarInfComercialTiposIguales ? tieneInfComercialTiposIguales() : true) &&
				(validarInfComercialAceptado ? tieneInfComercialAceptado() : true);
	}

}
