package es.capgemini.pfs.batch.scoring;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.scoring.dao.ScoringBatchDao;

/**
 * Manager de todos lo relacionado con scoring en el batch.
 * @author aesteban
 *
 */
public class ScoringBatchManager {
    @Autowired
    private ScoringBatchDao scoringBatchDao;

    /**
     * Desactiva los registros de la tabla PTO_PUNTUACION_TOTAL y
     * crea en la tabla PTO_PUNTUACION_TOTAL un registro por cada persona con una alerta activa.
     */
    public void crearTablasDeTotales() {
        scoringBatchDao.desactivarTotales();
        scoringBatchDao.crearRegistrosEnTablasTotales();
    }

    /**
     * Crea en la tabla PPA_PUNTUACION_PARCIAL un registro por cada alerta activa.
     */
    public void crearTablasDeParciales() {
        scoringBatchDao.crearRegistrosEnTablaParciales();

    }

    /**
     * Completa las columnas PTO_PUNTUACION, PTO_RATING y PTO_INTERVALO.
     */
    public void completarTablaDeTotales() {
        scoringBatchDao.calcularPuntuacionTotal();
        scoringBatchDao.calcularRating();
        scoringBatchDao.calcularRango();
    }

    /**
     * Ejecuta las validaciones del proceso de scoring.
     * @return true si pasaron todas.
     */
    public boolean validar(){
    	return scoringBatchDao.validarMetricas() && scoringBatchDao.validarRangos();
    }

}
