package es.pfsgroup.plugin.rem.bulkAdvisoryNote;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.formulario.ActivoGenericFormManager;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoScriptExecutorApi;
import es.pfsgroup.plugin.rem.model.BulkOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
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
	
	private final Log logger = LogFactory.getLog(getClass());

	public boolean validarTareasOfertasBulk(List<BulkOferta> listOfertasBulk, List<TareaExternaValor> list) {
		boolean resultado = false;
		DtoGenericForm dto;
		Map<String,String[]> valoresTarea = insertValoresToHashMap(list);
		for (BulkOferta ofertaDelBulk : listOfertasBulk) {

			TareaActivo tareaActivoDeOferta = tareaActivoApi.tareaOfertaDependiente(ofertaDelBulk.getPrimaryKey().getOferta());
			Map<String,String[]> valoresTareaOfertaBulk = tareaActivoApi.valoresTareaDependiente(valoresTarea, tareaActivoDeOferta, ofertaDelBulk.getPrimaryKey().getOferta());
			
			dto = agendaAdapter.convetirValoresToDto(valoresTareaOfertaBulk);

			try {
				String validacionPrevia = agendaAdapter.getValidacionPrevia(dto.getForm().getTareaExterna().getTareaPadre().getId());

				if (!Checks.esNulo(validacionPrevia)){
					return false;
				}

				String scriptValidacion = dto.getForm().getTareaExterna().getTareaProcedimiento().getScriptValidacionJBPM();
				Object result;
				result = jbpmMActivoScriptExecutorApi.evaluaScript(tareaActivoDeOferta.getTramite().getId(), dto.getForm().getTareaExterna().getId(), dto.getForm().getTareaExterna().getTareaProcedimiento().getId(),
											null, scriptValidacion);
				if (!Checks.esNulo(result)) {
					resultado = false;
				}else {
					resultado = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		
		}
		return resultado;
	}
	
	public void avanzarTareasOfertasBulk(List<BulkOferta> listOfertasBulk, Oferta ofertaActual,Map<String,String[]> valoresTarea) {
		
		List<Long> listIdsOfertasDelBulk = new ArrayList<Long>();
		for (BulkOferta bulkOferta : listOfertasBulk) {
			listIdsOfertasDelBulk.add(bulkOferta.getOferta());
		}
		try {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			Thread avanzaTareasOfertasBulkAN = new Thread(new AvanzaTareaOfertasBulkAN(usuarioLogado.getUsername(),listIdsOfertasDelBulk,ofertaActual.getId(),valoresTarea));
			avanzaTareasOfertasBulkAN.start();
		} catch (Exception e) {
			logger.error("[ERROR] Error en BulkAdvisoryNoteAdapter al intentar avanzar la tarea de la oferta", e);
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

}
