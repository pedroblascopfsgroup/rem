package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.procesosJudiciales.EXTTareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoExportarDetalleDictarInstruccionesHistorico;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.ExportarHistoricoOperacionesManagerApi;

/**
 * Manager de exportaci�n de las operaciones del historico de los procedimientos
 * @author Guillem
 *
 */
@Component
public class ExportarHistoricoOperacionesManager extends AbstractEntityDao<GenericFormItem, Long> implements ExportarHistoricoOperacionesManagerApi{
	  
	  @Autowired
	  private EXTTareaExternaManager tareaExternaManager;
	  
	  @Autowired
	  private JBPMProcessManager jbpmManager;

	  @Autowired
	  private Executor executor;

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(HISTORICO_OPERACIONES_MANAGER_EXPORTAR_DICTARINSTRUCCIONES_HISTORICO)
	public DtoExportarDetalleDictarInstruccionesHistorico exportaOperacionDictarInstruccionesHistorico(Long id){		
		TareaExterna tareaExterna = tareaExternaManager.get(id);
		GenericForm form = new GenericForm();
		form.setView(tareaExterna.getTareaProcedimiento().getView());
		form.setErrorValidacion(validacionPreviaDeLaTarea(tareaExterna));
		// cambiar el dao por un manager
		// TareaNotificacion tarea = notificacionManager.get(id);
		form.setTareaExterna(tareaExterna);
		DetachedCriteria criteria = DetachedCriteria.forClass(GenericFormItem.class);
		criteria.add(Restrictions.eq("tareaProcedimiento.id", tareaExterna.getTareaProcedimiento().getId())).addOrder(Order.asc("order"));
		List<GenericFormItem> items = getHibernateTemplate().findByCriteria(criteria);
		form.setItems(items);
		obtenerValoresDeLosCombos(items);
		asignaValoresALosItems(items, tareaExterna);		
		DtoExportarDetalleDictarInstruccionesHistorico dto = new DtoExportarDetalleDictarInstruccionesHistorico();
		try{
			if(items.get(0) != null){
				dto.setMensaje(items.get(0).getLabel());
			}
			if(items.get(1) != null){
				dto.setTexto(items.get(1).getValue());
			}
		}catch(Throwable e){
			
		}
		return dto;
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

	/** 
	 * Obtiene el valor del elemento por nombre de la lista de valores
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
	 * Obtiene los valores que necesita un combo para configurarse a partir de
	 * una businessoperation
	 *
	 * @param items
	 */
	@SuppressWarnings("unchecked")
	private void obtenerValoresDeLosCombos(List<GenericFormItem> items) {
		List<Dictionary> values;
		for (GenericFormItem item : items) {
			if (StringUtils.isNotBlank(item.getValuesBusinessOperation())) {
				values = (List<Dictionary>) executor.execute("ComunBusinessOperation.BO_DICTIONARY_GET_LIST", item.getValuesBusinessOperation()) ;
			} else {
				values = new ArrayList<Dictionary>();
			}
			item.setValues(values);
		}
	}
	
    /** 
     * Ejecuta la validaci�n definida en la tarea. El script debe devolver null para continuar, o un string indicando el error a mostrar
     * @param tareaExterna
     */
    private String validacionPreviaDeLaTarea(TareaExterna tareaExterna) {
        String script = tareaExterna.getTareaProcedimiento().getScriptValidacion();
        if (!StringUtils.isBlank(script)) {
            Long idTareaExterna = tareaExterna.getId();
            Long idProcedimiento = tareaExterna.getTareaPadre().getProcedimiento().getId();
            String result = null;
            try {
                result = (String) jbpmManager.evaluaScript(idProcedimiento, idTareaExterna, tareaExterna.getTareaProcedimiento().getId(), null,
                        script);
            } catch (Exception e) {
                throw new UserException("Error en el script de decisi�n [" + script + "] para la tarea: " + idTareaExterna + " del procedimiento: "
                        + idProcedimiento);
            }
            return result;
        }
        return null;
    }
	
}
