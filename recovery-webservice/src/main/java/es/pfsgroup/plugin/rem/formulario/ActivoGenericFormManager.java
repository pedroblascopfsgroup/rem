package es.pfsgroup.plugin.rem.formulario;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
//import es.pfsgroup.plugin.rem.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.plugin.rem.api.ActivoGenericFormManagerApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.formulario.dao.ActivoGenericFormItemDao;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoScriptExecutorApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajo;

@Service
public class ActivoGenericFormManager implements ActivoGenericFormManagerApi{

	public static final String TIPO_CAMPO_INFORMATIVO = "textinf";
	public static final String TIPO_CAMPO_FECHA = "date";
	public static final String TIPO_CAMPO_HORA = "time";
	public static final String TIPO_COMBOBOX_INICIAL = "comboini";
	
    protected final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private JBPMProcessManagerApi jbpmManager;
    
    @Autowired
    private JBPMActivoScriptExecutorApi jbpmScriptExecutorApi;
    
    @Autowired
    private JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;

    @Autowired
    private ActivoGenericFormItemDao genericFormItemDao;

    @Autowired
    private TareaExternaValorDao tareaExternaValorDao;

    @Autowired
    private TareaExternaManager tareaExternaManager;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private DictionaryManager dictionaryManager;

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private PreciosApi preciosApi;
    
    /**
     * Genera un vector de valores de las tareas del idTramite
     * @param idTramite El trámite del cual se quiere extraer sus valores de tareas
     * @return Vector con los valores de los items de las tareas -> valores['TramiteIntereses']['fecha']
     */
    public Map<String, Map<String, String>> getValoresTareas(Long idTramite) {
        return jbpmActivoTramiteManagerApi.creaMapValores(idTramite);
    }
    
    /**
     * Obtiene un formulario dinamico a partir del id de una tarea Externa
     *
     * @param idTareaExterna
     * @return GenericForm
     */
    public GenericForm getForm(Long idTareaExterna) {
    	return this.get(idTareaExterna);
    }
    
    /**
     * Obtiene un formulario dinamico a partir del id de una tarea Externa
     *
     * @param idTareaExterna id. de la tarea externa
     * @return GenericForm devuelve el formulario asociado a la tarea externa.
     */
    public GenericForm get(Long idTareaExterna) {
        TareaExterna tareaExterna = tareaExternaManager.get(idTareaExterna);

        GenericForm form = new GenericForm();

        form.setView(tareaExterna.getTareaProcedimiento().getView());
        form.setErrorValidacion(validacionPreviaDeLaTarea(tareaExterna));
        // cambiar el dao por un manager
        // TareaNotificacion tarea = notificacionManager.get(id);
        form.setTareaExterna(tareaExterna);

        List<GenericFormItem> items = genericFormItemDao.getByIdTareaProcedimiento(tareaExterna.getTareaProcedimiento().getId());
        form.setItems(items);

        //obtenerValoresDeLosCombos(items);
        asignaValoresALosItems(items, tareaExterna); //Comentado para la demo, usa métodos de procedimientos.

        return form;
    }
    
    /**
     * Guarda los valores obtenidos del formulario genérico de tareas en bbdd y envía la señal de avanzar el trámite asociado a la tarea.
     *
     * @param dto dto con los datos que se guardan.
     */
    @Transactional
    public void saveValues(DtoGenericForm dto) {
        String[] valores = dto.getValues();
        TareaExterna tarea = dto.getForm().getTareaExterna();

        //TareaNotificacion tareaPadre = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, tarea.getTareaPadre().getId());

        //Procedimiento prc = tareaPadre.getProcedimiento();

        //List<TareaExternaValor> listaValores = new ArrayList<TareaExternaValor>();
        for (int i = 0; i < valores.length; i++) {
            GenericFormItem item = dto.getForm().getItems().get(i);
            TareaExternaValor valor = new TareaExternaValor();
            valor.setTareaExterna(tarea);
            valor.setNombre(item.getNombre());
            valor.setValor(valores[i]);
            //listaValores.add(valor);
            tareaExternaValorDao.saveOrUpdate(valor);

        }

        //Le insertamos los valores del formulario al BPM en una variable de Thread para que pueda recuperarlos
        jbpmManager.signalToken(tarea.getTokenIdBpm(), BPMContants.TRANSICION_AVANZA_BPM);
    }    
    
    /**
     * Lanza la señal de avanzar el BPM asociado al token. El BPM avanza por la transición que se le indica.
     * @param idToken
     * @param transitionName
     */
    public void signalToken(final Long idToken, final String transitionName) {
    	jbpmManager.signalToken(idToken, transitionName);

    }

    /** Ejecuta la validación definida en la tarea. El script debe devolver null para continuar, o un string indicando el error a mostrar
     * @param tareaExterna
     */
    private String validacionPreviaDeLaTarea(TareaExterna tareaExterna) {
        String script = tareaExterna.getTareaProcedimiento().getScriptValidacion();

        //script = "!isEmbargosConFechaSolicitud() ? 'Antes de realizar la tarea es necesario marcar los bienes con fecha de solicitud de embargo' : null";
        //script = "isEmbargosConFechaDecreto() && !isEmbargosConFechaRegistro() ? 'Antes de realizar la tarea es necesario marcar los bienes con fecha de registro de embargo' : null";

        if (!StringUtils.isBlank(script)) {
            Long idTareaExterna = tareaExterna.getId();
            //Long idProcedimiento = tareaExterna.getTareaPadre().getProcedimiento().getId();
            Long idTramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite().getId();

            //            Map<String, Object> params = jbpmUtils.creaContextoParaScript(idProcedimiento, idTareaExterna);
            //
            //            String scriptAmpliado = params.get(BPMContants.FUNCIONES_GLOBALES_SCRIPT) + script;
            //            return (String) evaluator.evaluate(scriptAmpliado, params);

            String result = null;
            try {
                result = (String) jbpmScriptExecutorApi.evaluaScript(idTramite, idTareaExterna, tareaExterna.getTareaProcedimiento().getId(), null,
                        script);
            } catch (Exception e) {
                throw new UserException("Error en el script de decisión [" + script + "] para la tarea: " + idTareaExterna + " del trámite: "
                        + idTramite);
            }
            return result;
        }
        return null;
    }

    
    //TODO: Hay que refactorizar este método.
    private void asignaValoresALosItems(List<GenericFormItem> items, TareaExterna tareaExterna) {
        List<TareaExternaValor> valores = tareaExterna.getValores();
        for (GenericFormItem item : items) {

            //Recuperamos el valor guardado de la pantalla
            String valorGuardado = getValueFrom(valores, item.getNombre());

            //Si tiene valor guardado, le seteamos ese valor
            if (valorGuardado != null)
                item.setValue(valorGuardado);
            //Si no tiene valor guardado, comprobamos si es algún campo con carga inicial, y le seteamos el valor correspondiente
            else{
            	if(item.getType().equals(TIPO_CAMPO_INFORMATIVO))
            	{
            		if(item.getNombre().equals("saldoDisponible"))
            		{
            			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo", ((TareaActivo) tareaExterna.getTareaPadre()).getActivo().getId().toString());
            			List<VBusquedaActivosTrabajo> lista = genericDao.getList(VBusquedaActivosTrabajo.class, filtroActivo);
            			if(!Checks.estaVacio(lista))
            				item.setValue(lista.get(0).getSaldoDisponible() + "€");
            		}
            		if(item.getNombre().equals("nombrePropuesta"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			PropuestaPrecio propuesta = preciosApi.getPropuestaByTrabajo(tramite.getTrabajo().getId());
            			if(!Checks.esNulo(propuesta)) {
	            			String nombrePropuesta = propuesta.getNombrePropuesta();
	            		    if(!Checks.esNulo(nombrePropuesta))
	            		    	item.setValue(nombrePropuesta);
            			}
            		}
            	}
            	if(item.getType().equals(TIPO_CAMPO_INFORMATIVO))
            	{
            		if(item.getNombre().equals("comite"))
            		{
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if (!Checks.esNulo(expediente))
            					if(!Checks.esNulo(expediente.getComiteSancion()))
            						item.setValue(expediente.getComiteSancion().getDescripcion());
            			}
            		}
            	}
            	if(item.getType().equals(TIPO_CAMPO_FECHA))
            	{
            		if(item.getNombre().equals("fechaTope"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			Date fecha = trabajo.getFechaTope();
            			SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            			if(!Checks.esNulo(fecha))
            				item.setValue(formatoFecha.format(fecha));
            		}
            		if(item.getNombre().equals("fechaConcreta"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			Date fecha = trabajo.getFechaHoraConcreta();
            		    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            		    if(!Checks.esNulo(fecha))
            		    	item.setValue(formatoFecha.format(fecha));
            		}
            		if(item.getNombre().equals("fechaGeneracion"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			PropuestaPrecio propuesta = preciosApi.getPropuestaByTrabajo(tramite.getTrabajo().getId());
            			if(!Checks.esNulo(propuesta)) {
	            			Date fecha = propuesta.getFechaEmision();
	            		    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
	            		    if(!Checks.esNulo(fecha))
	            		    	item.setValue(formatoFecha.format(fecha));
            			}
            		}
            	}
            	if(item.getType().equals(TIPO_CAMPO_HORA))
            	{
            		if(item.getNombre().equals("horaConcreta"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			Date fecha = trabajo.getFechaHoraConcreta();
            			SimpleDateFormat formatoHora = new SimpleDateFormat("HH:mm");
            		    if(!Checks.esNulo(fecha))
            		    	item.setValue(formatoHora.format(fecha));
            		}
            	}
            	if(item.getType().equals(TIPO_COMBOBOX_INICIAL))
            	{
            		if(item.getNombre().equals("comboTarifa"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			trabajo.getActivo().getCartera();
            			Filter filtroSubtipoTrabajo = genericDao.createFilter(FilterType.EQUALS, "subtipoTrabajo", trabajo.getSubtipoTrabajo());
            			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera", trabajo.getActivo().getCartera());
            			if(genericDao.getList(ConfiguracionTarifa.class, filtroSubtipoTrabajo, filtroCartera).isEmpty())
            				item.setValue(DDSiNo.NO);
            			else
            				item.setValue(DDSiNo.SI);
            		}
            	}
            }
        }
    }

    /** Obtiene el valor del elemento por nombre de la lista de valores
     * @param valores
     * @param nombre
     * @return
     */
    private String getValueFrom(List<TareaExternaValor> valores, String nombre) {
    	if (nombre != null){
	        for (TareaExternaValor valor : valores) {
	            if (nombre.equals(valor.getNombre())) { return valor.getValor(); }
	        }
    	}
        return null;
    }
    
    /**
     * Obtiene los valores que necesita un combo para configurarse a partir de
     * una businessoperation
     *
     * @param items
     */
    @SuppressWarnings("unchecked")
    private void obtenerValoresDeLosCombos(List<GenericFormItem> items) {
        List values;
        for (GenericFormItem item : items) {
            if (StringUtils.isNotBlank(item.getValuesBusinessOperation())) {
                values = dictionaryManager.getList(item.getValuesBusinessOperation());
            } else {
                values = new ArrayList();
            }
            item.setValues(values);
        }
    }

}
