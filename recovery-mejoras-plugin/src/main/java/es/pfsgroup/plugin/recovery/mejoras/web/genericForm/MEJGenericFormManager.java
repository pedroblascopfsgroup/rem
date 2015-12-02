package es.pfsgroup.plugin.recovery.mejoras.web.genericForm;

import java.math.BigDecimal;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.dao.JuzgadoDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

@Service
public class MEJGenericFormManager extends
		BusinessOperationOverrider<GenericFormManagerApi> implements
		GenericFormManagerApi {

	private static final String OLD_VIEW = "generico/genericForm";
	private static final String NEW_VIEW = "plugin/mejoras/generico/genericForm";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	Executor executor;

	@Autowired
	private TareaExternaValorDao tareaExternaValorDao;

	@Autowired
	private JuzgadoDao juzgadoDao;

	@Autowired
	private ProcedimientoDao procedimientoDao;

	@Autowired
	private JBPMProcessManager jbpmManager;

	@Override
	@BusinessOperation(overrides = GET_GENERIC_FORM)
	public GenericForm get(Long id) {
		GenericForm form = parent().get(id);
		if (form != null) {
			if (OLD_VIEW.equals(form.getView())) {
				form.setView(NEW_VIEW);
			}
		}
		return form;
	}

	@BusinessOperation(overrides = GET_GENERIC_FORM_READ_ONLY)
	public GenericForm getReadOnly(Long id) {
		GenericForm form = parent().getReadOnly(id);
		if (form != null) {
			form.setView(NEW_VIEW);
		}
		return form;
	}
	
	@Override
	public String managerName() {
		return "genericFormManager";
	}

	/**
	 * Genera un vector de valores de las tareas del procedimiento
	 * 
	 * @param idProcedimiento
	 *            El procedimiento del cual se quiere extraer sus valores de
	 *            tareas
	 * @return Vector con los valores de los items de las tareas ->
	 *         valores['TramiteIntereses']['fecha']
	 */
	@BusinessOperation(overrides = "genericFormManager.getValoresTareas")
	public Map<String, Map<String, String>> getValoresTareas(
			Long idProcedimiento) {
		return jbpmManager.creaMapValores(idProcedimiento);
	}

	/**
	 * Guarda los valores de la pantalla gen�rica en bbdd
	 * 
	 * @param dto
	 * @throws Exception
	 */
	@Transactional(readOnly = false)
	@BusinessOperation(overrides = "genericFormManager.saveValues")
	public void saveValues(DtoGenericForm dto) throws Exception {

			String[] valores = dto.getValues();
			TareaExterna tarea = dto.getForm().getTareaExterna();

			TareaNotificacion tareaPadre = (TareaNotificacion) executor
					.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, tarea
							.getTareaPadre().getId());

			Procedimiento prc = tareaPadre.getProcedimiento();

			// List<TareaExternaValor> listaValores = new
			// ArrayList<TareaExternaValor>();
			for (int i = 0; i < valores.length; i++) {
				GenericFormItem item = dto.getForm().getItems().get(i);
				EXTTareaExternaValor valor = new EXTTareaExternaValor();
				valor.setTareaExterna(tarea);
				valor.setNombre(item.getNombre());
				String valorUnescape = HtmlUtils.htmlUnescape(valores[i]);
				valor.setValor(valorUnescape);
				// listaValores.add(valor);
				tareaExternaValorDao.saveOrUpdate(valor);

				String businessOperation = item.getValuesBusinessOperation();
				String tipoDato = item.getType();

				// Si tiene un combo de tipo juzgado, le seteamos al
				// procedimiento
				// el juzgado seleccionado
				if ("TipoJuzgado".equals(businessOperation)) {
					TipoJuzgado juzgado = juzgadoDao.getByCodigo(valores[i]);
					prc.setJuzgado(juzgado);
					procedimientoDao.saveOrUpdate(prc);
				}

				// si tiene un campo num�rico de principalDemanda, lo seteamos
				// al procedimiento
				if ("principalDemanda".equals(item.getNombre())) {
					prc.setSaldoRecuperacion(new BigDecimal(valores[i]));
					procedimientoDao.saveOrUpdate(prc);
				}

				// Si el tipo de dato es un n�mero de procedimiento lo seteamos
				// al
				// procedimiento
				else if ("textproc".equals(tipoDato)) {
					prc.setCodigoProcedimientoEnJuzgado(valores[i]);
					procedimientoDao.saveOrUpdate(prc);
				}

			}

			// Le insertamos los valores del formulario al BPM en una variable
			// de
			// Thread para que pueda recuperarlos
			jbpmManager.signalToken(tarea.getTokenIdBpm(),
					BPMContants.TRANSICION_AVANZA_BPM);
			
	}

}
