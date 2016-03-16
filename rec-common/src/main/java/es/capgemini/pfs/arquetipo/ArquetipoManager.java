package es.capgemini.pfs.arquetipo;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.arquetipo.dao.ArquetipoDao;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * @author lgiavedo
 *
 */
@Service
public class ArquetipoManager {

    @Autowired
    private ArquetipoDao arquetipoDao;
    @Autowired
    private Executor executor;

    /**
     * Retorna el arquetipo que corresponde al id indicado.
     * @param id arquetipo id
     * @return arquetipo
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET)
    public Arquetipo get(Long id) {
        return arquetipoDao.get(id);
    }

    /**
     * Retorna el arquetipo calculado de una persona
     * @param persona Persona del arquetipo
     * @return arquetipo
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_ARQUETIPO_CALCULADO_WITH_ESTADO)
    @Transactional
    public Arquetipo getArquetipoCalculadoWithEstado(Persona persona) {
        if (persona.getArquetipoCalculado() == null) return null;

        Arquetipo a = arquetipoDao.get(persona.getArquetipoCalculado());
        if (a.getItinerario() != null) Hibernate.initialize(a.getItinerario().getEstados());
        return a;
    }

    /**
     * Retorna el arquetipo que corresponde al id indicado.
     * @param id arquetipo id
     * @return arquetipo
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_WITH_ESTADO)
    @Transactional
    public Arquetipo getWithEstado(Long id) {
        Arquetipo a = arquetipoDao.get(id);
        if (a.getItinerario() != null) Hibernate.initialize(a.getItinerario().getEstados());
        return a;
    }

    /**
     * Calcula y retorna el arquetipo que corresponde de la persona indicada
     * como par�metro.
     *
     * @param personaId id
     * @return arquetipo id
     */
    @Transactional(readOnly = false)
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_CALCULAR_ARQUETIPO)
    public Long calcularArquetipo(Long personaId) {

        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET_WITH_CONTRATOS, personaId);
        if (persona != null) {
            return persona.getArquetipo() != null ? persona.getArquetipo() : persona.getArquetipoCalculado();
        } else {
            return -1L;
        }
    }

    /**
     * Comprueba si el itinerario asociado al arquetipo es de recuperaci�n.
     * @param arquetipoId ID del arquetipo
     * @return Devuelve true si se encuentra en un arquetipo de recuperaci�n
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_IS_ARQUETIPO_RECUPERACION)
    public Boolean isArquetipoRecuperacion(Long arquetipoId) {
        return arquetipoDao.isArquetipoRecuperacion(arquetipoId);
    }

    /**
     * Recupera todos los arqueptipos.
     * @return lista
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_GET_LIST)
    public List getList() {
        return arquetipoDao.getList();
    }

    /**
     * Recupera el arquetipo del nombre pasado por parametro.
     * @return Arquetipo
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_BY_NOMBRE)
    public Arquetipo getByNombre(String nombreArquetipo) {
        return arquetipoDao.getArquetipoPorNombre(nombreArquetipo);
    }
    
    /**
     * Recupera el arquetipo de recuperación de la persona pasada como parámetro
     * @return Arquetipo
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_RECUPERACION_BY_PERSONA)
    public Arquetipo getArquetipoRecuperacionByPersonaId(Long id) {
    	Arquetipo arquetipo = arquetipoDao.getArquetipoPorPersona(id);
        return arquetipo;
    }

    /**
     * Devuelve una lista con los arquetipos de recuperacion
     * @return
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_LIST_RECUPERACION) 
    public List<Arquetipo> getListRecuperacion() {
    	return arquetipoDao.getListRecuperacion();
    }
    
    /**
     * Devuelve una lista con los arquetipos de seguimiento
     * @return
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_LIST_SEGUIMIENTO) 
    public List<Arquetipo> getListSeguimiento() {
    	return arquetipoDao.getListSeguimiento();
    }
    
    /**
     * Devuelve una lista con los arquetipos de gestión de deuda
     * @return
     */    
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_LIST_GESTDEUDA)
    public List<Arquetipo> getListGestDeuda() {
    	return arquetipoDao.getListGestDeuda();
    }
    
}
