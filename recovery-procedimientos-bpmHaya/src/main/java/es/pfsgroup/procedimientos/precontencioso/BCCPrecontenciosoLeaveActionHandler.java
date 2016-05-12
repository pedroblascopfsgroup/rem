package es.pfsgroup.procedimientos.precontencioso;

import java.math.BigDecimal;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.ext.turnadoProcuradores.TurnadoProcuradoresApi;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;

public class BCCPrecontenciosoLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	private Executor executor;

	@Autowired
	UsuarioManager usuarioManager;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	TurnadoProcuradoresApi turnadoProcuradoresApi;

	private final String TAP_REDACTAR_DEMANDA = "HC106_RedactarDemandaAdjuntarDocu";

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		Procedimiento procedimiento = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);

		personalizacionTarea(procedimiento, tex);

	}

	@SuppressWarnings("unchecked")
	@Transactional
	private void personalizacionTarea(Procedimiento procedimiento, TareaExterna tex) {

		if (tex != null && tex.getTareaProcedimiento() != null && TAP_REDACTAR_DEMANDA.equals(tex.getTareaProcedimiento().getCodigo())) {

			List<EXTTareaExternaValor> listado = (List<EXTTareaExternaValor>) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA, tex.getId());

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("principal".equals(tev.getNombre())) {
							procedimiento.setSaldoRecuperacion(new BigDecimal(tev.getValor()));
						}
					} catch (Exception e) {
						logger.error("personalizacionTarea: " + e);
					}
				}
			}

			genericDao.save(Procedimiento.class, procedimiento);

			// Llamamos al turnado de procuradores siempre y cuando se haya
			// detectado diferencia entre lo propuesto y lo asignado
			// actualmente, ya que el usuario puede haber cambiado el procurador
			// asignado manualmente
			
			if(turnadoProcuradoresApi.comprobarSiLosDatosHanSidoCambiados(procedimiento.getId())){
				try {
					turnadoProcuradoresApi.turnarProcurador(procedimiento.getId(), usuarioManager.getUsuarioLogado().getUsername());
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (AplicarTurnadoException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
