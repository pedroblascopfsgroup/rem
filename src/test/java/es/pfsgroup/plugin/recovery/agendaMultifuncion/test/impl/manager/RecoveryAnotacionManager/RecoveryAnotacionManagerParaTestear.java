package es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager;

import java.util.Date;
import java.util.List;

import javax.mail.MessagingException;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager.RecoveryAnotacionManager;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;

public class RecoveryAnotacionManagerParaTestear extends RecoveryAnotacionManager {

    @Override
    public Long crearTarea(Long idUg, String codUg, String asuntoMail, Long idUsuarioDestinatarioTarea, boolean enEspera, String codigoSubtarea, Date fechaVencimiento)
            throws EXTCrearTareaException {
        return super.crearTarea(idUg, codUg, asuntoMail, idUsuarioDestinatarioTarea, enEspera, codigoSubtarea, fechaVencimiento);
    }

    @Override
    public void enviarMailConAdjuntos(List<String> mailsPara, String emailFrom, List<String> direccionesMailCc, String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list)
            throws MessagingException {
        super.enviarMailConAdjuntos(mailsPara, emailFrom, direccionesMailCc, asuntoMail, cuerpoEmail, list);
    }

}
