package es.pfsgroup.plugin.rem.validators;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;

@Component
public class VisibilidadGestionComercialValidator {

	private static final String Ecoarenys = "B63442974";
	private static final String JaleProcam = "B11819935";
	private static final String PromocionesMiesdelValle = "B39488549";

	public static final String VALID_ACTIVO_VENDIDO_RESERVADO_FIRMADO = "Activo con oferta reservada, firmada o vendida";
	public static final String VALID_ACTIVO_VENTA_EXTERNA = "Activo vendido de forma externa";
	public static final String VALID_ACTIVO_ESTADO_PUBLICACION = "Activo cuyo estado de publicación no permite la inclusión en perímetro";
	public static final String VALID_ACTIVO_NO_COMERCIALIZABLE = "Activo no comercializable";
	public static final String VALID_ACTIVO_NO_VPO = "Activo tiene indicado que pertenece a una VPO";
	public static final String VALID_ACTIVO_PROPIETARIO_SOCIEDAD = "Propietario con sociedad participada";
	public static final String VALID_ACTIVO_DESTINO_COMERCIAL = "Activo cuyo destino comercial no permite la inclusión en perímetro";
	public static final String VALID_ACTIVO_CON_CARGAS = "Activo con cargas";
	public static final String VALID_ACTIVO_ALQUILER_SOCIAL = "Activo incluido en perímetro de alquiler social";
	public static final String VALID_ACTIVO_OFERTAS_PENDIENTES = "Activo con ofertas pendientes";
	public static final String VALID_ACTIVO_GESTION = "Activo cuyo estado de publicación no permite la edición de Visibilidad Gestion Comercial";
	public static final String VALID_MOTIVO_EXCLUIDO= "Activo con Agrupación restringida no puede tener Motivo de excluido ";
	public static final String VALID_SUBFASE_PUBLICACION= "La subfase de publicación del activo no permite la modificación del check Visibilidad Gestion Comercial ";
	public static final String VALID_DESMARCAR_SIN_ERRORES= "Se cumplen todas las condiciones para que estén marcados.";
	public static final String VALID_ACTIVO_TIPO_COMERCIALIZACION = "Activo no tiene tipo de comercialización";
	public static final String VALID_FASE_PUBLICACION= "La fase de publicación del activo no permite la modificación del check Visibilidad Gestion Comercial ";

	public static final String[] SOCIEDADES_PARTICIPADAS = {Ecoarenys, JaleProcam, PromocionesMiesdelValle};
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoPublicacionDao activoPublicacionDao;
	
	@Autowired
	private ActivoCargasApi activoCargasApi;

	public Map<Long, List<String>> validarPerimetroActivo(Activo activo, Boolean dtoCheckGestorComercial, Boolean dtoExcluirValidaciones,boolean fichaActivo) {
		return getErrores(new Activo[] { activo }, dtoCheckGestorComercial, dtoExcluirValidaciones, null, fichaActivo);
	}

	public Map<Long, List<String>> validarPerimetroActivos(Activo[] activos, DDEstadosExpedienteComercial nuevoEstadoExpediente) {
		return getErrores(activos, null, false, nuevoEstadoExpediente, false);
	}
	
	public Map<Long, List<String>> validarPerimetroActivosOferta(Oferta oferta) {
		List<ActivoOferta> activosOferta = oferta.getActivosOferta();
		Activo[] activos = new Activo[oferta.getActivosOferta().size()];
		
		for (int i = 0; i< activosOferta.size(); i++) {
			activos[i] = activosOferta.get(i).getPrimaryKey().getActivo();
		}
		return getErrores(activos, null, null, null, false);
	}

	private Map<Long, List<String>> getErrores(Activo[] activos, Boolean dtoCheckGestorComercial, Boolean dtoExcluirValidaciones, DDEstadosExpedienteComercial nuevoEstadoExpediente, boolean ficha) {

		Map<Long, List<String>> mapaErrores = new HashMap<Long, List<String>>();

		for (Activo activoActual : activos) {
			List<String> erroresActivo = new ArrayList<String>();

			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoActual.getId());
			PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroIdActivo);
			
			boolean modificadoEnFicha = true;
			if(dtoCheckGestorComercial == null) {
				modificadoEnFicha = false;
			}
			Boolean checkGestorComercial = dtoCheckGestorComercial != null ? dtoCheckGestorComercial
					: perimetroActivo.getCheckGestorComercial() != null && perimetroActivo.getCheckGestorComercial() == true; // Comparo con True para tomar null como false
			Boolean excluirValidaciones = dtoExcluirValidaciones != null ? dtoExcluirValidaciones
					: perimetroActivo.getExcluirValidaciones() != null && DDSinSiNo.CODIGO_SI.equals(perimetroActivo.getExcluirValidaciones().getCodigo());
			
			
			List<ActivoOferta> listaActivoOferta = activoActual.getOfertas();
			if (!excluirValidaciones) {
				erroresActivo = this.erroresJerarquicosParaMarcar(activoActual, nuevoEstadoExpediente, listaActivoOferta);
				this.erroresParaDesMarcar(erroresActivo, activoActual.getId(), checkGestorComercial, ficha, modificadoEnFicha);
			}
			
			mapaErrores.put(activoActual.getNumActivo(), erroresActivo);
		}

		return mapaErrores;
	}

	private List<String> erroresJerarquicosParaMarcar(Activo activoActual, DDEstadosExpedienteComercial nuevoEstadoExpediente, List<ActivoOferta> listaActivoOferta){
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoActual.getId());
		ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class, filtroIdActivo);
		PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroIdActivo);
		ActivoPropietarioActivo activoPropietario = genericDao.get(ActivoPropietarioActivo.class, filtroIdActivo);
		
		List<String> erroresActivo = new ArrayList<String>();

		if(activoPublicacion != null) {
			if(DDCartera.isCarteraSareb(activoActual.getCartera())) {
				if (perimetroActivo != null && perimetroActivo.getAplicaComercializar() != null && perimetroActivo.getAplicaComercializar() == 0) {
					erroresActivo.add(VALID_ACTIVO_NO_COMERCIALIZABLE);
				}
			}else if(activoPublicacion.getTipoComercializacion() == null) {
				erroresActivo.add(VALID_ACTIVO_TIPO_COMERCIALIZACION);
			}else if(DDTipoComercializacion.isDestinoComercialSoloAlquiler(activoPublicacion.getTipoComercializacion())){
				if(!DDEstadoPublicacionAlquiler.isPublicadoAlquiler(activoPublicacion.getEstadoPublicacionAlquiler())) {
					erroresActivo.add(VALID_ACTIVO_ESTADO_PUBLICACION);
				}
			}else if((DDTipoComercializacion.isDestinoComercialVenta(activoPublicacion.getTipoComercializacion()) && !DDEstadoPublicacionVenta.isPublicadoVenta(activoPublicacion.getEstadoPublicacionVenta()))
			|| (DDTipoComercializacion.isDestinoComercialAlquilerVenta(activoPublicacion.getTipoComercializacion()) 
				&& !DDEstadoPublicacionVenta.isPublicadoVenta(activoPublicacion.getEstadoPublicacionVenta()) && !DDEstadoPublicacionAlquiler.isPublicadoAlquiler(activoPublicacion.getEstadoPublicacionAlquiler()))) {
				if(DDCartera.isCarteraBk(activoActual.getCartera())) {
					erroresActivo.add(VALID_ACTIVO_ESTADO_PUBLICACION);
				}else if(DDCartera.isCarteraCajamar(activoActual.getCartera())) {
					if(DDTipoComercializacion.isDestinoComercialSoloAlquiler(activoPublicacion.getTipoComercializacion())) {
						if(activoActual.getVpo() == 1) {
							erroresActivo.add(VALID_ACTIVO_NO_VPO);	
						}
					}
				}else if(DDCartera.isCarteraBBVA(activoActual.getCartera())) {
					if(activoPropietario != null && activoPropietario.getPropietario() !=null && Arrays.asList(SOCIEDADES_PARTICIPADAS).contains(activoPropietario.getPropietario().getDocIdentificativo())){
						erroresActivo.add(VALID_ACTIVO_PROPIETARIO_SOCIEDAD);
					}
				}		
				
				if (activoActual.getFechaVentaExterna() != null && activoActual.getFechaVentaExterna() != null) {
					erroresActivo.add(VALID_ACTIVO_VENTA_EXTERNA);
				}
				if (perimetroActivo != null && perimetroActivo.getAplicaComercializar() != null && perimetroActivo.getAplicaComercializar() == 0) {
					erroresActivo.add(VALID_ACTIVO_NO_COMERCIALIZABLE);
				}
				if (DDTipoAlquiler.isAlquilerFondoSocial(activoActual.getTipoAlquiler())) {
					erroresActivo.add(VALID_ACTIVO_ALQUILER_SOCIAL);
				}
				
				HistoricoFasePublicacionActivo fasePublicacionActivoVigente = activoPublicacionDao.getFasePublicacionVigentePorIdActivo(activoActual.getId());
				
				if(fasePublicacionActivoVigente != null) {
					if(DDSubfasePublicacion.isHistoricoFasesExcPubEstrategiaCl(fasePublicacionActivoVigente.getSubFasePublicacion()) 
					|| DDSubfasePublicacion.isHistoricoFasesReqLegAdm(fasePublicacionActivoVigente.getSubFasePublicacion()) 
					|| DDSubfasePublicacion.isHistoricoFasesSinValor(fasePublicacionActivoVigente.getSubFasePublicacion())) {
						erroresActivo.add(VALID_SUBFASE_PUBLICACION);
					}else if(DDCartera.isCarteraCerberus(activoActual.getCartera()) && DDSubfasePublicacion.isHistoricoFasesGestionApi(fasePublicacionActivoVigente.getSubFasePublicacion())) {
						erroresActivo.add(VALID_SUBFASE_PUBLICACION);
					}
				
					if(DDCartera.isCarteraCerberus(activoActual.getCartera()) && DDFasePublicacion.isFaseTres(fasePublicacionActivoVigente.getFasePublicacion())) {
						erroresActivo.add(VALID_FASE_PUBLICACION);
					}
				}
				
				String[] estadosExpedienteNoValidos = {DDEstadosExpedienteComercial.FIRMADO, DDEstadosExpedienteComercial.RESERVADO, DDEstadosExpedienteComercial.VENDIDO};
				boolean falloExpediente = false;
				if(nuevoEstadoExpediente != null && Arrays.asList(estadosExpedienteNoValidos).contains(nuevoEstadoExpediente.getCodigo())) {
					erroresActivo.add(VALID_ACTIVO_VENDIDO_RESERVADO_FIRMADO);
					falloExpediente = true;
				}
				
				if(!falloExpediente) {
					for (ActivoOferta actOfr : listaActivoOferta) {
						Oferta oferta = actOfr.getPrimaryKey().getOferta();
						if (!Checks.esNulo(oferta)) {
							
							Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
							ExpedienteComercial expedienteBuscado = genericDao.get(ExpedienteComercial.class, filtroExpediente);
	
							if (expedienteBuscado != null && expedienteBuscado.getEstado() != null && 
							Arrays.asList(estadosExpedienteNoValidos).contains(expedienteBuscado.getEstado().getCodigo())) {
								erroresActivo.add(VALID_ACTIVO_VENDIDO_RESERVADO_FIRMADO);
								break;
							}
						}
					}
				}	
			}
		}else {
			erroresActivo.add(VALID_ACTIVO_ESTADO_PUBLICACION);
		}
		
		return erroresActivo;
	}
	
	private void erroresParaDesMarcar(List<String> erroresActivo,Long idActivo, boolean checkGestorComercial, boolean ficha, boolean checkModificadoEnFicha){
	
		//Condiciones para desmarcar
		if(!checkGestorComercial && ficha) {
			if(erroresActivo.isEmpty()) {
				erroresActivo.add(VALID_DESMARCAR_SIN_ERRORES);
			}else {
				erroresActivo.clear();
			}
			if(checkModificadoEnFicha) {
				List<Oferta> ofertasTramitadas = ofertaApi.getListOtrasOfertasTramitadasActivo(idActivo);
				if(ofertasTramitadas != null && !ofertasTramitadas.isEmpty()) {
					erroresActivo.add(VALID_ACTIVO_OFERTAS_PENDIENTES);
				}
			}
		}
	}
}