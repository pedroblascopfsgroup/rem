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
import es.pfsgroup.plugin.rem.model.DtoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoGridFechaArras;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.FechaArrasExpediente;
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
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	private static final String CODIGO_T017_AGENDAR_FECHA_ARRAS = "T017_AgendarFechaFirmaArras";
	private static final String COMBO_QUITAR = "comboQuitar";
	private static final String COMBO_FECHA_ENVIO_PROPUESTA = "fechaEnvioPropuesta";
	private static final String COMBO_FECHA_ENVIO = "fechaEnvio";
	private static final String MOTIVO_APLAZAMIENTO = "Suspensión proceso arras";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarFechaArras.class);

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		DtoGridFechaArras dtoArras = new DtoGridFechaArras();
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Usuario usuarioLogeado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		try {
			if (ofertaAceptada != null) {
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				FechaArrasExpediente fae = null;
				DDEstadosExpedienteComercial estadoExp = null;
				DDEstadoExpedienteBc estadoBc = null;
				String estadoArras = null;
				String motivoAplazamiento = null;
				
				for(TareaExternaValor valor :  valores){
					if(COMBO_FECHA_ENVIO_PROPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoArras.setFechaPropuesta(ft.parse(valor.getValor()));
					}
					if(COMBO_FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoArras.setFechaEnvio(ft.parse(valor.getValor()));	
					}
					
					if (COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDSiNo.SI.equals(valor.getValor())) {
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_PBC_VENTAS);
							estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estadoExp);
							
							genericDao.save(ExpedienteComercial.class, expediente);
							
							Filter filtroReserva = genericDao.createFilter(FilterType.EQUALS,  "expediente.id", expediente.getId());
							Reserva reserva = genericDao.get(Reserva.class, filtroReserva);
							
							if (reserva != null) {
								reserva.getAuditoria().setBorrado(true);
								reserva.getAuditoria().setUsuarioBorrar(usuarioLogeado.getUsername());
								reserva.getAuditoria().setFechaBorrar(new Date());
							}
							
							genericDao.update(Reserva.class, reserva);
							
							estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA));
							estadoArras = DDMotivosEstadoBC.CODIGO_ANULADA;
							motivoAplazamiento = MOTIVO_APLAZAMIENTO;
							
						} else {
							estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_VALIDACION_DE_FIRMA_DE_ARRAS_POR_BC));
							estadoArras = DDMotivosEstadoBC.CODIGO_PDTE_VALIDACION;

						}
					}
				}	
				DtoExpedienteComercial dto = expedienteComercialApi.getExpedienteComercialByOferta(ofertaAceptada.getNumOferta());
				dtoArras.setValidacionBC(estadoArras);
				dtoArras.setMotivoAnulacion(motivoAplazamiento);
				expedienteComercialApi.createOrUpdateUltimaPropuestaEnviada(dto.getId(), dtoArras);		
				
				expediente.setEstadoBc(estadoBc);
				genericDao.save(ExpedienteComercial.class, expediente);
				ofertaApi.replicateOfertaFlush(expediente.getOferta());
				
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
