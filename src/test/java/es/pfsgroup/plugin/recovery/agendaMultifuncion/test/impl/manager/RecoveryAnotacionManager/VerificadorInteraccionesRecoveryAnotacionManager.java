package es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager;

import static org.mockito.Mockito.*;

import java.util.Map;

import org.apache.velocity.app.VelocityEngine;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.EmailContentUtil;

public class VerificadorInteraccionesRecoveryAnotacionManager {

    private EmailContentUtil mockEmailContentUtil;

    public VerificadorInteraccionesRecoveryAnotacionManager(final EmailContentUtil mockEmailContentUtil) {
        this.mockEmailContentUtil = mockEmailContentUtil;
    }

    public void seHanEnviadoEmails(final int numUsuarios, final String nombrePlantilla) {
        verify(mockEmailContentUtil,times(numUsuarios)).createContenntWithVelocity(any(VelocityEngine.class), eq(nombrePlantilla), any(Map.class));
    }

}
