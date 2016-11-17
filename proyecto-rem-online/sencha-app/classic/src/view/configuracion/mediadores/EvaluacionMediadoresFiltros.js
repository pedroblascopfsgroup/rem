Ext.define('HreRem.view.configuracion.mediadores.EvaluacionMediadoresFiltros', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'evaluacionmediadoresfiltros',
    reference: 'evaluacionMediadoresFiltros',
    cls	: 'panel-base shadow-panel',
    collapsible: false,

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.evaluacion.mediadores.filtro'));
    	
        me.buttons = [{ text: HreRem.i18n('title.evaluacion.mediadores.btn.buscar'), handler: 'onSearchClick' },
        				{ text: HreRem.i18n('title.evaluacion.mediadores.btn.limpiar'), handler: 'onCleanFiltersClick'}];
        me.buttonAlign = 'left';
        
	    me.items= [
	         {
    			xtype: 'panel',
    			collapsible: false,
    			cls: 'panel-busqueda-directa',
    			layout: 'column',
    			defaults: {
					addUxReadOnlyEditFieldPlugin: false,
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 25%'
			    },
				items: [
					// Fila 1
					{
						xtype: 'textfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.mediadores.codigo'),
						name: 'codigoRem'
					},
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.calificacion'),
			        	name: 'calificacionCodigo',
			        	bind: {
		            		store: '{comboCalificacionProveedor}'
		            	},
		            	displayField: 'descripcion',
						valueField: 'codigo'
			        },
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.mediadores.Tipo'),
			        	name: 'esCustodio',
						store : new Ext.data.SimpleStore({
							data : [[0, 'No custodio'], 
							        [1, 'Custodio'],
							        [undefined, '-']],
							fields : ['codigo', 'descripcion']
						}),
		            	displayField: 'descripcion',
						valueField: 'codigo'
			        },
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.proveedores.estado'),
						name: 'codEstadoProveedor',
						bind: {
							store: '{comboEstadoProveedor}'
						},
		            	displayField: 'descripcion',
						valueField: 'codigo'
					},
					
			        // Fila 2
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.proveedores.cartera'),
						name: 'codCartera',
						bind: {
							store: '{comboCartera}'		            		
						},
		            	displayField: 'descripcion',
						valueField: 'codigo'
					},
				 	{
				 		xtype: 'comboboxfieldbase',
				 		name: 'codProvincia',
				 		reference: 'mediadorProvinciaCombo',
				 		fieldLabel:	HreRem.i18n('fieldlabel.proveedores.provincia'),
			        	bind: {
		            		store: '{comboProvincia}'
		            	},
		            	displayField: 'descripcion',
						valueField: 'codigo',
						publishes: 'value'
				 	},
				 	{
				 		xtype: 'comboboxfieldbase',
				 		name: 'codLocalidad',
				 		reference: 'mediadorMunicipioCombo',
				 		fieldLabel:	HreRem.i18n('fieldlabel.proveedores.municipio'),
				 		queryMode: 'remote',
				 		forceSelection: true,
			        	bind: {
		            		store: '{comboMunicipio}',
		            		disabled: '{!mediadorProvinciaCombo.value}',
		            		filters: {
		            			property: 'codigoProvincia',
		            			value: '{mediadorProvinciaCombo.value}'
		            		}
		            	},
		            	displayField: 'descripcion',
						valueField: 'codigo'
				 	},
					{
						xtype: 'textfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.mediadores.nombre'),
						name: 'nombreApellidos'
					},

				 	// Fila 3
					{
						xtype: 'checkbox',
						fieldLabel:  HreRem.i18n('fieldlabel.mediadores.top'),
						name: 'esTop',
						inputValue: '1',
						uncheckedValue: '0',
						flex: 1.5
					},
					{
						xtype: 'checkbox',
						fieldLabel:  HreRem.i18n('fieldlabel.mediadores.homologados'),
						name: 'esHomologado',
						inputValue: '1',
						uncheckedValue: '0',
						flex: 1.5
					}
				]
			}
	    ];
	   	
	    me.callParent();
	}
});