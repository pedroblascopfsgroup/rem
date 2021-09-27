Ext.define('HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalFiltros', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'mantenimientoprincipalfiltros',
    reference: 'mantenimientoprincipalfiltrosref',
    cls	: 'panel-base shadow-panel',
    collapsible: false,

	initComponent: function() {
	
		var me = this;
		me.setTitle(HreRem.i18n('title.evaluacion.mediadores.filtro'));
    	
        me.buttons = [{ text: HreRem.i18n('title.evaluacion.mediadores.btn.buscar'), handler: 'onSearchClick' }, 
        				{ text: HreRem.i18n('title.evaluacion.mediadores.btn.limpiar'), handler: 'onCleanFiltersClick'},
        				{ text: HreRem.i18n('btn.exportar'), handler: 'onExportarExcelMantenimiento'}];
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
		
					{
						xtype: 'comboboxfieldbase',
						name: 'codCartera',
		              	fieldLabel :  HreRem.i18n('fieldlabel.entidad.propietaria'),
		              	reference: 'codCarteraRef',
						bind: {
							store: '{comboCartera}'
						},
		            	publishes: 'value',
		            	listeners:
		            	{
		            		change: 'onSelectComboCodCartera'
		            	}
					},
					{ 
		        		xtype: 'comboboxfieldbase',
			        	name: 'codSubCartera',
			        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
			        	reference: 'codSubCarteraRef',
			        	bind: {
		            		store: '{comboSubcartera}',
		            		disabled: '{!codCarteraRef.selection}',
		            		filters: {
		            			property: 'carteraCodigo',
		                        value: '{codCarteraRef.value}'
		            		}
			        	},
			        	publishes: 'value'		
					},				
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.propietario'),
						reference: 'codPropietarioRef',
						name: 'codPropietario',
						bind: {
							store: '{comboPropietario}',
							disabled: '{!codCarteraRef.selection}'							
						},
						displayField: 'nombre',
						valueField: 'id'
					},
			        { 
			        	xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.cartera.macc'),
						reference: 'carteraMaccRef',
		            	name: 'carteraMacc', 
			        	bind: 
			        		{store: '{comboSiNoRem}'}
			        }
				 	
				]
			}
	    ];
	   	
	    me.callParent();
	}
});