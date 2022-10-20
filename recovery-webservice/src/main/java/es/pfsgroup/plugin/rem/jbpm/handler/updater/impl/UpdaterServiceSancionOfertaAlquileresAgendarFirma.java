package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Fianzas;
import es.pfsgroup.plugin.rem.model.HistoricoReagendacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoExoneracionFianza;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceSancionOfertaAlquileresAgendarFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private FuncionesTramitesApi funcionesTramitesApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresAgendarFirma.class);
    
	private static final String COMBO_FIANZA_EXONERADA = "comboFianza";
	private static final String FECHA_AGENDACION= "fechaAgendacionIngreso";
	private static final String FECHA_REAGENDAR_INGRESO = "fechaReagendarIngreso";
	private static final String IMPORTE = "importe";
	private static final String IBAN_DEVOLUCION = "ibanDev";
	private static final String MOTIVO_EXONERACION_FIANZA = "motivoFianzaExonerada";
	private static final String MESES = "meses";
	
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
					dto.setFianzaExonerada(DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor()));
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
				if (MOTIVO_EXONERACION_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setMotivoExoneracionFianza(valor.getValor());
				}
				if (MESES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setMeses(Integer.parseInt(valor.getValor()));
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
			
			this.actualizarCondicionesExpediente(dto, expedienteComercial.getCondicionante());
			
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
		}
			
		funcionesTramitesApi.devolverCuentaVirtualAlquiler(oferta.getActivoPrincipal(), fia, true);
			
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
	
	private void actualizarCondicionesExpediente(DtoTareasFormalizacion dto, CondicionanteExpediente condicionantesExpediente) {
		
		condicionantesExpediente.setFianzaExonerada(dto.getFianzaExonerada());
		
		if(!dto.getFianzaExonerada()) {
			condicionantesExpediente.setMesesFianza(dto.getMeses());
			condicionantesExpediente.setImporteFianza(dto.getImporte());
		}else {
			if(dto.getMotivoExoneracionFianza() != null) {
				condicionantesExpediente.setMotivoExoneracionFianza(genericDao.get(DDMotivoExoneracionFianza.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoExoneracionFianza())));
			}
		}
		genericDao.save(CondicionanteExpediente.class, condicionantesExpediente);
	}

}
