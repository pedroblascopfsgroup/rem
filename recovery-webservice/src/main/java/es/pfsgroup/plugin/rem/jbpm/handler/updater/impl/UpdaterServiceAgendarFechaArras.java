package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoGridFechaArras;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Component
public class UpdaterServiceAgendarFechaArras implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;


	private static final String CODIGO_T017_AGENDAR_FECHA_ARRAS = "T017_AgendarFechaFirmaArras";
	private static final String COMBO_QUITAR = "comboQuitar";
	private static final String COMBO_FECHA_ENVIO_PROPUESTA = "fechaPropuesta";
	private static final String COMBO_FECHA_ENVIO = "fechaEnvio";
	private static final String MOTIVO_APLAZAMIENTO = "Suspensión proceso arras";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarFechaArras.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		DtoGridFechaArras dtoArras = new DtoGridFechaArras();
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.getExpedienteByIdTramite(tramite.getId());
		String fechaPropuesta = null;
		boolean comboQuitar = false;
		try {
			if (ofertaAceptada != null && expediente != null) {
				String estadoExp = null;
				String estadoBc = null;
				String estadoArras = null;
				
				for(TareaExternaValor valor :  valores){
					if(COMBO_FECHA_ENVIO_PROPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoArras.setFechaPropuesta(ft.parse(valor.getValor()));
						fechaPropuesta = valor.getValor();
					}else if(COMBO_FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoArras.setFechaEnvio(ft.parse(valor.getValor()));	
					}else if (COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDSiNo.SI.equals(valor.getValor())) {
							comboQuitar = true;
						}
					}
				}	
				
				DtoExpedienteComercial dto = expedienteComercialApi.getExpedienteComercialByOferta(ofertaAceptada.getNumOferta());
				
				if(comboQuitar) {
					estadoExp =  DDEstadosExpedienteComercial.PTE_PBC_VENTAS;
					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA;
					
					estadoArras = DDMotivosEstadoBC.CODIGO_ANULADA;
					dtoArras.setMotivoAnulacion(MOTIVO_APLAZAMIENTO);
					
					Filter filtroReserva = genericDao.createFilter(FilterType.EQUALS,  "expediente.id", expediente.getId());
					Reserva reserva = genericDao.get(Reserva.class, filtroReserva);
					
					if (reserva != null) {
						Auditoria.delete(reserva);
						genericDao.save(Reserva.class, reserva);
					}
					
				}else {
					estadoExp =  DDEstadosExpedienteComercial.PTE_FIRMA_ARRAS;
					estadoBc =  DDEstadoExpedienteBc.CODIGO_VALIDACION_DE_FIRMA_DE_ARRAS_POR_BC;
					estadoArras = DDMotivosEstadoBC.CODIGO_PDTE_VALIDACION;
				}
				
				dtoArras.setValidacionBC(estadoArras);
				expedienteComercialApi.createOrUpdateUltimaPropuestaEnviada(dto.getId(), dtoArras);		
				
				expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));
				expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));				
				genericDao.save(ExpedienteComercial.class, expediente);
				
				ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpedienteAndArras(expediente, fechaPropuesta));

			}
		}catch(ParseException e) {
			e.printStackTrace();
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_AGENDAR_FECHA_ARRAS };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
