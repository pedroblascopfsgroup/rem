package es.capgemini.pfs.batch.revisar.antecedentes.dao;

import java.util.Date;

import javax.sql.DataSource;

/**
 * Clase que contiene métodos de acceso a bbdd para la entidad Antecedente.
 *
 * @author mtorrado
 *
 */
public interface AntecedentesBatchDao{


   /**
    * Actualizar el antecedente interno indicado.
    *
    * @param posIrregular posición irregular máxima
    * @param diasIrregular cantidad máxima de dias en falta
    * @param fechaExtraccion Date
    * @param contratoId id del contrato
    */
    void actualizarAntecedenteInterno(Long contratoId, Double posIrregular, Long diasIrregular, Date fechaExtraccion);

   /**
    * Retorna el id del antecedente de la persona indicada.
    *
    * @param personaId
    *            id
    * @return id del antecedente
    */
    Long buscarAntecedente(Long personaId);

   /**
    * Retorna el id del antecedente interno del contrato.
    *
    * @param contratoId
    *            id
    * @return Long: id del antecedente interno, o <code>null</code> si no hay
    *         registro
    */
    Long buscarAntecedenteInterno(Long contratoId);

   /**
    * Genera una entrada base en la tabla de antecedentes y la setea a la
    * persona.
    *
    * @param personaId
    *            id
    */
    void generarAntecedenteBase(Long personaId);

   /**
    * Genera un antecedente interno para el contrato indicado.
    *
    * @param cntId
    *            id del contrato
    * @param posIrregularMax
    *            posición irregular máxima
    * @param diasIrregularMax
    *            máxima cantidad de dias en falta
    * @param fechaExtraccion
    *            date
    */
    void generarAntecedenteInterno(Long cntId, Double posIrregularMax, Long diasIrregularMax, Date fechaExtraccion);

   /**
    * Incrementa en 1 la cantindad de reincidencias del antecendete indicado.
    *
    * @param contratoId id
    */
    void incrementarReincidencia(Long contratoId);

   /**
    * @param dataSource
    *            Base de datos
    */
    void setDataSource(DataSource dataSource);

   /**
    * @param updateAntecedenteInternoQuery
    *            the updateAntecedenteInternoQuery to set
    */
    void setUpdateAntecedenteInternoQuery(String updateAntecedenteInternoQuery);

   /**
    * @param buscarAntecedentePersonaQuery
    *            the buscarAntecedentePersonaQuery to set
    */
    void setBuscarAntecedentePersonaQuery(String buscarAntecedentePersonaQuery);

   /**
    * @param buscarAntecendeteInternoQuery
    *            the buscarAntecendeteInternoQuery to set
    */
    void setBuscarAntecendeteInternoQuery(String buscarAntecendeteInternoQuery);

   /**
    * @param buscarUltimoAntecedenteQuery
    *            the buscarUltimoAntecedenteQuery to set
    */
    void setBuscarUltimoAntecedenteQuery(String buscarUltimoAntecedenteQuery);

   /**
    * @param insertarNuevoAntecedenteQuery
    *            the insertarNuevoAntecedenteQuery to set
    */
    void setInsertarNuevoAntecedenteQuery(String insertarNuevoAntecedenteQuery);

   /**
    * @param updateAntecedenteEnPersonaQuery
    *            the updateAntecedenteEnPersonaQuery to set
    */
    void setUpdateAntecedenteEnPersonaQuery(String updateAntecedenteEnPersonaQuery);

   /**
    * @param insertarNuevoAntecedenteInternoQuery
    *            the insertarNuevoAntecedenteInternoQuery to set
    */
    void setInsertarNuevoAntecedenteInternoQuery(String insertarNuevoAntecedenteInternoQuery);

   /**
    * @param incrementarAntecedenteQuery
    *            the incrementarAntecedenteQuery to set
    */
    void setIncrementarAntecedenteQuery(String incrementarAntecedenteQuery);

}
