package es.pfsgroup.framework.paradise.agenda.formulario;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.pfsgroup.framework.paradise.agenda.api.GenericFormManagerApi;
import es.pfsgroup.framework.paradise.agenda.formulario.dao.ParadiseFormItemDao;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;


@Service
public class ParadiseFormManager implements GenericFormManagerApi{

    protected final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private JBPMProcessManagerApi jbpmManager;

    @Autowired
    private ParadiseFormItemDao genericFormItemDao;

    @Autowired
    private TareaExternaValorDao tareaExternaValorDao;

    @Autowired
    private TareaExternaManager tareaExternaManager;

    @Autowired
    private DictionaryManager dictionaryManager;

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
        form.setErrorValidacion(null);
        form.setTareaExterna(tareaExterna);

        List<GenericFormItem> items = genericFormItemDao.getByIdTareaProcedimiento(tareaExterna.getTareaProcedimiento().getId());
        form.setItems(items);
        
        obtenerValoresDeLosCombos(items);
        return form;
        
    }

    /**
     * Guarda los valores obtenidos del formulario genérico de tareas en bbdd y envía la señal de avanzar el trámite asociado a la tarea.
     *
     * @param dto dto con los datos que se guardan.
     */
    @Transactional
    public void save(DtoGenericForm dto) {
        String[] valores = dto.getValues();
        TareaExterna tarea = dto.getForm().getTareaExterna();

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
        //jbpmManager.signalToken(tarea.getTokenIdBpm(), BPMContants.TRANSICION_AVANZA_BPM);
    }    
    
    /**
     * Lanza la señal de avanzar el BPM asociado al token. El BPM avanza por la transición que se le indica.
     * @param idToken
     * @param transitionName
     */
    public void signalToken(final Long idToken, final String transitionName) {
    	jbpmManager.signalToken(idToken, transitionName);

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
