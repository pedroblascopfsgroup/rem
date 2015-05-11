package es.capgemini.pfs.batch.revisar.antecedentes.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.revisar.antecedentes.dao.AntecedentesBatchDao;

/**
 * Clase que contiene métodos de acceso a bbdd para la entidad Antecedente.
 *
 * @author mtorrado
 *
 */
//@Repository("AntecedentesBatchDao")
public class AntecedentesBatchDaoImpl implements AntecedentesBatchDao{

   private final Log logger = LogFactory.getLog(getClass());
   private DataSource dataSource;
   private String updateAntecedenteInternoQuery;
   private String buscarAntecedentePersonaQuery;
   private String buscarAntecendeteInternoQuery;
   private String buscarUltimoAntecedenteQuery;
   private String insertarNuevoAntecedenteQuery;
   private String updateAntecedenteEnPersonaQuery;
   private String insertarNuevoAntecedenteInternoQuery;
   private String incrementarAntecedenteQuery;

   /**
    * Actualizar el antecedente interno indicado.
    *
    * @param posIrregular posición irregular máxima
    * @param diasIrregular cantidad máxima de dias en falta
    * @param fechaExtraccion Date
    * @param contratoId id del contrato
    */
   public void actualizarAntecedenteInterno(Long contratoId, Double posIrregular, Long diasIrregular, Date fechaExtraccion) {
      SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
      Object[] args = { posIrregular,
                        posIrregular,
                        diasIrregular,
                        diasIrregular,
                        df.format(fechaExtraccion),
                        contratoId };
      JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
      jdbcTemplate.update(updateAntecedenteInternoQuery, args);
      logger.debug("Se actualizó el antecedente interno para el contrato con id: " + contratoId);
   }

   /**
    * Retorna el id del antecedente de la persona indicada.
    *
    * @param personaId
    *            id
    * @return id del antecedente
    */
   public Long buscarAntecedente(Long personaId) {
      JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
      return (Long) jdbcTemplate.queryForObject(buscarAntecedentePersonaQuery, new Object[] { personaId }, Long.class);

   }

   /**
    * Retorna el id del antecedente interno del contrato.
    *
    * @param contratoId
    *            id
    * @return Long: id del antecedente interno, o <code>null</code> si no hay
    *         registro
    */
   public Long buscarAntecedenteInterno(Long contratoId) {
      JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
      try {
         return (Long) jdbcTemplate.queryForObject(buscarAntecendeteInternoQuery, new Object[] { contratoId }, Long.class);
      } catch (EmptyResultDataAccessException e) {
         return null;
      }
   }

   /**
    * Genera una entrada base en la tabla de antecedentes y la setea a la
    * persona.
    *
    * @param personaId
    *            id
    */
   public void generarAntecedenteBase(Long personaId) {
      JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

      jdbcTemplate.execute(insertarNuevoAntecedenteQuery);
      Long antecedente = (Long) jdbcTemplate.queryForObject(buscarUltimoAntecedenteQuery, Long.class);

      Object[] argsUpdateAntecedenteEnPersona = { antecedente, personaId };

      jdbcTemplate.update(updateAntecedenteEnPersonaQuery, argsUpdateAntecedenteEnPersona);
      logger.debug("Se generó un antecendete base para la persona con id: " + personaId);
   }

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
   public void generarAntecedenteInterno(Long cntId, Double posIrregularMax, Long diasIrregularMax, Date fechaExtraccion) {
      JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
      SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
      Object[] argsInsertarAntecedenteInterno = { cntId, posIrregularMax, diasIrregularMax, df.format(fechaExtraccion) };
      jdbcTemplate.update(insertarNuevoAntecedenteInternoQuery, argsInsertarAntecedenteInterno);
      logger.debug("Se generó un antecedente interno para el contrato con id: " + cntId);
   }

   /**
    * Incrementa en 1 la cantindad de reincidencias del antecendete indicado.
    *
    * @param contratoId id
    */
   public void incrementarReincidencia(Long contratoId) {
      JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
      jdbcTemplate.update(incrementarAntecedenteQuery, new Object[] { contratoId});
      logger.debug("Se incrementó en 1 la cantidad de reincidencias para el contrato con id: " + contratoId);
   }

   /**
    * @param dataSource
    *            Base de datos
    */
   public void setDataSource(DataSource dataSource) {
      this.dataSource = dataSource;
   }

   /**
    * @param updateAntecedenteInternoQuery
    *            the updateAntecedenteInternoQuery to set
    */
   public void setUpdateAntecedenteInternoQuery(String updateAntecedenteInternoQuery) {
      this.updateAntecedenteInternoQuery = updateAntecedenteInternoQuery;
   }

   /**
    * @param buscarAntecedentePersonaQuery
    *            the buscarAntecedentePersonaQuery to set
    */
   public void setBuscarAntecedentePersonaQuery(String buscarAntecedentePersonaQuery) {
      this.buscarAntecedentePersonaQuery = buscarAntecedentePersonaQuery;
   }

   /**
    * @param buscarAntecendeteInternoQuery
    *            the buscarAntecendeteInternoQuery to set
    */
   public void setBuscarAntecendeteInternoQuery(String buscarAntecendeteInternoQuery) {
      this.buscarAntecendeteInternoQuery = buscarAntecendeteInternoQuery;
   }

   /**
    * @param buscarUltimoAntecedenteQuery
    *            the buscarUltimoAntecedenteQuery to set
    */
   public void setBuscarUltimoAntecedenteQuery(String buscarUltimoAntecedenteQuery) {
      this.buscarUltimoAntecedenteQuery = buscarUltimoAntecedenteQuery;
   }

   /**
    * @param insertarNuevoAntecedenteQuery
    *            the insertarNuevoAntecedenteQuery to set
    */
   public void setInsertarNuevoAntecedenteQuery(String insertarNuevoAntecedenteQuery) {
      this.insertarNuevoAntecedenteQuery = insertarNuevoAntecedenteQuery;
   }

   /**
    * @param updateAntecedenteEnPersonaQuery
    *            the updateAntecedenteEnPersonaQuery to set
    */
   public void setUpdateAntecedenteEnPersonaQuery(String updateAntecedenteEnPersonaQuery) {
      this.updateAntecedenteEnPersonaQuery = updateAntecedenteEnPersonaQuery;
   }

   /**
    * @param insertarNuevoAntecedenteInternoQuery
    *            the insertarNuevoAntecedenteInternoQuery to set
    */
   public void setInsertarNuevoAntecedenteInternoQuery(String insertarNuevoAntecedenteInternoQuery) {
      this.insertarNuevoAntecedenteInternoQuery = insertarNuevoAntecedenteInternoQuery;
   }

   /**
    * @param incrementarAntecedenteQuery
    *            the incrementarAntecedenteQuery to set
    */
   public void setIncrementarAntecedenteQuery(String incrementarAntecedenteQuery) {
      this.incrementarAntecedenteQuery = incrementarAntecedenteQuery;
   }
}
