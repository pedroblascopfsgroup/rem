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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.SeguroRentasAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTratamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Component
public class UpdaterServiceSancionOfertaAlquileresDefinicionOferta implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
		

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresDefinicionOferta.class);
    
	private static final String TIPO_TRATAMIENTO = "tipoTratamiento";
	private static final String FECHA_TRATAMIENTO = "fechaTratamiento";
	private static final String TIPO_INQUILINO = "tipoInquilino";
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
	private static final String OBSERVACIONES = "observaciones";
	
	private static final String CODIGO_T015_DEFINICION_OFERTA = "T015_DefinicionOferta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();
		List<ActivoOferta> activosOferta = oferta.getActivosOferta();
		boolean estadoBcModificado = false;
		Boolean tipoTratamientoNinguna = false;
		Boolean checkDepositoMarcado = false;
		Boolean checkFiadorSolidarioMarcado = false;
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(TIPO_TRATAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDTipoTratamiento.TIPO_TRATAMIENTO_NINGUNA.equals(valor.getValor())){
					tipoTratamientoNinguna = true;
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_ELEVAR_SANCION));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);
					expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_PDTE_APROBACION_BC)));
					estadoBcModificado = true;

				} else if (DDTipoTratamiento.TIPO_TRATAMIENTO_SCORING.equals(valor.getValor())){
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_SCORING));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

				} else if (DDTipoTratamiento.TIPO_TRATAMIENTO_SEGURO_DE_RENTAS.equals(valor.getValor())){
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_SEGURO_RENTAS));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					Filter filter = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId());
					SeguroRentasAlquiler seguroRentasAlquiler = genericDao.get(SeguroRentasAlquiler.class, filter);
					if(Checks.esNulo(seguroRentasAlquiler)) {
						seguroRentasAlquiler = new SeguroRentasAlquiler();
						seguroRentasAlquiler.setExpediente(expedienteComercial);
						genericDao.save(SeguroRentasAlquiler.class, seguroRentasAlquiler);
					}
				}
			}
			
			if(TIPO_INQUILINO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtro = null;
				
				if(DDTipoInquilino.TIPO_INQUILINO_NORMAL.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoInquilino.TIPO_INQUILINO_NORMAL);
				}else if(DDTipoInquilino.TIPO_INQUILINO_ANTIGUO_DEUDOR.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoInquilino.TIPO_INQUILINO_ANTIGUO_DEUDOR);
				}else if(DDTipoInquilino.TIPO_INQUILINO_EMPLEADO_PROPIETARIO.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoInquilino.TIPO_INQUILINO_EMPLEADO_PROPIETARIO);
				}else if(DDTipoInquilino.TIPO_INQUILINO_EMPLEADO_HAYA.equals(valor.getValor())) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoInquilino.TIPO_INQUILINO_EMPLEADO_HAYA);
				}
				
				if(!Checks.esNulo(filtro)) {
					DDTipoInquilino tipoInquilino = genericDao.get(DDTipoInquilino.class, filtro);
					oferta.setTipoInquilino(tipoInquilino);
					Filter filtroTipoEstadoAlquiler = genericDao.createFilter(FilterType.EQUALS, "codigo",DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE);
					DDTipoEstadoAlquiler tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, filtroTipoEstadoAlquiler);
					for(ActivoOferta activoOferta : activosOferta){
						Activo activo = activoOferta.getPrimaryKey().getActivo();
						Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
						ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivo);
						if(!Checks.esNulo(activoPatrimonio)){
							activoPatrimonio.setTipoInquilino(tipoInquilino);
						}else{
							activoPatrimonio = new ActivoPatrimonio();
							activoPatrimonio.setActivo(activo);
							activoPatrimonio.setTipoInquilino(tipoInquilino);
							if (!Checks.esNulo(tipoEstadoAlquiler)){
								activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
							}
						}
						genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
						
					}
				}
			}
			
			if(tipoTratamientoNinguna) {
				if(N_MESES_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setMesesFianza(Integer.parseInt(valor.getValor()));
				}
				
				if(IMPORTE_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setImporteFianza(Double.parseDouble(valor.getValor()));
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
					Filter filtro = null;
					
					if(DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(valor.getValor())) {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IVA);
					}else if(DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(valor.getValor())) {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_ITP);
					}else if(DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(valor.getValor())) {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IGIC);
					}else if(DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(valor.getValor())) {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IPSI);
					}
					
					if(!Checks.esNulo(filtro)) {
						DDTiposImpuesto tipoImpuesto = genericDao.get(DDTiposImpuesto.class, filtro);
						condiciones.setTipoImpuesto(tipoImpuesto);
					}
				}
				
				if(PORCENTAJE_IMPUESTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setTipoAplicable(Double.parseDouble(valor.getValor()));
				}
				
				if(OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					//TODO El funcional no indica donde se guarda el campo.
				}
			}else{
				if(FECHA_TRATAMIENTO.equals(valor.getNombre())) {
					try {
						if (!Checks.esNulo(valor.getValor())) {
							condiciones.setFechaFirma(ft.parse(valor.getValor()));
						} else {
							condiciones.setFechaFirma(new Date());
						}
						
					} catch (ParseException e) {
						logger.error("Error insertando Fecha Tratamiento.", e);
					}
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_DEFINICION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
