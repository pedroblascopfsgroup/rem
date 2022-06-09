package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;

@Component
public class UpdaterServiceSancionOfertaRecomendacionCES implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRecomendacionCES.class);
	 
	private static final String COMBO_RESOLUCION = "comboRespuesta";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String CODIGO_T017_RECOMENDACION_CES = "T017_RecomendCES";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Filter filtro = null;	
		boolean rechazar = false;
		
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {		
				for (TareaExternaValor valor : valores) {
					if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						try {
							expediente.setFechaRecomendacionCes(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
					if (COMBO_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {		
						if (DDApruebaDeniega.CODIGO_APRUEBA.equals(valor.getValor())) {

							ofertaApi.congelarOfertasAndReplicate(ofertaAceptada.getActivoPrincipal(), ofertaAceptada);
							
						} else if (DDApruebaDeniega.CODIGO_DENIEGA.equals(valor.getValor())) {
							rechazar = true;
							if(((!Checks.esNulo(expediente.getReserva()))
									&& !Checks.esNulo(expediente.getReserva().getEstadoReserva())
									&& !DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo()))
									|| Checks.esNulo(expediente.getReserva()) 
									|| !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva()) && expediente.getCondicionante().getSolicitaReserva() == 0) {
								expediente.setFechaVenta(null);
								expediente.setFechaAnulacion(new Date());
									
								DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDTipoRechazoOferta.class,
												DDTipoRechazoOferta.CODIGO_DENEGADA);
								
								DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class,
												DDMotivoRechazoOferta.CODIGO_DECISION_COMITE);
								
								motivoRechazo.setTipoRechazo(tipoRechazo);
								ofertaAceptada.setMotivoRechazo(motivoRechazo);
							}
						}
					}
				}
				if(!Checks.esNulo(filtro)) {
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setEstado(estado);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
				}
				genericDao.save(Oferta.class, ofertaAceptada);
				genericDao.save(ExpedienteComercial.class, expediente);
				
				if (rechazar) {
					ofertaApi.inicioRechazoDeOfertaSinLlamadaBC(ofertaAceptada, DDEstadosExpedienteComercial.DENEGADA_OFERTA_CES);
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_RECOMENDACION_CES };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
