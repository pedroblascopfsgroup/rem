package es.pfsgroup.plugin.rem.validate.validator;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
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
    private OfertaApi ofertaApi;

	@Override
	public String[] getKeys() {
		return this.getCodigoTipoAgrupacion();

	}

	@Override
	public String[] getCodigoTipoAgrupacion() {		
		return new String[]{DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL, DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER};
	}

	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {

		// Validación estado venta.
		if(!Checks.esNulo(activo.getSituacionComercial()) && activo.getSituacionComercial().getCodigo().equals(DDSituacionComercial.CODIGO_VENDIDO)
				|| !Checks.esNulo(activo.getFechaVentaExterna())) {
			return ERROR_ACTIVO_VENDIDO;
		}
		
		// Validacion perimetro NO-COMERCIALIZABLE
		if(!Checks.esNulo(activo.getSituacionComercial()) && activo.getSituacionComercial().getCodigo().equals(DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE)) {
			return ERROR_ACTIVO_NO_COMERCIALIZABLE;
		}
		
		// Validación ofertas agrupación restringida del activo.
		boolean incluidoAgrupacionRestringida = false;
		List<ActivoAgrupacionActivo> agrupacionesActivo = activo.getAgrupaciones();
		if(!Checks.estaVacio(agrupacionesActivo)) {
			
			for(ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionesActivo) {
				if(!Checks.esNulo(activoAgrupacionActivo.getAgrupacion()) && !Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion())) {

					if(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
							|| activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER) 
							|| activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
						incluidoAgrupacionRestringida = true;
						List<Oferta> ofertasAgrupacion = activoAgrupacionActivo.getAgrupacion().getOfertas();
						if(!Checks.estaVacio(ofertasAgrupacion)) {
							
							for(Oferta oferta : ofertasAgrupacion) {
								if(!Checks.esNulo(oferta.getEstadoOferta())){

									if(ofertaApi.isOfertaAceptadaConExpedienteBlocked(oferta)) {
										return ERROR_OFERTA_AGRUPACION_ACTIVO_ACEPTADA;
									} else if(oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_PENDIENTE)||oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_ACEPTADA)) {
										ofertaApi.congelarOferta(oferta);
									}
								}
							}
						}
					}
				}
			}
		}

//		boolean tieneOfertasVivas = false;
		if(!incluidoAgrupacionRestringida) {
			// Validación ofertas activo.
			List<ActivoOferta> ofertasActivo = activo.getOfertas();
			if(!Checks.estaVacio(ofertasActivo)) {

				for(ActivoOferta ofertaActivo : ofertasActivo) {
					if(!Checks.esNulo(ofertaActivo.getPrimaryKey()) && !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta()) && !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta())){

//						if (!DDEstadoOferta.CODIGO_RECHAZADA.equals(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta())){
//							tieneOfertasVivas = true;
//						}
						
						if(ofertaApi.isOfertaAceptadaConExpedienteBlocked(ofertaActivo.getPrimaryKey().getOferta())) {
							return ERROR_OFERTA_ACTIVO_EXPED_TRAMITADO;
						} else if(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_PENDIENTE) || ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_ACEPTADA)) {
							ofertaApi.congelarOferta(ofertaActivo.getPrimaryKey().getOferta());
						}
					}
				}
			}
		}

// Aunque el activo tenga ofertas vivas, puede incluirse/excluirse del lote		
//		// Validacion activo con ofertas vivas (No rechazadas)
//		if(tieneOfertasVivas)
//			return ERROR_ACTIVO_CON_OFERTAS_VIVAS;
		
		ActivoAgrupacionActivo primerActivoAgrupacion = activoAgrupacionActivoApi.primerActivoPorActivoAgrupacion(agrupacion.getId());
		if (primerActivoAgrupacion == null) return "";

		Activo primerActivo = primerActivoAgrupacion.getActivo();
		if (primerActivo == null) return "";

//		// Validación Propietario.
//		if (Checks.esNulo(activo.getPropietariosActivo())) {
//			return ERROR_PROPIETARIO_NULL;
//		} else if(!isValidOwner(activo, primerActivo)) {	
//			return ERROR_PROPIETARIO_NOT_EQUAL;
//		}
		
		// Validación cartera.
		if (Checks.esNulo(activo.getCartera())) {
			return ERROR_CARTERA_NULL;
		} else if(!esCarteraValida(activo, primerActivo)) {	
			return ERROR_CARTERA_NOT_EQUAL;
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
	
	private boolean esCarteraValida(Activo activo, Activo primerActivo) {
		if(Checks.esNulo(activo.getCartera()) || Checks.esNulo(primerActivo.getCartera())){
			return false;
		}
		
		String codCarteraNuevoActivo = activo.getCartera().getCodigo();
		String codCarteraPrimerActivoAgr = primerActivo.getCartera().getCodigo();
		
		if(codCarteraNuevoActivo.equals(codCarteraPrimerActivoAgr)) {
			return true;
		} else {
			return false;
		}
	}
}