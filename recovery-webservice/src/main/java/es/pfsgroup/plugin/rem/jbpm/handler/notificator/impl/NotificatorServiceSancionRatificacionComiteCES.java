package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class NotificatorServiceSancionRatificacionComiteCES extends NotificatorServiceSancionOfertaGenerico implements NotificatorService {

    private static final String CODIGO_T017_RATIFICACION_COMITE_CES = "T017_RatificacionComiteCES";
    private static final String MENSAJE_BC = "Para el Número del inmueble BC: ";
	private static final String CODIGO_TRAMITE_T017 = "T017";

    @Autowired
    private GenericAdapter genericAdapter;

    @Autowired
    private ActivoTramiteApi activoTramiteApi;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private ExpedienteComercialDao expedienteComercialDao;

    @Autowired
    private GestorActivoApi gestorActivoManager;

    @Autowired
    private GenericABMDao genericDao;

    @Override
    public String[] getKeys() {
        return this.getCodigoTarea();
    }

    @Override
    public String[] getCodigoTarea() {
        return new String[] { CODIGO_T017_RATIFICACION_COMITE_CES };
    }

    private static final String BUZON_REM = "buzonrem";
    private static final String BUZON_PFS = "buzonpfs";
    private static final String BUZON_OFR_APPLE = "buzonofrapple";

    @Override
    public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {

        DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
        ExpedienteComercial expediente = getExpedienteComercial(tramite);
        Oferta oferta = expediente.getOferta();

        Activo activo = oferta.getActivoPrincipal();
        ActivoProveedor preescriptor= ofertaApi.getPreescriptor(oferta);

        List<String> mailsPara = new ArrayList<String>();
        List<String> mailsCC = new ArrayList<String>();
        mailsCC.add(this.getCorreoFrom());

        if(DDResolucionComite.CODIGO_CONTRAOFERTA.equalsIgnoreCase(activoTramiteApi.getTareaValorByNombre(valores, "comboRatificacion"))) {

            Usuario gestor = null;
            Usuario supervisorComercial = null;
            Usuario supervisor = null;
            Usuario gestorBackoffice = null;
            Usuario supervisorBackOffice = null;
            Usuario gestorFormalizacion = null;
            Usuario supervisorFormalizacion = null;
            Usuario usuarioBackOffice = null;
            Usuario buzonRem = genericDao.get(Usuario.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "username", BUZON_REM));
            Usuario buzonPfs = genericDao.get(Usuario.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "username", BUZON_PFS));
            Usuario buzonOfertaApple = genericDao.get(Usuario.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "username", BUZON_OFR_APPLE));

            List<Usuario> usuarios = new ArrayList<Usuario>();
            if (!Checks.esNulo(gestor)) {
                usuarios.add(gestor);
            }
            if (!Checks.esNulo(supervisor)) {
                usuarios.add(supervisor);
            }
            if (!Checks.esNulo(gestorBackoffice)) {
                usuarios.add(gestorBackoffice);
            }
            if (!Checks.esNulo(buzonRem)) {
                usuarios.add(buzonRem);
            }
            if (!Checks.esNulo(buzonPfs)) {
                usuarios.add(buzonPfs);
            }
            if (!Checks.esNulo(buzonOfertaApple) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
                usuarios.add(buzonOfertaApple);
            }

            mailsPara = getEmailsNotificacionContraoferta(usuarios);

            if (activo != null) {

                if (DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
                        || DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
                    gestorBackoffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
                    supervisorBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
                    gestorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
                    supervisorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
                    gestor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
                    supervisorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);

                    if (!Checks.esNulo(gestorBackoffice) && !Checks.esNulo(gestorBackoffice.getEmail())) {
                        mailsPara.add(gestorBackoffice.getEmail());
                    }

                    if (!Checks.esNulo(supervisorBackOffice) && !Checks.esNulo(supervisorBackOffice.getEmail())) {
                        mailsPara.add(supervisorBackOffice.getEmail());
                    }

                    if (!Checks.esNulo(gestorFormalizacion) && !Checks.esNulo(gestorFormalizacion.getEmail())) {
                        mailsPara.add(gestorFormalizacion.getEmail());
                    }

                    if (!Checks.esNulo(supervisorFormalizacion) && !Checks.esNulo(supervisorFormalizacion.getEmail())) {
                        mailsPara.add(supervisorFormalizacion.getEmail());
                    }

                    if (!Checks.esNulo(gestor) && !Checks.esNulo(gestor.getEmail())) {
                        mailsPara.add(gestor.getEmail());
                    }

                    if (!Checks.esNulo(supervisorComercial) && !Checks.esNulo(supervisorComercial.getEmail())) {
                        mailsPara.add(supervisorComercial.getEmail());
                    }
                }
            }

            if (!Checks.esNulo(preescriptor) && !Checks.esNulo(preescriptor.getEmail())) {
                mailsPara.add(preescriptor.getEmail());
            }
            mailsCC.add(this.getCorreoFrom());


            String contenido = "<p> Le informamos que la citada propuesta ha sido CONTRAOFERTADA por un importe de #importeContraoferta.</p>"
                    + "<p> Quedamos a su disposición para cualquier consulta o aclaración.</p>"
                    + "<p> Saludos cordiales.</p>"
                    + "<p> Fdo: #gestorTarea </p>"
                    + "<p> Email: #mailGestorTarea </p>";

            String gestorNombre = "SIN_DATOS_NOMBRE_APELLIDO_GESTOR";
            String gestorEmail = "SIN_DATOS_EMAIL_GESTOR";
            if (gestor != null && gestor.getApellidoNombre() != null) {
                gestorNombre = gestor.getApellidoNombre();
            }
            if (gestor != null && gestor.getEmail() != null) {
                gestorEmail = gestor.getEmail();
            }
            contenido = contenido.replace("#importeContraoferta", activoTramiteApi.getTareaValorByNombre(valores, "numImporteContra"))
                    .replace("#gestorTarea", gestorNombre)
                    .replace("#mailGestorTarea", gestorEmail);

            String titulo = "Contraoferta Activo/Agrupación #numactivo_agrupacion Oferta #numoferta";
            String numactivoagrupacion = Checks.esNulo(oferta.getAgrupacion()) ? activo.getNumActivo().toString() : oferta.getAgrupacion().getNumAgrupRem().toString();
            titulo = titulo.replace("#numactivo_agrupacion", numactivoagrupacion)
                    .replace("#numoferta", oferta.getNumOferta().toString());

            dtoSendNotificator.setTitulo("Notificación REM");
            contenido = tieneNumeroInmuebleBC(contenido, tramite);
            genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
        }
    }

    private ExpedienteComercial getExpedienteComercial(ActivoTramite tramite) {
        ActivoTramite activoTramite = activoTramiteApi.get(tramite.getId());

        if (activoTramite == null) {
            return null;
        }

        Trabajo trabajo = activoTramite.getTrabajo();

        if (trabajo == null) {
            return null;
        }

        ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());

        if (expediente == null) {
            return null;
        }

        return expediente;
    }

    private List<String> getEmailsNotificacionContraoferta(List<Usuario> usuarios) {


        List<String> mailsPara = new ArrayList<String>();

        for(Usuario usuario: usuarios) {

            if (usuario != null && !Checks.esNulo(usuario.getEmail())) {
                mailsPara.add(usuario.getEmail());
            }
        }



        return mailsPara;
    }
    
    private String tieneNumeroInmuebleBC(String cuerpo, ActivoTramite tramite) {
		if (CODIGO_TRAMITE_T017.equals(tramite.getTipoTramite().getCodigo()) 
			&& DDCartera.isCarteraBk(tramite.getActivo().getCartera())
			&& !Checks.esNulo(tramite.getActivo().getNumActivoCaixa())) {
			cuerpo = MENSAJE_BC + tramite.getActivo().getNumActivoCaixa() + ",\n" + cuerpo;
		}
		return cuerpo;
	}
}

