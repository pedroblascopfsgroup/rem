package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.FechaArrasExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Component
public class UpdaterServiceConfirmarFechaFirmaArras implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	private static final String CODIGO_T017_CONFIRMAR_FECHA_FIRMA_ARRAS = "T017_ConfirmarFechaFirmaArras";
	private static final String motivoAplazamiento = "Suspensión proceso arras";
	private static final String COMBO_QUITAR = "comboQuitar";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceConfirmarFechaFirmaArras.class);

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Usuario usuarioLogeado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		if (ofertaAceptada != null) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			FechaArrasExpediente fae = null;
			DDEstadosExpedienteComercial estadoExp = null;
			DDEstadoExpedienteBc estadoBc = null;
			
			for(TareaExternaValor valor :  valores){
				if (COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_PBC_VENTAS);
						estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estadoExp);
						
						Filter filtroBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA);
						estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroBc);
						expediente.setEstadoBc(estadoBc);
						
						genericDao.save(ExpedienteComercial.class, expediente);
						
						Filter filtroReserva = genericDao.createFilter(FilterType.EQUALS,  "expediente.id", expediente.getId());
						Reserva reserva = genericDao.get(Reserva.class, filtroReserva);
						
						if (reserva != null) {
							reserva.getAuditoria().setBorrado(true);
							reserva.getAuditoria().setUsuarioBorrar(usuarioLogeado.getUsername());
							reserva.getAuditoria().setFechaBorrar(new Date());
						}
						
						genericDao.update(Reserva.class, reserva);
						
						fae = expedienteComercialApi.getUltimaPropuesta(expediente.getId(), null);
						if (fae != null) {
							DDMotivosEstadoBC motivoBC = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_ANULADA));
							fae.setValidacionBC(motivoBC);
						}
						fae.setMotivoAnulacion(motivoAplazamiento);
						
						genericDao.save(FechaArrasExpediente.class, fae);
						
					}
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_CONFIRMAR_FECHA_FIRMA_ARRAS };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		// TODO Auto-generated method stub
		
	}

}
