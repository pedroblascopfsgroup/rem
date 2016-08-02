package es.capgemini.pfs.itinerario;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.itinerario.dao.DDEstadoItinerarioDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Manager de DDEstadoItinerario.
 *
 */
@Service("estadoItinearioManager")
public class DDEstadoItinerarioManager {
    @Autowired
    private DDEstadoItinerarioDao ddEstadoItinerarioDao;

    /**
     * Devuelve la lista de estados.
     * @return la lista de estados
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_GET_ESTADOS)
    public List<DDEstadoItinerario> getEstados() {
        return ddEstadoItinerarioDao.getList();
    }

    /**
     * Devuelve la lista de estados para un expediente.
     * @return la lista de estados
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_GET_ESTADOS_EXPEDIENTES)
    public List<DDEstadoItinerario> getEstadosExpedientes(){
    	return ddEstadoItinerarioDao.findByEntidad(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
    }
    
    /**
     * devuelve los estados correspondientes a un tipo de entidad y un tipo de itinerario.
     * @param tipoEntidad el tipo de entidad y codigo del tipo de itinerario
     * @return la lista de estados
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_GET_ESTADOS_EXPEDIENTES_POR_TIPO_ITINERARIO)
    public List<DDEstadoItinerario> getEstadosItiExpedientesByTipoItinerario(String codigoTipoItinerario){
    	return ddEstadoItinerarioDao.findByEntidadAndTipoItinerario(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoTipoItinerario);
    }
    

    /**
     * Devuelve la lista de estados para un cliente.
     * @return la lista de estados
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_GET_ESTADOS_CLIENTES)
    public List<DDEstadoItinerario> getEstadosClientes(){
    	return ddEstadoItinerarioDao.findByEntidad(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
    }

    /**
     * Devuelve la lista de estados para un asunto.
     * @return la lista de estados
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_GET_ESTADOS_ASUNTOS)
    public List<DDEstadoItinerario> getEstadosAsuntos(){
    	return ddEstadoItinerarioDao.findByEntidad(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
    }

    /**
     * Devuelve la lista de estados.
     * @return la lista de estados
     */
    @BusinessOperation("DDEstadosItinerario")
    public List<DDEstadoItinerario> getDDEstadosItinerario() {
        return getEstados();
    }

    /**
     * @param codigo String
     * @return estado DDEstadoItinerario
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE)
    public DDEstadoItinerario findByCodigo(String codigo) {
        List<DDEstadoItinerario> estados = ddEstadoItinerarioDao.findByCodigo(codigo);
        if(estados.size()>0) {
            return estados.get(0);
        }
        return null;
    }
}
