package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.exception.PlusvaliaActivoException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestionPlusv;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;

@Component
public class UpdaterServiceSancionOfertaFirmaPropietario implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    
    @Autowired
    private ActivoApi activoApi;
    
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
    
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaFirmaPropietario.class);

	private static final String CODIGO_T013_FIRMA_PROPIETARIO = "T013_FirmaPropietario";
	private static final String CODIGO_T017_FIRMA_PROPIETARIO = "T017_FirmaPropietario";
    private static final String COMBO_FIRMA = "comboFirma";
    private static final String FECHA_FIRMA = "fechaFirma";
    private static final String MOTIVO_ANULACION = "motivoAnulacion";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    private static final String CODIGO_SUBCARTERA_OMEGA = "65";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		boolean pasaAVendido = false;
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
			for(TareaExternaValor valor :  valores){
	
				if(COMBO_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					if(DDSiNo.SI.equals(valor.getValor())){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

						pasaAVendido = true;

						if ( ofertaAceptada.getActivoPrincipal() != null ) {
							try {
								activoApi.changeAndSavePlusvaliaEstadoGestionActivoById(ofertaAceptada.getActivoPrincipal(), DDEstadoGestionPlusv.COD_EN_CURSO);
							} catch (PlusvaliaActivoException e) {
								logger.error(e);
							}
						}		
						
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);
						
						for(ActivoOferta activoOferta : ofertaAceptada.getActivosOferta())
						{
							Activo activo = activoOferta.getPrimaryKey().getActivo();
							
							PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
							perimetro.setAplicaComercializar(0);
							genericDao.save(PerimetroActivo.class, perimetro);
							
							//Marcamos el activo como vendido
							Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
							activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));
							
							activo.setBloqueoPrecioFechaIni(new Date());
							
							activoApi.saveOrUpdate(activo);
						}
						
						//Rechazamos el resto de ofertas
						List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
						Filter filtroMotivo;
						
						for(Oferta oferta : listaOfertas){
							if(DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())){
								filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "codigo",
										DDMotivoRechazoOferta.CODIGO_ACTIVO_VENDIDO);
								DDMotivoRechazoOferta motivo = genericDao.get(DDMotivoRechazoOferta.class,
										filtroMotivo);
								
								oferta.setMotivoRechazo(motivo);
								ofertaApi.rechazarOferta(oferta);
							}
						}
						
						genericDao.save(Oferta.class, ofertaAceptada);
						
					}else{

						// Se anula el expediente
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

						expediente.setFechaVenta(null);
						
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);

						//Rechaza la oferta y descongela el resto
						ofertaApi.rechazarOferta(ofertaAceptada);
						try {
							ofertaApi.descongelarOfertas(expediente);
							ofertaApi.finalizarOferta(ofertaAceptada);
						} catch (Exception e) {
							logger.error("Error descongelando ofertas.", e);
						}
					}
				}
				
				if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					try {
						expediente.setFechaVenta(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						e.printStackTrace();
					}
				}
				
				if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					// Se incluye un motivo de anulacion del expediente, si se indico en la tarea
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
					DDMotivoAnulacionExpediente motivoAnulacion =  genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
					expediente.setMotivoAnulacion(motivoAnulacion);
				}
				
				
			}
			expedienteComercialApi.update(expediente, pasaAVendido);
			genericDao.save(Oferta.class, ofertaAceptada);
		}


	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_FIRMA_PROPIETARIO, CODIGO_T017_FIRMA_PROPIETARIO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
