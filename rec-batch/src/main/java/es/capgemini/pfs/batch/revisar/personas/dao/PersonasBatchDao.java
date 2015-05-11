package es.capgemini.pfs.batch.revisar.personas.dao;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Required;

/**
 * Clase que contiene los métodos de acceso a bbdd para la entidad Contratos.
 *
 * @author mtorrado
 *
 */

public interface PersonasBatchDao {

    /**
     * De los contratos indicado retorna la menor fecha de posición vendida, es
     * decir, la primera en el tiempo.
     */
    void realizaPrecalculosCarga();

    /**
     * Retorna el id del arquetipo calculado de la persona.
     *
     * @param personaId long
     * @return arquetipo
     */
    Long buscarArquetipoCalculado(Long personaId);

    /**
     * Recupera los IDs de las personas que deben generar cliente.
     * @return Listado de ids de persona
     */
    List<Long> buscarFuturosClientesSeguimiento();

    /**
     * Método que mueve a un histórico las prepolíticas actuales
     */
    void historificaPrepoliticas();
    
    /**
     * Recupera los IDs de las personas activas.
     * @return Listado de ids de persona
     */
    List<Long> buscarPersonasActivas();
    
    /**
     * Recupera los IDs de los contratos de una persona
     * @param perId
     * @return Listado de ids de contratos
     */
    List<Long> buscarContratos(Long perId);

    /*------------------------------
     * Setters
     *------------------------------*/

    /**
     * @param dataSource
     *            Base de datos
     */
    @Required
    void setDataSource(DataSource dataSource);

    /**
     * @param buscarFuturosClientesSeguimientoQuery the buscarFuturosClientesSeguimientoQuery to set
     */
    void setBuscarFuturosClientesSeguimientoQuery(String buscarFuturosClientesSeguimientoQuery);

    /**
     * @param buscarArquetipoCalculadoQuery the buscarArquetipoCalculadoQuery to set
     */
    void setBuscarArquetipoCalculadoQuery(String buscarArquetipoCalculadoQuery);

    /**
     * @param updateFormulasPrecalculoPersonaQuery the updateFormulasPrecalculoPersonaQuery to set
     */
    void setUpdateFormulasPrecalculoPersonaQuery(String updateFormulasPrecalculoPersonaQuery);

    /**
     * @param updateFormulasPrecalculoGrupoQuery the updateFormulasPrecalculoGrupoQuery to set
     */
    void setUpdateFormulasPrecalculoGrupoQuery(String updateFormulasPrecalculoGrupoQuery);

    /**
     * @param historificaPrepoliticasQuery the historificaPrepoliticasQuery to set
     */
    void setHistorificaPrepoliticasQuery(String historificaPrepoliticasQuery);
    
    void setBuscarPersonasActivasQuery(String buscarPersonasActivasQuery);
    
    void actualizarArquetiposPorCalculados();

}
