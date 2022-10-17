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
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.DepositoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CuentasVirtualesAlquiler;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Fianzas;
import es.pfsgroup.plugin.rem.model.HistoricoReagendacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceAgendarFirmaNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private ApiProxyFactory proxyFactory;
    
    @Autowired
	private GenericApi genericApi;
    
    @Autowired
    private DepositoApi depositoApi;
	
    @Autowired
	private UsuarioApi usuarioApi;
    
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarFirmaNoComercial.class);
    
    SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
    
	private static final String COMBO_FIANZA_EXONERADA = "comboResultado";
	private static final String FECHA_AGENDACION = "fechaAgendacionIngreso";
	private static final String FECHA_REAGENDACION = "fechaReagendarIngreso";
	private static final String IMPORTE = "importe";
	private static final String IBAN_DEVOLUCION = "ibanDev";

	private static final String CODIGO_T018_AGENDAR_FIRMA = "T018_AgendarFirma";
	
	@SuppressWarnings("null")
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		boolean fianzaExonerada = false;
		boolean fechaReagendacionRelleno = false;
		String fechaAgendacionValor = null;
		String fechaReagendarIngresoValor = null;
		String importe = null;
		String ibanDevolucion = null;
		Fianzas fianza = null;
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Activo activo =tramite.getActivo();
		Oferta oferta = expedienteComercial.getOferta();
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Filter filterOfr =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
		Fianzas fia = genericDao.get(Fianzas.class, filterOfr);
		
		for(TareaExternaValor valor :  valores){
			
			if (DDCartera.CODIGO_CAIXA.equals(activo.getCartera().getCodigo())) {
				if (COMBO_FIANZA_EXONERADA.equals(valor.getNombre()) && !Checks.esNulo(DDSinSiNo.cambioStringtoBooleano(valor.getValor())) && DDSinSiNo.cambioStringtoBooleano(valor.getValor())) {
					fianzaExonerada = true;
				}
				if (FECHA_AGENDACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					fechaAgendacionValor = valor.getValor();
				}
				if (FECHA_REAGENDACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					fechaReagendacionRelleno = true;
					fechaReagendarIngresoValor = valor.getValor();
				}
				if (IMPORTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					importe = valor.getValor();
				}
				if (IBAN_DEVOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					ibanDevolucion = valor.getValor();
				}
			}
		}
		
		if (fianzaExonerada) {
			if (fia != null) {
				fia.getAuditoria().setUsuarioBorrar(usu.getUsername());
				fia.getAuditoria().setFechaBorrar(new Date());
				fia.getAuditoria().setBorrado(true);
				genericDao.save(Fianzas.class, fia);
			}
			
		} else {
			if (fia != null) {
				if (oferta != null) {
					fia.setOferta(oferta);
				}
				if (fechaAgendacionValor != null) {
					try {
						fia.setFechaAgendacionIngreso(ft.parse(fechaAgendacionValor));
					} catch (ParseException e) {
						logger.error("error en UpdaterServiceAgendarFirmaNoComercial", e);
						e.printStackTrace();
					}
				}
				if (importe != null) {
					fia.setImporte(Double.parseDouble(importe));
				}		
				if (ibanDevolucion != null) {
					fia.setIbanDevolucion(ibanDevolucion);
				}
				fianza = fia;
				genericDao.save(Fianzas.class, fia);
			} else {
				Fianzas fiaN = new Fianzas();
				if (oferta != null) {
					fiaN.setOferta(oferta);
				}
				if (fechaAgendacionValor != null) {
					try {
						fiaN.setFechaAgendacionIngreso(ft.parse(fechaAgendacionValor));
					} catch (ParseException e) {
						logger.error("error en UpdaterServiceAgendarFirmaNoComercial", e);
						e.printStackTrace();
					}
				}
				if (importe != null) {
					fiaN.setImporte(Double.parseDouble(importe));
				}		
				if (ibanDevolucion != null) {
					fiaN.setIbanDevolucion(ibanDevolucion);
				}

				fianza = fiaN;
				List<CuentasVirtualesAlquiler> cuentasVirtualesAlquiler = depositoApi.vincularCuentaVirtualAlquiler(activo, fiaN);
				
				CuentasVirtualesAlquiler cuentaVirtualAlquiler = null;
				
				if(cuentasVirtualesAlquiler != null && !cuentasVirtualesAlquiler.isEmpty()) {
					cuentaVirtualAlquiler = cuentasVirtualesAlquiler.get(0);
					cuentaVirtualAlquiler.setFechaInicio(new Date());
					cuentaVirtualAlquiler.getAuditoria().setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
					cuentaVirtualAlquiler.getAuditoria().setFechaModificar(new Date());
					
					fia.setCuentaVirtualAlquiler(cuentaVirtualAlquiler);

					genericDao.update(CuentasVirtualesAlquiler.class, cuentaVirtualAlquiler);
				}
				genericDao.save(Fianzas.class, fiaN);
			}
			
			if (fechaReagendacionRelleno) {
				HistoricoReagendacion histReagendacion = new HistoricoReagendacion();
				histReagendacion.setFianza(fianza);
				if (fechaReagendarIngresoValor != null) {
					try {
						histReagendacion.setFechaReagendacionIngreso(ft.parse(fechaReagendarIngresoValor));
					} catch (ParseException e) {
						logger.error("error en UpdaterServiceAgendarFirmaNoComercial", e);
						e.printStackTrace();
					}
				}
				genericDao.save(HistoricoReagendacion.class, histReagendacion);
			}
			
		}	
		
		String estadoExpBC = this.devolverEstadoBC(fianzaExonerada, tareaExternaActual);
		if(estadoExpBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigoC4C", estadoExpBC)));
		}
				
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_AGENDAR_FIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private String devolverEstadoBC(Boolean fianzaExonerada,  TareaExterna tareaExterna) {
		String estadoExpBC = null;
		if(fianzaExonerada != null) {
			if(fianzaExonerada) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO;
			}else {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_ENTREGA_GARANTIAS_FIANZAS_AVAL;
			}
		}
		
		return estadoExpBC;
	}

}
