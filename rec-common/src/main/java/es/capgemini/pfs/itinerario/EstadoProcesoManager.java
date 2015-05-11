package es.capgemini.pfs.itinerario;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.AsuntosManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.itinerario.dao.EstadoProcesoDao;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.EstadoProceso;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * manager de estado proceso.
 * @author jbosnjak
 *
 */
@Service
public class EstadoProcesoManager {

    @Autowired
    private Executor executor;
    @Autowired
    private EstadoProcesoDao estadoProcesoDao;
    @Autowired
    private ClienteManager clienteManager;
    @Autowired
    private ExpedienteManager expedienteManager;
    @Autowired
    private AsuntosManager asuntosManager;

    /**
     * get estado proceso.
     * @param id id de proceso
     * @return proceso
     */
    @BusinessOperation
    public EstadoProceso get(Long id) {
        return estadoProcesoDao.get(id);
    }

    /**
     * save.
     * @param estado estado
     * @return id
     */
    @BusinessOperation
    public Long save(EstadoProceso estado) {
        return estadoProcesoDao.save(estado);
    }

    /**
     * save.
     * @param estado estado
     */
    @BusinessOperation
    public void saveOrUpdate(EstadoProceso estado) {
        estadoProcesoDao.saveOrUpdate(estado);
    }

    /**
     * Agrega un nuevo estado.
     * @param entidad entidad
     * @param codigoTipoEntidad tipo entidad
     * @param estadoItinerario estadoItinerario
     * @param idBPM id bpm
     */
    @Transactional(readOnly = false)
    public void pasarDeEstado(Long entidad, String codigoTipoEntidad, Estado estadoItinerario, Long idBPM) {
        EstadoProceso estadoProceso = new EstadoProceso();
        if (estadoItinerario != null) {
            borrarEstadoProcesoActivo(entidad, codigoTipoEntidad);
            estadoProceso.setEstadoItinerario(estadoItinerario.getEstadoItinerario());
        } else {
            throw new BusinessOperationException("error de parametrizacion, estado itinerario inexistente");
        }
        estadoProceso.setFechaCambioEstado(new Date());
        estadoProceso.setProcesoBPM(idBPM);
        decodificarTipoEntidad(entidad, codigoTipoEntidad, estadoProceso);
        this.save(estadoProceso);
    }

    /**
     * Borra la entida de estadoProcesoDao activa.
     * @param entidad id
     * @param codigoTipoEntidad tipoEntidad
     */
    @Transactional(readOnly = false)
    public void borrarEstadoProcesoActivo(Long entidad, String codigoTipoEntidad) {
        EstadoProceso estadoProceso = estadoProcesoDao.buscarEstadoActivo(entidad, codigoTipoEntidad);
        if (estadoProceso == null) { return; }
        estadoProcesoDao.delete(estadoProceso);
    }

    /**
     * decofifica la entidad.
     * @param entidad entidad
     * @return entidaddecodificada
     */
    private void decodificarTipoEntidad(Long entidad, String codigoTipoEntidad, EstadoProceso estadoProceso) {
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(codigoTipoEntidad)) {
            DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                    DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);

            estadoProceso.setTipoEntidad(tipoEntidad);
            estadoProceso.setCliente(clienteManager.get(entidad));
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(codigoTipoEntidad)) {
            DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                    DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);

            estadoProceso.setTipoEntidad(tipoEntidad);
            estadoProceso.setExpediente(expedienteManager.getExpediente(entidad));
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codigoTipoEntidad)) {
            DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                    DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
            estadoProceso.setTipoEntidad(tipoEntidad);
            estadoProceso.setAsunto((Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, entidad));
            //estadoProceso.setAsunto(asuntosManager.get(entidad));
        }
    }
}
