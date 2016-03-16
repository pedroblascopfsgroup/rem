package es.capgemini.pfs.arquetipo.dao;

import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author lgiavedo
 *
 */
public interface ArquetipoDao extends AbstractDao<Arquetipo, Long> {

    /**
     * buscarArquetipoPredefinido.
     *
     * @param personaId Long
     * @return arquetipo
     */
    Long buscarArquetipoPredefinido(Long personaId);

    int COL_ARQ_ID = 0;
    int COL_TIPO_PERSONA = 1;
    int COL_TIPO_SEGMENTO = 2;
    int COL_TIPO_CONTRATO = 3;
    int COL_DOMICILIO = 4;
    int COL_REINCIDENCIA = 5;
    int COL_RIESGO = 6;

    /**
     * Comprueba si el itinerario asociado al arquetipo es de recuperaci�n.
     * @param arquetipoId ID del arquetipo
     * @return Devuelve true si se encuentra en un arquetipo de recuperaci�n
     */
    Boolean isArquetipoRecuperacion(Long arquetipoId);
    
    /**
     * Devuelve el Arquetipo de un nombre concreto
     * @param nombre
     * @return
     */
    Arquetipo getArquetipoPorNombre(String nombre);
    
    /**
     * Devuelve el Arquetipo más actualizado de la persona con el id pasado como parámetro
     * @param idPersona ID de la persona
     * @return Devuelve el Arquetipo asociado a la persona 
     */
    Arquetipo getArquetipoPorPersona(Long idPersona);
    
    /**
     * Devuelve la lista de arquetipos de tipo recuperacion
     * @return
     */
    List<Arquetipo> getListRecuperacion();

    /**
     * Devuelve la lista de arquetipos de tipo seguimiento
     * @return
     */
	List<Arquetipo> getListSeguimiento();
	
    /**
     * Devuelve una lista con los arquetipos de gestión de deuda
     * @return
     */    
    List<Arquetipo> getListGestDeuda();	
}
