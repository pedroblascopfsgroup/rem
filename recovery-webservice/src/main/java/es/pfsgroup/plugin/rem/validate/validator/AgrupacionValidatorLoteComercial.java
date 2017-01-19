package es.pfsgroup.plugin.rem.validate.validator;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;

@Component
public class AgrupacionValidatorLoteComercial extends AgrupacionValidatorCommonImpl implements AgrupacionValidator  {

    @Autowired 
    private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;

    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private OfertaApi ofertaApi;

	@Override
	public String[] getKeys() {
		return this.getCodigoTipoAgrupacion();

	}

	@Override
	public String[] getCodigoTipoAgrupacion() {		
		return new String[]{DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL};
	}

	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {

		// Validación estado venta.
		if(!Checks.esNulo(activo.getSituacionComercial()) && activo.getSituacionComercial().getCodigo().equals(DDSituacionComercial.CODIGO_VENDIDO)) {
			return ERROR_ACTIVO_VENDIDO;
		}

		// Validación ofertas agrupación restringida del activo.
		boolean incluidoAgrupacionRestringida = false;
		List<ActivoAgrupacionActivo> agrupacionesActivo = activo.getAgrupaciones();
		if(!Checks.estaVacio(agrupacionesActivo)) {
			
			for(ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionesActivo) {
				if(!Checks.esNulo(activoAgrupacionActivo.getAgrupacion()) && !Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion())) {

					if(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
						incluidoAgrupacionRestringida = true;
						List<Oferta> ofertasAgrupacion = activoAgrupacionActivo.getAgrupacion().getOfertas();
						if(!Checks.estaVacio(ofertasAgrupacion)) {
							
							for(Oferta oferta : ofertasAgrupacion) {
								if(!Checks.esNulo(oferta.getEstadoOferta())){

									if(ofertaApi.isOfertaAceptadaConExpedienteBlocked(oferta)) {
										return ERROR_OFERTA_AGRUPACION_ACTIVO_ACEPTADA;
									} else if(oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_PENDIENTE)) {
										DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_CONGELADA);
										oferta.setEstadoOferta(estadoOferta);
									}
								}
							}
						}
					}
				}
			}
		}

		if(!incluidoAgrupacionRestringida) {
			// Validación ofertas activo.
			List<ActivoOferta> ofertasActivo = activo.getOfertas();
			if(!Checks.estaVacio(ofertasActivo)) {

				for(ActivoOferta ofertaActivo : ofertasActivo) {
					if(!Checks.esNulo(ofertaActivo.getPrimaryKey()) && !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta()) && !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta())){

						if(ofertaApi.isOfertaAceptadaConExpedienteBlocked(ofertaActivo.getPrimaryKey().getOferta())) {
							return ERROR_OFERTA_ACTIVO_ACEPTADA;
						} else if(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_PENDIENTE)) {
							DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_CONGELADA);
							ofertaActivo.getPrimaryKey().getOferta().setEstadoOferta(estadoOferta);
						}
					}
				}
			}
		}

		ActivoAgrupacionActivo primerActivoAgrupacion = activoAgrupacionActivoApi.primerActivoPorActivoAgrupacion(agrupacion.getId());
		if (primerActivoAgrupacion == null) return "";

		Activo primerActivo = primerActivoAgrupacion.getActivo();
		if (primerActivo == null) return "";

		// Validación Propietario.
		if (Checks.esNulo(activo.getPropietariosActivo())) {
			return ERROR_PROPIETARIO_NULL;
		} else if(!isValidOwner(activo, primerActivo)) {	
			return ERROR_PROPIETARIO_NOT_EQUAL;
		}

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