package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.formulario.ActivoGenericFormManager;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceContabilidadBbva;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaDefinicionOferta implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private NotificacionApi notificacionApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private  GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private NotificatorServiceContabilidadBbva notificatorServiceContabilidadBbva;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaDefinicionOferta.class);

	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	private static final String CODIGO_T017_DEFINICION_OFERTA = "T017_DefinicionOferta";
	private static final String FECHA_ENVIO_COMITE = "fechaEnvio";
	private static final String COMBO_CONFLICTO = "comboConflicto";
	private static final String COMBO_RIESGO = "comboRiesgo";
	private static final String COMBO_COMITE_SUPERIOR = "comiteSuperior";
	private static final String CAMPO_COMITE = "comite";
	private static final String T017 = "T017";
	private static final String CODIGO_SUBCARTERA_OMEGA = "65";
	private static final String CODIGO_CARTERA_THIRD_PARTY = "11";
	private static final Integer RESERVA_SI = 1;
	public static final String CODIGO_CARTERA_BANKIA = "03";
	public static final String CODIGO_CARTERA_LIBERBANK = "08";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		/*
		 * Si tiene atribuciones guardamos la fecha de aceptación de la tarea
		 * como fecha de sanción, en caso contrario, la fecha de sanción será la
		 * de resolución del comité externo.
		 */
		boolean estadoBcModificado = false;
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi
				.expedienteComercialPorOferta(ofertaAceptada.getId());
		
		Activo activo = ofertaAceptada.getActivoPrincipal();
		GestorEntidadDto ge = new GestorEntidadDto();
		String tipoTramite = tramite.getTipoTramite().getCodigo();

		if (!Checks.esNulo(ofertaAceptada) && !Checks.esNulo(expediente)) {	
			boolean tieneAtribuciones = ofertaApi.checkAtribuciones(tramite.getTrabajo());
			//Si tiene atribuciones y no es T017 podra entrar (aunque el comité de T017 no deberia entrar de por si). Si es oferta express entra
			if (((tieneAtribuciones && (!T017.equals(tipoTramite)) || DDCartera.isCarteraBk(activo.getCartera()))) || (ofertaAceptada.getOfertaExpress() != null && ofertaAceptada.getOfertaExpress())) {
				List<ActivoOferta> listActivosOferta = expediente.getOferta().getActivosOferta();
				for (ActivoOferta activoOferta : listActivosOferta) {
					ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
					if(Checks.esNulo(expediente.getReserva()) && DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo()) && activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
						Oferta oferta = expediente.getOferta();	
						OfertaGencat ofertaGencat = null;
						if (!Checks.esNulo(comunicacionGencat)) {
							ofertaGencat = genericDao.get(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta), genericDao.createFilter(FilterType.EQUALS,"comunicacion", comunicacionGencat));
						}
						if(!Checks.esNulo(ofertaGencat)) {
								if(Checks.esNulo(ofertaGencat.getIdOfertaAnterior()) && !ofertaGencat.getAuditoria().isBorrado()) {
									gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
								}
						}else{	
							gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
						}					
					}
					
				}
				expediente.setFechaSancion(new Date());
				
				if(expediente.getOferta()!=null &&  expediente.getFechaSancion()!=null) {
					ofertaApi.comprobarFechasParaLanzarComisionamiento(expediente.getOferta(), expediente.getFechaSancion());
				}
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadosExpedienteComercial.APROBADO);
				if(T017.equals(tipoTramite) && DDCartera.isCarteraBk(activo.getCartera())) {
					Filter filtroEstadoBC = null;
					if(ofertaApi.esMayorista(tareaExternaActual)) {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",DDEstadosExpedienteComercial.PTE_PBC_CN);
						filtroEstadoBC = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_EN_TRAMITE);
					}else {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",DDEstadosExpedienteComercial.PTE_SANCION);
						filtroEstadoBC = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_PDTE_APROBACION_BC);
						estadoBcModificado = true;
					}

					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroEstadoBC);
					expediente.setEstadoBc(estadoBc);

				}
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expediente.setEstado(estado);
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
				
				if(expediente.getCondicionante().getSolicitaReserva()!=null 
						&& RESERVA_SI.equals(expediente.getCondicionante().getSolicitaReserva()) && ge!=null) {
					EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");
					
					if (tipoGestorComercial != null && DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo()) 
							&& !DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) //REMVIP-8388,todas menos Cerberus hasta que digan lo contrario
							&& gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GBOAR") == null) {
						ge.setIdEntidad(expediente.getId());
						ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
						ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());	
						ge.setIdTipoGestor(tipoGestorComercial.getId());
						gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);
					}
				}
				
				// Una vez aprobado el expediente, se congelan el resto de
				// ofertas que no estén rechazadas (aceptadas y pendientes)
				List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
				for (Oferta oferta : listaOfertas) { 
					if(oferta.getActivoPrincipal() != null && !DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())) {
						if (!oferta.getId().equals(ofertaAceptada.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo()) 
								&& ((!ofertaApi.isOfertaPrincipal(oferta) && !ofertaApi.isOfertaDependiente(oferta)) 
							|| (DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL.equals(ofertaAceptada.getClaseOferta().getCodigo())))) {
							ofertaApi.congelarOferta(oferta);
						}
					}
				}

				// Se comprueba si cada activo tiene KO de admisión o de gestión
				// y se envía una notificación
				if(expediente.getComiteSancion() != null &&
						!DDComiteSancion.CODIGO_APPLE_CERBERUS.equals(expediente.getComiteSancion().getCodigo())){

					notificacionApi.enviarNotificacionPorActivosAdmisionGestion(expediente);
				}
			} else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadosExpedienteComercial.PTE_SANCION);
				Filter filtroSinFormalizacion = genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadosExpedienteComercial.APROBADO);
				
				PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(expediente.getOferta().getActivoPrincipal().getId());
				
				DDEstadosExpedienteComercial estado;

				String codSubCartera = null;
				
				if (!Checks.esNulo(activo.getSubcartera())) {
					codSubCartera = activo.getSubcartera().getCodigo();
				}
				if (!CODIGO_SUBCARTERA_OMEGA.equals(codSubCartera)) {
					if(perimetro.getAplicaFormalizar() == 0){
						estado = genericDao.get(DDEstadosExpedienteComercial.class, filtroSinFormalizacion);	
					}else{
						estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					}
					expediente.setEstado(estado);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

				}
			}

			String codCartera = null;
			if (!Checks.esNulo(activo.getCartera())) {
				codCartera = activo.getCartera().getCodigo();
			}
			boolean aplicaSuperior = false;
			DDComiteSancion comite = null;
			for (TareaExternaValor valor : valores) {		
				if(expedienteComercialApi.esApple(valor.getTareaExterna())){
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SANCION);
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setEstado(estado);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

				}	
				if (FECHA_ENVIO_COMITE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()) && CODIGO_CARTERA_THIRD_PARTY.equals(codCartera)) {
					try {
						expediente.setFechaSancion(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						logger.error(e);
					}
				}
				if (COMBO_RIESGO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())) {
						expediente.setRiesgoReputacional(1);
					} else {
						if (DDSiNo.NO.equals(valor.getValor())) {
							expediente.setRiesgoReputacional(0);
						}
					}
				}
				if (COMBO_CONFLICTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())) {
						expediente.setConflictoIntereses(1);
					} else {
						if (DDSiNo.NO.equals(valor.getValor())) {
							expediente.setConflictoIntereses(0);
						}
					}
				}
				if(COMBO_COMITE_SUPERIOR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())){
						aplicaSuperior = true;
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_BANKIA_DGVIER);
						DDComiteSancion comiteSuperior = genericDao.get(DDComiteSancion.class, filtro);
						if(!Checks.esNulo(comiteSuperior)) {
							expediente.setComiteSuperior(comiteSuperior);
							expediente.setComiteSancion(comiteSuperior);
							DDEstadosExpedienteComercial estado =genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo",
									DDEstadosExpedienteComercial.PTE_SANCION));
							expediente.setEstado(estado);
							recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

						}
						
					}else {
						aplicaSuperior = false;
					}
				}
				if(CAMPO_COMITE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if(!valor.getValor().equals(ActivoGenericFormManager.NO_APLICA)) {
						comite = expedienteComercialApi.comiteSancionadorByCodigo(valor.getValor());						
					}
				}
			}

			if(!aplicaSuperior && !Checks.esNulo(comite)) {
				expediente.setComiteSuperior(comite);
				expediente.setComiteSancion(comite);
			}
		}	
		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_DEFINICION_OFERTA , CODIGO_T017_DEFINICION_OFERTA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
