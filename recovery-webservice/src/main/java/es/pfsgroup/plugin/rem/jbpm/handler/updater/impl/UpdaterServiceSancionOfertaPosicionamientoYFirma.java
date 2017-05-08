package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;

@Component
public class UpdaterServiceSancionOfertaPosicionamientoYFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Resource
    MessageService messageServices;
    
    private static final String COMBO_FIRMA = "comboFirma";
    private static final String FECHA_FIRMA = "fechaFirma";
    private static final String MOTIVO_NO_FIRMA = "motivoNoFirma";
    private static final String CODIGO_T013_POSICIONAMIENTOYFIRMA = "T013_PosicionamientoYFirma";
    private static final String MOTIVO_ESTADO_PUBLICACION_ACTIVO_VENDIDO = "activo.motivo.tramite.vendido.no.publicar";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			
			for(TareaExternaValor valor :  valores){
				
				if(COMBO_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					Filter filtro;
					if(DDSiNo.SI.equals(valor.getValor())){
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
						for(ActivoOferta activoOferta : ofertaAceptada.getActivosOferta())
						{
							Activo activo = activoOferta.getPrimaryKey().getActivo();
							
							PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
							perimetro.setAplicaComercializar(0);
							//TODO: Cuando esté el motivo de no comercialización como texto libre, poner el texto: "Vendido".
							genericDao.save(PerimetroActivo.class, perimetro);
							
							//Marcamos el activo como vendido
							Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
							activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));
														
							activo.setBloqueoPrecioFechaIni(new Date());
							
							//Al venderse el activo, actualizamos el estado de publicación a 'No publicado'.
							String[] numTrabajoMotivo = {String.valueOf(tramite.getTrabajo().getNumTrabajo())};
							try {
								activoApi.setActivoToNoPublicado(activo, messageServices.getMessage(MOTIVO_ESTADO_PUBLICACION_ACTIVO_VENDIDO, numTrabajoMotivo));
							} catch (JsonViewerException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
							genericDao.save(Activo.class, activo);
						}
						List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
						
						//Rechazamos el resto de ofertas
						for(Oferta oferta : listaOfertas){
							if(DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())){
								ofertaApi.rechazarOferta(oferta);
							}
						}
						
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
					}else{
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
					}
					
					/*
					else{ Se pasa a la tarea de Devolución de llaves/Resolucion expediente la labora de anular.
							
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
						expediente.setFechaAnulacion(new Date());
						genericDao.save(ExpedienteComercial.class, expediente);
						
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);

						//Rechaza la oferta y descongela el resto
						ofertaApi.rechazarOferta(ofertaAceptada);
						List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
						for(Oferta oferta : listaOfertas){
							if((DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo()))){
								ofertaApi.descongelarOferta(oferta);
							}
						}
						
					}
					*/


					
				}				
				//La fecha de firma la guardamos como la fecha de toma de posesión
				if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					for(ActivoOferta activoOferta : ofertaAceptada.getActivosOferta())
					{
						Activo activo = activoOferta.getPrimaryKey().getActivo();
						
						ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
						situacionPosesoria.setConTitulo(1);
						situacionPosesoria.setOcupado(1);
						try {
							situacionPosesoria.setFechaTomaPosesion(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						activo.setSituacionPosesoria(situacionPosesoria);
					}
					try {
						expediente.setFechaVenta(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
				if(MOTIVO_NO_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					// Se incluye un motivo de anulacion del expediente, si se indico en la tarea
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
					DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
					expediente.setMotivoAnulacion(motivoAnulacion);
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_POSICIONAMIENTOYFIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
