package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSeguroRentasAlquiler;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.SeguroRentasAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Component
public class UpdaterServiceSancionOfertaAlquileresVerificarSeguroRentas implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
		
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresVerificarSeguroRentas.class);
		
    private static final String RESULTADO_SEGURO_RENTAS = "resultadoRentas";
	private static final String FECHA_SANCION_RENTAS = "fechaSancRentas";
	private static final String MOTIVO_RECHAZO = "motivoRechazo";
	private static final String N_MESES_FIANZA = "nMesesFianza";
	private static final String IMPORTE_FIANZA = "importeFianza";
	private static final String DEPOSITO = "deposito";
	private static final String N_MESES = "nMeses";
	private static final String IMPORTE_DEPOSITO = "importeDeposito";
	private static final String FIADOR_SOLIDARIO = "fiadorSolidario";
	private static final String NOMBRE_FS = "nombreFS";
	private static final String DOCUMENTO = "documento";
	private static final String TIPO_IMPUESTO = "tipoImpuesto";
	private static final String PORCENTAJE_IMPUESTO = "porcentajeImpuesto";
	private static final String ASEGURADORA = "aseguradora";
	private static final String ENVIO_EMAIL = "envioEmail";
	private static final String OBSERVACIONES = "observaciones";
	
	private static final String CODIGO_T015_VERIFICAR_SEGURO_RENTAS = "T015_VerificarSeguroRentas";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();
		Oferta oferta = expedienteComercial.getOferta();
		
		boolean estadoBcModificado = false;
		Boolean checkDepositoMarcado = false;
		Boolean checkFiadorSolidarioMarcado = false;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId());
		SeguroRentasAlquiler seguroRentasAlquiler = genericDao.get(SeguroRentasAlquiler.class, filtro);
		
		HistoricoSeguroRentasAlquiler historicoSeguroRentasAlquiler = new HistoricoSeguroRentasAlquiler();
		
		if(Checks.esNulo(seguroRentasAlquiler)) {
			seguroRentasAlquiler = new SeguroRentasAlquiler();
			seguroRentasAlquiler.setExpediente(expedienteComercial);
		}
		DDResultadoCampo resultadoCampo = null;
		boolean replicarOferta = true;
		for(TareaExternaValor valor :  valores){

			if(RESULTADO_SEGURO_RENTAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				@SuppressWarnings("unused")
				Filter filtroResultadoSeguroRentas = null;
				DDEstadosExpedienteComercial estadoExpedienteComercial = null;
				if(DDResultadoCampo.RESULTADO_APROBADO.equals(valor.getValor())) {
					filtroResultadoSeguroRentas = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoCampo.RESULTADO_APROBADO);
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_ELEVAR_SANCION));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					resultadoCampo = (DDResultadoCampo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoCampo.class, DDResultadoCampo.RESULTADO_APROBADO);
					historicoSeguroRentasAlquiler.setResultadoSeguroRentas(resultadoCampo);
					seguroRentasAlquiler.setResultadoSeguroRentas(resultadoCampo);
					expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_PDTE_APROBACION_BC)));
					estadoBcModificado = true;
				}else {
					filtroResultadoSeguroRentas = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoCampo.RESULTADO_RECHAZADO);
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.ANULADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
					oferta.setEstadoOferta(estadoOferta);
					resultadoCampo = (DDResultadoCampo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoCampo.class, DDResultadoCampo.RESULTADO_RECHAZADO);
					historicoSeguroRentasAlquiler.setResultadoSeguroRentas(resultadoCampo);
					seguroRentasAlquiler.setResultadoSeguroRentas(resultadoCampo);
					replicarOferta = true;
				}
			}
			
			if(FECHA_SANCION_RENTAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					historicoSeguroRentasAlquiler.setFechaSancion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha sanción scoring.", e);
				}
			}
			
			if(MOTIVO_RECHAZO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				//TODO motivo rechazo a partir de diccionario DDMotivoRechazoAlquiler cuando este definido.
				DDMotivoRechazoAlquiler motivoRechazoAlquiler = null;
				if(DDMotivoRechazoAlquiler.MOTIVO_RECHAZO_1.equals(valor.getValor())) {
					motivoRechazoAlquiler = (DDMotivoRechazoAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoAlquiler.class, DDMotivoRechazoAlquiler.MOTIVO_RECHAZO_1);
					seguroRentasAlquiler.setMotivoRechazo(motivoRechazoAlquiler.getDescripcion());
				}else if(DDMotivoRechazoAlquiler.MOTIVO_RECHAZO_2.equals(valor.getValor())) {
					motivoRechazoAlquiler = (DDMotivoRechazoAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoAlquiler.class, DDMotivoRechazoAlquiler.MOTIVO_RECHAZO_2);
					seguroRentasAlquiler.setMotivoRechazo(motivoRechazoAlquiler.getDescripcion());
				}else {
					motivoRechazoAlquiler = (DDMotivoRechazoAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoAlquiler.class, DDMotivoRechazoAlquiler.MOTIVO_RECHAZO_3);
					seguroRentasAlquiler.setMotivoRechazo(motivoRechazoAlquiler.getDescripcion());
				}
			}
			
			if(N_MESES_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				condiciones.setMesesFianza(Integer.parseInt(valor.getValor()));
				historicoSeguroRentasAlquiler.setMesesFianza(Integer.parseInt(valor.getValor()));
			}
				
			if(IMPORTE_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				condiciones.setImporteFianza(Double.parseDouble(valor.getValor()));
				historicoSeguroRentasAlquiler.setImportFianza(Long.parseLong(valor.getValor()));
			}
				
			if(DEPOSITO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				checkDepositoMarcado = Boolean.parseBoolean(valor.getValor());
			}
				
			if(checkDepositoMarcado) {
				if(N_MESES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setMesesDeposito(Integer.parseInt(valor.getValor()));
				}
					
				if(IMPORTE_DEPOSITO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setImporteDeposito(Double.parseDouble(valor.getValor()));
				}
			}
				
			if(FIADOR_SOLIDARIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				checkFiadorSolidarioMarcado = Boolean.parseBoolean(valor.getValor());
			}
				
			if(checkFiadorSolidarioMarcado) {
				if(NOMBRE_FS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setAvalista(valor.getValor());
				}
					
				if(DOCUMENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setDocumentoFiador(valor.getValor());
				}
			}
				
			if(TIPO_IMPUESTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtroTipoImpuesto = null;
				
				if(DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IVA);
				}else if(DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_ITP);
				}else if(DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IGIC);
				}else if(DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IPSI);
				}
					
				if(!Checks.esNulo(filtroTipoImpuesto)) {
					DDTiposImpuesto tipoImpuesto = genericDao.get(DDTiposImpuesto.class, filtroTipoImpuesto);
					condiciones.setTipoImpuesto(tipoImpuesto);
				}
			}
				
			if(PORCENTAJE_IMPUESTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				condiciones.setTipoAplicable(Double.parseDouble(valor.getValor()));
			}
			
			if(ASEGURADORA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				seguroRentasAlquiler.setAseguradoras(valor.getValor());
			}
			
			if(ENVIO_EMAIL.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				seguroRentasAlquiler.setEmailPolizaAseguradora(valor.getValor());
			}
				
			if(OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				seguroRentasAlquiler.setComentarios(valor.getValor());
			}
		}
		expedienteComercial.setOferta(oferta);
		expedienteComercialApi.update(expedienteComercial,false);
		genericDao.update(SeguroRentasAlquiler.class, seguroRentasAlquiler);
		historicoSeguroRentasAlquiler.setSeguroRentasAlquiler(seguroRentasAlquiler);
		genericDao.save(HistoricoSeguroRentasAlquiler.class, historicoSeguroRentasAlquiler);
		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
		} else if (replicarOferta){
			ofertaApi.llamaReplicarCambioEstado(oferta.getId(), oferta.getEstadoOferta().getCodigo());
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_VERIFICAR_SEGURO_RENTAS};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
