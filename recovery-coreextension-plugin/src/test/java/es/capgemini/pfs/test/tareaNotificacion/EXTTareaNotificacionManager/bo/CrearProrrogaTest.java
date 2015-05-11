package es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.bo;

import static org.mockito.Mockito.*;

import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.internal.verification.VerificationModeFactory;
import org.mockito.runners.MockitoJUnitRunner;
import org.mockito.verification.VerificationMode;

import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.AbstractExtTareaNotificacionManagerTests;

/**
 * Comprobaciones de la operación de negocio de crear una prórroga
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class CrearProrrogaTest extends AbstractExtTareaNotificacionManagerTests {

    private Long idEntidadInformacion;
    private Long plazo;
    private Long idBpmProcess;
    private Long idProrroga;
    private Long idTareaAsociada;
    private String descripcionCausa;

    @Override
    public void setUpChildTest() {
        Random r = new Random();
        idEntidadInformacion = r.nextLong();
        plazo = r.nextLong();
        idBpmProcess = r.nextLong();
        idProrroga = r.nextLong();
        idTareaAsociada = r.nextLong();
        descripcionCausa = RandomStringUtils.randomAlphabetic(200);
    }

    @Override
    public void tearDownChildTest() {
        idEntidadInformacion = null;
        plazo = null;
        idBpmProcess = null;
        idTareaAsociada = null;
        descripcionCausa = null;
    }

    /**
     * Test del caso general
     */
    @Test
    public void testCrearProrroga_Procedimiento() {
        DtoSolicitarProrroga dto = new DtoSolicitarProrroga();
        // FIXME Pasamos un código pero en el DTO la propiedad hace referencia a
        // un ID
        dto.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
        dto.setIdEntidadInformacion(idEntidadInformacion);
        dto.setDescripcionCausa(descripcionCausa);

        simularInteracciones().simulaCreateProrroga(idProrroga);
        simularInteracciones().simulaGetTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
        simularInteracciones().simulaGetProcedimiento(idEntidadInformacion);
        simularInteracciones().simulaGetPlazoTareasDefault(PlazoTareasDefault.CODIGO_SOLICITUD_PRORROGA, plazo);
        simularInteracciones().simulaCreateBPMProcess(idBpmProcess);
        simularInteracciones().simulaGetVariableBPM(idBpmProcess, TareaBPMConstants.ID_TAREA, idTareaAsociada);
        TareaNotificacion mockTarea = simularInteracciones().simulaGetTarea(idTareaAsociada);
        
        manager.crearProrroga(dto);

        verificarInteracciones().seHaGuardadoLaProrroga();
        verificarInteracciones().seHaCreadoBPMConParametros(TareaBPMConstants.TAREA_PROCESO);
        
        verify(mockTarea, times(1)).setDescripcionTarea(descripcionCausa);
        verify(manager, times(1)).saveOrUpdate(mockTarea);
        
    }

}
