package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTratamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Component
public class UpdaterServiceSancionOfertaAlquileresDefinicionOferta implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

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
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();
		
		Boolean tipoTratamientoNinguna = false;
		Boolean checkDepositoMarcado = false;
		Boolean checkFiadorSolidarioMarcado = false;
		
		for(TareaExternaValor valor :  valores){
			
			if(TIPO_TRATAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDTipoTratamiento.TIPO_TRATAMIENTO_NINGUNA.equals(valor.getValor()))
					tipoTratamientoNinguna = true;
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
				if(FECHA_TRATAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					try {
						if(!Checks.esNulo(expedienteComercial))
							if(!Checks.esNulo(expedienteComercial.getReserva()))
								
								expedienteComercial.getReserva().setFechaFirma(ft.parse(valor.getValor()));
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
