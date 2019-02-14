package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.resolucionComite.dao.ResolucionComiteDao;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

@Component
public class UpdaterServiceSancionOfertaRatificacionComite implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
	private NotificacionApi notificacionApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;
    
	@Autowired
	private ResolucionComiteApi resolucionComiteApi;
    
	@Autowired
	private ResolucionComiteDao resolucionComiteDao;
	
	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private ActivoDao activoDao;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRatificacionComite.class);

    private static final String COMBO_RATIFICACION = "comboRatificacion";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String IMPORTE_CONTRAOFERTA = "importeContraoferta";
   	private static final String CODIGO_T013_RATIFICACION_COMITE = "T013_RatificacionComite";
   	private static final String MOTIVO_NO_RATIFICADA = "604"; //NO RATIFICADA

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Boolean esAfectoGencat = false;
		if(!Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getId())){
			esAfectoGencat = activoDao.isActivoAfectoGENCAT(tramite.getActivo().getId());
		}
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if(!Checks.esNulo(expediente)) {
				
				for(TareaExternaValor valor :  valores) {
					
					if(COMBO_RATIFICACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro;
						if(DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
							Boolean esEstadoAnteriorTramitado = false;
							if(DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo())) {
								esEstadoAnteriorTramitado = true;
							}
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);

							//Una vez aprobado el expediente, se congelan el resto de ofertas que no estén rechazadas (aceptadas y pendientes)
							List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
							for(Oferta oferta : listaOfertas){
								if(!oferta.getId().equals(ofertaAceptada.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())){
									ofertaApi.congelarOferta(oferta);
								}
							}
							// Se comprueba si cada activo tiene KO de admisión o de gestión
							// y se envía una notificación
							notificacionApi.enviarNotificacionPorActivosAdmisionGestion(expediente);
							
							//TODO COMPROBACION PRE BLOQUEO GENCAT 
							if ((Checks.esNulo(expediente.getReserva())) && (esEstadoAnteriorTramitado) && esAfectoGencat) {
								Oferta oferta = expediente.getOferta();	
								OfertaGencat ofertaGencat = genericDao.get(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta));
								if(!Checks.esNulo(ofertaGencat) && Checks.esNulo(ofertaGencat.getIdOfertaAnterior())&& !ofertaGencat.getBorrado()) {
									gencatApi.bloqueoExpedienteGENCAT(expediente, tramite);
								}
							}
						} else if(DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
							//Resuelve el expediente
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							expediente.setFechaVenta(null);

							//Finaliza el trámite
							Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
							tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
							genericDao.save(ActivoTramite.class, tramite);

							//Rechaza la oferta y descongela el resto
							ofertaApi.rechazarOferta(ofertaAceptada);
							try {
								ofertaApi.descongelarOfertas(expediente);
							} catch (Exception e) {
								logger.error("Error descongelando ofertas.", e);
							}

							// Motivo anulacion: NO RATIFICADA
							DDMotivoAnulacionExpediente motivoAnulacionExpediente = 
									(DDMotivoAnulacionExpediente) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAnulacionExpediente.class, MOTIVO_NO_RATIFICADA);
							expediente.setMotivoAnulacion(motivoAnulacionExpediente);
						}
					}
					if (IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						ofertaAceptada.setImporteContraOferta(Double.valueOf(valor.getValor().replace(',', '.')));
						genericDao.save(Oferta.class, ofertaAceptada);
	
						// Actualizar honorarios para el nuevo importe de contraoferta.
						expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());
	
						// Actualizamos la participación de los activos en la oferta;
						expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
						expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
						
//						ResolucionComiteBankiaDto resolDto = null;
//						List<ResolucionComiteBankia> listaResol = null;
//						ResolucionComiteDto dto = new ResolucionComiteDto();
//						dto.setOfertaHRE(ofertaAceptada.getNumOferta());
//						dto.setCodigoTipoResolucion(DDTipoResolucion.CODIGO_TIPO_RESOLUCION);						
//						dto.setImporteContraoferta(ofertaAceptada.getImporteContraOferta());
//						dto.setCodigoComite(expediente.getComiteSancion().getCodigo());
//						dto.setCodigoResolucion(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA);
//						try {
//							resolDto = resolucionComiteApi.getResolucionComiteBankiaDtoFromResolucionComiteDto(dto);
//							if(Checks.esNulo(resolDto)){
//								throw new Exception("Se ha producido un error en la búsqueda de resoluciones.");
//							}
//							
//							//Obtenemos la lista de resoluciones por expediente y tipo si existe
//							listaResol = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
//							if(!Checks.esNulo(listaResol) && listaResol.size()>0){
//								for(int i = 0; i< listaResol.size(); i++){					
//									resolucionComiteDao.delete(listaResol.get(i));
//								}
//							}
//							
//						} catch (Exception e) {
//							// TODO Auto-generated catch block
//							e.printStackTrace();
//						}
					}	
				}
				genericDao.save(ExpedienteComercial.class, expediente);
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RATIFICACION_COMITE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
