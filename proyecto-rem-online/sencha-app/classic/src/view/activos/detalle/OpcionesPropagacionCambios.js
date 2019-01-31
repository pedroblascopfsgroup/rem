Ext.define('HreRem.view.activos.detalle.OpcionesPropagacionCambios', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'opcionespropagacioncambios',
        
    layout	: {
    	type: 'hbox',
    	align: 'stretch'
    },
    width	: Ext.Element.getViewportWidth() / 1.2,    
    height	: Ext.Element.getViewportHeight() > 780 ? 780 : Ext.Element.getViewportHeight() - 50 ,
    
    activos: null,
    
    form: null,
    
    activoActual: null,
    
    propagableData: null,
    
    sub: null,
    
    targetGrid: null,
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.createContent();			
		}
		
	},

    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.seleccion.cambios.masivo"));
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: HreRem.i18n("btn.saveBtnText"), handler: "onClickSaveMasivosCondiciones"}, { itemId: 'btnCancelar', text: HreRem.i18n("btn.cancelBtnText"), handler: 'onClickCancelarPropagarCambios'}];
    	
    	me.items = [
    	
    	{
    		xtype: 'container',
    		margin: '0 10 0 0',
    		reference: "campos",
    		flex: 1.5,
    		layout: {
    			type: 'vbox',
    			align: 'stretch'
    		},
    		items: [    		
			    	{
			    		xtype: 'fieldset',
			    		padding: 10,
			    		flex: 1,
			    		layout: {
			    			type: 'vbox',
			    			align: 'stretch'
			    		},
			    		items: [
			    			{
			                      xtype: 'label',
			                      html: HreRem.i18n("txt.instrucciones.cambios.activo.masivo1")
			            	},
			            	{
			            		xtype: 'container',
			            		flex: 1,
			            		reference: 'camposContent',
			            		margin: '20 0 0 0',
			            		bodyPadding: 10,
			            		scrollable: 'vertical'
			            	}
			            ]
			    		
			    	}
    		]
    	},
    	
    	{
    		xtype: 'fieldset',
    		padding: 10,
    		flex: 3,
    		layout: {
    			type: 'vbox',
    			align: 'stretch'
    		},
    		items: [
    			{
                  xtype: 'label',
                  html: HreRem.i18n("txt.instrucciones.cambios.activo.masivo2") + "</br></br>"
			    },    		
	    		{
			        xtype: 'radiogroup',
			        reference: 'opcionesPropagacion',
			        margin: '0 0 10 10',
			        columns: 1,
			        vertical: true,
			        listeners: {
			        	change: function(checkbox, newValue) {
			        		me.onChangeOpcionesPropagacion(newValue);
			        	}
			        	
			        },
			        items: [
			        	{ boxLabel: HreRem.i18n("label.solo.activo.actual"), name: 'seleccion', inputValue: '1', checked: !Ext.isEmpty(me.form), hidden: Ext.isEmpty(me.form) },
			            { boxLabel: HreRem.i18n("label.activos.agrupacion.pertenece"), name: 'seleccion', inputValue: '2', checked: Ext.isEmpty(me.form)},
			            { boxLabel: HreRem.i18n("label.activos.subdivision.pertenece"), name: 'seleccion', inputValue: '3'},
			            { boxLabel: HreRem.i18n("label.siguientes.activos.seleccionados"), name: 'seleccion', inputValue: '4' }
			        ]			        
	    		},
	    		{
	    			xtype: 'gridBase',
	    			reference: 'listaActivos',
	    			flex: 1,
	    			title: HreRem.i18n("title.activos.seleccionados"),
	    			columns: [
						  		
					    {
				            dataIndex: 'numActivo',
				            text: HreRem.i18n('header.numero.activo.haya'),
							editor: {xtype:'textfield'}
			
				        },
				        {   
			            	text	 : HreRem.i18n('header.fecha.alta'),
			                dataIndex: 'fechaInclusion',
					        formatter: 'date("d/m/Y")',
					        hidden: true 
					    },
				        {
				            dataIndex: 'tipoActivo',
				            text: HreRem.i18n('header.tipo'),
				            flex: 1
				        },
				        {
				            dataIndex: 'subtipoActivo',
				            text: HreRem.i18n('header.subtipo'),
				            flex: 0.5
				        },
				        {
				            dataIndex: 'subdivision',
				            text: HreRem.i18n('header.subdivision'),
				            hideable: false,
				            flex: 2
				        },				      
				        {
				            dataIndex: 'fincaRegistral',
				            text: HreRem.i18n('header.finca.registral'),
				            hideable: false,
				            bind: {
					        	hidden: '{!esAgrupacionObraNuevaOrAsistida}'
					        },
				            flex: 0.5
				        },
				        {
				            dataIndex: 'puerta',
				            text: HreRem.i18n('header.puerta'),
				            hideable: false,
				            bind: {
					        	hidden: '{!esAgrupacionObraNuevaOrAsistida}'
					        },
				            flex: 0.5
				        },
				        {
				            dataIndex: 'publicado',
				            text: HreRem.i18n('header.publicado'),
				            flex: 1,
				            hidden: true
				        },
				        {
				            dataIndex: 'situacionComercial',
				            text: HreRem.i18n('header.disponibilidad.comercial'),
				            flex: 1,
				            hidden: true
				        },
				        {
				            dataIndex: 'importeMinimoAutorizado',
				            text: HreRem.i18n('header.valor.web'),
				            flex: 1,
				            renderer: function(value) {
				        		return Ext.util.Format.currency(value);
				        	},
				        	hidden: true,
				            sortable: false		            
				        },
				        {
				            dataIndex: 'importeAprobadoVenta',
				            text: HreRem.i18n('header.valor.aprobado.venta'),
				            flex: 1,
				            renderer: function(value) {
				        		return Ext.util.Format.currency(value);
				        	},
				        	hidden: true,
				            sortable: false		            
				        },
				        {
				            dataIndex: 'importeDescuentoPublicado',
				            text: HreRem.i18n('header.valor.descuento.publicado'),
				            flex: 1,
				            hidden: true,
				            renderer: function(value) {
				        		return Ext.util.Format.currency(value);
				        	},
				            sortable: false		            
				        },
				        {
				            dataIndex: 'superficieConstruida',
				            hideable: false,
				            bind: {
					        	hidden: '{esAgrupacionObraNuevaOrAsistida}'
					        },
				            text: HreRem.i18n('header.superficie.construida'),
				            flex: 1,
				            renderer: Ext.util.Format.numberRenderer('0,000.00'),
				            sortable: false      
				        }
	    			
	    			],
	    			selModel: {
	    				selType: 'checkboxmodel',
	    				checkOnly: !Ext.isGecko,
	    				listeners: {
	    					selectionchange: function(grid, selected) {
	    						me.down("[reference=displayListaActivos]").setValue("Seleccionados "+ selected.length +" de " + grid.getStore().getCount());
	    					}
	    				}
	    			},
	    			listeners: {
			            afterrender: function(grid) {
			                // Por defecto la columna de selecci�n estar� oculta, para que pueda ser mostrada si se selecciona la opci�n correspondiente.
			                grid.getColumns()[0].setVisible(false);
			            }
			        },
			        dockedItems: [
				        {
				            xtype: 'toolbar',
				            dock: 'bottom',
				            items:[
				            	'->',
				            	{
				            		xtype: 'displayfieldbase',
				            		reference: 'displayListaActivos'
				            	}
				            ]
				        }
					]
	    		}
    		

            ] 
    		
    	}
    	];
    	
    	me.callParent();
    	
    },
    
    createContent: function() {
    	var me = this,
    	campos = [];
    	
    	if(!Ext.isEmpty(me.form)) {
    		
    		var fields = me.form.getForm().getFields();

    		fields.each(function(field) {
    			
    			if (!Ext.isEmpty(field) && !Ext.isEmpty(field.bind) && !Ext.isEmpty(field.bind.value) && !Ext.isEmpty(field.bind.value.stub)  ) {
    				
    				var path = field.bind.value.stub.path;
    				var indexSeparator = path.indexOf(".");
    				var name = path.substring(0,indexSeparator);
    				var property = path.substring(indexSeparator+1, path.length);
    				
    				Ext.Array.each(me.propagableData.models, function(model,index) {
    					if (model.type == name && model.data.hasOwnProperty(property)) {
    						campos.push(field);
    					}
    				});
    				
    			}
    					
    		
    		});
    	}
    	
    	var containerCampos = me.down("container[reference=campos]");

    	if(campos.length==0) {
    		containerCampos.setVisible(false);
    	} else {

	    	Ext.Array.each(campos, function(campo, index) {
	    		
	    		var configField = {
	    			xtype: 'displayfieldbase',
	    			value: "undefined", 
	    			fieldLabel: campo.getFieldLabel(),
	    			width: '90%'
	    		};
	    		
	    		switch (campo.xtype) {
	    			
	    			case 'textfield' :
	    			case 'textfieldbase' :
	    			case 'numberfield' :
	    			case 'numberfieldbase' :
		    			configField.value = campo.getValue();		    			
		    			break;
		    		case 'currencyfieldbase' :
		    			configField.value = Ext.util.Format.currency(campo.getRawValue());
		    			break;
		    		case 'comboboxfieldbase' :
		    		case 'combobox' :
		    			configField.value = campo.getDisplayValue();		    			
		    			break;
		    		case 'textarea' :
	    			case 'textareafield' :
	    			case 'textareafieldbase' :
	    				configField.labelAlign = 'top';
	    				configField.value = campo.getValue();
	    				break;
	    			case 'datefieldbase' :
	    			case 'datefield' :
	    				configField.value = campo.getRawValue();
	    				break;
	    			case 'checkbox' :
	    			case 'checkboxfieldbase' :
	    				configField.xtype= 'checkbox';
	    				configField.readOnly= true;
	    				configField.value = campo.getValue();
	    				break;
		    		default :
		    			me.fireEvent("log", "Tipo de campo no definido - " + campo.xtype);
	    		}  		

	    		containerCampos.down("[reference=camposContent]").add(Ext.widget(configField));
	    	
	    	});
    	}

    	var store =  Ext.create('Ext.data.Store', {
    	pageSize:0,
	    data : me.activos});

    	me.down("grid").setStore(store);
    	
    	me.down("[reference=displayListaActivos]").setValue("Seleccionados 0 de " + store.getCount());

    },
    
    onChangeOpcionesPropagacion: function(newValue) {

    	var me = this;
		grid = 	me.down("grid"),
		checkColumn = grid.getColumns()[0];
		
		switch (newValue.seleccion) {
			
			case "1": 
				checkColumn.setVisible(false);
				grid.getSelectionModel().deselectAll();
				grid.getStore().clearFilter();
				break;
				
			case "2":			        				
				checkColumn.setVisible(false);
				grid.getStore().clearFilter();
				grid.getSelectionModel().selectAll();
				break;
				
			case "3":	
				checkColumn.setVisible(false);
				grid.getStore().filter('subdivision', me.activoActual.subdivision);
				grid.getSelectionModel().selectAll();
				break;
			
			case "4":
				grid.getStore().clearFilter();
				checkColumn.setVisible(true);
				grid.getSelectionModel().deselectAll();
				break;
		}
		
	}
});
    