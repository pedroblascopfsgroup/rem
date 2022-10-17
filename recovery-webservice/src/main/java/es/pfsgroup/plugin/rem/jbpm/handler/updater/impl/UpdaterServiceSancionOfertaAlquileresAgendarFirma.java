package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.DepositoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CuentasVirtualesAlquiler;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Fianzas;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.HistoricoReagendacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;

@Component
public class UpdaterServiceSancionOfertaAlquileresAgendarFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private ActivoAdapter activoAdapter;
        
    @Autowired
    private ApiProxyFactory proxyFactory;
    
    @Autowired
    private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private GenericApi genericApi;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private DepositoApi depositoApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresAgendarFirma.class);
    
	private static final String FECHA_FIRMA = "fechaFirma";
	private static final String COMBO_RESULTADO= "comboResultado";
	private static final String FECHA_INICIO = "fechaInicio";
	private static final String FECHA_FIN = "fechaFin";
	private static final String COMBO_FIRMA = "comboFirma";
	
	private static final String COMBO_FIANZA_EXONERADA = "comboFianza";
	private static final String FECHA_AGENDACION= "fechaAgendacionIngreso";
	private static final String FECHA_REAGENDAR_INGRESO = "fechaReagendarIngreso";
	private static final String IMPORTE = "importe";
	private static final String IBAN_DEVOLUCION = "ibanDev";
	
	private static final String CODIGO_T015_AGENDAR_FIRMA = "T015_AgendarFechaFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		

		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		String estadoBC = null;
		String estadoHaya = null;
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();		
		try {
			for(TareaExternaValor valor :  valores){
	
				if (COMBO_FIANZA_EXONERADA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFianzaExonerada(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
				}
				if (FECHA_AGENDACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaAgendacion(ft.parse(valor.getValor()));
				}
				if (FECHA_REAGENDAR_INGRESO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaReagendarIngreso(ft.parse(valor.getValor()));
				}
				if (IMPORTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setImporte(Double.parseDouble(valor.getValor()));
				}
				if (IBAN_DEVOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setIbanDevolucion(valor.getValor());
				}
			}
		
		
			Fianzas fia = genericDao.get(Fianzas.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
			
			if(!Checks.esNulo(dto.getFianzaExonerada()) && dto.getFianzaExonerada()) {
				if(fia != null) {
					Auditoria.delete(fia);
					genericDao.save(Fianzas.class, fia);
				}
				estadoBC = DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO;
				estadoHaya = DDEstadosExpedienteComercial.PTE_FIRMA;
			}else {
				estadoBC = DDEstadoExpedienteBc.CODIGO_ENTREGA_GARANTIAS_FIANZAS_AVAL;
				estadoHaya = DDEstadosExpedienteComercial.PTE_INGRESO_FIANZA;

				fia = this.updateOrCreateFianza(fia, oferta, dto);
				this.crearRegistroEnHistorico(fia, dto);
			}
			
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoHaya)));
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBC)));
			genericDao.save(ExpedienteComercial.class, expedienteComercial);
			
		}catch (ParseException e) {
			logger.error("error en UpdaterServiceSancionOfertaAlquileresAgendarFirma", e);
			e.printStackTrace();
		}

				
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_AGENDAR_FIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private Fianzas updateOrCreateFianza(Fianzas fia, Oferta oferta, DtoTareasFormalizacion dto) {
		if(fia == null) {
			fia = new Fianzas();
			fia.setOferta(oferta);
			
			List<CuentasVirtualesAlquiler> cuentasVirtualesAlquiler = depositoApi.vincularCuentaVirtualAlquiler(oferta.getActivoPrincipal(), fia);
			
			CuentasVirtualesAlquiler cuentaVirtualAlquiler = null;
			
			if(cuentasVirtualesAlquiler != null && !cuentasVirtualesAlquiler.isEmpty()) {
				cuentaVirtualAlquiler = cuentasVirtualesAlquiler.get(0);
				cuentaVirtualAlquiler.setFechaInicio(new Date());
				cuentaVirtualAlquiler.getAuditoria().setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
				cuentaVirtualAlquiler.getAuditoria().setFechaModificar(new Date());
				
				fia.setCuentaVirtualAlquiler(cuentaVirtualAlquiler);

				genericDao.update(CuentasVirtualesAlquiler.class, cuentaVirtualAlquiler);
			}
		}
		
		fia.setFechaAgendacionIngreso(dto.getFechaAgendacion());
		fia.setImporte(dto.getImporte());
		
		fia.setIbanDevolucion(dto.getIbanDevolucion());
		genericDao.save(Fianzas.class, fia);
		
		return fia;
	}
	
	private void crearRegistroEnHistorico(Fianzas fia, DtoTareasFormalizacion dto) {
		if (!Checks.esNulo(dto.getFechaReagendarIngreso())) {
			HistoricoReagendacion histReagendacion = new HistoricoReagendacion();
			histReagendacion.setFianza(fia);
			histReagendacion.setFechaReagendacionIngreso(dto.getFechaReagendarIngreso());
			genericDao.save(HistoricoReagendacion.class, histReagendacion);
		}
	}

}
