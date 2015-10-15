package es.capgemini.pfs.web.genericForm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.Token;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.embargoProcedimiento.EmbargoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.JuzgadoDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.capgemini.pfs.web.genericForm.dao.GenericFormDao;
import es.capgemini.pfs.web.genericForm.dao.GenericFormItemDao;
import es.pfsgroup.commons.utils.Checks;

@Service
public class GenericFormManager {

    protected final Log logger = LogFactory.getLog(getClass());

    @Autowired
    WebExecutor executor;

    @Autowired
    EmbargoProcedimientoManager embargoProcedimientoManager;

    @Autowired
    private JBPMProcessManager jbpmManager;

    @Autowired
    private ProcessManager processManager;

    @Autowired
    private GenericFormDao genericFormDao;

    @Autowired
    private GenericFormItemDao genericFormItemDao;

    @Autowired
    private JuzgadoDao juzgadoDao;

    @Autowired
    private ProcedimientoDao procedimientoDao;

    @Autowired
    private TareaExternaValorDao tareaExternaValorDao;

    @Autowired
    private TareaExternaManager tareaExternaManager;

    @Autowired
    private DictionaryManager dictionaryManager;

    @BusinessOperation
    public List<GenericForm> getByCodigoTipoProcedimiento(String codigo) {
        return genericFormDao.getByTipoProcedimiento(codigo);
    }

    /**
     * Genera un vector de valores de las tareas del procedimiento
     * @param idProcedimiento El procedimiento del cual se quiere extraer sus valores de tareas
     * @return Vector con los valores de los items de las tareas -> valores['TramiteIntereses']['fecha']
     */
    @BusinessOperation
    public Map<String, Map<String, String>> getValoresTareas(Long idProcedimiento) {
        return jbpmManager.creaMapValores(idProcedimiento);
    }

	/**
     * Obtiene un formulario dinamico a partir del id de una tarea Externa
     *
     * @param id
     * @return GenericForm
     */
    @BusinessOperation
    public GenericForm get(Long id) {
    	return getForm(id, false);
    }
    
	/**
     * Obtiene un formulario dinamico en SÓLO LECTURA a partir del id de una tarea Externa
     *
     * @param id
     * @return GenericForm
     */
    @BusinessOperation
    public GenericForm getReadOnly(Long id) {
    	return getForm(id, true);
    }
    
    /**
     * Obtiene un formulario dinamico a partir del id de una tarea Externa, devuelve el modo de pintado solicitado.
     *
     * @param id
     * @return GenericForm
     */
    @BusinessOperation
    public GenericForm getForm(Long id, boolean readOnly) {
        TareaExterna tareaExterna = tareaExternaManager.get(id);

        GenericForm form = new GenericForm();
        form.setReadOnly(readOnly);
        
        // En modo consulta no ponemos vista, ni validación BPMs (para Hisorico)
        if (!form.isReadOnly()) {
            form.setView(tareaExterna.getTareaProcedimiento().getView());
        	form.setErrorValidacion(validacionPreviaDeLaTarea(tareaExterna));
        }
        
        // cambiar el dao por un manager
        // TareaNotificacion tarea = notificacionManager.get(id);
        form.setTareaExterna(tareaExterna);

        List<GenericFormItem> items = genericFormItemDao.getByIdTareaProcedimiento(tareaExterna.getTareaProcedimiento().getId());
        form.setItems(items);

        obtenerValoresDeLosCombos(items);
        asignaValoresALosItems(items, tareaExterna);

        return form;
    }

    /** Ejecuta la validaciÃ¯Â¿Â½n definida en la tarea. El script debe devolver null para continuar, o un string indicando el error a mostrar
     * @param tareaExterna
     */
    private String validacionPreviaDeLaTarea(TareaExterna tareaExterna) {
        String script = tareaExterna.getTareaProcedimiento().getScriptValidacion();

        //script = "!isEmbargosConFechaSolicitud() ? 'Antes de realizar la tarea es necesario marcar los bienes con fecha de solicitud de embargo' : null";
        //script = "isEmbargosConFechaDecreto() && !isEmbargosConFechaRegistro() ? 'Antes de realizar la tarea es necesario marcar los bienes con fecha de registro de embargo' : null";

        if (!StringUtils.isBlank(script)) {
            Long idTareaExterna = tareaExterna.getId();
            Long idProcedimiento = tareaExterna.getTareaPadre().getProcedimiento().getId();

            //            Map<String, Object> params = jbpmUtils.creaContextoParaScript(idProcedimiento, idTareaExterna);
            //
            //            String scriptAmpliado = params.get(BPMContants.FUNCIONES_GLOBALES_SCRIPT) + script;
            //            return (String) evaluator.evaluate(scriptAmpliado, params);

            String result = null;
            try {
                result = (String) jbpmManager.evaluaScript(idProcedimiento, idTareaExterna, tareaExterna.getTareaProcedimiento().getId(), null,
                        script);
            } catch (Exception e) {
                throw new UserException("Error en el script de decisiÃ³n [" + script + "] para la tarea: " + idTareaExterna + " del procedimiento: "
                        + idProcedimiento);
            }
            return result;
        }
        return null;
    }

    private void asignaValoresALosItems(List<GenericFormItem> items, TareaExterna tareaExterna) {
        List<TareaExternaValor> valores = tareaExterna.getValores();
        for (GenericFormItem item : items) {

            //Recuperamos el valor guardado de la pantalla
            String valorGuardado = getValueFrom(valores, item.getNombre());

            //Si tiene valor guardado, le seteamos ese valor
            if (valorGuardado != null)
                item.setValue(valorGuardado);

            //Si no tiene valor guardado, comprobamos si tiene valor inicial y se lo seteamos
            else {
                String scriptValorInicial = item.getValue();
                if (!StringUtils.isBlank(scriptValorInicial)) {
                    try {
                        Object result = jbpmManager.evaluaScript(tareaExterna.getTareaPadre().getProcedimiento().getId(), tareaExterna.getId(),
                                tareaExterna.getTareaProcedimiento().getId(), null, scriptValorInicial);

                        if (result != null) {
                            item.setValue(result.toString());
                        } else {
                            item.setValue("");
                        }
                    } catch (Exception e) {
                        logger.error("Error al ejecutar el script de valor inicial [" + scriptValorInicial + "] de la tareaExterna: "
                                + tareaExterna.getId() + " y del procedimiento: " + tareaExterna.getTareaPadre().getProcedimiento().getId(), e);
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
        for (TareaExternaValor valor : valores) {
            if (nombre.equals(valor.getNombre())) { return valor.getValor(); }
        }
        return null;
    }

    /**
     * Guarda los valores de la pantalla genÃ¯Â¿Â½rica en bbdd
     *
     * @param dto
     */
    @Transactional
    @BusinessOperation
    public void saveValues(DtoGenericForm dto) {
        String[] valores = dto.getValues();
        TareaExterna tarea = dto.getForm().getTareaExterna();

        TareaNotificacion tareaPadre = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, tarea.getTareaPadre().getId());

        Procedimiento prc = tareaPadre.getProcedimiento();

        //List<TareaExternaValor> listaValores = new ArrayList<TareaExternaValor>();
        for (int i = 0; i < valores.length; i++) {
            GenericFormItem item = dto.getForm().getItems().get(i);
            TareaExternaValor valor = new TareaExternaValor();
            valor.setTareaExterna(tarea);
            valor.setNombre(item.getNombre());
            valor.setValor(valores[i]);
            //listaValores.add(valor);
            tareaExternaValorDao.saveOrUpdate(valor);

            String businessOperation = item.getValuesBusinessOperation();
            String tipoDato = item.getType();

            //Si tiene un combo de tipo juzgado, le seteamos al procedimiento el juzgado seleccionado
            if ("TipoJuzgado".equals(businessOperation)) {
                TipoJuzgado juzgado = juzgadoDao.getByCodigo(valores[i]);
                prc.setJuzgado(juzgado);
                procedimientoDao.saveOrUpdate(prc);
            }

            //Si el tipo de dato es un nÃºmero de procedimiento lo seteamos al procedimiento
            else if ("textproc".equals(tipoDato)) {
                prc.setCodigoProcedimientoEnJuzgado(valores[i]);
                procedimientoDao.saveOrUpdate(prc);
            }

        }

        //Le insertamos los valores del formulario al BPM en una variable de Thread para que pueda recuperarlos
        jbpmManager.signalToken(tarea.getTokenIdBpm(), BPMContants.TRANSICION_AVANZA_BPM);
    }

    @BusinessOperation
    public Map<String, Object> execute(DtoGenericForm form) {
        Map<String, Object> result = new HashMap<String, Object>();
        if ("start".equals(form.getValues()[1])) {
            long id = jbpmManager.crearNewProcess("generic", new HashMap<String, Object>());
        }

        if ("signal".equals(form.getValues()[1])) {
            long processId = Long.parseLong(form.getValues()[2]);
            jbpmManager.signalProcess(processId, form.getValues()[3]);

        }

        if ("token".equals(form.getValues()[1])) {
            long processId = Long.parseLong(form.getValues()[2]);
            signalToken(processId, form.getValues()[3]);
        }

        return result;

    }

    public void signalToken(final Long idToken, final String transitionName) {
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la Ã¯Â¿Â½ltima instancia conocida
                Token token = context.getGraphSession().getToken(idToken);
                if (transitionName == null) {
                    token.signal();
                } else {
                    token.signal(transitionName);
                }
                return null;
            }
        });
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
