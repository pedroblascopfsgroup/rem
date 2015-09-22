package es.pfsgroup.plugin.recovery.procuradores.procesado.api.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletContext;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDTipoResolucionDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVResolucionDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.MSVResolucionInputApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.procuradores.historico.MSVCampoDinamicoHistorico;
import es.pfsgroup.plugin.recovery.procuradores.procesado.api.PCDResolucionProcuradorApi;
import es.pfsgroup.recovery.api.TareaExternaApi;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;


@Service
@Transactional(readOnly = false)
public class PCDResolucionProcuradorManager implements PCDResolucionProcuradorApi {

	//private static final String FICHERO_VACIO = "/reports/plugin/masivo/vacio.file";
	private static final String COD_RESOLUCION_AUTOPRORROGA = "RESOL_PROCU_AUTO";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MSVResolucionDao msvResolucionDao;
	
	@Autowired
	private MSVDDTipoResolucionDao msvDDTipoResolucionDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
    @Autowired(required=false)
    ServletContext servletContext;
    
    @Autowired
    private transient RecoveryBPMfwkDatosProcedimientoApi datosProcedimientoManager;
    
	@Autowired
	private ApiProxyFactory apiProxyFactory;
    
	@Autowired
	private JBPMProcessManager jbpmManager;
	
	@Override
	@BusinessOperation(PCD_MSV_BO_MOSTRAR_RESOLUCIONES)
	public	List<MSVResolucion> mostrarResoluciones() {
		return proxyFactory.proxy(MSVResolucionApi.class).mostrarResoluciones();
	}
	
	@Override
	@BusinessOperation(PCD_MSV_BO_MOSTRAR_RESOLUCIONES_PAGINATED)
	public Page mostrarResoluciones(MSVDtoFiltroProcesos dto) {
		return proxyFactory.proxy(MSVResolucionApi.class).mostrarResoluciones(dto);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_UPLOAD_FICHERO_RESOLUCION)
	public MSVDtoResultadoSubidaFicheroMasivo uploadFile(
			ExcelFileBean uploadForm, MSVDtoFileItem dto)
			throws BusinessOperationException {
		return proxyFactory.proxy(MSVResolucionApi.class).uploadFile(uploadForm, dto);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_GUARDAR_DATOS_RESOLUCION)
	public MSVResolucion guardarDatos(MSVResolucionesDto dtoResolucion) {
		return proxyFactory.proxy(MSVResolucionApi.class).guardarDatos(dtoResolucion);
	}
	
	@Override
	@BusinessOperation(PCD_MSV_BO_GUARDAR_RESOLUCION)
	public MSVResolucion guardarResolucion(MSVResolucionesDto dtoResolucion){
		return proxyFactory.proxy(MSVResolucionApi.class).guardarResolucion(dtoResolucion);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_GET_DATOS_RESOLUCION)
	public MSVResolucion getResolucion(Long idResolucion) throws Exception {
		return proxyFactory.proxy(MSVResolucionApi.class).getResolucion(idResolucion);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_DAME_AYUDA_RESOLUCION)
	public String dameAyuda(Long idTipoResolucion) {
		return proxyFactory.proxy(MSVResolucionApi.class).dameAyuda(idTipoResolucion);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_PROCESA_RESOLUCION)
	public MSVResolucion procesaResolucion(Long idResolucion) {
		return proxyFactory.proxy(MSVResolucionApi.class).procesaResolucion(idResolucion);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_GET_TIPOS_RESOLUCION)
	public List<MSVDDTipoResolucion> getTiposDeResolucion(Long idProcedimiento) {
		return proxyFactory.proxy(MSVResolucionApi.class).getTiposDeResolucion(idProcedimiento);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_GET_TIPO_RESOLUCION)
	public MSVDDTipoResolucion getTipoResolucion(Long idTipoResolucion) {
		return proxyFactory.proxy(MSVResolucionApi.class).getTipoResolucion(idTipoResolucion);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_GET_TIPO_RESOLUCION_POR_CODIGO)
	public MSVDDTipoResolucion getTipoResolucionPorCodigo(
			String codigoTipoResolucion) {
		return proxyFactory.proxy(MSVResolucionApi.class).getTipoResolucionPorCodigo(codigoTipoResolucion);
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_GET_RESOLUCION_BY_TAREA)
	public MSVResolucion getResolucionByTarea(Long idTareaExterna) {
		if (idTareaExterna == null)
			return null;
		List<MSVResolucion> resoluciones = msvResolucionDao.dameResolucionByTarea(idTareaExterna);
		if (resoluciones.isEmpty()){
			return null;
		}else{
			///Nos quedamos con la resolucion que sea de tipo ADVANCE
			MSVResolucion resolucion = null;
			for(MSVResolucion resol : resoluciones){
				if(resol.getTipoResolucion().getTipoAccion().getCodigo().equals("ADVANCE")){
					resolucion = resol;
					break;
				}
			}
			return resolucion;
		}
	}
	
	@Override
	@BusinessOperation(PCD_MSV_BO_GET_TIPO_RESOLUCIONES_ESPECIALES)
	public List<MSVTipoResolucionDto> getTiposResolucionesEspeciales(String prefijoResEspeciales, Long idTarea)
	{
		List<MSVDDTipoResolucion> listaResoluciones = msvDDTipoResolucionDao.dameTiposEspeciales(prefijoResEspeciales);
		List<MSVTipoResolucionDto> listaResolucionesDto = new ArrayList<MSVTipoResolucionDto>();
		for (MSVDDTipoResolucion resolucion: listaResoluciones) {
			MSVTipoResolucionDto dtoTipoResol = new MSVTipoResolucionDto();
			dtoTipoResol.setIdTipoResolucion(resolucion.getId());
			dtoTipoResol.setCodigoTipoResolucion(resolucion.getCodigo());
			dtoTipoResol.setDescripcionTipoResolucion(resolucion.getDescripcion());
			dtoTipoResol.setCodigoTipoAccion(resolucion.getTipoAccion().getCodigo());
			
			// Si el procedimiento no tiene tareas activas no se incluye la autoprórroga.
			// Si se han realizado el máximo de autoprórrogas no se incluye la autoprórroga.
//			if(resolucion.getCodigo().equals(PCDResolucionProcuradorManager.COD_RESOLUCION_AUTOPRORROGA) && idTarea != null)
//			{
//			    	EXTTareaExterna tarea = (EXTTareaExterna) proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
//			    	int numProrrogas = tarea.getNumeroAutoprorrogas();
//			    	
//					EXTTareaProcedimiento tareaProcedimiento = genericDao.get(EXTTareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", tarea.getTareaProcedimiento().getId()));
//			    	int numMaximoProrrogas = tareaProcedimiento.getMaximoAutoprorrogas();
//			    	 
//			    	if (numProrrogas < numMaximoProrrogas)
//			    		listaResolucionesDto.add(dtoTipoResol);
//			}else{
				listaResolucionesDto.add(dtoTipoResol);
//			}
		}
		
		return listaResolucionesDto;
	}
	
	@Override
	@BusinessOperation(PCD_MSV_BO_ES_TIPO_ESPECIAL)
	public boolean esTipoEspecial(Long idTipo, String PrefijoResEspeciales)
	{
		return msvDDTipoResolucionDao.esTipoEspecial(idTipo, PrefijoResEspeciales);
	}
	
	
	
	@BusinessOperation(PCD_MSV_BO_OBTENER_RESOLUCIONES)
	public Set<MSVTipoResolucionDto> obtenerTiposResoluciones(Long idProcedimiento, Long idTarea){
		
    	//Si no tiene tareas activas obtiene los tipos de resolución a partir del idProcedimiento
    	Set<MSVTipoResolucionDto> setTiposResolucion = (Checks.esNulo(idTarea)) 
    			? apiProxyFactory.proxy(MSVResolucionInputApi.class).obtenerTiposResolucionesSinTarea(idProcedimiento)
    			: apiProxyFactory.proxy(MSVResolucionInputApi.class).obtenerTiposResolucionesTareas(idTarea);
    	
    	
		MSVTipoResolucionDto tipoAutoprorroga = new MSVTipoResolucionDto();
		tipoAutoprorroga.setCodigoTipoResolucion(COD_RESOLUCION_AUTOPRORROGA);
		
		//Si la tarea es nula o a llegado al máximo de las prórrogas, eliminamos la resolución.
		if(Checks.esNulo(idTarea)){
			setTiposResolucion.remove(tipoAutoprorroga);
		}else{
    		EXTTareaExterna tarea = (EXTTareaExterna) proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
			int numProrrogas = tarea.getNumeroAutoprorrogas();
			    	
			EXTTareaProcedimiento tareaProcedimiento = genericDao.get(EXTTareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", tarea.getTareaProcedimiento().getId()));
			int numMaximoProrrogas = tareaProcedimiento.getMaximoAutoprorrogas();
			    	 
		   	if (numProrrogas >= numMaximoProrrogas)
		    	setTiposResolucion.remove(tipoAutoprorroga);
		}
    			
    	
    	return setTiposResolucion;
	}
	
	@BusinessOperation(PCD_MSV_BO_BORRAR_ADJUNTO)
	public void borrarAdjunto(MSVResolucion msvResolucion){
		EXTAdjuntoAsunto adjuntoAsunto = msvResolucion.getAdjuntoFinal();
		adjuntoAsunto.getAuditoria().setBorrado(true);
	}
	
	
	@BusinessOperation(PCD_MSV_BO_DAME_VALIDACION_RESOLUCION)
	public String dameValidacion(Long idTarea){
		TareaExterna tareaExterna = proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
		
		       String script = tareaExterna.getTareaProcedimiento().getScriptValidacion();

		       if (!StringUtils.isBlank(script)) {
		           Long idTareaExterna = tareaExterna.getId();
		           Long idProcedimiento = tareaExterna.getTareaPadre().getProcedimiento().getId();

		           String result = null;
		           try {
		               result = (String) jbpmManager.evaluaScript(idProcedimiento, idTareaExterna, tareaExterna.getTareaProcedimiento().getId(), null,
		                       script);
		           } catch (Exception e) {
		               throw new UserException("Error en el script de decisión [" + script + "] para la tarea: " + idTareaExterna + " del procedimiento: "
		                       + idProcedimiento);
		           }
		           return result;
		       }
		       return null;
		   }
	
	@BusinessOperation(PCD_MSV_BO_DAME_VALIDACION_RESOLUCION_JBPM)
	public String dameValidacionJBPM(Long idTarea){
		TareaExterna tareaExterna = proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
		
		       String script = tareaExterna.getTareaProcedimiento().getScriptValidacionJBPM();

		       if (!StringUtils.isBlank(script)) {
		           Long idTareaExterna = tareaExterna.getId();
		           Long idProcedimiento = tareaExterna.getTareaPadre().getProcedimiento().getId();

		           String result = null;
		           try {
		               result = (String) jbpmManager.evaluaScript(idProcedimiento, idTareaExterna, tareaExterna.getTareaProcedimiento().getId(), null,
		                       script);
		           } catch (Exception e) {
		               throw new UserException("Error en el script de decisión [" + script + "] para la tarea: " + idTareaExterna + " del procedimiento: "
		                       + idProcedimiento);
		           }
		           return result;
		       }
		       return null;
		   }

	@BusinessOperation(PCD_MSV_GUARDAR_DATOS_HISTORICO)
	public void guardarDatosHistorico(MSVResolucionesDto dtoResolucion, MSVResolucion msvResolucion)
	{
		if(dtoResolucion.getCamposDinamicos() != null & dtoResolucion.getCamposDinamicos().size() > 0)
		{
			//Set<MSVCampoDinamicoHistorico> camposResolucion = apiProxyFactory.proxy(MSVCampoDinamicoHistorico.class);
			Map<String,String> camposDinamicosHistorico = dtoResolucion.getCamposDinamicos();
			
			for(Map.Entry<String, String> entry : camposDinamicosHistorico.entrySet()){
				MSVCampoDinamicoHistorico msvCampoDinamicoHistorico = new MSVCampoDinamicoHistorico();//this.dameCampo(entry.getKey(), camposResolucion);
				msvCampoDinamicoHistorico.setNombreCampo(entry.getKey());
			    msvCampoDinamicoHistorico.setValorCampo(this.formateaValor(entry.getValue()));
			    msvCampoDinamicoHistorico.setResolucion(msvResolucion);
			    genericDao.save(MSVCampoDinamicoHistorico.class, msvCampoDinamicoHistorico);
			}
		}
	}
	
	private String formateaValor(String value) {
		if (value != null && value.matches("\\d{4}-\\d{2}-\\d{2}T00:00:00")) {
		    return value.substring(8, 10) + "/" + value.substring(5, 7) + "/" + value.substring(0, 4);
		}
		return value;
	}

	@Override
	@BusinessOperation(PCD_MSV_GET_RESOLUCIONES_PENDIENTES_VALIDAR)
	public List<MSVResolucion> getResolucionesPendientesValidar(Long idTarea,List<String> tipoResolucionAccionBaned) {

		return  msvResolucionDao.getResolucionesPendientesValidar(idTarea,tipoResolucionAccionBaned);
		
	}

	@Override
	@BusinessOperation(PCD_MSV_BO_ADJUNTAR_FICHERO_RESOLUCION)
	public MSVResolucion adjuntaFicheroResolucuion(MSVResolucionesDto dtoResolucion) {
		return proxyFactory.proxy(MSVResolucionApi.class).guardarAdjuntoResolucion(dtoResolucion);
	}
	
}
