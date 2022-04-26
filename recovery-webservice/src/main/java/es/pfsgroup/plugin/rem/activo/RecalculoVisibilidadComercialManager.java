package es.pfsgroup.plugin.rem.activo;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.validators.VisibilidadGestionComercialValidator;

@Service("recalculoVisibilidadComercialManager")
public class RecalculoVisibilidadComercialManager implements RecalculoVisibilidadComercialApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private VisibilidadGestionComercialValidator visibilidadGestionComercialValidator;
	
	@Override
	@Transactional
	public Map<Long, List<String>> recalcularVisibilidadComercial(Activo activo, Boolean dtoCheckGestorComercial, Boolean dtoExcluirValidaciones,boolean fichaActivo) {
		Map<Long, List<String>> mapaErrores = new HashMap<Long, List<String>>();

		PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
		
		mapaErrores = visibilidadGestionComercialValidator.validarPerimetroActivo(activo, dtoCheckGestorComercial, dtoExcluirValidaciones, fichaActivo);
		
		List<String> listaErrores = mapaErrores.get(activo.getNumActivo());

		boolean tieneErrores = false;		
		if(listaErrores != null && !listaErrores.isEmpty()){
			tieneErrores = true;
		}

		if(!fichaActivo) {
			if(tieneErrores && (perimetroActivo.getExcluirValidaciones() == null || !DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones()))) {
				perimetroActivo.setCheckGestorComercial(false);	
				perimetroActivo.setFechaGestionComercial(new Date());
				genericDao.update(PerimetroActivo.class,perimetroActivo);
			}
			if(!tieneErrores) {
				perimetroActivo.setCheckGestorComercial(true);	
				perimetroActivo.setFechaGestionComercial(new Date());
				perimetroActivo.setExcluirValidaciones((DDSinSiNo) diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_NO));
				perimetroActivo.setMotivoGestionComercial(null);
				
				genericDao.update(PerimetroActivo.class,perimetroActivo);
			}
		}
		
		if (Checks.esNulo(perimetroActivo.getExcluirValidaciones()) || !DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones())) {
			return mapaErrores;
		}else {
			return new HashMap<Long, List<String>>();
		}
		
	}

	@Override
	@Transactional
	public Map<Long, List<String>> recalcularVisibilidadComercial(Activo[] activos, DDEstadosExpedienteComercial nuevoEstadoExpediente) {
		Map<Long, List<String>> mapaErrores = visibilidadGestionComercialValidator.validarPerimetroActivos(activos, nuevoEstadoExpediente);
		
		Boolean tieneErrores = false;
		
		DDSinSiNo diccionarioNo = (DDSinSiNo) diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_NO);
		
		for (Activo activo : activos) {
			
			if(!Checks.esNulo(mapaErrores.get(activo.getNumActivo())) 
				&& !mapaErrores.get(activo.getNumActivo()).isEmpty()) {
				tieneErrores = true;
			}
					
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroIdActivo);
			
			if(perimetroActivo != null) {

				if(tieneErrores && (perimetroActivo.getExcluirValidaciones() == null || !DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones()))) {
					perimetroActivo.setCheckGestorComercial(false);	
					perimetroActivo.setFechaGestionComercial(new Date());	
					genericDao.update(PerimetroActivo.class,perimetroActivo);
				}
				if(!tieneErrores) {
					perimetroActivo.setCheckGestorComercial(true);	
					perimetroActivo.setFechaGestionComercial(new Date());
					perimetroActivo.setExcluirValidaciones(diccionarioNo);
					perimetroActivo.setMotivoGestionComercial(null);
					genericDao.update(PerimetroActivo.class,perimetroActivo);
				}
				
				if(!Checks.esNulo(perimetroActivo.getExcluirValidaciones()) && DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones())) {
					if (mapaErrores.containsKey(activo.getNumActivo())){
						mapaErrores.remove(activo.getNumActivo());
					}
				}
				tieneErrores = false;
			}
		
		}
		
		return mapaErrores;
	}
	
	@Override
	@Transactional
	public Map<Long, List<String>> recalcularVisibilidadComercial(Oferta oferta, DDEstadosExpedienteComercial nuevoEstadoExpediente) {
		List<ActivoOferta> activosOferta = oferta.getActivosOferta();
		Activo[] activos = new Activo[oferta.getActivosOferta().size()];
		
		for (int i = 0; i< activosOferta.size(); i++) {
			activos[i] = activosOferta.get(i).getPrimaryKey().getActivo();
		}
		return recalcularVisibilidadComercial(activos, nuevoEstadoExpediente);
	}

	@Override
	public void lanzarPrimerErrorSiTiene(Map<Long, List<String>> mapaErrores) {
		
		for (Map.Entry<Long, List<String>> entry : mapaErrores.entrySet()) {
			
			List<String> listaErrores = entry.getValue();
			
			if(listaErrores != null && !listaErrores.isEmpty()) {
				throw new JsonViewerException(entry.getKey() + ": " + listaErrores.get(0));
			}
	    }
		
	}

	@Override
	@Transactional
	public Map<Long, List<String>> recalcularVisibilidadComercial(List<Long> listaIdActivos) {		
		Activo[] activos = new Activo[listaIdActivos.size()];
		
		for (int i = 0; i< listaIdActivos.size(); i++) {
			activos[i] = activoApi.get(listaIdActivos.get(i));
		}
		return recalcularVisibilidadComercial(activos, null);
	}
	
}

