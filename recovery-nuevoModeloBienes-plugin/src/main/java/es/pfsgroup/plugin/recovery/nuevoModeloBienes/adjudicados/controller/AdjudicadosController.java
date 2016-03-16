package es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicados.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.dto.DtoNMBBienAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicados.dto.BienesAdjudicadosDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContextImpl;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;

@Controller
public class AdjudicadosController {

	private static final String BIENES_PROCEDIMIENTO_JSON = "plugin/nuevoModeloBienes/adjudicacion/bienesTipoAdjudicacionJSON";
	private static final String BIENES_ADJUDICADOS_JSON = "plugin/nuevoModeloBienes/adjudicacion/bienesAdjudicacionJSON";
	private static final String GENERIC_FORM_CUSTOM = "plugin/nuevoModeloBienes/adjudicacion/generico/genericFormCustom";
	private static final String RESPUESTA_JSON = "plugin/nuevoModeloBienes/adjudicacion/generico/respuestaJSON";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private NMBProjectContext nmbProjectContext;

	@Autowired
	private Executor executor;

    @Autowired
    private JBPMProcessManager jbpmManager;
    
    private final Log logger = LogFactory.getLog(getClass());
    
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getBienesAsuntoApremio(@RequestParam(value = "idAsunto", required = true) Long idAsunto, ModelMap map) {
		List<String> tiposProcedimientos = nmbProjectContext.getTiposProcedimientosAdjudicados();
		if (!Checks.esNulo(tiposProcedimientos)) {
			List<DtoNMBBienAdjudicacion> bienesAdjudicacionDTO = proxyFactory.proxy(BienApi.class).getBienesAsuntoTiposPocedimientos(idAsunto, tiposProcedimientos, false);
			Map<Long,BienesAdjudicadosDTO> bienesDTO = new HashMap<Long, BienesAdjudicadosDTO>();

			Map<String, String> tipoPrcNombre = nmbProjectContext.getMapaTiposPrc();

			for (DtoNMBBienAdjudicacion dtoBien : bienesAdjudicacionDTO) {
				
				BienesAdjudicadosDTO dto = new BienesAdjudicadosDTO();
				
				NMBBien nmbBien = dtoBien.getBien();
				
				if (!Checks.estaVacio(bienesDTO)) {
					dto = bienesDTO.get(nmbBien.getId());
				}
				
				if (Checks.esNulo(dto) || Checks.estaVacio(bienesDTO)) {
					dto = new BienesAdjudicadosDTO();
					dto.setId(nmbBien.getId());
					dto.setOrigen(nmbBien.getOrigen());
					dto.setCodigoInterno(nmbBien.getCodigoInterno());
					dto.setNumeroActivo(nmbBien.getNumeroActivo());
					dto.setDescripcion(nmbBien.getDescripcion());
					dto.setHabitual(nmbBien.getViviendaHabitual());
				}
				
				if (dtoBien.getProcedimientoBien().getProcedimiento().getTipoProcedimiento().getCodigo()
								.compareTo(tipoPrcNombre.get(NMBProjectContextImpl.CONST_TIPO_PROCEDIMIENTO_ADJUDICACION)) == 0) {
					dto.setAdjudicacionOK(!dtoBien.getTareaActiva());
					if(dtoBien.getTareaActiva()) dto.setTareaActivaAdjudicacion(dtoBien.getDescripcionTarea());
				}
				
				if (dtoBien.getProcedimientoBien().getProcedimiento().getTipoProcedimiento().getCodigo()
								.compareTo(tipoPrcNombre.get(NMBProjectContextImpl.CONST_TIPO_PROCEDIMIENTO_SANEAMIENTO)) == 0) {
					dto.setSaneamientoOK(!dtoBien.getTareaActiva());
					if(dtoBien.getTareaActiva()) dto.setTareaActivaSaneamiento(dtoBien.getDescripcionTarea());
				}
				if (dtoBien.getProcedimientoBien().getProcedimiento().getTipoProcedimiento().getCodigo()
								.compareTo(tipoPrcNombre.get(NMBProjectContextImpl.CONST_TIPO_PROCEDIMIENTO_POSESION)) == 0) {
					dto.setPosesionOK(!dtoBien.getTareaActiva());
					if(dtoBien.getTareaActiva()) dto.setTareaActivaPosesion(dtoBien.getDescripcionTarea());
				}
				if (dtoBien.getProcedimientoBien().getProcedimiento().getTipoProcedimiento().getCodigo()
								.compareTo(tipoPrcNombre.get(NMBProjectContextImpl.CONST_TIPO_PROCEDIMIENTO_GESTION_LLAVES)) == 0) {
					dto.setLlavesOK(!dtoBien.getTareaActiva());
					if(dtoBien.getTareaActiva()) dto.setTareaActivaLlaves(dtoBien.getDescripcionTarea());
				}
				

				bienesDTO.put(dto.getId(), dto);
			}
			map.put("bienes", new ArrayList<BienesAdjudicadosDTO>(bienesDTO.values()));
		}
		return BIENES_ADJUDICADOS_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getBienesTipoProcedimientoNombre(@RequestParam(value = "idAsunto", required = true) Long idAsunto,
			@RequestParam(value = "nombreTipoProcedimiento", required = true) String nombreTipoProcedimiento, ModelMap map) {
		Map<String, String> tipoPrcNombre = nmbProjectContext.getMapaTiposPrc();
		String tipoPrc = tipoPrcNombre.get(nombreTipoProcedimiento);
		if (!Checks.esNulo(tipoPrc)) {
			List<DtoNMBBienAdjudicacion> bienes = proxyFactory.proxy(BienApi.class).getBienesAsuntoTipoPocedimiento(idAsunto, tipoPrc, true);
			map.put("bienes", bienes);
		}
		return BIENES_PROCEDIMIENTO_JSON;
	}

	@SuppressWarnings({ "unchecked" })
	@RequestMapping
	public String openGenericFormCustom(@RequestParam(value = "idAsunto", required = true) Long idAsunto, @RequestParam(value = "idsTareas", required = true) String idsTareas,
			@RequestParam(value = "nombreTipoProcedimiento", required = true) String nombreTipoProcedimiento, ModelMap map) {

		Procedimiento procedimiento = null;
		GenericForm genericForm = null;
		Map<String, Map<String, String>> valores = null;
		String errorValidacion = "";

		Set<Long> idsTareasExternas = new HashSet<Long>();
		Long idTareaExterna = null;

		String[] arrTareas = idsTareas.split(",");
		if (arrTareas.length > 0) {
			Map<String, Object> contexto = new HashMap<String, Object>();
			
			for (String strTareaId : arrTareas) {
				TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(Long.parseLong(strTareaId));
				if (!Checks.esNulo(tarea)) {
					procedimiento = tarea.getProcedimiento();
					if (Checks.esNulo(procedimiento)) {
						throw new FrameworkException("No se ha encontrado ningún procedimiento");
					}
					TareaExterna tareaExterna = tarea.getTareaExterna();
					if (Checks.esNulo(tareaExterna)) {
						throw new FrameworkException("No se ha encontrado ninguna tarea externa");
					}
					
					idTareaExterna = tareaExterna.getId();
					idsTareasExternas.add(idTareaExterna);
					
					if (!Checks.esNulo(procedimiento) && !Checks.esNulo(idTareaExterna)) {
						if (Checks.estaVacio(contexto)) { 
							try {
								contexto = jbpmManager.getContextoParaScript(procedimiento.getId(), idTareaExterna, tareaExterna.getTareaProcedimiento().getId());
							} catch (ClassNotFoundException e) {
								logger.error(e.getMessage());
							}
						}
						
						String errorValidacionTmp = validacionPreviaDeLaTarea(tareaExterna, procedimiento.getId(), contexto);
						if (!Checks.esNulo(errorValidacionTmp)) {
							errorValidacion += "Procedimiento " + procedimiento.getId() + " devuelve el siguiente mensaje:<br>" + errorValidacionTmp +"<br><br>";
						}
					} else {
						throw new FrameworkException("No se ha encontrado ninguna tarea activa");
					}						
				} else {
					throw new FrameworkException("La tarea '" + strTareaId + "' no es realizable por este usuario");
				}
			}
			
			
						
		} else {
			throw new FrameworkException("No se ha seleccionado ningún bien");
		}
		
		
		//Se saca fuera del bucle para solo obtener el genericForm una vez
		if (!Checks.esNulo(procedimiento) && !Checks.esNulo(idTareaExterna)) {
			Long idProcedimiento = procedimiento.getId();
			genericForm = (GenericForm) executor.execute("genericFormManager.get",idTareaExterna);
			if (errorValidacion.compareTo("")!=0) {
				genericForm.setErrorValidacion(errorValidacion);
			}
			valores = (Map<String, Map<String, String>>) executor.execute("genericFormManager.getValoresTareas",idProcedimiento);
		} else {
			throw new FrameworkException("No se ha encontrado ninguna tarea activa");
		}
		
		
		
		map.put("form", genericForm);
		map.put("valores", valores);
		map.put("idTarea", idTareaExterna);
		map.put("idsTareas", idsTareasExternas);

		return GENERIC_FORM_CUSTOM;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String saveValues(WebRequest request, ModelMap map) {
		String idTareaExterna = request.getParameter("idTarea");

		GenericForm genericForm = (GenericForm) executor.execute("genericFormManager.get",Long.valueOf(idTareaExterna.trim()));
		
		DtoGenericForm dto = rellenaDtoGenericForm(genericForm, request);
		try {
			executor.execute("genericFormManager.saveValues",dto);
		} 
		catch (FrameworkException e) {
			String txtProcedimientoError = "";
			if (!Checks.esNulo(genericForm) && !(Checks.esNulo(genericForm.getTareaExterna())) && !(Checks.esNulo(genericForm.getTareaExterna().getTareaPadre())) && !(Checks.esNulo(genericForm.getTareaExterna().getTareaPadre().getProcedimiento()))) {
				Procedimiento p = genericForm.getTareaExterna().getTareaPadre().getProcedimiento();
				txtProcedimientoError = "Procedimiento '" + p.getId() + "' devuelve el siguiente mensaje:\n";				
			}			
			map.put("msgError", txtProcedimientoError + StringEscapeUtils.unescapeHtml(StringUtils.substringBeforeLast(StringUtils.substringAfter(e.getMessage(), ">"), "<")) +"\n\n");
		}
		
		return RESPUESTA_JSON;
	}
	
	private DtoGenericForm rellenaDtoGenericForm(GenericForm genericForm, WebRequest request) {
		DtoGenericForm dto = new DtoGenericForm();
		
		dto.setForm(genericForm);
		
		List<GenericFormItem> formItems = genericForm.getItems();
		String[] values = new String[formItems.size()];
		
		for (int i=0;i<formItems.size();i++) {			
			values[i] = request.getParameter("values["+i+"]");
			if ((formItems.get(i).getType().compareTo("date")==0) && (!Checks.esNulo(values[i]))) {
				values[i] = values[i].replace("T00:00:00", "");
			}
			dto.setValues(values);
		}
		
		return dto;
	}
	
    private String validacionPreviaDeLaTarea(TareaExterna tareaExterna, Long idProcedimiento, Map<String, Object> contexto) {
        String script = tareaExterna.getTareaProcedimiento().getScriptValidacion();

        if (!StringUtils.isBlank(script)) {
            Long idTareaExterna = tareaExterna.getId();
            Long idTareaProcedimiento = tareaExterna.getTareaProcedimiento().getId();

            String result = null;
            try {
            	result = (String) jbpmManager.evaluaScriptPorContexto(idProcedimiento, idTareaExterna, idTareaProcedimiento , contexto, script);
            } catch (Exception e) {
                throw new UserException("Error en el script de decisión [" + script + "] para la tarea: " + idTareaExterna + " del procedimiento: "
                        + idProcedimiento);
            }
            return result;
        }
        return null;
    }
}