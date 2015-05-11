package es.capgemini.pfs.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

import es.capgemini.pfs.test.analisis.MapaGlobalOficinaTest;
import es.capgemini.pfs.test.comite.ComiteTest;
import es.capgemini.pfs.test.contrato.ContratoTest;
import es.capgemini.pfs.test.expediente.ExpedienteTest;
import es.capgemini.pfs.test.metrica.BorrarMetricasTest;
import es.capgemini.pfs.test.metrica.MetricaFileParserTest;
import es.capgemini.pfs.test.metrica.MetricaManagerTest;
import es.capgemini.pfs.test.metrica.MetricaValidatorTest;
import es.capgemini.pfs.test.persona.PersonaTest;
import es.capgemini.pfs.test.politica.PoliticaManagerTest;
import es.capgemini.pfs.test.scoring.SimulacionTest;
import es.capgemini.pfs.test.users.UsuarioTest;

/**
 * Clase para ejecutar de forma conjunta la totalidad de los Junits.
 *
 * @author lgiavedo
 *
 */
@RunWith(Suite.class)
@Suite.SuiteClasses({
    MapaGlobalOficinaTest.class,
    ComiteTest.class,
    ContratoTest.class,
    ExpedienteTest.class,
    BorrarMetricasTest.class,
    MetricaFileParserTest.class,
    MetricaManagerTest.class,
    MetricaValidatorTest.class,
    PersonaTest.class,
    PoliticaManagerTest.class,
    SimulacionTest.class,
    UsuarioTest.class })
public class AllTestSuit {

}