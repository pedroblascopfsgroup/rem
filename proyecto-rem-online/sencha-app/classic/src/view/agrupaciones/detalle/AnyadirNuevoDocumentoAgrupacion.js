Ext.define('HreRem.view.agrupaciones.detalle.AnyadirNuevoDocumentoAgrupacion', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirNuevoDocumentoAgrupacion',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,    
    controller: 'agrupaciondetalle',
    viewModel: {
        type: 'agrupaciondetalle'
    },
    
    idAgrupacion: null,
    grid: null,
    entidad: null,
       
	initComponent: function() {
    	var me = this;
    	me.buttons =
    	[{  
			formBind: true, 
			itemId: 'btnGuardar', 
			text: 'Adjuntar', 
			handler: 'onClickAnyadirNuevoDocumentoAgrupacion'
		  },  
		  { 
			  itemId: 'btnCancelar', 
			  text: 'Cancelar', 
			  handler: 'onClickCerrarPestanyaAnyadirNuevoDocumentoAgrupacion'
		  }];
    	
    	me.items = [
    		{
				
				xtype: 'formBase',
				cls	: 'panel-base shadow-panel',
				url: $AC.getRemoteUrl(me.entidad + "/upload"),
				reference: 'adjuntarDocumentoAgrupacion',
				collapsed: false,
				scrollable	: 'y',
				layout: {
	   			 			type: 'vbox'
	   			 		},
				cls:'formbase_no_shadow',	    				
            	items: [
            		{

						xtype: 'filefield',
				        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
				        reference: 'fileUpload',
				        name: 'fileUpload',
				        allowBlank: false,
				        msgTarget: 'side',
				        anchor: '100%',
				        width: 		'100%',
				        buttonConfig: {
				        	iconCls: 'ico-search-white',
				        	text: ''
				        },
				        align: 'right',
						listeners: {
							change: function(fld, value) {
								var lastIndex = null,
								fileName = null;
								if(!Ext.isEmpty(value)) {
							    	lastIndex = value.lastIndexOf('\\');
								        if (lastIndex == -1) return;
								        fileName = value.substring(lastIndex + 1);
							            fld.setRawValue(fileName);
							    	}
							    }
						}

		    		},
		    		{
						xtype: 'combobox',
			        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
			        	name:'tipoDocumentoAgrupacion',
			        	reference: 'tipoDocumentoAgrupacion',
			        	editable: true,
			        	msgTarget: 'side',
			        	bind: {
							store: '{tiposAdjuntoAgrupacion}'	            		
						},
		            	displayField	: 'descripcion',
					    valueField		: 'codigo',
						allowBlank: false,
						width: '100%',
						enableKeyEvents:true,
					    listeners: {
					    	'keyup': function() {
					    		this.getStore().clearFilter();
					    	   	this.getStore().filter({
					        	    property: 'descripcion',
					        	    value: this.getRawValue(),
					        	    anyMatch: true,
					        	    caseSensitive: false
					        	})
					    	},
					    	'beforequery': function(queryEvent) {
					         	queryEvent.combo.onLoad();
					    	}
					    }
			        },
			        {
	                	xtype: 'textarea',
	                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
	                	reference: 'descripcion',
            	    	name:'descripcion',
	                	maxLength: 256,
	                	msgTarget: 'side',
	                	width: '100%'
            		}
            	    

            	]
    		}
    	];
    	
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('title.adjuntar.documento'));
    }
});