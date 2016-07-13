package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el listado de Activos del Tramite
 * 
 * @author Bender
 *
 */
public class DtoActivoTramite extends WebDto {

	private static final long serialVersionUID = 0L;

	

	private String numActivo;
	private String numActivoRem;
	private String idSareb;
	private String numActivoUvem;
	private String idRecovery;
	private String rating;
	private String municipioCodigo;
	private String municipioDescripcion;
	private String provinciaCodigo;
	private String provinciaDescripcion;
	private String direccion;
	private String tipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoCodigo;
	private String subtipoActivoDescripcion;
	private String tipoTituloCodigo;
	private String tipoTituloDescripcion;
	private String subtipoTituloCodigo;
	private String subtipoTituloDescripcion;
	private String entidadPropietariaCodigo;
	private String entidadPropietariaDescripcion;
	private String estadoActivoCodigo;
	private String estadoActivoDescripcion;
	

	private int page;
	private int start;
	private int limit;



}