package es.pfsgroup.plugin.rem.updaterstate;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.impl.UpdaterServiceSancionOfertaResolucionExpediente;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;

@Service("updaterStateOfertaManager")
public class UpdaterStateOfertaManager implements UpdaterStateOfertaApi{
	
	@Autowired
    private GenericABMDao genericDao;
	
	@Autowired
    private OfertaApi ofertaApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
    private ActivoApi activoApi;
	
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionExpediente.class);
	
	@Override
	@Transactional(readOnly = false)
	public void updaterStateDevolucionReserva(String codigoDevolucionReserva, ActivoTramite tramite, Oferta ofertaAceptada, ExpedienteComercial expediente) {
		
		Filter filtro;
		if(DDDevolucionReserva.CODIGO_NO.equals(codigoDevolucionReserva)) {
			
			//Anula el expediente
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
			expediente.setFechaVenta(null);
			expediente.setFechaAnulacion(new Date());

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
			Filter filtroTanteo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoTanteo.CODIGO_EJERCIDO);
			ofertaAceptada.setResultadoTanteo(genericDao.get(DDResultadoTanteo.class, filtroTanteo));

			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
			expediente.setEstado(estado);
			recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

			genericDao.save(ExpedienteComercial.class, expediente);

			Reserva reserva = expediente.getReserva();
			if(!Checks.esNulo(reserva)){
				reserva.setIndicadorDevolucionReserva(0);
				Filter filtroEstadoReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO);
				DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class, filtroEstadoReserva);
				reserva.setEstadoReserva(estadoReserva);
				reserva.setDevolucionReserva(this.getDevolucionReserva(codigoDevolucionReserva));
				
				genericDao.save(Reserva.class, reserva);
			}
//			HREOS-13592 Se bloquea el evolutivo de ocultación de activos para la subida 
//			activoApi.devolucionFasePublicacionAnterior(tramite.getActivo());
		} else {
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.EN_DEVOLUCION);
			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
			expediente.setEstado(estado);
			recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

			genericDao.save(ExpedienteComercial.class, expediente);
			
			Reserva reserva = expediente.getReserva();
			if(!Checks.esNulo(reserva)){
				reserva.setIndicadorDevolucionReserva(1);
				Filter filtroEstadoReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION);
				DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class, filtroEstadoReserva);
				reserva.setEstadoReserva(estadoReserva);
				reserva.setDevolucionReserva(this.getDevolucionReserva(codigoDevolucionReserva));

				genericDao.save(Reserva.class, reserva);
			}
		}
	}
	
	private DDDevolucionReserva getDevolucionReserva(String codigo) {
		Filter filtroDevolucionReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		return genericDao.get(DDDevolucionReserva.class, filtroDevolucionReserva);
	}
}
