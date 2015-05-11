package es.capgemini.pfs.test.antecedenteexterno;

import static junit.framework.Assert.assertEquals;

import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.antecedenteexterno.AntecedenteExternoManager;
import es.capgemini.pfs.antecedenteexterno.model.AntecedenteExterno;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.test.AbstractCommonTest;

/**
 * @author Mariano Ruiz
 */
public class AntecedenteExternoTest extends AbstractCommonTest {

    @Autowired
    private AntecedenteExternoManager antecedenteExternoManager;

    /**
     * Verifica que se guarden los objetos en la BBDD.
     */
    @Test
    public void testGuardarModificar() {
        AntecedenteExterno antecedenteExterno = new AntecedenteExterno();
        antecedenteExterno.setFechaImpagos(new Date());
        antecedenteExterno.setFechaIncidenciaJudicial(new Date());
        antecedenteExterno.setNumImpagos(new Integer("10"));
        antecedenteExterno.setNumIncidenciasJudiciales(new Integer("5"));

        antecedenteExternoManager.saveOrUpdate(antecedenteExterno);

        // Verifico la persistencia
        antecedenteExterno = antecedenteExternoManager.getList().get(0);
        assertEquals(antecedenteExterno.getNumImpagos(), new Integer("10"));
        assertEquals(antecedenteExterno.getNumIncidenciasJudiciales(), new Integer("5"));

        // Modifico los datos y actualizo
        antecedenteExterno.setNumImpagos(new Integer("99"));
        antecedenteExterno.setNumIncidenciasJudiciales(new Integer("15"));
        antecedenteExternoManager.saveOrUpdate(antecedenteExterno);

        // Verifico la persistencia
        antecedenteExterno = antecedenteExternoManager.getList().get(0);
        assertEquals(antecedenteExterno.getNumImpagos(), new Integer("99"));
        assertEquals(antecedenteExterno.getNumIncidenciasJudiciales(), new Integer("15"));
    }

    /**
     * Borrar antecedente externo.
     */
    @Test
    public void testDelete() {
        // Obtenemos el antecedente externo
        AntecedenteExterno antecedenteExterno = antecedenteExternoManager.getList().get(0);
        // Lo eliminamos
        antecedenteExternoManager.delete(antecedenteExterno);
        // Lo obtenemos nuevamente
        List<AntecedenteExterno> antecedentes = antecedenteExternoManager.getList();
        assertEquals("No borro el antecente", 0, antecedentes.size());
    }
}
