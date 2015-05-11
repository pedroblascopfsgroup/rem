package es.capgemini.pfs.batch.revisar.antecedentes;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.revisar.antecedentes.dao.AntecedentesBatchDao;
import es.capgemini.pfs.batch.revisar.movimientos.MovimientosBatchManager;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase manager de la entidad Antecedente.
 *
 * @author mtorrado
 *
 */

public class AntecedentesBatchManager {

   private final Log logger = LogFactory.getLog(getClass());

   @Autowired
   private MovimientosBatchManager movimientosBatchManager;

   @Autowired
   private AntecedentesBatchDao antedecedenteDao;

   /**
    * Inserta o actualiza en la tabla de antecedentes / antecedentes internos
    * por cada contrato la reicidencia en las personas / contratos (ver
    * BATCH-42).
    *
    * @param contratoId Long: id del contrato a registrar antecedentes
    * @param fecha Date
    * @param posIrregular Double: posición irregular
    */
   public void registrarAntecedenteInterno(Long contratoId, Date fecha, Double posIrregular) {

      logger.debug("Iniciando el registro de antecedente del contrato " + contratoId);

      antedecedenteDao.incrementarReincidencia(contratoId);

      Long diasIrregular = movimientosBatchManager.buscarDiasDescubiertoMovimiento(contratoId);

      Long antecedenteInterno = antedecedenteDao.buscarAntecedenteInterno(contratoId);
      if (antecedenteInterno == null) {
         antedecedenteDao.generarAntecedenteInterno(contratoId, posIrregular, diasIrregular, fecha);
      } else {
         antedecedenteDao.actualizarAntecedenteInterno(contratoId, posIrregular, diasIrregular, fecha);
      }
   }
   
   /**
    * Comprueba si existe un antecedente base para una determinada persona
    * y en caso de no existir crea el antecedente base inicial
    * @param personaId
    */
   public void compruebaSiExisteAntecedenteBase(Long personaId){
	   logger.debug("Comprobamos si existe un entecedente base para la persona con id " + personaId);
	   if(Checks.esNulo(antedecedenteDao.buscarAntecedente(personaId))){
		   logger.debug("No existe antecedente base, se crea un antecedente base inicial.");
		   antedecedenteDao.generarAntecedenteBase(personaId);		   
	   }else{
		   logger.debug("Existe un antecedente base para la persona");
	   }
   }   
   
}
