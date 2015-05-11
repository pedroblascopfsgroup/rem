package es.capgemini.pfs.test.comite;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.comite.ComiteManager;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * Test para probar el correcto funcionamiento del la calse ContratoManage.
 *
 * @author pamuller
 */
public class ComiteTest extends CommonTestAbstract {

    @Autowired
    private ComiteManager comiteManager;

    @Autowired
    private ExpedienteManager expedienteManager;

    private static final Long DEFAULT_EXPEDIENTE_ID = Long.valueOf(1);
    private static final Long DEFAULT_COMITE_ID = Long.valueOf(5);
    private static final String COMITE_UN_NIVEL_ARRIBA = "Comite Dtor. Riesgos";
    private static final String COMITE_OTRO_NIVEL_ARRIBA = "Comite Recuperaciones";


    /**
     * Test PersonaManager.get.
     */
    @Test
    public void testGet() {

    }

    /**
     * Test ContratoManager.buscarContratos.
     */
    @Test
    public void testBuscarComiteElevar(){
    	Expediente exp = expedienteManager.getExpediente(DEFAULT_EXPEDIENTE_ID);
    	Comite com = comiteManager.get(DEFAULT_COMITE_ID);
    	exp.setComite(com);
    	//Le agrego un comité para poder hacer el test
    	expedienteManager.saveOrUpdate(exp);
    	Comite comite = comiteManager.buscarComiteParaElevar(exp.getId());
    	assertNotNull(comite);
    	assertEquals(COMITE_UN_NIVEL_ARRIBA,comite.getNombre());
    	exp.setComite(comite);
    	expedienteManager.saveOrUpdate(exp);
    	comite = comiteManager.buscarComiteParaElevar(exp.getId());
    	assertEquals(COMITE_OTRO_NIVEL_ARRIBA,comite.getNombre());
    	//Le borro el comité para dejar los cosas como antes
    	exp.setComite(null);
    	expedienteManager.saveOrUpdate(exp);
    }
}
