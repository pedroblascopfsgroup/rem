package es.pfsgroup.plugin.rem.validate.validator;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoRestringida;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;

@Component
public class AgrupacionValidatorRestringida extends AgrupacionValidatorCommonImpl implements AgrupacionValidator  {

    @Autowired 
    private ActivoAgrupacionApi activoAgrupacionApi;
    
    @Autowired 
    private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
    
    @Autowired 
    private ActivoApi activoApi;
    
    @Autowired
    private OfertaApi ofertaApi;

	@Override
	public String[] getKeys() {
		return this.getCodigoTipoAgrupacion();

	}

	@Override
	public String[] getCodigoTipoAgrupacion() {		
		return new String[]{DDTipoAgrupacion.AGRUPACION_RESTRINGIDA,DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER,DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM};
	}

	// TODO refactorizar este validador, creando validadores independientes hasta que se pueda eliminar 
	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {

		// Validación ofertas agrupación restringida del activo.
		boolean incluidoAgrupacionRestringida = false;
		List<ActivoOferta> ofertasActivo = activo.getOfertas();
		if(!Checks.estaVacio(ofertasActivo)) {
			for(ActivoOferta ofertaActivo : ofertasActivo) {
				if(!Checks.esNulo(ofertaActivo)) {
					if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
							|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
							|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
						incluidoAgrupacionRestringida = true;
						Oferta oferta = ofertaActivo.getPrimaryKey().getOferta();
						if(!Checks.esNulo(oferta.getEstadoOferta())){
							if(ofertaApi.isOfertaAceptadaConExpedienteBlocked(oferta)) {
								return ERROR_OFERTA_AGRUPACION_ACTIVO_ACEPTADA;
							} else if(oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_PENDIENTE)|| oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_ACEPTADA)) {
								ofertaApi.congelarOferta(oferta);
							}
						}
					}
				}
			}
		}

		ActivoAgrupacionActivo primerActivoAgrupacion = activoAgrupacionActivoApi.primerActivoPorActivoAgrupacion(agrupacion.getId());
		if (primerActivoAgrupacion == null) return "";
		Activo primerActivo = primerActivoAgrupacion.getActivo();
		if (primerActivo == null) return "";

		ActivoRestringida restringida = (ActivoRestringida) agrupacion;
		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();
		
		/*if (Checks.esNulo(restringida.getCodigoPostal())) {
			return ERROR_CP_NULL;
		} else if (!restringida.getCodigoPostal().equals(pobl.getCodPostal())) {
			return ERROR_CP_NOT_EQUAL;
		}*/

		if (Checks.esNulo(restringida.getProvincia())) {
			return ERROR_PROV_NULL;
		} else if (!restringida.getProvincia().equals(pobl.getProvincia())) {
			return ERROR_PROV_NOT_EQUAL;
		}
				
		if (Checks.esNulo(restringida.getLocalidad())) {
			return ERROR_LOC_NULL;
		} else if (!restringida.getLocalidad().equals(pobl.getLocalidad())) {
			return ERROR_LOC_NOT_EQUAL;
		}
		
		if (Checks.esNulo(activo.getPropietariosActivo())) {
			return ERROR_PROPIETARIO_NULL;
		} else if(!isValidOwner(activo, primerActivo)) {	
			return ERROR_PROPIETARIO_NOT_EQUAL;
		}	

		
//TODO: Quiza el tipo(Alq/venta) al que hace referencia sea el campo Dpto. Comercial
//		if (Checks.esNulo(activo.getTipoBien())) {
//			return ERROR_TIPO_NULL;
//		} else if (!activo.getTipoBien().equals(primerActivo.getTipoBien())) {
//			return ERROR_TIPO_NOT_EQUAL;
//		}
		
		return "";
	}

	private boolean isValidOwner(Activo activo, Activo primerActivo) {
		List<ActivoPropietarioActivo> list = activo.getPropietariosActivo();
		if (list.size() == 0)return false;
		List<ActivoPropietarioActivo> primList = primerActivo.getPropietariosActivo();
		for (int i = 0; i < list.size(); i++) {
			for (int j = 0; j < primList.size(); j++) {
				if (list.get(i).getPropietario().equals(primList.get(j).getPropietario())) {
					return true;
				}
			}
		}
		return false;
	}

}