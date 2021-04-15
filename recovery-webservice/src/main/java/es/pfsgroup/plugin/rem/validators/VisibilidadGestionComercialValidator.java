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
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
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

	public static final String[] SOCIEDADES_PARTICIPADAS = {Ecoarenys, JaleProcam, PromocionesMiesdelValle};
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoPublicacionDao activoPublicacionDao;

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

			ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class, filtroIdActivo);
			PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroIdActivo);
			ActivoPropietarioActivo activoPropietario = genericDao.get(ActivoPropietarioActivo.class, filtroIdActivo);
			
		
			HistoricoFasePublicacionActivo fasePublicacionActivoVigente = activoPublicacionDao.getFasePublicacionVigentePorIdActivo(activoActual.getId());
			

			Boolean checkGestorComercial = dtoCheckGestorComercial != null ? dtoCheckGestorComercial
					: perimetroActivo.getCheckGestorComercial() != null && perimetroActivo.getCheckGestorComercial() == true; // Comparo con True para tomar null como false
			Boolean excluirValidaciones = dtoExcluirValidaciones != null ? dtoExcluirValidaciones
					: perimetroActivo.getExcluirValidaciones() != null && DDSinSiNo.CODIGO_SI.equals(perimetroActivo.getExcluirValidaciones().getCodigo());
			
			List<ActivoOferta> listaActivoOferta = activoActual.getOfertas();
			
			if (!excluirValidaciones) {
				
				

				
				for (ActivoOferta actOfr : listaActivoOferta) {
					Oferta oferta = actOfr.getPrimaryKey().getOferta();
					if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta())) {

						if(nuevoEstadoExpediente != null && (DDEstadosExpedienteComercial.FIRMADO.equals(nuevoEstadoExpediente.getCodigo())
							|| DDEstadosExpedienteComercial.VENDIDO.equals(nuevoEstadoExpediente.getCodigo())
							|| DDEstadosExpedienteComercial.RESERVADO.equals(nuevoEstadoExpediente.getCodigo()))) {
							erroresActivo.add(VALID_ACTIVO_VENDIDO_RESERVADO_FIRMADO);
							break;
						}
						
						Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
						ExpedienteComercial expedienteBuscado = genericDao.get(ExpedienteComercial.class, filtroExpediente);

						if (expedienteBuscado != null && expedienteBuscado.getEstado() != null && 
							(DDEstadosExpedienteComercial.FIRMADO.equals(expedienteBuscado.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.VENDIDO.equals(expedienteBuscado.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.RESERVADO.equals(expedienteBuscado.getEstado().getCodigo()))) {
							erroresActivo.add(VALID_ACTIVO_VENDIDO_RESERVADO_FIRMADO);
							break;
						}
					}
				}

				// Validación que comprueba si el activo se ha vendido de forma externa.
				if (activoActual.getFechaVentaExterna() != null && activoActual.getFechaVentaExterna() != null) {
					erroresActivo.add(VALID_ACTIVO_VENTA_EXTERNA);
				}

				// Validación que comprueba si su estado de publicación es compatible con la inclusión en perímetro
				if(activoPublicacion != null) {	
					if(DDCartera.isCarteraCajamar(activoActual.getCartera())){
						if(DDTipoComercializacion.isDestinoComercialSoloAlquiler(activoPublicacion.getTipoComercializacion())
						&& !DDEstadoPublicacionAlquiler.isPublicadoAlquiler(activoPublicacion.getEstadoPublicacionAlquiler()) 
						&& perimetroActivo.getCheckGestorComercial() != null && perimetroActivo.getCheckGestorComercial()) {
							erroresActivo.add(VALID_ACTIVO_GESTION);
						}
					}else if(DDCartera.isCarteraBBVA(activoActual.getCartera())) {
						if(!DDEstadoPublicacionVenta.isPublicadoVenta(activoPublicacion.getEstadoPublicacionVenta())
						&& !DDEstadoPublicacionAlquiler.isPublicadoAlquiler(activoPublicacion.getEstadoPublicacionAlquiler())&& 
						activoPropietario != null && activoPropietario.getPropietario() !=null && 
						Arrays.asList(SOCIEDADES_PARTICIPADAS).contains(activoPropietario.getPropietario().getDocIdentificativo())){
							erroresActivo.add(VALID_ACTIVO_PROPIETARIO_SOCIEDAD);
						}
					}else if(!DDEstadoPublicacionVenta.isPublicadoVenta(activoPublicacion.getEstadoPublicacionVenta())
						&& !DDEstadoPublicacionAlquiler.isPublicadoAlquiler(activoPublicacion.getEstadoPublicacionAlquiler())) {
						erroresActivo.add(VALID_ACTIVO_ESTADO_PUBLICACION);
					}
				}else {
					erroresActivo.add(VALID_ACTIVO_ESTADO_PUBLICACION);
				}

				// Validación que comprueba si el activo es comercializable
				if (perimetroActivo != null && perimetroActivo.getAplicaComercializar() != null && perimetroActivo.getAplicaComercializar() == 0) {
						erroresActivo.add(VALID_ACTIVO_NO_COMERCIALIZABLE);
				}

				// Validación que comprueba si pertenece a una VPO
				if (DDCartera.isCarteraCajamar(activoActual.getCartera()) && activoPublicacion != null 
					&& DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(activoPublicacion.getTipoComercializacion().getCodigo())
					&& !DDEstadoPublicacionAlquiler.isPublicadoAlquiler(activoPublicacion.getEstadoPublicacionAlquiler()) && activoActual.getVpo() == 1) {
						erroresActivo.add(VALID_ACTIVO_NO_VPO);
					
				}

				// Validación que comprueba si el activo tiene cargas
				if (activoActual.getConCargas() != null && activoActual.getConCargas() == 1) {
					erroresActivo.add(VALID_ACTIVO_CON_CARGAS);
				}

				// Validación que comprueba si el activo está incluido en perímetro de alquiler social
				if (activoActual.getTipoAlquiler() != null && (DDTipoAlquiler.CODIGO_FONDO_SOCIAL
						.equals(activoActual.getTipoAlquiler().getCodigo()))) {
					erroresActivo.add(VALID_ACTIVO_ALQUILER_SOCIAL);
				}
				
				if(fasePublicacionActivoVigente != null && DDSubfasePublicacion.isHistoricoFasesExcPubEstrategiaCl(fasePublicacionActivoVigente) || DDSubfasePublicacion.isHistoricoFasesReqLegAdm(fasePublicacionActivoVigente) || DDSubfasePublicacion.isHistoricoFasesSinValor(fasePublicacionActivoVigente)) {
					erroresActivo.add(VALID_SUBFASE_PUBLICACION);
				}
				
				// Si se intenta desmarcar pero cumple todas las condiciones para estar marcado no deja.
				if(!checkGestorComercial && erroresActivo.isEmpty() && ficha) {
					erroresActivo.add(VALID_DESMARCAR_SIN_ERRORES);
				}
				
				//Para desmarcar
				if(!checkGestorComercial) {
					for (ActivoOferta actOfr : listaActivoOferta) {
						Oferta oferta = actOfr.getPrimaryKey().getOferta();
						if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta()) && DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
							erroresActivo.add(VALID_ACTIVO_OFERTAS_PENDIENTES);
							break;
						}
					}
				}
			}
			
			mapaErrores.put(activoActual.getNumActivo(), erroresActivo);
		}

		return mapaErrores;
	}

}