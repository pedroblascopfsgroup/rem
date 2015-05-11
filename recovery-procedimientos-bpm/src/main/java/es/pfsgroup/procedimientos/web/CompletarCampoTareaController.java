package es.pfsgroup.procedimientos.web;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Controller
public class CompletarCampoTareaController {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxy;
	
	

	@RequestMapping
	public String insertarCampo(String campo, String tarea, Long idTarea, String nuevaFecha,Long tokenIdBPM,Long idProcedimiento){
		TareaExternaValor nuevoCampo = new TareaExternaValor();
		
		nuevoCampo.setNombre(campo);
		nuevoCampo.setValor(nuevaFecha);
		try{
			EXTTareaExterna te = null;
			EXTTareaNotificacion tn = new EXTTareaNotificacion();
			if(idTarea.equals(0L)){//TEX_ID
				 
				 te = new EXTTareaExterna();
				 tn.setTipoEntidad(genericDao.get(DDTipoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 tn.setCodigoTarea("3");
				 tn.setEstadoItinerario(genericDao.get(DDEstadoItinerario.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoItinerario.ESTADO_ASUNTO),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 tn.setSubtipoTarea(genericDao.get(EXTSubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", EXTSubtipoTarea.CODIGO_TAREA_GESTOR_ADMINISTRATIVO),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 tn.setTarea("Tarea ficticia para rellenar una fecha que faltaba");
				 tn.setDescripcionTarea("Tarea ficticia para rellenar una fecha que faltaba");
				 tn.setFechaFin(new Date());
				 tn.setFechaInicio(new Date());
				 tn.setTareaFinalizada(true);
				 tn.setEmisor("AUTOMATICA-F");
				 tn.setFechaVenc(new Date());
				 tn.setFechaVencReal(new Date());
				 tn.setEspera(false);
				 tn.setAlerta(false);
				 tn.setProcedimiento(genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 
				 te.setTareaProcedimiento(genericDao.get(EXTTareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tarea)));
				 te.setDetenida(false);
				 te.setNumeroAutoprorrogas(0);
				 te.setTokenIdBpm(tokenIdBPM);
			}
			else{
				 te= genericDao.get(EXTTareaExterna.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", idTarea));
				 tn.setTipoEntidad(genericDao.get(DDTipoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 tn.setCodigoTarea("3");
				 tn.setEstadoItinerario(genericDao.get(DDEstadoItinerario.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoItinerario.ESTADO_ASUNTO),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 tn.setSubtipoTarea(genericDao.get(EXTSubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", EXTSubtipoTarea.CODIGO_TAREA_GESTOR_ADMINISTRATIVO),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 tn.setTarea("Tarea ficticia para rellenar una fecha que faltaba");
				 tn.setDescripcionTarea("Tarea ficticia para rellenar una fecha que faltaba");
				 tn.setFechaFin(new Date());
				 tn.setFechaInicio(new Date());
				 tn.setTareaFinalizada(true);
				 tn.setEmisor("AUTOMATICA-F");
				 tn.setFechaVenc(new Date());
				 tn.setFechaVencReal(new Date());
				 tn.setEspera(false);
				 tn.setAlerta(false);
				 tn.setProcedimiento(genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				 
				
			}
			
			if(te != null){		
				
				proxy.proxy(PROTareaExternaManagerApi.class).guardarTareaExternaValor(nuevoCampo,te,tn);
				
				
				
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return "default";
	}
	
	public GenericABMDao getGenericDao() {
		return genericDao;
	}


	public void setGenericDao(GenericABMDao genericDao) {
		this.genericDao = genericDao;
	}

	

	

}
