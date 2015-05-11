package es.capgemini.pfs.test.contrato;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * Test para probar el correcto funcionamiento del la calse ContratoManage.
 *
 * @author pamuller
 */
public class ContratoTest extends CommonTestAbstract {

    @Autowired
    private ContratoManager contratoManager;

    private static final Long DEFAULT_CONTRATO_ID = Long.valueOf(1);

    /*private static final String DEFAULT_CODIGO_CONTRATO = "11724887";
    private static final String DEFAULT_CODIGO_TIPO_PROD = "P37";
    private static final String DEFAULT_NOMBRE = "CARLOS";
    private static final String DEFAULT_APELLIDO1 = "RECOUSO";
    private static final String DEFAULT_APELLIDO2 = "BARBEITO";
    private static final Double DEFAULT_POS_VIVA_VENCIDA = 955.13d;
    */

    /**
     * Test PersonaManager.get.
     */
    @Test
    public void testGet() {
        // Obtenemos la persona por su id
        Contrato cnt = contratoManager.get(DEFAULT_CONTRATO_ID);
        // Confirmamos que no sea nula
        assertNotNull(cnt);
        //Confirmamos la condicion de su ID
        assertEquals(cnt.getId().longValue(), DEFAULT_CONTRATO_ID.longValue());
        assertNotNull(cnt.getContratoPersona());
        assertTrue(cnt.getContratoPersona().size() > 0);
    }

    /**
     * Test ContratoManager.buscarContratos.
     */
    /*    @Test
        public void testBuscarContratos() {
            BusquedaContratosDto dto = new BusquedaContratosDto();
            //Busco por codigo de contrato
            dto.setNroContrato(DEFAULT_CODIGO_CONTRATO);
            Page page = contratoManager.buscarContratos(dto);
            assertEquals(1, page.getResults().size());

            //Agrego tipo de producto
            dto = new BusquedaContratosDto();
            dto.setNroContrato(DEFAULT_CODIGO_CONTRATO);
            dto.setTiposProducto(DEFAULT_CODIGO_TIPO_PROD);
            page = contratoManager.buscarContratos(dto);
            assertEquals(1, page.getResults().size());

            //Agrego nombre, apellido1 y apellido2
            dto = new BusquedaContratosDto();
            dto.setNroContrato(DEFAULT_CODIGO_CONTRATO);
            dto.setTiposProducto(DEFAULT_CODIGO_TIPO_PROD);
            dto.setNombre(DEFAULT_NOMBRE);
            dto.setApellido1(DEFAULT_APELLIDO1);
            dto.setApellido2(DEFAULT_APELLIDO2);
            page = contratoManager.buscarContratos(dto);
            assertEquals(1, page.getResults().size());

            //Agrego descripción cliente
            dto = new BusquedaContratosDto();
            dto.setNroContrato(DEFAULT_CODIGO_CONTRATO);
            dto.setTiposProducto(DEFAULT_CODIGO_TIPO_PROD);
            dto.setNombre(DEFAULT_NOMBRE);
            dto.setApellido1(DEFAULT_APELLIDO1);
            dto.setApellido2(DEFAULT_APELLIDO2);
            page = contratoManager.buscarContratos(dto);
            assertEquals(1, page.getResults().size());

            //Agrego descripción expediente
            dto = new BusquedaContratosDto();
            dto.setNroContrato(DEFAULT_CODIGO_CONTRATO);
            dto.setTiposProducto(DEFAULT_CODIGO_TIPO_PROD);
            dto.setNombre(DEFAULT_NOMBRE);
            dto.setApellido1(DEFAULT_APELLIDO1);
            dto.setApellido2(DEFAULT_APELLIDO2);
            dto.setDescripcionExpediente(DEFAULT_APELLIDO1 + " " + DEFAULT_APELLIDO2 + ", " + DEFAULT_NOMBRE);
            page = contratoManager.buscarContratos(dto);
            //Debe dar 0 poruqe no hay expediente
            assertEquals(0, page.getResults().size());

            //Agrego pos viva vencida
            dto = new BusquedaContratosDto();
            dto.setNroContrato(DEFAULT_CODIGO_CONTRATO);
            dto.setTiposProducto(DEFAULT_CODIGO_TIPO_PROD);
            dto.setNombre(DEFAULT_NOMBRE);
            dto.setApellido1(DEFAULT_APELLIDO1);
            dto.setApellido2(DEFAULT_APELLIDO2);
            dto.setMinVolRiesgoVencido(DEFAULT_POS_VIVA_VENCIDA - 1 + "");
            dto.setMaxVolRiesgoVencido(DEFAULT_POS_VIVA_VENCIDA + 1 + "");
            page = contratoManager.buscarContratos(dto);
            assertEquals(1, page.getResults().size());

        }*/
}
