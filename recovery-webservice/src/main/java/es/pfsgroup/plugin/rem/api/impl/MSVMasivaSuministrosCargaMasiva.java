package es.pfsgroup.plugin.rem.api.impl;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoSuministros;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAltaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoBajaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDPeriodicidad;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSuministro;

@Component
public class MSVMasivaSuministrosCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int NUM_ACTIVO = 0;
	private static final int TIPO_SUMINISTRO = 1;
	private static final int SUBTIPO_SUMINISTRO = 2;
	private static final int COMP_SUMINISTRADORA = 3;
	private static final int DOMICILIADO = 4;
	private static final int N_CONTRATO = 5;
	private static final int N_CUPS = 6;
	private static final int PERIOCIDAD = 7;
	private static final int F_ALTA_SUMINISTRO = 8;
	private static final int MOTIVO_ALTA_SUMINISTRO = 9;
	private static final int F_BAJA_SUMINISTRO = 10;
	private static final int MOTIVO_BAJA_SUMINISTRO = 11;
	private static final int C_VALIDACION_SUMINISTRO = 12;
	private static final String[] listaValidosPositivos = { "S", "SI" };

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	GenericABMDao genericDao;
	

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SUMINISTROS;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws Exception {
		
		ActivoSuministros activoSuministros = new ActivoSuministros();
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)));
		if(activo != null) {
			activoSuministros.setActivo(activo);
		}
	
		Filter filtroDDTipoSuministro  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, TIPO_SUMINISTRO));
		DDTipoSuministro ddTipoSuministro = genericDao.get(DDTipoSuministro.class, filtroDDTipoSuministro);
		if(ddTipoSuministro != null) {
			activoSuministros.setTipoSuministro(ddTipoSuministro);
		}
		
		Filter filtroDDSubtipoSuministro  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, SUBTIPO_SUMINISTRO));
		DDSubtipoSuministro ddSubtipoSuministro = genericDao.get(DDSubtipoSuministro.class, filtroDDSubtipoSuministro);
		if(ddSubtipoSuministro != null) {
			activoSuministros.setSubtipoSuministro(ddSubtipoSuministro);
		}
		
		Filter filtroActivoProveedor  = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.parseLong(exc.dameCelda(fila, COMP_SUMINISTRADORA)));
		ActivoProveedor activoProveedor = genericDao.get(ActivoProveedor.class, filtroActivoProveedor);
		if(activoProveedor != null) {
			activoSuministros.setCompaniaSuministro(activoProveedor);
		}
		
		if(!exc.dameCelda(fila, DOMICILIADO).isEmpty()) {
			activoSuministros.setDomiciliado(traducirSiNo(exc.dameCelda(fila, DOMICILIADO)));
		}
		
		if(!exc.dameCelda(fila, N_CONTRATO).isEmpty()) {
			activoSuministros.setNumContrato(exc.dameCelda(fila, N_CONTRATO));
		}
		
		if(!exc.dameCelda(fila, N_CUPS).isEmpty()) {
			activoSuministros.setNumCups(exc.dameCelda(fila, N_CUPS));
		}
		
		Filter filtroDDPeriodicidad  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, PERIOCIDAD));
		DDPeriodicidad ddPeriodicidad = genericDao.get(DDPeriodicidad.class, filtroDDPeriodicidad);
		if(ddPeriodicidad != null) {
			activoSuministros.setPeriodicidad(ddPeriodicidad);
		}
		
		if(!exc.dameCelda(fila, F_ALTA_SUMINISTRO).isEmpty()) {
			if(esBorrar(exc.dameCelda(fila, F_ALTA_SUMINISTRO))) {
				activoSuministros.setFechaAlta(null);
			}else {
				Date fechaAltaSuministro = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, F_ALTA_SUMINISTRO));
				activoSuministros.setFechaAlta(fechaAltaSuministro);
			}
		}
		
		Filter filtroDDMotivoAltaSuministro  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, MOTIVO_ALTA_SUMINISTRO));
		DDMotivoAltaSuministro ddMotivoAltaSuministro = genericDao.get(DDMotivoAltaSuministro.class, filtroDDMotivoAltaSuministro);
		if(ddMotivoAltaSuministro != null) {
			activoSuministros.setMotivoAlta(ddMotivoAltaSuministro);
		}
		
		if(!exc.dameCelda(fila, F_BAJA_SUMINISTRO).isEmpty()) {
			if(esBorrar(exc.dameCelda(fila, F_BAJA_SUMINISTRO))) {
				activoSuministros.setFechaBaja(null);
			}else {
				Date fechaBajaSuministro = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, F_BAJA_SUMINISTRO));
				activoSuministros.setFechaBaja(fechaBajaSuministro);
			}
		}
		
		Filter filtroDDMotivoBajaSuministro  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, MOTIVO_BAJA_SUMINISTRO));
		DDMotivoBajaSuministro ddMotivoBajaSuministro = genericDao.get(DDMotivoBajaSuministro.class, filtroDDMotivoBajaSuministro);
		if(ddMotivoBajaSuministro != null) {
			activoSuministros.setMotivoBaja(ddMotivoBajaSuministro);
		}
		
		if(!exc.dameCelda(fila, C_VALIDACION_SUMINISTRO).isEmpty()) {
			activoSuministros.setValidado(traducirSiNo(exc.dameCelda(fila, C_VALIDACION_SUMINISTRO)));
		}
		
		genericDao.save(ActivoSuministros.class, activoSuministros);
		
		return new ResultadoProcesarFila();
	}
	
	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}
	
	private boolean esBorrar(String cadena) {
		return cadena.toUpperCase().trim().equals("X");
	}
	
	private DDSinSiNo traducirSiNo(String celda) {
		if(celda != null && Arrays.asList(listaValidosPositivos).contains(celda.toUpperCase())) {
			Filter filtroSi  = genericDao.createFilter(FilterType.EQUALS, "codigo", "01");
			return genericDao.get(DDSinSiNo.class, filtroSi);
		}
		
		Filter filtroNo  = genericDao.createFilter(FilterType.EQUALS, "codigo", "02");
		return genericDao.get(DDSinSiNo.class, filtroNo);
	}

}
