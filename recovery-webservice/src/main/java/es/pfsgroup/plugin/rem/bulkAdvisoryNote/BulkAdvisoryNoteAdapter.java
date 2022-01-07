package es.pfsgroup.plugin.rem.bulkAdvisoryNote;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.bulkAdvisoryNote.dao.BulkOfertaDao;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.formulario.ActivoGenericFormManager;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoScriptExecutorApi;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.BulkOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;
import es.pfsgroup.plugin.rem.thread.AvanzaTareaOfertasBulkAN;

@Service("bulkAdvisoryNoteAdapter")
public class BulkAdvisoryNoteAdapter {
		
	@Autowired
	private AgendaAdapter agendaAdapter;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;
	
	@Autowired
	private JBPMActivoScriptExecutorApi jbpmMActivoScriptExecutorApi;
	
	@Autowired
	private ActivoGenericFormManager actGenericFormManager;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Autowired
	private TareaActivoDao tareaActivoDao;
	
	@Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private BulkOfertaDao bulkOfertaDao;
    
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	
    public static final String COD_TAP_TAREA_AUTORIZACION_PROPIEDAD = "T017_ResolucionPROManzana";
	public static final String COD_TAP_TAREA_ADVISORY_NOTE = "T017_AdvisoryNote";
	public static final String COD_TAP_TAREA_RECOM_ADVISORY= "T017_RecomendCES";
	
	public boolean ofertaEnBulkAN(Map<String,String[]> valoresFormulario)
			throws Exception {
		
		String valor = valoresFormulario.get("idTarea")[0];
		
		if(valor == null)
			return false;
			
		Long idTareaActivo = Long.parseLong(String.valueOf(valor));
		
		TareaActivo tarActivo = tareaActivoDao.get(idTareaActivo);
		
		TareaExterna tareaExterna = tarActivo.getTareaExterna(); 
		
		Oferta ofertaActual = ofertaApi.tareaExternaToOferta(tareaExterna);
		List<ActivoOferta> listActOfr = null;
		ActivoOferta actOfr = null;
		BulkOferta bulkOferta  = null;
		if(ofertaActual != null) {
			listActOfr = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaActual.getId()));
			if(!listActOfr.isEmpty()) {
				actOfr = listActOfr.get(0);
			}
			bulkOferta = bulkOfertaDao.findOne(null, ofertaActual.getId(), false);
		}
		
		String tapCodigoActual= tareaExterna.getTareaProcedimiento().getCodigo();
		
		Boolean esOfertaEnBulk = false;
		if(actOfr != null && tapCodigoActual != null && bulkOferta != null)
			esOfertaEnBulk = ofertaEnBulkOferta(actOfr,tapCodigoActual,bulkOferta);
		
		return esOfertaEnBulk;
	}
	
	public boolean validarTareasOfertasBulk(Map<String,String[]> valoresFormulario) throws Exception {
		String valor = valoresFormulario.get("idTarea")[0];
		
		if(valor == null)
			return false;
			
		Long idTareaActivo = Long.parseLong(String.valueOf(valor));
		
		TareaActivo tarActivo = tareaActivoDao.get(idTareaActivo);
		
		TareaExterna tareaExterna = tarActivo.getTareaExterna(); 
		
		Oferta ofertaActual = ofertaApi.tareaExternaToOferta(tareaExterna);
		List<ActivoOferta> listActOfr = null;
		ActivoOferta actOfr = null;
		BulkOferta bulkOferta  = null;
		if(ofertaActual != null) {
			listActOfr = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaActual.getId()));
			if(!listActOfr.isEmpty()) {
				actOfr = listActOfr.get(0);
			}
			bulkOferta = bulkOfertaDao.findOne(null, ofertaActual.getId(), false);
		}
		
		List<TareaExternaValor> valores = activoTareaExternaManagerApi.obtenerValoresTarea(tareaExterna.getId());
		Map<String,String[]> valoresTarea = insertValoresToHashMap(valores);
		TareaProcedimiento tareaProcedimiento = tareaExterna.getTareaProcedimiento();
				
		if(bulkOferta == null)
			return false;
		
		List<BulkOferta> listOfertasBulk = bulkOfertaDao.getListBulkOfertasByIdBulk(bulkOferta.getPrimaryKey().getBulkAdvisoryNote().getId());
		
		return validarTareasOfertasBulk(listOfertasBulk, valoresTarea, tareaProcedimiento);
	}
	
	private Boolean ofertaEnBulkOferta(ActivoOferta actOfr,String tapCodigoActual,BulkOferta bulkOferta) {

		List<BulkOferta> listOfertasBulk;
		Boolean esOfertaEnbulk = false;
		if(!Checks.esNulo(actOfr) 
				&& ( COD_TAP_TAREA_AUTORIZACION_PROPIEDAD.equals(tapCodigoActual)
						|| COD_TAP_TAREA_ADVISORY_NOTE.equals(tapCodigoActual)
						|| COD_TAP_TAREA_RECOM_ADVISORY.equals(tapCodigoActual)
					) 
				&& !Checks.esNulo(actOfr.getPrimaryKey().getActivo().getCartera())
				&& DDCartera.CODIGO_CARTERA_CERBERUS.equals(actOfr.getPrimaryKey().getActivo().getCartera().getCodigo()) 
				&& !Checks.esNulo(actOfr.getPrimaryKey().getActivo().getSubcartera()) 
				&& (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(actOfr.getPrimaryKey().getActivo().getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(actOfr.getPrimaryKey().getActivo().getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_JAGUAR.equals(actOfr.getPrimaryKey().getActivo().getSubcartera().getCodigo()))
				&& bulkOferta != null && !Checks.esNulo(bulkOferta.getPrimaryKey().getBulkAdvisoryNote())) {

			listOfertasBulk = bulkOfertaDao.getListBulkOfertasByIdBulk(bulkOferta.getPrimaryKey().getBulkAdvisoryNote().getId());
			if(listOfertasBulk != null && !listOfertasBulk.isEmpty() && listOfertasBulk.size() > 1) {
				esOfertaEnbulk=true;
			}
		}
		return esOfertaEnbulk;
	}

	public boolean validarTareasOfertasBulk(List<BulkOferta> listOfertasBulk,
			Map<String,String[]> valoresTarea, TareaProcedimiento tareaProcedimiento) throws Exception {
		
		DtoGenericForm dto;
		String tapCodigoActual = tareaProcedimiento.getCodigo();
		for (BulkOferta ofertaDelBulk : listOfertasBulk) {
			
			Oferta ofertaActual = ofertaDao.get(ofertaDelBulk.getPrimaryKey().getOferta().getId());
			
			if(!Checks.esNulo(ofertaActual) 
					&&  (ofertaDao.tieneTareaActiva(tapCodigoActual,ofertaActual.getNumOferta().toString()))){

				TareaActivo tareaActivoDeOferta = tareaActivoDeOferta(ofertaActual, tareaProcedimiento);
				Map<String,String[]> valoresTareaOfertaBulk = tareaActivoApi.valoresTareaDependiente(valoresTarea, tareaActivoDeOferta, ofertaActual);
				
				dto = agendaAdapter.convetirValoresToDto(valoresTareaOfertaBulk);

				String scriptValidacion = dto.getForm().getTareaExterna().getTareaProcedimiento().getScriptValidacion();
				Object result = jbpmMActivoScriptExecutorApi.evaluaScript(tareaActivoDeOferta.getTramite().getId(), dto.getForm().getTareaExterna().getId(),
						dto.getForm().getTareaExterna().getTareaProcedimiento().getId(),null, scriptValidacion);

				if (!Checks.esNulo(result)){
					throw new UserException("Oferta "+ofertaActual.getNumOferta() +": "+(String)result);
				}

				scriptValidacion = dto.getForm().getTareaExterna().getTareaProcedimiento().getScriptValidacionJBPM();
				result = jbpmMActivoScriptExecutorApi.evaluaScript(tareaActivoDeOferta.getTramite().getId(), dto.getForm().getTareaExterna().getId(),
						dto.getForm().getTareaExterna().getTareaProcedimiento().getId(),null, scriptValidacion);
				
				if (result instanceof Boolean && !(Boolean) result) {
					throw new UserException("bpm.error.script");
				}
				
				if (result instanceof String && ((String) result).length() > 0 && !"null".equalsIgnoreCase((String) result)) {
					throw new UserException("Oferta "+ofertaActual.getNumOferta() +": "+ (String)result);
				}
			} else {
				return false;
			}
		}
		return true;
	}
	
	public void avanzarTareasOfertasBulk(Map<String,String[]> valoresFormulario) throws Exception {
		
		String valor = valoresFormulario.get("idTarea")[0];
		
		if(valor == null)
			return ;
			
		Long idTareaActivo = Long.parseLong(String.valueOf(valor));
		
		TareaActivo tarActivo = tareaActivoDao.get(idTareaActivo);
		
		TareaExterna tareaExterna = tarActivo.getTareaExterna(); 
		
		Oferta ofertaActual = ofertaApi.tareaExternaToOferta(tareaExterna);
		List<ActivoOferta> listActOfr = null;
		ActivoOferta actOfr = null;
		BulkOferta bulkOfrf  = null;
		if(ofertaActual != null) {
			listActOfr = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaActual.getId()));
			if(!listActOfr.isEmpty()) {
				actOfr = listActOfr.get(0);
			}
			bulkOfrf = bulkOfertaDao.findOne(null, ofertaActual.getId(), false);
		}
		
		List<TareaExternaValor> valores = activoTareaExternaManagerApi.obtenerValoresTarea(tareaExterna.getId());
		Map<String,String[]> valoresTarea = insertValoresToHashMap(valores);
		String tapCodigoActual= tareaExterna.getTareaProcedimiento().getCodigo();

		if(bulkOfrf != null) {
			List<BulkOferta> listOfertasBulk = bulkOfertaDao.getListBulkOfertasByIdBulk(bulkOfrf.getPrimaryKey().getBulkAdvisoryNote().getId());
			List<Long> listIdsOfertasDelBulk = new ArrayList<Long>();
			for (BulkOferta bulkOferta : listOfertasBulk) {
				if(ofertaActual != null && !ofertaActual.getNumOferta().equals(bulkOferta.getOferta().getNumOferta()))
					listIdsOfertasDelBulk.add(bulkOferta.getOferta().getId());
			}
			
			try {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Thread avanzaTareasOfertasBulkAN = new Thread(new AvanzaTareaOfertasBulkAN(usuarioLogado.getUsername(),listIdsOfertasDelBulk,ofertaActual.getId(),valoresTarea, tapCodigoActual));
				avanzaTareasOfertasBulkAN.start();
			} catch (Exception e) {
				logger.error("[ERROR] Error en BulkAdvisoryNoteAdapter al intentar avanzar la tarea de la oferta", e);
				throw e;
			}
		}else {
			throw new  JsonViewerException("No existe el Bulk en esta oferta, no se avanzara la tarea.");
		}
	}
	
	public Map<String,String[]> insertValoresToHashMap(List<TareaExternaValor> list) {
		Map<String,String[]> valoresTarea = new HashMap<String,String[]>();
		
			for (TareaExternaValor tareaExternaV : list) {
				valoresTarea.put(tareaExternaV.getNombre(),new String[] { tareaExternaV.getValor()});
			}
		return valoresTarea;
	}
	
	public DtoGenericForm convetirValoresToDto(Map<String,String[]> valoresDependiente, Session session) {
		Long idTarea = 0L;
		DtoGenericForm dto = null;
		
		Map<String, String> camposFormulario = new HashMap<String,String>();
		for (Map.Entry<String, String[]> entry : valoresDependiente.entrySet()) {
			String key = entry.getKey();
			if (!"idTarea".equals(key)){
				camposFormulario.put(key, entry.getValue()[0]);
			}else{
				idTarea = Long.parseLong(entry.getValue()[0]);
			}
		}
		
		if (!Checks.esNulo(idTarea) && !Checks.estaVacio(camposFormulario)) {
			try {
				dto = rellenaDTO(idTarea,camposFormulario, session);
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		}
		
		return dto;
	}
	
	@SuppressWarnings("rawtypes")
	private DtoGenericForm rellenaDTO(Long idTarea, Map<String,String> camposFormulario, Session session) throws Exception {
		TareaNotificacion tar = (TareaNotificacion) session.get(TareaNotificacion.class, idTarea);
		GenericForm genericForm = actGenericFormManager.get(tar.getTareaExterna().getId());

		DtoGenericForm dto = new DtoGenericForm();
		dto.setForm(genericForm);
		String[] valores = new String[genericForm.getItems().size()];

		for (int i = 0; i < genericForm.getItems().size(); i++) {
			GenericFormItem gfi = genericForm.getItems().get(i);
			String nombreCampo = gfi.getNombre();
			for (Map.Entry<String, String> stringStringEntry : camposFormulario.entrySet()) {
				if (nombreCampo.equals(((Map.Entry) stringStringEntry).getKey())) {
					String valorCampo = (String) ((Map.Entry) stringStringEntry).getValue();
					if (valorCampo != null && !valorCampo.isEmpty() && nombreCampo.toUpperCase().contains("FECHA")) {
						try {
							valorCampo = valorCampo.substring(6, 10) + "-" + valorCampo.substring(3, 5) + "-" + valorCampo.substring(0, 2);
						}catch (Exception e) {
							logger.error("[ERROR] Error en BulkAdvisoryNoteAdapter, no se puede rellenar el dto para pasar los valores de la tarea.");
						}
					}
					valores[i] = valorCampo;
					break;
				}
			}
		}

		dto.setValues(valores);
		return dto;
	}
	
	@Transactional(readOnly = false)
	public void avanzaTareasDelBulk(String userName,List<Long> listIdsOfertasDelBulk
			,Long idOfertaActual,Map<String,String[]> valoresTarea,String tapCodigoActual) throws Exception {
		
		logger.error("[INFO] En el hilo del Bulk.");
		try {
			Oferta ofertaDelBulk = null;
			Oferta ofertaActual = ofertaDao.get(idOfertaActual);
			String idTarea = null;
			
			for (Long idOfertaDelBulk : listIdsOfertasDelBulk) {
				ofertaDelBulk = ofertaDao.get(idOfertaDelBulk);
				
				if(ofertaActual != null && ofertaDelBulk != null 
					&& !ofertaActual.getNumOferta().toString().equals(ofertaDelBulk.getNumOferta().toString())) {
					
					ExpedienteComercial expedienteComercial=  expedienteComercialDao.getExpedienteComercialByIdOferta(idOfertaDelBulk);
					List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
					List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(listaTramites.get(0).getId());
					for (TareaExterna tareaExterna : tareasTramite) {
						if(tapCodigoActual.equals(tareaExterna.getTareaProcedimiento().getCodigo())){
							idTarea = tareaExterna.getTareaPadre().getId().toString();
							break;
						}
					}
					valoresTarea.put("idTarea", new String[] { idTarea });
					agendaAdapter.save(valoresTarea);
				}
			}
			logger.error("[INFO] Saliendo del hilo del Bulk.");
		} catch (Exception e) {
			throw e;
		}
	}
	
	@Transactional
	public TareaActivo tareaActivoDeOferta(Oferta oferta, TareaProcedimiento tareaProcedimiento) {
		TareaActivo tarea = null;
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (!Checks.esNulo(expediente)) {
			Trabajo trabajoAsociadoExpediente = expediente.getTrabajo();
			if (!Checks.esNulo(trabajoAsociadoExpediente)) {
				Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajoAsociadoExpediente.getId());
				ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTrabajo);
				if (!Checks.esNulo(tramite)) {
					Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "tramite.id", tramite.getId());
					Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "tareaExterna.tareaProcedimiento.id", tareaProcedimiento.getId());
					Filter filtroTareaFinalizada = genericDao.createFilter(FilterType.EQUALS, "tareaFinalizada", false);
					List<TareaActivo> listado = genericDao.getList(TareaActivo.class, filtroTramite, filtroTarea, filtroTareaFinalizada);
					if(listado != null && !listado.isEmpty())
						tarea = listado.get(0);
				}
			}
		}
		return tarea;
	}

}
