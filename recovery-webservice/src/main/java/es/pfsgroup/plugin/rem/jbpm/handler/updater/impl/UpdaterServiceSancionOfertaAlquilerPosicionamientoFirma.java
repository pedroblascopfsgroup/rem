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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.recovery.api.UsuarioApi;

@Component
public class UpdaterServiceSancionOfertaAlquilerPosicionamientoFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private ActivoDao activoDao;
    
    @Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
    
    @Autowired
    private ApiProxyFactory proxyFactory;

        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerPosicionamientoFirma.class);
    
	private static final String FECHA_INICIO = "fechaInicio";
	private static final String FECHA_FIN = "fechaFin";
	private static final String NUM_CONTRATO = "numContrato";
	private static final String COMBO_FIRMA = "comboFirma";
	
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_T014_POSICIONAMIENTO_FIRMA = "T014_PosicionamientoFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ActivoSituacionPosesoria situacionPosesoria = tramite.getActivo().getSituacionPosesoria();
//		Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(tramite.getActivo());
//		ExpedienteComercial expedienteComercial = null;
//		
//		if(!Checks.esNulo(ofertaAceptada))
//			expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta ofertaAceptada = expedienteComercial.getOferta();
		Filter tituloActivo;
		DDTipoTituloActivoTPA tipoTitulo;
		
		for(TareaExternaValor valor :  valores){

			//Fecha inicio Oferta Alquiler
			if(FECHA_INICIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha inicio => expediente comercial.fecha inicio
				try {
					if(!Checks.esNulo(expedienteComercial))
						expedienteComercial.setFechaInicioAlquiler(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
				for(ActivoOferta activoOferta : ofertaAceptada.getActivosOferta())
				{
					Activo activo = activoOferta.getPrimaryKey().getActivo();
					tituloActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTituloActivoTPA.tipoTituloSi);
					tipoTitulo = genericDao.get(DDTipoTituloActivoTPA.class, tituloActivo);
					
					situacionPosesoria.setConTitulo(tipoTitulo);
					situacionPosesoria.setOcupado(1);
					
					Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
					String usuarioModificar = usu == null ? CODIGO_T014_POSICIONAMIENTO_FIRMA : CODIGO_T014_POSICIONAMIENTO_FIRMA + " - " + usu.getUsername();
					
					situacionPosesoria.setUsuarioModificarOcupado(usuarioModificar);
					situacionPosesoria.setFechaModificarOcupado(new Date());
					situacionPosesoria.setUsuarioModificarConTitulo(usuarioModificar);
					situacionPosesoria.setFechaModificarConTitulo(new Date());
					
					if(usu!=null) {			
						HistoricoOcupadoTitulo histOcupado = new HistoricoOcupadoTitulo(activo,situacionPosesoria,usu,HistoricoOcupadoTitulo.COD_OFERTA_ALQUILER,null);
						genericDao.save(HistoricoOcupadoTitulo.class, histOcupado);					
					}
					try {
						situacionPosesoria.setFechaTomaPosesion(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					activo.setSituacionPosesoria(situacionPosesoria);
					
				}

			}
			
			//Fecha Fin Oferta Alquiler
			if(FECHA_FIN.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha fin => expediente comercial.fecha fin
				try {
					if(!Checks.esNulo(expedienteComercial))
						expedienteComercial.setFechaFinAlquiler(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			
			//No. de contrato
			if(NUM_CONTRATO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				if(!Checks.esNulo(expedienteComercial))
					expedienteComercial.setNumContratoAlquiler(valor.getValor());
			}
			
			//Combo Firmar contrato SI/NO
			if(COMBO_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())){
					// Actualizacion del estado de expediente comercial: ALQUILADO
					if(!Checks.esNulo(expedienteComercial)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ALQUILADO);
	
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expedienteComercial.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estado);

						List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
						
						//Rechazamos el resto de ofertas
						for(Oferta oferta : listaOfertas){
							if(DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())){
								ofertaApi.rechazarOferta(oferta);
							}
						}
						
					}
				} else {
					// Actualizacion del estado de expediente comercial: ANULADO
					if(!Checks.esNulo(expedienteComercial)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
	
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expedienteComercial.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estado);

						expedienteComercial.setFechaVenta(null);
						
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);

						//Rechaza la oferta y descongela el resto
						ofertaApi.rechazarOferta(ofertaAceptada);
						try {
							ofertaApi.descongelarOfertas(expedienteComercial);
						} catch (Exception e) {
							logger.error("Error descongelando ofertas.", e);
						}
					}
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T014_POSICIONAMIENTO_FIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
