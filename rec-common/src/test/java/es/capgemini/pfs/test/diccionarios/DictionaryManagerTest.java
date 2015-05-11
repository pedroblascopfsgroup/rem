package es.capgemini.pfs.test.diccionarios;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class DictionaryManagerTest extends CommonTestAbstract {

    @Autowired
    DictionaryManager dictionaryManager;

    @Test
    public final void testGetList() {
        dictionaryManager.getList("DDEstadoAsunto");
    }

    @Test
    public final void testGetByCode() {
        dictionaryManager.getByCode(DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
    }

}
