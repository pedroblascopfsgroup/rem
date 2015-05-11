package es.capgemini.pfs.batch.analisis.dao;

import java.util.Date;

import javax.sql.DataSource;

/**
* Clase que contiene los métodos de acceso a la bbdd para la entidad Mapa Global (resumen).
*
* @author lgiavedoni
*
*/
public interface ResumenDao {

    /**
     * Realiza el analisis de los datos según los argumentos indicados.
     * @param args Object[]
     * @return Long
     */
    Long realizarAnalisis(Object[] args);

    /**
     * Borra el analisis de externa para la fecha indicada.
     * @param fechaExtraccion Date
     * @return Long
     */
    Long borrarAnalisisExterna(Date fechaExtraccion);

    /**
     * Realiza el de externa analisis de los datos según los argumentos indicados.
     * @param args Object[]
     * @return Long
     */
    Long realizarAnalisisExterna(Object[] args);

    /**
     * Borra el analisis para la fecha indicada.
     * @param fechaExtraccion Date
     * @return Long
     */
    Long borrarAnalisis(Date fechaExtraccion);

    /**
     * @param dataSource the dataSource to set
     */
    void setDataSource(DataSource dataSource);

    /**
     * @param realizarAnalisisQuery the realizarAnalisisQuery to set
     */
    void setRealizarAnalisisQuery(String realizarAnalisisQuery);

    /**
     * @param borrarAnalisisQuery the borrarAnalisisQuery to set
     */
    void setBorrarAnalisisQuery(String borrarAnalisisQuery);

    /**
     * @param realizarAnalisisExternaQuery the realizarAnalisisExternaQuery to set
     */
    void setRealizarAnalisisExternaQuery(String realizarAnalisisExternaQuery);

    /**
     * @param borrarAnalisisExternaQuery the borrarAnalisisExternaQuery to set
     */
    void setBorrarAnalisisExternaQuery(String borrarAnalisisExternaQuery);
}