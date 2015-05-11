package es.capgemini.pfs.bpm.generic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;

/**
 * PONER JAVADOC FO.
 */
@Component
public class GenericUserDecisionActionHandler extends BaseActionHandler {
    private static final long serialVersionUID = 1L;

    @Autowired
    private SubtipoTareaDao subtipoTareaDao;

    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {

        String idSubtipoTarea = SubtipoTarea.CODIGO_TOMA_DECISION_BPM;
        String idTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO;
        String codigoPlazo = PlazoTareasDefault.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO;

        String descripcion = subtipoTareaDao.buscarPorCodigo(idSubtipoTarea).getDescripcionLarga();

        Long idBPM = tareaNotificacionManager.crearTareaConBPM(getProcedimiento().getId(), idTipoEntidad, idSubtipoTarea, codigoPlazo);
        Long idTarea = (Long) processUtils.getVariablesToProcess(idBPM, TareaBPMConstants.ID_TAREA);

        TareaNotificacion tn = tareaNotificacionManager.get(idTarea);
        tn.setDescripcionTarea(descripcion);
        tareaNotificacionManager.saveOrUpdate(tn);

        //Avanzamos BPM
        getExecutionContext().getToken().signal();
    }

}
