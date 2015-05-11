package es.capgemini.pfs.asunto.dao.impl.test;

import junit.framework.TestCase;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;

public class EXTAsuntoDaoImplTest extends TestCase {

    public void testBuscarAsuntosPaginated() {
        EXTDtoBusquedaAsunto dto = new EXTDtoBusquedaAsunto();
        //HashMap<String, Object> params = new HashMap<String, Object>();
        final int bufferSize = 1024;
        StringBuffer hql = new StringBuffer(bufferSize);
        hql.append("from Asunto a where a.id in (select distinct asu.id from Asunto asu");


        try {
            dto.setIdSesionComite(Long.parseLong(""));
        } catch (Throwable e) {

        }

        if ((dto.getIdSesionComite() != null) || (dto.getIdComite() != null)) {
            hql.append(", DecisionComite dco , DDEstadoItinerario estIti ");
        }
    }

    public void testCrearAsunto() {

    }

    public void testModificarAsunto() {

    }

    public void testIsNombreAsuntoDuplicado() {

    }

    public void testBuscarAsuntosPaginatedDinamico() {

    }

    public void testBuscarAsuntosPaginatedDinamicoCount() {

    }

}
