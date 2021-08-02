/**
 * @class HreRem.view.common.FormBase
 * @author Jose Villel
 *
 * Formulario base con funciones para cargar o guardar un modelo o varios, especificados en
 * los correspondientes atributos, funciones para validaciones de primer y segundo nivel y gestión de errores.
 *
 * Ejemplo de uso:
 *
 	Ext.define('HreRem.view.trabajos.detalle.FichaTrabajo', {
	    extend: 'HreRem.view.common.FormBase',
	    xtype: 'fichatrabajo',
	    recordName: "trabajo",
		recordClass: "HreRem.model.FichaTrabajo",
	    requires: ['HreRem.model.FichaTrabajo'],
	    items :[
        			{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.objeto'),
						items :
							[
				                {
				                	xtype: 'displayfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.numero.trabajo'),
				                	bind:		'{trabajo.numTrabajo}'
				                },
				                {
				                	xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.propietario.activo'),
									bind:		'{trabajo.propietario}'
				                },
				                {
						        	xtype: 'displayfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
									bind:		'{trabajo.cartera}'
								},
				                {
						        	xtype: 'displayfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
						        	bind: '{trabajo.tipoTrabajoDescripcion}'
						        }
							]
		           }
        ];
	});
 */
 Ext.define('HreRem.view.common.FormBase', {
    extend		: 'Ext.form.Panel',
    xtype		: 'formBase',
    saveMultiple: false,
    trackResetOnLoad: true,
    requires: ['HreRem.view.common.FieldSetTable', 'HreRem.view.common.TextFieldBase',
    			'HreRem.view.common.ComboBoxFieldBase', 'HreRem.view.common.CheckBoxFieldBase',
    			'HreRem.view.common.DateFieldBase', 'HreRem.view.common.TextAreaFieldBase',
    			'HreRem.view.common.GridBaseEditable', 'HreRem.view.common.DisplayFieldBase',
    			'HreRem.view.common.GridBaseEditableRow', 'HreRem.view.common.TimeFieldBase',
    			'HreRem.view.common.RadioFieldBase', 'HreRem.view.common.CurrencyFieldBase',
    			'HreRem.view.common.NumberFieldBase', 'HreRem.view.common.ImageFieldBase',
    			'Ext.plugin.LazyItems','HreRem.view.common.ComboBoxSearchFieldBase'],
    /**
     * Atributo para pintar botones de guardar y cancelar
     * @type Boolean
     */
    isSaveForm: false,
    /**
     * Atributo para pintar botones de buscar y limpiar
     * @type Boolean
     */
    isSearchForm: false,

    /**
     * Para el caso de necesitar refrescar el formulario después de guardar.
     * @type Boolean
     */
    refreshAfterSave: false,

    initComponent: function() {
    	var esEditable = $AU.userHasFunction('EDITAR_BTN_EXPORT_FACTURAS_TASAS_IMPUESTOS');
    	
    	var exportarTareas = $AU.userHasFunction('EXPORTAR_BUSQUEDA_TAREAS');
    	var exportarAlertas = $AU.userHasFunction('EXPORTAR_BUSQUEDA_ALERTAS');
    	var exportarAvisos = $AU.userHasFunction('EXPORTAR_BUSQUEDA_AVISOS');
    	var exportarActivos = $AU.userHasFunction('EXPORTAR_BUSQUEDA_ACTIVOS');
    	var exportarAgrupaciones = $AU.userHasFunction('EXPORTAR_BUSQUEDA_AGRUPACIONES');
    	var exportarTrabajos = $AU.userHasFunction('EXPORTAR_BUSQUEDA_TRABAJOS');
    	var exportarPublicacion = $AU.userHasFunction('EXPORTAR_BUSQUEDA_PUBLICACIONES');
    	var exportarOfertas = $AU.userHasFunction('EXPORTAR_BUSQUEDA_OFERTAS');
    	var exportarGastos = $AU.userHasFunction('EXPORTAR_BUSQUEDA_GASTOS');
    	var exportarProveedores = $AU.userHasFunction('EXPORTAR_BUSQUEDA_PROVEEDORES');
    	
    	var me = this;

    	me.addCls('panel-base shadow-panel');

    	//Errores de primer nivel
		me.errors = [];

		//Errores de segundo nivel
		me.externalErrors = [];

		// Ventana donde se verán los errores si los hay
		me.windowInfoValidation = null;

		// Vista que enlazada con el modelo que contendrá el record de este form.
    	me.viewWithModel = me.up('[viewModel]');
    	if (me.isSearchFormTareas) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcelTareas', disabled: !exportarTareas}, {text: HreRem.i18n('btn.gesSustituto'), handler: 'onClickCargaTareasGestorSustituto', bind: { hidden: false}, reference: 'btnGestorSustituto'}];
    	}

    	if (me.isSearchFormAlertas) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcelAlertas', disabled: !exportarAlertas}];
    	}

    	if (me.isSearchFormJuntas) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onClickJuntasSearch' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}];
    	}

    	if (me.isSearchFormAvisos) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcelAvisos', disabled: !exportarAvisos}];
    	}

    	if (me.isSearchFormActivos) {
    		me.collapsible = true;
    		me.collapsed = false;
    		me.buttonAlign = 'left';
		    var isSuper = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
       		var isGestorActivos = $AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']);
	   		var isGestorAlquiler = $AU.userGroupHasRole(CONST.PERFILES['GESTOR_ALQUILER_HPM']);
	   		var isUserGestedi = $AU.userIsRol(CONST.PERFILES['GESTEDI']);
            var isHidden = !isSuper && !isGestorActivos && !isGestorAlquiler && !isUserGestedi;
            
    		//me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel'}, { text: HreRem.i18n('btn.crearTrabajo'), handler: 'onClickCrearTrabajo', hidden: !$AU.userIsRol(CONST.PERFILES['SUPERVISOR_ACTIVO'])}]
    		//El botón de crear trabajo se pone visible para todos en el arranque
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.abrir.activo'), handler: 'onSearchBusquedaDirectaActivos', reference: 'btnActivo', disabled: true },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel', disabled: !exportarActivos}, { text: HreRem.i18n('btn.crearTrabajo'), hidden: isHidden , handler: 'onClickCrearTrabajo'}]
    	}
    	
    	if (me.isSearchFormAgrupaciones) {
    		    		
    		me.collapsible= true;
    		me.collapsed= false;    		
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.abrir.agrupacion'), handler: 'onSearchBusquedaDirectaAgrupaciones', reference: 'btnAgrupacion', disabled: true },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel'}];
       	}
    	
    	if (me.isSearchFormTrabajos) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.abrir.trabajo'), handler: 'onSearchBusquedaDirectaTrabajo', reference: 'btnTrabajo', disabled: true },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel'}];
    	}
    	
    	if (me.isSearchFormPublicacion) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel', disabled: !exportarPublicacion}];
    	}

    	if (me.isSearchForm) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel'}];
    	}

    	if (me.isSearchFormOfertas) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.abrir.expediente'), handler: 'onSearchBusquedaDirectaExpediente', reference: 'btnExp', disabled: true},{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel', disabled: !exportarOfertas}, { text: HreRem.i18n('btn.ofertas.ces'), handler: 'onClickDescargarExcelOfertaCES', hidden: !($AU.userIsRol('HAYASUPER') || $AU.userIsRol('HAYAGESTPORTMAN') || $AU.userIsRol('HAYAGBOINM') || $AU.userIsRol('HAYAGRUPOCES')) }];
    	}

    	if (me.isSearchFormGastos) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onClickGastosSearch', reference: 'btnSearchGastos' },{ text: HreRem.i18n('btn.abrir.gasto'), handler: 'onSearchBusquedaDirectaGasto', reference: 'btnGasto', disabled: true },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcelGestionGastos', disabled: !exportarGastos}, {text: HreRem.i18n('fieldlabel.activo.administracion.extraer.facturas'), handler: 'onExportClickFacturas', hidden: !esEditable}, {text: HreRem.i18n('fieldlabel.activo.administracion.extraer.impuestos'), handler: 'onExportClickTasasImpuestos', hidden: !esEditable}];
    	}

    	if (me.isSearchFormProvisiones) {

			me.collapsible= true;
			me.collapsed= false;
			me.buttonAlign = 'left';
			me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onClickProvisionesSearch' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcelProvisionGastos', disabled: !exportarGastos}];
    	}

    	if (me.isSaveForm) {

    		me.buttonAlign = 'left';
    		me.buttons = [ { text: HreRem.i18n('btn.saveBtnText'), handler: 'onSaveClick' },{ text: HreRem.i18n('btn.cancelBtnText'), handler: 'onCancelClick'}];

    	}

    	if (me.isEditForm) {

    		me.buttonAlign = 'left';
    		me.buttons = [ { text: HreRem.i18n('btn.saveBtnText'), handler: 'onSaveEditClick' }];

    	}

    	
    	if (me.isSearchFormPlusvalia) {
    		me.collapsible= false;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onClickPlusvaliaSearch', reference: 'btnSearchPlusvalia' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}];
    	}

    	if (me.isSearchProveedoresForm) {
    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchProveedoresClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel', disabled: !exportarProveedores}];
    	}
    	
    	if (me.isSearchGestoresSustitutosForm) {
    		me.collapsible= true;
    		me.collapsed= false;    		
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchGestoresSustitutosClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}];
    	}
    	
    	if (me.isSearchPerfilesForm) {
    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchPerfilesClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}];

    	}
    	if (me.isSearchFormVisitas) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), handler: 'onClickDescargarExcel', disabled: !exportarOfertas}];
    	}
    	
    	if (me.isSearchFormTrabajosPrefactura) {

    		me.collapsible= true;
    		me.collapsed= false;
    		me.buttonAlign = 'left';
    		me.buttons = [{ text: HreRem.i18n('btn.buscar'), handler: 'onSearchClick' },{ text: HreRem.i18n('btn.limpiar'), handler: 'onCleanFiltersClick'}, { text: HreRem.i18n('btn.exportar'), reference: 'btnExportarPrefactura', handler: 'onClickDescargarExcel', disabled: true}];
    	}

    	me.callParent();

    },


     /**
     * Función necesaria para poder hacer bind con el formulario . Tiene que devolver una instancia del modelo
     * que rellenará el formulario.
     * @return {}
     */
    getModelInstance: function() {
    	var me = this;
    	return Ext.create(me.recordClass);
    },

         /**
     * Función necesaria para poder hacer bind con el formulario .Tiene que devolver un array con una instancia de cada modelo
     * que rellenará el formulario.
     * @return {}
     */
    getModelsInstance: function() {

    	var me = this,
    	records = [];

    	Ext.Array.each(me.recordsClass,function(recordclass, index) {
			records.push(Ext.create(recordclass));
		});

		return records;


    },


        /**
     * Función necesaria para mostrar los datos en el formulario que incluirá el registro en el viewModel
     * @return {}
     */
    setBindRecord: function(record) {
    	var me = this;
    	me.viewWithModel.getViewModel().set(me.recordName, record);
    },

    /**
     * Función necesaria para poder guardar el formulario que devolverá el registro que contiene los datos del fomualrio en el viewModel
     * @return {}
     */
    getBindRecord: function() {
    	var me = this;
    	return me.viewWithModel.getViewModel().get(me.recordName);
    },

    /**
     * Función necesaria para poder guardar el formulario que devolverá los registros que contendrán los datos del formulario
     * @return {}
     */
    getBindRecords: function() {

		var me = this;
		var listaRecords = new Array();

		for (i = 0; i<me.records.length; i++) {

			listaRecords[i] = me.viewWithModel.getViewModel().get(me.records[i]);

		}

    	return listaRecords;

    },

    isFormValid: function() {
    	var me = this;
    	me.errors.length = 0;
    	me.externalErrors.length=0;
    	// Validación de primer nivel, si no es valido recogemos los errores.
		if (!me.getForm().isValid()) {
			me.getFormErrors();
		}
		// Recogemos los errores de la validación de segundo nivel si existe.
		me.getErrorsExtendedFormBase();

		if(me.errors.length > 0 || me.externalErrors.length > 0) {


			/*if(!me.windowInfoValidation) {   INFO: En caso de querer mostrar una ventana con los errores.

				me.windowInfoValidation = Ext.create('Ext.window.Window', {
		            title		: 'Errores de validación',
		            html 		: me.formateaErrores(),
		            width		: 300,
		            height		: 200,
		            closable 	: true,
		            draggable	: true,
		            closeAction: 'hide',
		            cls			: 'form-validation-popup'
		        });

			} else {
				me.windowInfoValidation.update(me.formatErrors());
			}
			me.windowInfoValidation.show();*/
			//me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
			return false;

		} else {
			//si no hay erores, destruimos la ventana
			if(me.windowInfoValidation) {
				me.windowInfoValidation.destroy();
				delete me.windowInfoValidation;
			}
		}

		return true;

    },

    /**
     * En caso de necesitar validación de segundo nivel, el componente que extienda de formBase deberá sobreescribir esta función,
     * llamando finalmente a la función addErroresExternos para añadir los errores encontrados.
     * Además cada campo que no haya pasado la validación correspondiente deberá marcarse como erroneo de la siguiente manera:
     *
     *	field.markInvalid(i18n("mensaje de error"));
     *
     * @return {Boolean}
     */
    getErrorsExtendedFormBase: function() {

   		var me = this,
   		errores = [],
   		error;

   		me.addExternalErrors(errores);

   },

    /**
     *
     * @return {}
     */
	getFormErrors: function () {

		var me = this;
		me.errors.length = 0;

		Ext.Array.each(me.getForm().getFields().items, function(field, index) {
			if(!field.validate() && !field.hidden && !field.readOnly) {
				me.errors = me.errors.concat(field.getActiveErrors());
			}
		});
	},

	/**
	 * Función que será llamada desde las implementaciones propias de la función getErrorsExtendedFormBase
	 * @param {} errores
	 */
	addExternalErrors: function (errores) {
		var me = this;
		if(!Ext.isArray(errores)) {
			errores = [errores];
		}
		me.externalErrors = errores;
	},

	/**
	 * Crea un template con los errores encontrados para poder mostrarlos
	 * en una ventana, tooltip ,etc...
	 * @return {}
	 */
	formatErrors:function (){

		var me=this;

		var errorItemTemplate = new Ext.XTemplate (
			'<div class="error-list">',
				'<ul class="level1">',
					'<tpl for="errores">',
						'<li class="error-item">{.}</li>',
					'</tpl>',
				'</ul>',
				'<ul class="level2">',
					'<tpl for="erroresExternos">',
						'<li class="error-item">{.}</li>',
					'</tpl>',
				'</ul>',
			'</div>'
		);

		var html = errorItemTemplate.applyTemplate({
			errores 		: me.errors,
			erroresExternos: me.externalErrors

		});
		return html;
	},
	/**
	 * Sobreescribir en el formulario extendido en caso de necesitar
	 * cargar algún componente después de la primera carga.
	 * @return {}
	 */
	afterLoad: function() {
		return null;
	}

});